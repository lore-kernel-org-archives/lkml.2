Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0DNO5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:57:20 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:63842 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab0DNO5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OI0ysEcCDQ+tn1+kVVGwFa176skRRLnZTyBBegUyVyPW9LqR4fLorhK/OEFgUWBGB2
         /uRYjdDye/xi2JzU/fp2wKV9GCLf27ixepUgBk/BuNg7/97yFrVt21EVbp0a4YrnjrIk
         Er7jIfapoHkKSoTTQ8iRW6mYGzmXZiSLr7BEo=
Subject: Re: [PATCH net-next-2.6] fasync: RCU locking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BC57E7D.9060706@cn.fujitsu.com>
References: <1271230961.16881.630.camel@edumazet-laptop>
	 <4BC57E7D.9060706@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 16:57:07 +0200
Message-ID: <1271257027.16881.1663.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 avril 2010 à 16:36 +0800, Lai Jiangshan a écrit :

> Since rcu_read_lock() protects fasync_struct *fa for us, we can access
> to @fa safely even fasync_remove_entry() is just called.
> 
> But this patch does not ensure 'fa->fa_file is not freed' nor
> 'fa->fa_fd is not released', so kill_fasync_rcu() may do wrong thing
> if there is no other code ensure it.

You are 100% right, I forgot my old attempt to RCUified struct files
failed...

Maybe its time to finally move f_owner out of struct file, and use RCU
to free it.

In the mean time, adding a lock in fasync_struct is more than enough.

Thanks !

[PATCH net-next-2.6 v2] fasync: fine grained locking

kill_fasync() uses a central rwlock, candidate for RCU conversion, to
avoid cache line ping pongs on SMP.

fasync_remove_entry() and fasync_add_entry() can disable IRQS on a short
section instead during whole list scan.

Use a spinlock per fasync_struct to synchronize fasync_{remove|
add}_entry() and kill_fasync_rcu()

We can remove __kill_fasync() direct use in net, and rename it to
kill_fasync_rcu().

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
v2: As Lai Jiangshan noticed, we need a mutual exclusion between
fasync_{remove|add}_entry() and kill_fasync_rcu().

 fs/fcntl.c         |   66 +++++++++++++++++++++++++++----------------
 include/linux/fs.h |   12 +++----
 net/socket.c       |    4 +-
 3 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 452d02f..0a14074 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -614,9 +614,15 @@ int send_sigurg(struct fown_struct *fown)
 	return ret;
 }
 
-static DEFINE_RWLOCK(fasync_lock);
+static DEFINE_SPINLOCK(fasync_lock);
 static struct kmem_cache *fasync_cache __read_mostly;
 
+static void fasync_free_rcu(struct rcu_head *head)
+{
+	kmem_cache_free(fasync_cache,
+			container_of(head, struct fasync_struct, fa_rcu));
+}
+
 /*
  * Remove a fasync entry. If successfully removed, return
  * positive and clear the FASYNC flag. If no entry exists,
@@ -625,8 +631,6 @@ static struct kmem_cache *fasync_cache __read_mostly;
  * NOTE! It is very important that the FASYNC flag always
  * match the state "is the filp on a fasync list".
  *
- * We always take the 'filp->f_lock', in since fasync_lock
- * needs to be irq-safe.
  */
 static int fasync_remove_entry(struct file *filp, struct fasync_struct **fapp)
 {
@@ -634,17 +638,22 @@ static int fasync_remove_entry(struct file *filp, struct fasync_struct **fapp)
 	int result = 0;
 
 	spin_lock(&filp->f_lock);
-	write_lock_irq(&fasync_lock);
+	spin_lock(&fasync_lock);
 	for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
 		if (fa->fa_file != filp)
 			continue;
+
+		spin_lock_irq(&fa->fa_lock);
+		fa->fa_file = NULL;
+		spin_unlock_irq(&fa->fa_lock);
+
 		*fp = fa->fa_next;
-		kmem_cache_free(fasync_cache, fa);
+		call_rcu(&fa->fa_rcu, fasync_free_rcu);
 		filp->f_flags &= ~FASYNC;
 		result = 1;
 		break;
 	}
-	write_unlock_irq(&fasync_lock);
+	spin_unlock(&fasync_lock);
 	spin_unlock(&filp->f_lock);
 	return result;
 }
