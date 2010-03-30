Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0C3GUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:20:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34946 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0C3GUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iv7aOr//dNm/oxifYm9VAa32cEbaUi2h+l3ww8O/n5fPLDhSlorlhoCCjrI+i1bsAr
         Ri1YvluZlyDxLRskCay2ujip+9DIDNqU5iRfYrAxo8lALElGFk6wF1xlZqIhD/3qPf9W
         qAdpgAe7g6IWjupRtSOByP7dJNGeUrnPtWNNA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/6] procfs: Push down the bkl from ioctl
Date: Tue, 30 Mar 2010 08:20:14 +0200
Message-Id: <1269930015-863-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push down the bkl from procfs's ioctl main handler to its users.
Only three procfs users implement an ioctl (non unlocked) handler.
Turn them into unlocked_ioctl and push down the Devil inside.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 drivers/char/i8k.c                  |   53 +++++++++++++++------
 drivers/isdn/divert/divert_procfs.c |   90 ++++++++++++++++++++++-------------
 net/sunrpc/cache.c                  |   20 ++++++--
 3 files changed, 109 insertions(+), 54 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index fc8cf7a..85f8893 100644
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
@@ -307,8 +307,7 @@ static int i8k_get_dell_signature(int req_fn)
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
 }
 
-static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
-		     unsigned long arg)
+static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int val = 0;
 	int speed;
@@ -318,6 +317,9 @@ static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 	if (!argp)
 		return -EINVAL;
 
+	/* Pushed down from procfs ioctl handler */
+	lock_kernel();
+
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
 		val = i8k_get_bios_version();
@@ -341,57 +343,78 @@ static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 		break;
 
 	case I8K_GET_SPEED:
