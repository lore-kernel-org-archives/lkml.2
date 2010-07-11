Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0GKVTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:19:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0GKVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:19:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 08/12] sbus: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:18:59 +0200
Message-Id: <1278883143-29035-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uCnseFBfTopHBTa3YXI7QtH+vr5QK2XB44cHpHvqfti
 LJrVV7BWIgUsrlKUO4795K7OXcWb1Jjl3MYUaIM7LIFXdYCVE0
 7w5wyMV1v3jTK8X0H0zzYlKlPq2eg4qs8b8ONS2Ryh8kV+sQts
 8jrn6LGqz696VfK14zirb0sVxUAT3aPDBxlUZD+alWU/XfEqoH
 0qPwMtaZt1dFj28KF4DIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these files use the big kernel lock in a trivial
way to serialize their private file operations,
typically resulting from an earlier semi-automatic
pushdown from VFS.

None of these drivers appears to want to lock against
other code, and they all use the BKL as the top-level
lock in their file operations, meaning that there
is no lock-order inversion problem.

Consequently, we can remove the BKL completely,
replacing it with a per-file mutex in every case.
Using a scripted approach means we can avoid
typos.

file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/sbus/char/display7seg.c |    8 ++++----
 drivers/sbus/char/envctrl.c     |    2 --
 drivers/sbus/char/flash.c       |   15 ++++++++-------
 drivers/sbus/char/openprom.c    |   15 ++++++++-------
 drivers/sbus/char/uctrl.c       |    7 ++++---
 5 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 7baf1b6..4ad4d2c 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -13,7 +13,7 @@
 #include <linux/miscdevice.h>
 #include <linux/ioport.h>		/* request_region */
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <asm/atomic.h>
@@ -26,6 +26,7 @@
 #define DRIVER_NAME	"d7s"
 #define PFX		DRIVER_NAME ": "
 
+static DEFINE_MUTEX(d7s_mutex);
 static int sol_compat = 0;		/* Solaris compatibility mode	*/
 
 /* Solaris compatibility flag -
@@ -74,7 +75,6 @@ static int d7s_open(struct inode *inode, struct file *f)
 {
 	if (D7S_MINOR != iminor(inode))
 		return -ENODEV;
-	cycle_kernel_lock();
 	atomic_inc(&d7s_users);
 	return 0;
 }
@@ -110,7 +110,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (D7S_MINOR != iminor(file->f_path.dentry->d_inode))
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&d7s_mutex);
 	switch (cmd) {
 	case D7SIOCWR:
 		/* assign device register values we mask-out D7S_FLIP
@@ -151,7 +151,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		writeb(regs, p->regs);
 		break;
 	};
-	unlock_kernel();
+	mutex_unlock(&d7s_mutex);
 
 	return error;
 }
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index c8166ec..bd0bbc6 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -27,7 +27,6 @@
 #include <linux/kmod.h>
 #include <linux/reboot.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 
@@ -699,7 +698,6 @@ envctrl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static int
 envctrl_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	file->private_data = NULL;
 	return 0;
 }
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 368d662..ed9494e 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -10,7 +10,7 @@
 #include <linux/fcntl.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
 #include <linux/of.h>
@@ -22,6 +22,7 @@
 #include <asm/io.h>
 #include <asm/upa.h>
 
+static DEFINE_MUTEX(flash_mutex);
 static DEFINE_SPINLOCK(flash_lock);
 static struct {
 	unsigned long read_base;	/* Physical read address */
@@ -80,7 +81,7 @@ flash_mmap(struct file *file, struct vm_area_struct *vma)
 static long long
 flash_llseek(struct file *file, long long offset, int origin)
 {
-	lock_kernel();
+	mutex_lock(&flash_mutex);
 	switch (origin) {
 		case 0:
 			file->f_pos = offset;
@@ -94,10 +95,10 @@ flash_llseek(struct file *file, long long offset, int origin)
 			file->f_pos = flash.read_size;
 			break;
 		default:
-			unlock_kernel();
+			mutex_unlock(&flash_mutex);
 			return -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&flash_mutex);
 	return file->f_pos;
 }
 
@@ -125,13 +126,13 @@ flash_read(struct file * file, char __user * buf,
 static int
 flash_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&flash_mutex);
 	if (test_and_set_bit(0, (void *)&flash.busy) != 0) {
-		unlock_kernel();
+		mutex_unlock(&flash_mutex);
 		return -EBUSY;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&flash_mutex);
 	return 0;
 }
 
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index d53e62a..72f04fc 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -33,7 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
@@ -61,6 +61,7 @@ typedef struct openprom_private_data
 } DATA;
 
 /* ID of the PROM node containing all of the EEPROM options. */
+static DEFINE_MUTEX(openprom_mutex);
 static struct device_node *options_node;
 
 /*
@@ -316,7 +317,7 @@ static long openprom_sunos_ioctl(struct file * file,
 	if (bufsize < 0)
 		return bufsize;
 
-	lock_kernel();
+	mutex_lock(&openprom_mutex);
 
 	switch (cmd) {
 	case OPROMGETOPT:
@@ -367,7 +368,7 @@ static long openprom_sunos_ioctl(struct file * file,
 	}
 
 	kfree(opp);
-	unlock_kernel();
+	mutex_unlock(&openprom_mutex);
 
 	return error;
 }
@@ -558,7 +559,7 @@ static int openprom_bsd_ioctl(struct file * file,
 	void __user *argp = (void __user *)arg;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&openprom_mutex);
 	switch (cmd) {
 	case OPIOCGET:
 		err = opiocget(argp, data);
@@ -589,7 +590,7 @@ static int openprom_bsd_ioctl(struct file * file,
 		err = -EINVAL;
 		break;
 	};
-	unlock_kernel();
+	mutex_unlock(&openprom_mutex);
 
 	return err;
 }
@@ -697,11 +698,11 @@ static int openprom_open(struct inode * inode, struct file * file)
 	if (!data)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&openprom_mutex);
 	data->current_node = of_find_node_by_path("/");
 	data->lastnode = data->current_node;
 	file->private_data = (void *) data;
-	unlock_kernel();
+	mutex_unlock(&openprom_mutex);
 
 	return 0;
 }
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 5f25366..079da4c 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -9,7 +9,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
@@ -72,6 +72,7 @@ struct ts102_regs {
 #define UCTRL_STAT_RXNE_STA        0x04    /* receive FIFO not empty status */
 #define UCTRL_STAT_RXO_STA         0x08    /* receive FIFO overflow status */
 
+static DEFINE_MUTEX(uctrl_mutex);
 static const char *uctrl_extstatus[16] = {
         "main power available",
         "internal battery attached",
@@ -210,10 +211,10 @@ uctrl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static int
 uctrl_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&uctrl_mutex);
 	uctrl_get_event_status(global_driver);
 	uctrl_get_external_status(global_driver);
-	unlock_kernel();
+	mutex_unlock(&uctrl_mutex);
 	return 0;
 }
 
-- 
1.7.1

