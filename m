Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0IWMxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:53:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55914 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0IWMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h6f28JEL7gYCsXR9E1uW+Ws3K5rj1MIRGbXcAEGhupUUSViiIV7nPujcp4I7tBU8ND
         eXaA/dOI0XQyUiz+o5R9jSul7L5pxD1zee9XGv6vVLQCC0DN6/8M9xx6q3i3fSbzdHmi
         N3fdCgwI56R7vOvwJry8CC5CK+wf8VfIYoNiE=
Subject: Re: When booting a 16TB system, unix_create1 fails due to integer
 overflow.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Miklos Szeredi <mszeredi@suse.cz>, Mingming Cao <cmm@us.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>, Pavel Emelyanov <xemul@openvz.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100923121704.GR14064@sgi.com>
References: <20100923121704.GR14064@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 14:53:04 +0200
Message-ID: <1285246384.362.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 23 septembre 2010 à 07:17 -0500, Robin Holt a écrit : 
> I do not know which direction to take, but here is the summary of the
> problem.
> 
> We recently started trying to boot a customer's two new machines which
> are configured with 384GB short of 16TB of memory.
> 
> We were seeing a failure which prevented boot.  The kernel was incapable
> of creating either a named pipe or unix domain socket.  This comes down
> to a common kernel function called unix_create1() which does:
> 
> 	atomic_inc(&unix_nr_socks);
> 	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
> 		goto out;
> 
> The function get_max_files() is a simple return of files_stat.max_files.
> files_stat.max_files is a signed integer and is computed in
> fs/file_table.c's files_init().
> 
> 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
> 	files_stat.max_files = n;
> 
> In our case, mempages (total_ram_pages) is approx 3,758,096,384
> (0xe0000000).  That leaves max_files at approximately 1,503,238,553.
> This causes 2 * get_max_files() to integer overflow.
> 
> We came up with a few possible solutions:
> 
> Our first response was to limit max_files to (INT_MAX / 2)  This at
> least got us past the problem and seemed reasonable.
> 
> We could also have changed the 2 * get_max_files() to 2UL *
> get_max_files() and gotten past this point in boot.  That was not tested.
> 
> We could also have changed the definition of max_files to at least an
> unsigned int instead of an int and gotten past the problem, but again,
> not tested.
> 
> 
> Any suggestions for a direction would be appreciated.

Hi Robin

I would say : We can use atomic_long_t instead of atomic_t

And make get_max_files(void) return a long ?

Something like :


 fs/file_table.c    |   10 +++++-----
 include/linux/fs.h |    2 +-
 net/unix/af_unix.c |   14 +++++++-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index a04bdd8..a2d2189 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -68,9 +68,9 @@ static int get_nr_files(void)
 /*
  * Return the maximum number of open files in the system
  */
-int get_max_files(void)
+unsigned long get_max_files(void)
 {
-	return files_stat.max_files;
+	return (unsigned long)(unsigned int)files_stat.max_files;
 }
 EXPORT_SYMBOL_GPL(get_max_files);
 
@@ -140,7 +140,7 @@ struct file *get_empty_filp(void)
 over:
 	/* Ran out of filps - report that */
 	if (get_nr_files() > old_max) {
-		printk(KERN_INFO "VFS: file-max limit %d reached\n",
+		printk(KERN_INFO "VFS: file-max limit %lu reached\n",
 					get_max_files());
 		old_max = get_nr_files();
 	}
@@ -487,7 +487,7 @@ retry:
 
 void __init files_init(unsigned long mempages)
 { 
-	int n; 
+	unsigned long n;
 
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
@@ -498,7 +498,7 @@ void __init files_init(unsigned long mempages)
 	 */ 
 
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
-	files_stat.max_files = n; 
+	files_stat.max_files = min(n, 0x7FFFFFFFUL);
 	if (files_stat.max_files < NR_FILE)
 		files_stat.max_files = NR_FILE;
 	files_defer_init();
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..0de4989 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -404,7 +404,7 @@ extern void __init inode_init_early(void);
 extern void __init files_init(unsigned long);
 
 extern struct files_stat_struct files_stat;
-extern int get_max_files(void);
+extern unsigned long get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b39b24..b3c70ac 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -117,7 +117,7 @@
 
 static struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
 static DEFINE_SPINLOCK(unix_table_lock);
-static atomic_t unix_nr_socks = ATOMIC_INIT(0);
+static atomic_long_t unix_nr_socks = ATOMIC_INIT(0);
 
 #define unix_sockets_unbound	(&unix_socket_table[UNIX_HASH_SIZE])
 
@@ -360,13 +360,13 @@ static void unix_sock_destructor(struct sock *sk)
 	if (u->addr)
 		unix_release_addr(u->addr);
 
-	atomic_dec(&unix_nr_socks);
+	atomic_long_dec(&unix_nr_socks);
 	local_bh_disable();
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	local_bh_enable();
 #ifdef UNIX_REFCNT_DEBUG
-	printk(KERN_DEBUG "UNIX %p is destroyed, %d are still alive.\n", sk,
-		atomic_read(&unix_nr_socks));
+	printk(KERN_DEBUG "UNIX %p is destroyed, %ld are still alive.\n", sk,
+		atomic_long_read(&unix_nr_socks));
 #endif
 }
 
@@ -606,8 +606,8 @@ static struct sock *unix_create1(struct net *net, struct socket *sock)
 	struct sock *sk = NULL;
 	struct unix_sock *u;
 
-	atomic_inc(&unix_nr_socks);
-	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
+	atomic_long_inc(&unix_nr_socks);
+	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
 		goto out;
 
 	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto);
@@ -632,7 +632,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock)
 	unix_insert_socket(unix_sockets_unbound, sk);
 out:
 	if (sk == NULL)
-		atomic_dec(&unix_nr_socks);
+		atomic_long_dec(&unix_nr_socks);
 	else {
 		local_bh_disable();
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);


