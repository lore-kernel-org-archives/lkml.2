Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0GCWP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:15:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0GCWPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:15:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Cris <linux-cris-kernel@axis.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/6] cris: Pushdown the bkl from ioctl
Date: Sun,  4 Jul 2010 00:15:08 +0200
Message-Id: <1278195310-25590-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278195310-25590-1-git-send-email-arnd@arndb.de>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/dEgKOjRwL7agFUfGG6l4CxFujO1maf3z8l5
 jCVnfqk6QzJ03pBXvHUApHDDabeEj2eoqTVPc4+AjVVRZKrjYd
 LckgNdBSEYW4k27Y4zMRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Pushdown the bkl to the remaining drivers using the
deprecated .ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Cris <linux-cris-kernel@axis.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
---
 arch/cris/arch-v10/drivers/gpio.c         |   30 ++++++++++++++++++---------
 arch/cris/arch-v10/drivers/i2c.c          |   24 ++++++++++++++++-----
 arch/cris/arch-v10/drivers/sync_serial.c  |   32 +++++++++++++++++++---------
 arch/cris/arch-v32/drivers/cryptocop.c    |   24 ++++++++++++++++-----
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |   28 +++++++++++++++++--------
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |   29 +++++++++++++++++---------
 arch/cris/arch-v32/drivers/sync_serial.c  |   30 +++++++++++++++++++--------
 7 files changed, 137 insertions(+), 60 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 4b0f65f..300bd37 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -46,8 +46,7 @@ static char gpio_name[] = "etrax gpio";
 static wait_queue_head_t *gpio_wq;
 #endif
 
-static int gpio_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg);
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static ssize_t gpio_write(struct file *file, const char __user *buf,
 	size_t count, loff_t *off);
 static int gpio_open(struct inode *inode, struct file *filp);
@@ -505,8 +504,7 @@ static int
 gpio_leds_ioctl(unsigned int cmd, unsigned long arg);
 
 static int
-gpio_ioctl(struct inode *inode, struct file *file,
-	   unsigned int cmd, unsigned long arg)
+gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 	unsigned long val;
@@ -684,6 +682,18 @@ gpio_ioctl(struct inode *inode, struct file *file,
 }
 
 static int
+gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = gpio_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+static int
 gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 {
 	unsigned char green;
@@ -713,12 +723,12 @@ gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 }
 
 static const struct file_operations gpio_fops = {
-	.owner       = THIS_MODULE,
-	.poll        = gpio_poll,
-	.ioctl       = gpio_ioctl,
-	.write       = gpio_write,
-	.open        = gpio_open,
-	.release     = gpio_release,
+	.owner		= THIS_MODULE,
+	.poll		= gpio_poll,
+	.unlocked_ioctl	= gpio_ioctl,
+	.write		= gpio_write,
+	.open		= gpio_open,
+	.release	= gpio_release,
 };
 
 static void ioif_watcher(const unsigned int gpio_in_available,
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index a8737a8..6da8580 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -580,8 +580,7 @@ i2c_release(struct inode *inode, struct file *filp)
  */
 
 static int
-i2c_ioctl(struct inode *inode, struct file *file,
-	  unsigned int cmd, unsigned long arg)
+i2c_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	if(_IOC_TYPE(cmd) != ETRAXI2C_IOCTYPE) {
 		return -EINVAL;
@@ -617,11 +616,24 @@ i2c_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
+static long
+i2c_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = i2c_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 static const struct file_operations i2c_fops = {
-	.owner    = THIS_MODULE,
-	.ioctl    = i2c_ioctl,
-	.open     = i2c_open,
-	.release  = i2c_release,
+	.owner    	= THIS_MODULE,
+	.unlocked_ioctl = i2c_ioctl,
+	.open		= i2c_open,
+	.release	= i2c_release,
 };
 
 int __init
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 109dcd8..5295485 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -157,7 +157,7 @@ static int sync_serial_open(struct inode *inode, struct file *file);
 static int sync_serial_release(struct inode *inode, struct file *file);
 static unsigned int sync_serial_poll(struct file *filp, poll_table *wait);
 
-static int sync_serial_ioctl(struct inode *inode, struct file *file,
+static long sync_serial_ioctl(struct file *file,
 	unsigned int cmd, unsigned long arg);
 static ssize_t sync_serial_write(struct file *file, const char *buf,
 	size_t count, loff_t *ppos);
@@ -244,13 +244,13 @@ static unsigned sync_serial_prescale_shadow;
 #define NUMBER_OF_PORTS 2
 
 static const struct file_operations sync_serial_fops = {
-	.owner   = THIS_MODULE,
-	.write   = sync_serial_write,
-	.read    = sync_serial_read,
-	.poll    = sync_serial_poll,
-	.ioctl   = sync_serial_ioctl,
-	.open    = sync_serial_open,
-	.release = sync_serial_release
+	.owner		= THIS_MODULE,
+	.write		= sync_serial_write,
+	.read		= sync_serial_read,
+	.poll		= sync_serial_poll,
+	.unlocked_ioctl = sync_serial_ioctl,
+	.open		= sync_serial_open,
+	.release	= sync_serial_release
 };
 
 static int __init etrax_sync_serial_init(void)
@@ -678,8 +678,8 @@ static unsigned int sync_serial_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static int sync_serial_ioctl(struct inode *inode, struct file *file,
-		  unsigned int cmd, unsigned long arg)
+static int sync_serial_ioctl_unlocked(struct file *file,
+				      unsigned int cmd, unsigned long arg)
 {
 	int return_val = 0;
 	unsigned long flags;
@@ -956,6 +956,18 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 	return return_val;
 }
 
+static long sync_serial_ioctl(struct file *file,
+			      unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = sync_serial_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 
 static ssize_t sync_serial_write(struct file *file, const char *buf,
 	size_t count, loff_t *ppos)
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b70fb34..1070bf2 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -217,7 +217,7 @@ static int cryptocop_open(struct inode *, struct file *);
 
 static int cryptocop_release(struct inode *, struct file *);
 
-static int cryptocop_ioctl(struct inode *inode, struct file *file,
+static long cryptocop_ioctl(struct file *file,
 			   unsigned int cmd, unsigned long arg);
 
 static void cryptocop_start_job(void);
@@ -279,10 +279,10 @@ static void print_user_dma_lists(struct cryptocop_dma_list_operation *dma_op);
 
 
 const struct file_operations cryptocop_fops = {
-	.owner =	THIS_MODULE,
-	.open =		cryptocop_open,
-	.release =	cryptocop_release,
-	.ioctl =	cryptocop_ioctl
+	.owner		= THIS_MODULE,
+	.open		= cryptocop_open,
+	.release	= cryptocop_release,
+	.unlocked_ioctl = cryptocop_ioctl,
 };
 
 
@@ -3102,7 +3102,7 @@ static int cryptocop_ioctl_create_session(struct inode *inode, struct file *filp
 	return 0;
 }
 
-static int cryptocop_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
+static int cryptocop_ioctl_unlocked(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
 	if (_IOC_TYPE(cmd) != ETRAXCRYPTOCOP_IOCTYPE) {
@@ -3134,6 +3134,18 @@ static int cryptocop_ioctl(struct inode *inode, struct file *filp, unsigned int
 	return 0;
 }
 
+static long cryptocop_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	long ret;
+
+	lock_kernel();
+	ret = cryptocop_ioctl_unlocked(inode, filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 
 #ifdef LDEBUG
 static void print_dma_descriptors(struct cryptocop_int_operation *iop)
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index 97357cf..4dcfae3 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -72,8 +72,7 @@ static char gpio_name[] = "etrax gpio";
 static int virtual_gpio_ioctl(struct file *file, unsigned int cmd,
 			      unsigned long arg);
 #endif
-static int gpio_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg);
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static ssize_t gpio_write(struct file *file, const char __user *buf,
 	size_t count, loff_t *off);
 static int gpio_open(struct inode *inode, struct file *filp);
@@ -521,7 +520,7 @@ static inline unsigned long setget_output(struct gpio_private *priv,
 	return dir_shadow;
 } /* setget_output */
 
-static int gpio_ioctl(struct inode *inode, struct file *file,
+static int gpio_ioctl_unlocked(struct file *file,
 	unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
@@ -664,6 +663,17 @@ static int gpio_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = gpio_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
 static int virtual_gpio_ioctl(struct file *file, unsigned int cmd,
 	unsigned long arg)
@@ -877,12 +887,12 @@ static int gpio_pwm_ioctl(struct gpio_private *priv, unsigned int cmd,
 }
 
 static const struct file_operations gpio_fops = {
-	.owner       = THIS_MODULE,
-	.poll        = gpio_poll,
-	.ioctl       = gpio_ioctl,
-	.write       = gpio_write,
-	.open        = gpio_open,
-	.release     = gpio_release,
+	.owner		= THIS_MODULE,
+	.poll		= gpio_poll,
+	.unlocked_ioctl = gpio_ioctl,
+	.write		= gpio_write,
+	.open		= gpio_open,
+	.release	= gpio_release,
 };
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index d89ab80..d2e184c 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -74,8 +74,7 @@ static wait_queue_head_t *gpio_wq;
 static int virtual_gpio_ioctl(struct file *file, unsigned int cmd,
 	unsigned long arg);
 #endif
-static int gpio_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg);
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static ssize_t gpio_write(struct file *file, const char *buf, size_t count,
 	loff_t *off);
 static int gpio_open(struct inode *inode, struct file *filp);
@@ -561,8 +560,7 @@ static int
 gpio_leds_ioctl(unsigned int cmd, unsigned long arg);
 
 static int
-gpio_ioctl(struct inode *inode, struct file *file,
-	   unsigned int cmd, unsigned long arg)
+gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 	unsigned long val;
@@ -707,6 +705,17 @@ gpio_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = gpio_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
 static int
 virtual_gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -856,12 +865,12 @@ gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 }
 
 static const struct file_operations gpio_fops = {
-	.owner       = THIS_MODULE,
-	.poll        = gpio_poll,
-	.ioctl       = gpio_ioctl,
-	.write       = gpio_write,
-	.open        = gpio_open,
-	.release     = gpio_release,
+	.owner		= THIS_MODULE,
+	.poll		= gpio_poll,
+	.unlocked_ioctl	= gpio_ioctl,
+	.write		= gpio_write,
+	.open		= gpio_open,
+	.release	= gpio_release,
 };
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index 4889f19..bf6d2f9 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -153,7 +153,7 @@ static int sync_serial_open(struct inode *, struct file*);
 static int sync_serial_release(struct inode*, struct file*);
 static unsigned int sync_serial_poll(struct file *filp, poll_table *wait);
 
-static int sync_serial_ioctl(struct inode*, struct file*,
+static long sync_serial_ioctl(struct file *,
 			     unsigned int cmd, unsigned long arg);
 static ssize_t sync_serial_write(struct file * file, const char * buf,
 				 size_t count, loff_t *ppos);
@@ -241,13 +241,13 @@ static struct sync_port ports[]=
 #define NBR_PORTS ARRAY_SIZE(ports)
 
 static const struct file_operations sync_serial_fops = {
-	.owner   = THIS_MODULE,
-	.write   = sync_serial_write,
-	.read    = sync_serial_read,
-	.poll    = sync_serial_poll,
-	.ioctl   = sync_serial_ioctl,
-	.open    = sync_serial_open,
-	.release = sync_serial_release
+	.owner		= THIS_MODULE,
+	.write		= sync_serial_write,
+	.read		= sync_serial_read,
+	.poll		= sync_serial_poll,
+	.unlocked_ioctl = sync_serial_ioctl,
+	.open		= sync_serial_open,
+	.release	= sync_serial_release
 };
 
 static int __init etrax_sync_serial_init(void)
@@ -650,7 +650,7 @@ static unsigned int sync_serial_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static int sync_serial_ioctl(struct inode *inode, struct file *file,
+static int sync_serial_ioctl_unlocked(struct file *file,
 		  unsigned int cmd, unsigned long arg)
 {
 	int return_val = 0;
@@ -961,6 +961,18 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 	return return_val;
 }
 
+static long sync_serial_ioctl(struct file *file,
+			      unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = sync_serial_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /* NOTE: sync_serial_write does not support concurrency */
 static ssize_t sync_serial_write(struct file *file, const char *buf,
 				 size_t count, loff_t *ppos)
-- 
1.7.1