-		if (copy_from_user(&val, argp, sizeof(int)))
+		if (copy_from_user(&val, argp, sizeof(int))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		val = i8k_get_fan_speed(val);
 		break;
 
 	case I8K_GET_FAN:
-		if (copy_from_user(&val, argp, sizeof(int)))
+		if (copy_from_user(&val, argp, sizeof(int))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		val = i8k_get_fan_status(val);
 		break;
 
 	case I8K_SET_FAN:
-		if (restricted && !capable(CAP_SYS_ADMIN))
+		if (restricted && !capable(CAP_SYS_ADMIN)) {
+			unlock_kernel();
 			return -EPERM;
+		}
 
-		if (copy_from_user(&val, argp, sizeof(int)))
+		if (copy_from_user(&val, argp, sizeof(int))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
-		if (copy_from_user(&speed, argp + 1, sizeof(int)))
+		if (copy_from_user(&speed, argp + 1, sizeof(int))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		val = i8k_set_fan(val, speed);
 		break;
 
 	default:
+		unlock_kernel();
 		return -EINVAL;
 	}
 
-	if (val < 0)
-		return val;
+	if (val < 0) {
+		unlock_kernel();
+		return -val;
+	}
 
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
-		if (copy_to_user(argp, &val, 4))
+		if (copy_to_user(argp, &val, 4)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		break;
 	case I8K_MACHINE_ID:
-		if (copy_to_user(argp, buff, 16))
+		if (copy_to_user(argp, buff, 16)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		break;
 	default:
-		if (copy_to_user(argp, &val, sizeof(int)))
+		if (copy_to_user(argp, &val, sizeof(int))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		break;
 	}
 
+	unlock_kernel();
+
 	return 0;
 }
 
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index 3697c40..24b3642 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/isdnif.h>
 #include <net/net_namespace.h>
+#include <linux/smp_lock.h>
 #include "isdn_divert.h"
 
 
@@ -176,18 +177,20 @@ isdn_divert_close(struct inode *ino, struct file *filep)
 /*********/
 /* IOCTL */
 /*********/
-static int
-isdn_divert_ioctl(struct inode *inode, struct file *file,
-		  uint cmd, ulong arg)
+static long isdn_divert_ioctl(struct file *file, uint cmd, ulong arg)
 {
 	divert_ioctl dioctl;
-	int i;
 	unsigned long flags;
 	divert_rule *rulep;
 	char *cp;
 
-	if (copy_from_user(&dioctl, (void __user *) arg, sizeof(dioctl)))
+	/* Pushed down from procfs ioctl handler */
+	lock_kernel();
+
+	if (copy_from_user(&dioctl, (void __user *) arg, sizeof(dioctl))) {
+		unlock_kernel();
 		return -EFAULT;
+	}
 
 	switch (cmd) {
 		case IIOCGETVER:
@@ -195,65 +198,84 @@ isdn_divert_ioctl(struct inode *inode, struct file *file,
 			break;
 
 		case IIOCGETDRV:
-			if ((dioctl.getid.drvid = divert_if.name_to_drv(dioctl.getid.drvnam)) < 0)
-				return (-EINVAL);
+			if ((dioctl.getid.drvid = divert_if.name_to_drv(dioctl.getid.drvnam)) < 0) {
+				unlock_kernel();
+				return -EINVAL;
+			}
 			break;
 
 		case IIOCGETNAM:
 			cp = divert_if.drv_to_name(dioctl.getid.drvid);
-			if (!cp)
-				return (-EINVAL);
-			if (!*cp)
-				return (-EINVAL);
+			if (!cp || !*cp) {
+				unlock_kernel();
+				return -EINVAL;
+			}
 			strcpy(dioctl.getid.drvnam, cp);
 			break;
 
 		case IIOCGETRULE:
-			if (!(rulep = getruleptr(dioctl.getsetrule.ruleidx)))
-				return (-EINVAL);
+			if (!(rulep = getruleptr(dioctl.getsetrule.ruleidx))) {
+				unlock_kernel();
+				return -EINVAL;
+			}
 			dioctl.getsetrule.rule = *rulep;	/* copy data */
 			break;
 
 		case IIOCMODRULE:
-			if (!(rulep = getruleptr(dioctl.getsetrule.ruleidx)))
-				return (-EINVAL);
-            spin_lock_irqsave(&divert_lock, flags);
+			if (!(rulep = getruleptr(dioctl.getsetrule.ruleidx))) {
+				unlock_kernel();
+				return -EINVAL;
+			}
+			spin_lock_irqsave(&divert_lock, flags);
 			*rulep = dioctl.getsetrule.rule;	/* copy data */
 			spin_unlock_irqrestore(&divert_lock, flags);
-			return (0);	/* no copy required */
-			break;
+
+			unlock_kernel();
+			return 0;	/* no copy required */
 
 		case IIOCINSRULE:
-			return (insertrule(dioctl.getsetrule.ruleidx, &dioctl.getsetrule.rule));
-			break;
+			unlock_kernel();
+			return insertrule(dioctl.getsetrule.ruleidx, &dioctl.getsetrule.rule);
 
 		case IIOCDELRULE:
-			return (deleterule(dioctl.getsetrule.ruleidx));
-			break;
+			unlock_kernel();
+			return deleterule(dioctl.getsetrule.ruleidx);
 
 		case IIOCDODFACT:
-			return (deflect_extern_action(dioctl.fwd_ctrl.subcmd,
-						  dioctl.fwd_ctrl.callid,
-						 dioctl.fwd_ctrl.to_nr));
+			unlock_kernel();
+			return deflect_extern_action(dioctl.fwd_ctrl.subcmd,
+						     dioctl.fwd_ctrl.callid,
+						     dioctl.fwd_ctrl.to_nr);
 
 		case IIOCDOCFACT:
 		case IIOCDOCFDIS:
-		case IIOCDOCFINT:
-			if (!divert_if.drv_to_name(dioctl.cf_ctrl.drvid))
-				return (-EINVAL);	/* invalid driver */
-			if ((i = cf_command(dioctl.cf_ctrl.drvid,
+		case IIOCDOCFINT: {
+			long err;
+
+			if (!divert_if.drv_to_name(dioctl.cf_ctrl.drvid)) {
+				unlock_kernel();
+				return -EINVAL;	/* invalid driver */
+			}
+			err = cf_command(dioctl.cf_ctrl.drvid,
 					    (cmd == IIOCDOCFACT) ? 1 : (cmd == IIOCDOCFDIS) ? 0 : 2,
 					    dioctl.cf_ctrl.cfproc,
 					    dioctl.cf_ctrl.msn,
 					    dioctl.cf_ctrl.service,
 					    dioctl.cf_ctrl.fwd_nr,
-					    &dioctl.cf_ctrl.procid)))
-				return (i);
+					    &dioctl.cf_ctrl.procid);
+			if (err) {
+				unlock_kernel();
+				return err;
+			}
 			break;
 
+		}
 		default:
-			return (-EINVAL);
-	}			/* switch cmd */
+			unlock_kernel();
+			return -EINVAL;
+	}
+
+	unlock_kernel();
 	return copy_to_user((void __user *)arg, &dioctl, sizeof(dioctl)) ? -EFAULT : 0;
 }				/* isdn_divert_ioctl */
 
@@ -264,7 +286,7 @@ static const struct file_operations isdn_fops =
 	.read           = isdn_divert_read,
 	.write          = isdn_divert_write,
 	.poll           = isdn_divert_poll,
-	.ioctl          = isdn_divert_ioctl,
+	.unlocked_ioctl = isdn_divert_ioctl,
 	.open           = isdn_divert_open,
 	.release        = isdn_divert_close,                                      
 };
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 39bddba..08abb9b 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1331,12 +1331,22 @@ static unsigned int cache_poll_procfs(struct file *filp, poll_table *wait)
 	return cache_poll(filp, wait, cd);
 }
 
-static int cache_ioctl_procfs(struct inode *inode, struct file *filp,
-			      unsigned int cmd, unsigned long arg)
+static long cache_ioctl_procfs(struct file *filp,
+			       unsigned int cmd, unsigned long arg)
 {
-	struct cache_detail *cd = PDE(inode)->data;
+	long ret;
+	struct cache_detail *cd;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
-	return cache_ioctl(inode, filp, cmd, arg, cd);
+	/* Pushed down from procfs ioctl handler */
+	lock_kernel();
+
+	cd = PDE(inode)->data;
+	ret = cache_ioctl(inode, filp, cmd, arg, cd);
+
+	unlock_kernel();
+
+	return ret;
 }
 
 static int cache_open_procfs(struct inode *inode, struct file *filp)
@@ -1359,7 +1369,7 @@ static const struct file_operations cache_file_operations_procfs = {
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

