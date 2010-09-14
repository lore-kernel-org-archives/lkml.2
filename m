Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0INTlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:41:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0INTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] hpet: kill BKL, add compat_ioctl
Date: Tue, 14 Sep 2010 21:40:05 +0200
Message-Id: <1284493213-7263-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NyxJI10+/opYWVRx1agExBRpvTgwucdSXgdywFNbDtq
 tfTihPO6JDVRFOOITD0PB6RoF/Ce2AG62thUoJugldbG7bdp5f
 rhJzNm3lodO5VHwGVggNGhy326+A8l0JiBBvf8GMK0WWEYMkSd
 7OYSMxZIMorcogOzclAi/WhFDT7OgFQI20gtMtDWFzf+QNm1CO
 P6FkN4cEQto0KZdMAtkeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpet uses the big kernel lock in its ioctl and open
functions. Replace this with a private mutex to be
sure. Since we're already touching the ioctl function,
add the compat_ioctl version as well -- all commands
except HPET_INFO are compatible and that one is easy
to add.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Bob Picco <bob.picco@hp.com>
---
 drivers/char/hpet.c |   98 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 64 insertions(+), 34 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index a0a1829..a4eee32 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -30,6 +30,7 @@
 #include <linux/bcd.h>
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
+#include <linux/compat.h>
 #include <linux/clocksource.h>
 #include <linux/slab.h>
 
@@ -67,6 +68,7 @@
 #define	read_counter(MC)	readl(MC)
 #endif
 
+static DEFINE_MUTEX(hpet_mutex); /* replaces BKL */
 static u32 hpet_nhpet, hpet_max_freq = HPET_USER_FREQ;
 
 /* This clocksource driver currently only works on ia64 */
@@ -250,7 +252,7 @@ static int hpet_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
-	lock_kernel();
+	mutex_lock(&hpet_mutex);
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -264,7 +266,7 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
+		mutex_unlock(&hpet_mutex);
 		return -EBUSY;
 	}
 
@@ -272,7 +274,7 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
-	unlock_kernel();
+	mutex_unlock(&hpet_mutex);
 
 	hpet_timer_set_irq(devp);
 
@@ -429,22 +431,6 @@ static int hpet_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
-
-static long hpet_ioctl(struct file *file, unsigned int cmd,
-			unsigned long arg)
-{
-	struct hpet_dev *devp;
-	int ret;
-
-	devp = file->private_data;
-	lock_kernel();
-	ret = hpet_ioctl_common(devp, cmd, arg, 0);
-	unlock_kernel();
-
-	return ret;
-}
-
 static int hpet_ioctl_ieon(struct hpet_dev *devp)
 {
 	struct hpet_timer __iomem *timer;
@@ -553,7 +539,8 @@ static inline unsigned long hpet_time_div(struct hpets *hpets,
 }
 
 static int
-hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
+hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg,
+		  struct hpet_info *info)
 {
 	struct hpet_timer __iomem *timer;
 	struct hpet __iomem *hpet;
@@ -594,23 +581,15 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 		break;
 	case HPET_INFO:
 		{
-			struct hpet_info info;
-
 			if (devp->hd_ireqfreq)
-				info.hi_ireqfreq =
+				info->hi_ireqfreq =
 					hpet_time_div(hpetp, devp->hd_ireqfreq);
 			else
-				info.hi_ireqfreq = 0;
-			info.hi_flags =
+				info->hi_ireqfreq = 0;
+			info->hi_flags =
 			    readq(&timer->hpet_config) & Tn_PER_INT_CAP_MASK;
-			info.hi_hpet = hpetp->hp_which;
-			info.hi_timer = devp - hpetp->hp_dev;
-			if (kernel)
-				memcpy((void *)arg, &info, sizeof(info));
-			else
-				if (copy_to_user((void __user *)arg, &info,
-						 sizeof(info)))
-					err = -EFAULT;
+			info->hi_hpet = hpetp->hp_which;
+			info->hi_timer = devp - hpetp->hp_dev;
 			break;
 		}
 	case HPET_EPI:
@@ -636,7 +615,7 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 		devp->hd_flags &= ~HPET_PERIODIC;
 		break;
 	case HPET_IRQFREQ:
-		if (!kernel && (arg > hpet_max_freq) &&
+		if ((arg > hpet_max_freq) &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EACCES;
 			break;
@@ -653,12 +632,63 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 	return err;
 }
 
+static long
+hpet_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct hpet_info info;
+	int err;
+
+	mutex_lock(&hpet_mutex);
+	err = hpet_ioctl_common(file->private_data, cmd, arg, &info);
+	mutex_unlock(&hpet_mutex);
+
+	if ((cmd == HPET_INFO) && !err &&
+	    (copy_to_user((void __user *)arg, &info, sizeof(info))))
+		err = -EFAULT;
+
+	return err;
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_hpet_info {
+	compat_ulong_t hi_ireqfreq;	/* Hz */
+	compat_ulong_t hi_flags;	/* information */
+	unsigned short hi_hpet;
+	unsigned short hi_timer;
+};
+
+static long
+hpet_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct hpet_info info;
+	int err;
+
+	mutex_lock(&hpet_mutex);
+	err = hpet_ioctl_common(file->private_data, cmd, arg, &info);
+	mutex_unlock(&hpet_mutex);
+
+	if ((cmd == HPET_INFO) && !err) {
+		struct compat_hpet_info __user *u = compat_ptr(arg);
+		if (put_user(info.hi_ireqfreq, &u->hi_ireqfreq) ||
+		    put_user(info.hi_flags, &u->hi_flags) ||
+		    put_user(info.hi_hpet, &u->hi_hpet) ||
+		    put_user(info.hi_timer, &u->hi_timer))
+			err = -EFAULT;
+	}
+
+	return err;
+}
+#endif
+
 static const struct file_operations hpet_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
 	.unlocked_ioctl = hpet_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = hpet_compat_ioctl,
+#endif
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-- 
1.7.1

