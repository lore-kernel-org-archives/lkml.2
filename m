Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0INTlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:41:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0INTkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] cris: autoconvert trivial BKL users
Date: Tue, 14 Sep 2010 21:40:10 +0200
Message-Id: <1284493213-7263-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9Gj/vYQY03+7k3NHYLsP0MGotLN2RR95WaxCUtz7q15
 MKLsEcwH/5ZEnkMh76nQiHXl8WcTyMiVByGNe8qec7CzefRvEM
 W0B8fc6JlhaIOXqqNNT43OwR4dL3gNVQwL/mT3Q2sBrLkDTGQH
 0ryxa2iZcaA0pt5oKQa1kfz4ZMRB9lm2mqxDEkM7f5OxsOPleW
 3FIY3A0y38aVbTpyXMLjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of the big kernel lock in the cris architecture
are for ioctl and open functions of character device drivers,
which can be trivially converted to a per-driver mutex.

Most of these are probably unnecessary, so it may make sense
to audit them and eventually remove the extra mutex introduced
by this patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/arch-v10/drivers/ds1302.c       |    7 ++++---
 arch/cris/arch-v10/drivers/pcf8563.c      |    6 +++---
 arch/cris/arch-v10/drivers/sync_serial.c  |   11 ++++++-----
 arch/cris/arch-v32/drivers/cryptocop.c    |    4 ++--
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |   11 ++++++-----
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |   11 ++++++-----
 arch/cris/arch-v32/drivers/pcf8563.c      |    6 +++---
 arch/cris/arch-v32/drivers/sync_serial.c  |   11 ++++++-----
 8 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 8842756..4b92ad0 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/bcd.h>
 #include <linux/capability.h>
 
@@ -34,6 +34,7 @@
 
 #define RTC_MAJOR_NR 121 /* local major, change later */
 
+static DEFINE_MUTEX(ds1302_mutex);
 static const char ds1302_name[] = "ds1302";
 
 /* The DS1302 might be connected to different bits on different products. 
@@ -357,9 +358,9 @@ static long rtc_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned lon
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ds1302_mutex);
 	ret = rtc_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ds1302_mutex);
 
 	return ret;
 }
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 7dcb1f8..2f1dded 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 #include <linux/bcd.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -49,6 +48,7 @@
 #define rtc_read(x) i2c_readreg(RTC_I2C_READ, x)
 #define rtc_write(x,y) i2c_writereg(RTC_I2C_WRITE, x, y)
 
+static DEFINE_MUTEX(pcf8563_mutex);
 static DEFINE_MUTEX(rtc_lock); /* Protect state etc */
 
 static const unsigned char days_in_month[] =
@@ -343,9 +343,9 @@ static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pcf8563_mutex);
 	return pcf8563_ioctl(filp, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&pcf8563_mutex);
 
 	return ret;
 }
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index ee2dd43..3d9fa07 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -20,7 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/timer.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
@@ -149,6 +149,7 @@ struct sync_port {
 };
 
 
+static DEFINE_MUTEX(sync_serial_mutex);
 static int etrax_sync_serial_init(void);
 static void initialize_port(int portnbr);
 static inline int sync_data_avail(struct sync_port *port);
@@ -445,7 +446,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 	int mode;
 	int err = -EBUSY;
 
-	lock_kernel();
+	mutex_lock(&sync_serial_mutex);
 	DEBUG(printk(KERN_DEBUG "Open sync serial port %d\n", dev));
 
 	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled) {
@@ -626,7 +627,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 	ret = 0;
 	
 out:
-	unlock_kernel();
+	mutex_unlock(&sync_serial_mutex);
 	return ret;
 }
 
@@ -961,9 +962,9 @@ static long sync_serial_ioctl(struct file *file,
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&sync_serial_mutex);
 	ret = sync_serial_ioctl_unlocked(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&sync_serial_mutex);
 
 	return ret;
 }
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b07646a..0973d5a 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -3139,9 +3139,9 @@ cryptocop_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
        struct inode *inode = file->f_path.dentry->d_inode;
        long ret;
 
-       lock_kernel();
+       mutex_lock(&cryptocop_mutex);
        ret = cryptocop_ioctl_unlocked(inode, filp, cmd, arg);
-       unlock_kernel();
+       mutex_unlock(&cryptocop_mutex);
 
        return ret;
 }
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index 2dcd27a..50d1885 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/etraxgpio.h>
 #include <hwregs/reg_map.h>
