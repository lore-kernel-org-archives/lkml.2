Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0EQBXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 21:23:41 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49731 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0EQBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 21:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rlUSM1AjEFoH7vv/c4LPqK+mkBgPJyEEgD5vUEw5NdkDwe9iY29O1mMKNLEH/y+vvs
         ehYwqNO5UzN14gY4johw+XP12QnJ3cqbMRwL71RQ4fyOF57gxpyaOyyCOCb0ADcEQPfX
         /XemOxKErnSfKup67BynY0t0puDAX+WICaUuQ=
Date: Mon, 17 May 2010 03:23:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v4] procfs: Push down the bkl from ioctl
Message-ID: <20100517012338.GC22299@nowhere>
References: <1270824337-7985-1-git-send-regression-fweisbec@gmail.com> <1270905915-7019-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270905915-7019-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have updated this patch because the direct pushdown into
the handler was rather invasive and error prone.

Instead I've used wrappers.

Arnd I've kept your ack, hope it's still fine for you.

Thanks.

---
>From d79b6f4de5db0103ceb4734e42ad101d836d61d9 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 30 Mar 2010 07:27:50 +0200
Subject: [PATCH v4] procfs: Push down the bkl from ioctl

Push down the bkl from procfs's ioctl main handler to its users.
Only three procfs users implement an ioctl (non unlocked) handler.
Turn them into unlocked_ioctl and push down the Devil inside.

v2: PDE(inode)->data doesn't need to be under bkl
v3: And don't forget to git-add the result
v4: Use wrappers to pushdown instead of an invasive and error prone
    handlers surgery.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/char/i8k.c                  |   21 ++++++++++++++++-----
 drivers/isdn/divert/divert_procfs.c |   18 ++++++++++++++----
 net/sunrpc/cache.c                  |   14 ++++++++++----
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index fc8cf7a..4cd8b22 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -23,6 +23,7 @@
 #include <linux/seq_file.h>
 #include <linux/dmi.h>
 #include <linux/capability.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -82,8 +83,7 @@ module_param(fan_mult, int, 0);
 MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
 
 static int i8k_open_fs(struct inode *inode, struct file *file);
-static int i8k_ioctl(struct inode *, struct file *, unsigned int,
-		     unsigned long);
+static long i8k_ioctl(struct file *, unsigned int, unsigned long);
 
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
@@ -91,7 +91,7 @@ static const struct file_operations i8k_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
-	.ioctl		= i8k_ioctl,
+	.unlocked_ioctl	= i8k_ioctl,
 };
 
 struct smm_regs {
@@ -307,8 +307,8 @@ static int i8k_get_dell_signature(int req_fn)
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
 }
 
-static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
-		     unsigned long arg)
+static int
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int val = 0;
 	int speed;
@@ -395,6 +395,17 @@ static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 	return 0;
 }
 
+static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = i8k_ioctl_unlocked(fp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  * Print the information for /proc/i8k.
  */
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index 3697c40..724693c 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/isdnif.h>
 #include <net/net_namespace.h>
+#include <linux/smp_lock.h>
 #include "isdn_divert.h"
 
 
@@ -176,9 +177,7 @@ isdn_divert_close(struct inode *ino, struct file *filep)
 /*********/
 /* IOCTL */
 /*********/
-static int
-isdn_divert_ioctl(struct inode *inode, struct file *file,
-		  uint cmd, ulong arg)
+static int isdn_divert_ioctl_unlocked(struct file *file, uint cmd, ulong arg)
 {
 	divert_ioctl dioctl;
 	int i;
@@ -257,6 +256,17 @@ isdn_divert_ioctl(struct inode *inode, struct file *file,
 	return copy_to_user((void __user *)arg, &dioctl, sizeof(dioctl)) ? -EFAULT : 0;
 }				/* isdn_divert_ioctl */
 
+static long isdn_divert_ioctl(struct file *file, uint cmd, ulong arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = isdn_divert_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations isdn_fops =
 {
 	.owner          = THIS_MODULE,
@@ -264,7 +274,7 @@ static const struct file_operations isdn_fops =
 	.read           = isdn_divert_read,
 	.write          = isdn_divert_write,
 	.poll           = isdn_divert_poll,
-	.ioctl          = isdn_divert_ioctl,
+	.unlocked_ioctl = isdn_divert_ioctl,
 	.open           = isdn_divert_open,
 	.release        = isdn_divert_close,                                      
 };
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 39bddba..95690a8 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1331,12 +1331,18 @@ static unsigned int cache_poll_procfs(struct file *filp, poll_table *wait)
 	return cache_poll(filp, wait, cd);
 }
 
-static int cache_ioctl_procfs(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
+static long cache_ioctl_procfs(struct file *filp,
+			       unsigned int cmd, unsigned long arg)
 {
+	long ret;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cache_detail *cd = PDE(inode)->data;
 
-	return cache_ioctl(inode, filp, cmd, arg, cd);
+	lock_kernel();
+	ret = cache_ioctl(inode, filp, cmd, arg, cd);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int cache_open_procfs(struct inode *inode, struct file *filp)
@@ -1359,7 +1365,7 @@ static const struct file_operations cache_file_operations_procfs = {
 	.read		= cache_read_procfs,
 	.write		= cache_write_procfs,
 	.poll		= cache_poll_procfs,
-	.ioctl		= cache_ioctl_procfs, /* for FIONREAD */
+	.unlocked_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
 	.open		= cache_open_procfs,
 	.release	= cache_release_procfs,
 };
-- 
1.6.2.3



