Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608Ab0I1DrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 23:47:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab0I1DrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 23:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LI2omAbAlRdk2zEyHm1XELXO5ViRUPWr3JRA+QYzWtEDZWa+lO/vbDYReFvfa96nqV
         sEkdQ9UKi1UEOh1oRpJaAeS7gnug1Ssa/uP5RsR7l2J/PYcNXnQP3VNPjktug9kpSnzZ
         HQR8xWgx1LYWicqtWUBI9KOBQPMTg2rsf0Tv0=
Subject: [PATCH V3] fs: allow for more than 2^31 files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: dipankar@in.ibm.com, holt@sgi.com, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        den@openvz.org, mingo@elte.hu, mszeredi@suse.cz, cmm@us.ibm.com,
        npiggin@kernel.dk, xemul@openvz.org, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100927.153639.212415479.davem@davemloft.net>
References: <20100923121704.GR14064@sgi.com>
	 <1285246384.362.3.camel@edumazet-laptop> <20100923141037.GA3811@in.ibm.com>
	 <20100927.153639.212415479.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 05:46:51 +0200
Message-ID: <1285645611.10438.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 27 septembre 2010 à 15:36 -0700, David Miller a écrit :

> Is someone following up on integrating this upstream so this thing
> gets fixed?
> 

Thanks for the heads-up.

I am not sure V2 of my patch was reviewed, maybe it did not reach the
list.

Here is V3 of it. I removed the ATOMIC_INIT(0) I left in V2.
It should be an ATOMIC_LONG_INIT(0), but then, it can be avoided.

CC netdev

Thanks

[PATCH V3] fs: allow for more than 2^31 files

Robin Holt tried to boot a 16TB system and found af_unix was overflowing
a 32bit value :

<quote>

We were seeing a failure which prevented boot.  The kernel was incapable
of creating either a named pipe or unix domain socket.  This comes down
to a common kernel function called unix_create1() which does:

        atomic_inc(&unix_nr_socks);
        if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
                goto out;

The function get_max_files() is a simple return of files_stat.max_files.
files_stat.max_files is a signed integer and is computed in
fs/file_table.c's files_init().

        n = (mempages * (PAGE_SIZE / 1024)) / 10;
        files_stat.max_files = n;

In our case, mempages (total_ram_pages) is approx 3,758,096,384
(0xe0000000).  That leaves max_files at approximately 1,503,238,553.
This causes 2 * get_max_files() to integer overflow.

</quote>

Fix is to let /proc/sys/fs/file-nr & /proc/sys/fs/file-max use long
integers, and change af_unix to use an atomic_long_t instead of
atomic_t.

get_max_files() is changed to return an unsigned long.
get_nr_files() is changed to return a long.

unix_nr_socks is changed from atomic_t to atomic_long_t, while not
strictly needed to address Robin problem.
 
Before patch (on a 64bit kernel) :
# echo 2147483648 >/proc/sys/fs/file-max
# cat /proc/sys/fs/file-max
-18446744071562067968

After patch:
# echo 2147483648 >/proc/sys/fs/file-max
# cat /proc/sys/fs/file-max
2147483648


Reported-by: Robin Holt <holt@sgi.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 fs/file_table.c    |   15 ++++++---------
 include/linux/fs.h |    8 ++++----
 kernel/sysctl.c    |    8 ++++----
 net/unix/af_unix.c |   14 +++++++-------
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index a04bdd8..46457ba 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -60,7 +60,7 @@ static inline void file_free(struct file *f)
 /*
  * Return the total number of open files in the system
  */
-static int get_nr_files(void)
+static long get_nr_files(void)
 {
 	return percpu_counter_read_positive(&nr_files);
 }
@@ -68,7 +68,7 @@ static int get_nr_files(void)
 /*
  * Return the maximum number of open files in the system
  */
-int get_max_files(void)
+unsigned long get_max_files(void)
 {
 	return files_stat.max_files;
 }
@@ -105,7 +105,7 @@ int proc_nr_files(ctl_table *table, int write,
 struct file *get_empty_filp(void)
 {
 	const struct cred *cred = current_cred();
-	static int old_max;
+	static long old_max;
 	struct file * f;
 
 	/*
@@ -140,8 +140,7 @@ struct file *get_empty_filp(void)
 over:
 	/* Ran out of filps - report that */
 	if (get_nr_files() > old_max) {
-		printk(KERN_INFO "VFS: file-max limit %d reached\n",
-					get_max_files());
+		pr_info("VFS: file-max limit %lu reached\n", get_max_files());
 		old_max = get_nr_files();
 	}
 	goto fail;
@@ -487,7 +486,7 @@ retry:
 
 void __init files_init(unsigned long mempages)
 { 
-	int n; 
+	unsigned long n;
 
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
@@ -498,9 +497,7 @@ void __init files_init(unsigned long mempages)
 	 */ 
 
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
-	files_stat.max_files = n; 
-	if (files_stat.max_files < NR_FILE)
-		files_stat.max_files = NR_FILE;
+	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
 	lg_lock_init(files_lglock);
 	percpu_counter_init(&nr_files, 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..8c06590 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -34,9 +34,9 @@
 
 /* And dynamically-tunable limits and defaults: */
 struct files_stat_struct {
-	int nr_files;		/* read only */
-	int nr_free_files;	/* read only */
-	int max_files;		/* tunable */
+	unsigned long nr_files;		/* read only */
+	unsigned long nr_free_files;	/* read only */
+	unsigned long max_files;		/* tunable */
 };
 
 struct inodes_stat_t {
@@ -404,7 +404,7 @@ extern void __init inode_init_early(void);
 extern void __init files_init(unsigned long);
 
 extern struct files_stat_struct files_stat;
-extern int get_max_files(void);
+extern unsigned long get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..fc667bf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1352,16 +1352,16 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "file-nr",
 		.data		= &files_stat,
-		.maxlen		= 3*sizeof(int),
+		.maxlen		= sizeof(files_stat),
 		.mode		= 0444,
-		.proc_handler	= proc_nr_files,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "file-max",
 		.data		= &files_stat.max_files,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "nr_open",
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b39b24..3e1d7d1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -117,7 +117,7 @@
 
 static struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
 static DEFINE_SPINLOCK(unix_table_lock);
-static atomic_t unix_nr_socks = ATOMIC_INIT(0);
+static atomic_long_t unix_nr_socks;
 
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