@@ -66,6 +66,7 @@ static int dp_cnt;
 #define DP(x)
 #endif
 
+static DEFINE_MUTEX(gpio_mutex);
 static char gpio_name[] = "etrax gpio";
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
@@ -391,7 +392,7 @@ static int gpio_open(struct inode *inode, struct file *filp)
 	if (!priv)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&gpio_mutex);
 	memset(priv, 0, sizeof(*priv));
 
 	priv->minor = p;
@@ -414,7 +415,7 @@ static int gpio_open(struct inode *inode, struct file *filp)
 		spin_unlock_irq(&gpio_lock);
 	}
 
-	unlock_kernel();
+	mutex_unlock(&gpio_mutex);
 	return 0;
 }
 
@@ -667,9 +668,9 @@ static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
        long ret;
 
-       lock_kernel();
+       mutex_lock(&gpio_mutex);
        ret = gpio_ioctl_unlocked(file, cmd, arg);
-       unlock_kernel();
+       mutex_unlock(&gpio_mutex);
 
        return ret;
 }
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index 5ec8a7d..de8dca0 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -22,7 +22,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/etraxgpio.h>
 #include <hwregs/reg_map.h>
@@ -64,6 +64,7 @@ static int dp_cnt;
 #define DP(x)
 #endif
 
+static DEFINE_MUTEX(gpio_mutex);
 static char gpio_name[] = "etrax gpio";
 
 #if 0
@@ -429,7 +430,7 @@ gpio_open(struct inode *inode, struct file *filp)
 	if (!priv)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&gpio_mutex);
 	memset(priv, 0, sizeof(*priv));
 
 	priv->minor = p;
@@ -450,7 +451,7 @@ gpio_open(struct inode *inode, struct file *filp)
 	alarmlist = priv;
 	spin_unlock_irq(&alarm_lock);
 
-	unlock_kernel();
+	mutex_unlock(&gpio_mutex);
 	return 0;
 }
 
@@ -708,9 +709,9 @@ static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
        long ret;
 
-       lock_kernel();
+       mutex_lock(&gpio_mutex);
        ret = gpio_ioctl_unlocked(file, cmd, arg);
-       unlock_kernel();
+       mutex_unlock(&gpio_mutex);
 
        return ret;
 }
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index bef6eb5..bdcac9d 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/bcd.h>
 #include <linux/mutex.h>
@@ -45,6 +44,7 @@
 #define rtc_read(x) i2c_readreg(RTC_I2C_READ, x)
 #define rtc_write(x,y) i2c_writereg(RTC_I2C_WRITE, x, y)
 
+static DEFINE_MUTEX(pcf8563_mutex);
 static DEFINE_MUTEX(rtc_lock); /* Protect state etc */
 
 static const unsigned char days_in_month[] =
@@ -339,9 +339,9 @@ static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pcf8563_mutex);
 	return pcf8563_ioctl(filp, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&pcf8563_mutex);
 
 	return ret;
 }
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index ca248f3..a01ae9f 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -13,7 +13,7 @@
 #include <linux/errno.h>
 #include <linux/major.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/poll.h>
 #include <linux/init.h>
@@ -145,6 +145,7 @@ typedef struct sync_port
 	spinlock_t lock;
 } sync_port;
 
+static DEFINE_MUTEX(sync_serial_mutex);
 static int etrax_sync_serial_init(void);
 static void initialize_port(int portnbr);
 static inline int sync_data_avail(struct sync_port *port);
@@ -434,7 +435,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 	reg_dma_rw_cfg cfg = {.en = regk_dma_yes};
 	reg_dma_rw_intr_mask intr_mask = {.data = regk_dma_yes};
 
-	lock_kernel();
+	mutex_lock(&sync_serial_mutex);
 	DEBUG(printk(KERN_DEBUG "Open sync serial port %d\n", dev));
 
 	if (dev < 0 || dev >= NBR_PORTS || !ports[dev].enabled)
@@ -583,7 +584,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 	port->busy++;
 	ret = 0;
 out:
-	unlock_kernel();
+	mutex_unlock(&sync_serial_mutex);
 	return ret;
 }
 
@@ -966,9 +967,9 @@ static long sync_serial_ioctl(struct file *file,
 {
        long ret;
 
-       lock_kernel();
+       mutex_lock(&sync_serial_mutex);
        ret = sync_serial_ioctl_unlocked(file, cmd, arg);
-       unlock_kernel();
+       mutex_unlock(&sync_serial_mutex);
 
        return ret;
 }
-- 
1.7.1