@@ -666,25 +675,30 @@ static int fasync_add_entry(int fd, struct file *filp, struct fasync_struct **fa
 		return -ENOMEM;
 
 	spin_lock(&filp->f_lock);
-	write_lock_irq(&fasync_lock);
+	spin_lock(&fasync_lock);
 	for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
 		if (fa->fa_file != filp)
 			continue;
+
+		spin_lock_irq(&fa->fa_lock);
 		fa->fa_fd = fd;
+		spin_unlock_irq(&fa->fa_lock);
+
 		kmem_cache_free(fasync_cache, new);
 		goto out;
 	}
 
+	spin_lock_init(&new->fa_lock);
 	new->magic = FASYNC_MAGIC;
 	new->fa_file = filp;
 	new->fa_fd = fd;
 	new->fa_next = *fapp;
-	*fapp = new;
+	rcu_assign_pointer(*fapp, new);
 	result = 1;
 	filp->f_flags |= FASYNC;
 
 out:
-	write_unlock_irq(&fasync_lock);
+	spin_unlock(&fasync_lock);
 	spin_unlock(&filp->f_lock);
 	return result;
 }
@@ -704,37 +718,41 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
 
 EXPORT_SYMBOL(fasync_helper);
 
-void __kill_fasync(struct fasync_struct *fa, int sig, int band)
+/*
+ * rcu_read_lock() is held
+ */
+static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 {
 	while (fa) {
-		struct fown_struct * fown;
+		struct fown_struct *fown;
 		if (fa->magic != FASYNC_MAGIC) {
 			printk(KERN_ERR "kill_fasync: bad magic number in "
 			       "fasync_struct!\n");
 			return;
 		}
-		fown = &fa->fa_file->f_owner;
-		/* Don't send SIGURG to processes which have not set a
-		   queued signum: SIGURG has its own default signalling
-		   mechanism. */
-		if (!(sig == SIGURG && fown->signum == 0))
-			send_sigio(fown, fa->fa_fd, band);
-		fa = fa->fa_next;
+		spin_lock(&fa->fa_lock);
+		if (fa->fa_file) {
+			fown = &fa->fa_file->f_owner;
+			/* Don't send SIGURG to processes which have not set a
+			   queued signum: SIGURG has its own default signalling
+			   mechanism. */
+			if (!(sig == SIGURG && fown->signum == 0))
+				send_sigio(fown, fa->fa_fd, band);
+		}
+		spin_unlock(&fa->fa_lock);
+		fa = rcu_dereference(fa->fa_next);
 	}
 }
 
-EXPORT_SYMBOL(__kill_fasync);
-
 void kill_fasync(struct fasync_struct **fp, int sig, int band)
 {
 	/* First a quick test without locking: usually
 	 * the list is empty.
 	 */
 	if (*fp) {
-		read_lock(&fasync_lock);
-		/* reread *fp after obtaining the lock */
-		__kill_fasync(*fp, sig, band);
-		read_unlock(&fasync_lock);
+		rcu_read_lock();
+		kill_fasync_rcu(rcu_dereference(*fp), sig, band);
+		rcu_read_unlock();
 	}
 }
 EXPORT_SYMBOL(kill_fasync);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39d57bc..018d382 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1280,10 +1280,12 @@ static inline int lock_may_write(struct inode *inode, loff_t start,
 
 
 struct fasync_struct {
-	int	magic;
-	int	fa_fd;
-	struct	fasync_struct	*fa_next; /* singly linked list */
-	struct	file 		*fa_file;
+	spinlock_t		fa_lock;
+	int			magic;
+	int			fa_fd;
+	struct fasync_struct	*fa_next; /* singly linked list */
+	struct file		*fa_file;
+	struct rcu_head		fa_rcu;
 };
 
 #define FASYNC_MAGIC 0x4601
@@ -1292,8 +1294,6 @@ struct fasync_struct {
 extern int fasync_helper(int, struct file *, int, struct fasync_struct **);
 /* can be called from interrupts */
 extern void kill_fasync(struct fasync_struct **, int, int);
-/* only for net: no internal synchronization */
-extern void __kill_fasync(struct fasync_struct *, int, int);
 
 extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int force);
 extern int f_setown(struct file *filp, unsigned long arg, int force);
diff --git a/net/socket.c b/net/socket.c
index 35bc198..846739c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1159,10 +1159,10 @@ int sock_wake_async(struct socket *sock, int how, int band)
 		/* fall through */
 	case SOCK_WAKE_IO:
 call_kill:
-		__kill_fasync(sock->fasync_list, SIGIO, band);
+		kill_fasync(sock->fasync_list, SIGIO, band);
 		break;
 	case SOCK_WAKE_URG:
-		__kill_fasync(sock->fasync_list, SIGURG, band);
+		kill_fasync(sock->fasync_list, SIGURG, band);
 	}
 	return 0;
 }


