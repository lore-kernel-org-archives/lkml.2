Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0D0JTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:19:37 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0D0JTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=slxQBNVmdqvlxYr5elgz558C8X5Gr2ITMsgW7t8NZLCPQsVYjngVAn5FHBiC2m8go5
         oo5NNN0oC4oKu7gYGDZnvYLtsBy6uEDHR27iT3tywHHdrvhIn+6WhYOsOFbFIb/dsTvN
         TZquReILtGHzKMENVwGj3GGeku4bkNDvicNvw=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 09/10] drivers: push down BKL into various drivers
Date: Tue, 27 Apr 2010 11:18:17 +0200
Message-Id: <1272359898-32020-10-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

These are the last remaining device drivers using
the ->ioctl file operation in the drivers directory.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Fixed merge conflicts that result from having applied
Linus's Preparation for BKL'ed ioctl removal patch first.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/block/pktcdvd.c           |   13 ++++++++--
 drivers/char/apm-emulation.c      |    8 ++++--
 drivers/char/applicom.c           |   13 ++++++----
 drivers/char/ds1620.c             |   16 +++++++++++-
 drivers/char/dtlk.c               |   15 ++++++------
 drivers/char/generic_nvram.c      |   17 +++++++++++--
 drivers/char/genrtc.c             |   16 +++++++++++-
 drivers/char/hpet.c               |   14 +++++++----
 drivers/char/i8k.c                |   21 ++++++++++++++---
 drivers/char/ipmi/ipmi_devintf.c  |   26 +++++++++++++++++----
 drivers/char/ipmi/ipmi_watchdog.c |   17 ++++++++++++-
 drivers/char/nvram.c              |   10 ++++++--
 drivers/char/nwflash.c            |    7 ++++-
 drivers/char/raw.c                |   42 ++++++++++++++++++++---------------
 drivers/hwmon/fschmd.c            |    9 ++++---
 drivers/hwmon/w83793.c            |   10 +++++---
 drivers/input/misc/hp_sdc_rtc.c   |   34 ++++++++++++++++++++--------
 drivers/macintosh/nvram.c         |    2 +-
 drivers/macintosh/via-pmu.c       |   17 +++++++++++--
 drivers/mtd/mtdchar.c             |   19 +++++++++++----
 drivers/pcmcia/pcmcia_ioctl.c     |   17 +++++++++++--
 drivers/rtc/rtc-m41t80.c          |   16 +++++++++++-
 drivers/sbus/char/openprom.c      |   44 +++++++++++++++++++++----------------
 drivers/usb/mon/mon_bin.c         |   23 ++++++++++++++-----
 drivers/usb/mon/mon_stat.c        |    3 +-
 25 files changed, 307 insertions(+), 122 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d0bb5c7..84a5658 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -55,6 +55,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
+#include <linux/smp_lock.h>
 #include <linux/freezer.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -2984,7 +2985,7 @@ static void pkt_get_status(struct pkt_ctrl_command *ctrl_cmd)
 	mutex_unlock(&ctl_mutex);
 }
 
-static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
@@ -3001,16 +3002,22 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 	case PKT_CTRL_CMD_SETUP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		lock_kernel();
 		ret = pkt_setup_dev(new_decode_dev(ctrl_cmd.dev), &pkt_dev);
+		unlock_kernel();
 		ctrl_cmd.pkt_dev = new_encode_dev(pkt_dev);
 		break;
 	case PKT_CTRL_CMD_TEARDOWN:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		lock_kernel();
 		ret = pkt_remove_dev(new_decode_dev(ctrl_cmd.pkt_dev));
+		unlock_kernel();
 		break;
 	case PKT_CTRL_CMD_STATUS:
+		lock_kernel();
 		pkt_get_status(&ctrl_cmd);
+		unlock_kernel();
 		break;
 	default:
 		return -ENOTTY;
@@ -3023,8 +3030,8 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 
 
 static const struct file_operations pkt_ctl_fops = {
-	.bkl_ioctl	 = pkt_ctl_ioctl,
-	.owner	 = THIS_MODULE,
+	.unlocked_ioctl	= pkt_ctl_ioctl,
+	.owner	 	= THIS_MODULE,
 };
 
 static struct miscdevice pkt_misc = {
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index a7d3df3..033e150 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -265,8 +265,8 @@ static unsigned int apm_poll(struct file *fp, poll_table * wait)
  *   Only when everyone who has opened /dev/apm_bios with write permission
  *   has acknowledge does the actual suspend happen.
  */
-static int
-apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
+static long
+apm_ioctl(struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as = filp->private_data;
 	int err = -EINVAL;
@@ -274,6 +274,7 @@ apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 	if (!as->suser || !as->writer)
 		return -EPERM;
 
+	lock_kernel();
 	switch (cmd) {
 	case APM_IOC_SUSPEND:
 		mutex_lock(&state_lock);
@@ -334,6 +335,7 @@ apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 		mutex_unlock(&state_lock);
 		break;
 	}
+	unlock_kernel();
 
 	return err;
 }
@@ -397,7 +399,7 @@ static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
-	.bkl_ioctl	= apm_ioctl,
+	.unlocked_ioctl	= apm_ioctl,
 	.open		= apm_open,
 	.release	= apm_release,
 };
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 8a845bd..63313a3 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/pci.h>
 #include <linux/wait.h>
@@ -106,8 +107,7 @@ static unsigned int DeviceErrorCount;	/* number of device error     */
 
 static ssize_t ac_read (struct file *, char __user *, size_t, loff_t *);
 static ssize_t ac_write (struct file *, const char __user *, size_t, loff_t *);
-static int ac_ioctl(struct inode *, struct file *, unsigned int,
-		    unsigned long);
+static long ac_ioctl(struct file *, unsigned int, unsigned long);
 static irqreturn_t ac_interrupt(int, void *);
 
 static const struct file_operations ac_fops = {
@@ -115,7 +115,7 @@ static const struct file_operations ac_fops = {
 	.llseek = no_llseek,
 	.read = ac_read,
 	.write = ac_write,
-	.bkl_ioctl = ac_ioctl,
+	.unlocked_ioctl = ac_ioctl,
 };
 
 static struct miscdevice ac_miscdev = {
@@ -689,7 +689,7 @@ static irqreturn_t ac_interrupt(int vec, void *dev_instance)
 
 
 
-static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
      
 {				/* @ ADG ou ATO selon le cas */
 	int i;
@@ -711,7 +711,8 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 		kfree(adgl);
 		return -EFAULT;
 	}
-	
+
+	lock_kernel();	
 	IndexCard = adgl->num_card-1;
 	 
 	if(cmd != 6 && ((IndexCard >= MAX_BOARD) || !apbs[IndexCard].RamIO)) {
@@ -721,6 +722,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 			warncount--;
 		}
 		kfree(adgl);
+		unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -838,6 +840,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 	}
 	Dummy = readb(apbs[IndexCard].RamIO + VERS);
 	kfree(adgl);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index de8f7ba..dbee868 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -232,7 +232,7 @@ ds1620_read(struct file *file, char __user *buf, size_t count, loff_t *ptr)
 }
 
 static int
-ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+ds1620_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct therm therm;
 	union {
@@ -316,6 +316,18 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
 	return 0;
 }
 
+static long
+ds1620_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ds1620_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef THERM_USE_PROC
 static int
 proc_therm_ds1620_read(char *buf, char **start, off_t offset,
@@ -344,7 +356,7 @@ static const struct file_operations ds1620_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ds1620_open,
 	.read		= ds1620_read,
-	.bkl_ioctl	= ds1620_ioctl,
+	.unlocked_ioctl	= ds1620_unlocked_ioctl,
 };
 
 static struct miscdevice ds1620_miscdev = {
diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index da15fb9..e3859d4 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -93,8 +93,8 @@ static ssize_t dtlk_write(struct file *, const char __user *,
 static unsigned int dtlk_poll(struct file *, poll_table *);
 static int dtlk_open(struct inode *, struct file *);
 static int dtlk_release(struct inode *, struct file *);
-static int dtlk_ioctl(struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg);
+static long dtlk_ioctl(struct file *file,
+		       unsigned int cmd, unsigned long arg);
 
 static const struct file_operations dtlk_fops =
 {
@@ -102,7 +102,7 @@ static const struct file_operations dtlk_fops =
 	.read		= dtlk_read,
 	.write		= dtlk_write,
 	.poll		= dtlk_poll,
-	.bkl_ioctl	= dtlk_ioctl,
+	.unlocked_ioctl	= dtlk_ioctl,
 	.open		= dtlk_open,
 	.release	= dtlk_release,
 };
@@ -263,10 +263,9 @@ static void dtlk_timer_tick(unsigned long data)
 	wake_up_interruptible(&dtlk_process_list);
 }
 
-static int dtlk_ioctl(struct inode *inode,
-		      struct file *file,
-		      unsigned int cmd,
-		      unsigned long arg)
+static long dtlk_ioctl(struct file *file,
+		       unsigned int cmd,
+		       unsigned long arg)
 {
 	char __user *argp = (char __user *)arg;
 	struct dtlk_settings *sp;
@@ -276,7 +275,9 @@ static int dtlk_ioctl(struct inode *inode,
 	switch (cmd) {
 
 	case DTLK_INTERROGATE:
+		lock_kernel();
 		sp = dtlk_interrogate();
+		unlock_kernel();
 		if (copy_to_user(argp, sp, sizeof(struct dtlk_settings)))
 			return -EINVAL;
 		return 0;
diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index 0947ad9..82b5a88 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -19,6 +19,7 @@
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/nvram.h>
 #ifdef CONFIG_PPC_PMAC
@@ -84,8 +85,7 @@ static ssize_t write_nvram(struct file *file, const char __user *buf,
 	return p - buf;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static int nvram_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch(cmd) {
 #ifdef CONFIG_PPC_PMAC
@@ -116,12 +116,23 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
+static long nvram_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = nvram_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 const struct file_operations nvram_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
 	.write		= write_nvram,
-	.bkl_ioctl	= nvram_ioctl,
+	.unlocked_ioctl	= nvram_unlocked_ioctl,
 };
 
 static struct miscdevice nvram_dev = {
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 414ca68..b6c2cc1 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -262,7 +262,7 @@ static inline int gen_set_rtc_irq_bit(unsigned char bit)
 #endif
 }
 
-static int gen_rtc_ioctl(struct inode *inode, struct file *file,
+static int gen_rtc_ioctl(struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct rtc_time wtime;
@@ -332,6 +332,18 @@ static int gen_rtc_ioctl(struct inode *inode, struct file *file,
 	return -EINVAL;
 }
 
+static long gen_rtc_unlocked_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = gen_rtc_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  *	We enforce only one user at a time here with the open/close.
  *	Also clear the previous interrupt data on an open, and clean
@@ -482,7 +494,7 @@ static const struct file_operations gen_rtc_fops = {
 	.read		= gen_rtc_read,
 	.poll		= gen_rtc_poll,
 #endif
-	.bkl_ioctl	= gen_rtc_ioctl,
+	.unlocked_ioctl	= gen_rtc_unlocked_ioctl,
 	.open		= gen_rtc_open,
 	.release	= gen_rtc_release,
 };
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 09c33d1..a0a1829 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -431,14 +431,18 @@ static int hpet_release(struct inode *inode, struct file *file)
 
 static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
-static int
-hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	   unsigned long arg)
+static long hpet_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
 {
 	struct hpet_dev *devp;
+	int ret;
 
 	devp = file->private_data;
-	return hpet_ioctl_common(devp, cmd, arg, 0);
+	lock_kernel();
+	ret = hpet_ioctl_common(devp, cmd, arg, 0);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int hpet_ioctl_ieon(struct hpet_dev *devp)
@@ -654,7 +658,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.bkl_ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 2a211d5..3dc67ae 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/dmi.h>
 #include <linux/capability.h>
 #include <asm/uaccess.h>
@@ -82,8 +83,8 @@ module_param(fan_mult, int, 0);
 MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
 
 static int i8k_open_fs(struct inode *inode, struct file *file);
-static int i8k_ioctl(struct inode *, struct file *, unsigned int,
-		     unsigned long);
+static long i8k_unlocked_ioctl(struct file *, unsigned int,
+			       unsigned long);
 
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
@@ -91,7 +92,7 @@ static const struct file_operations i8k_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
-	.bkl_ioctl	= i8k_ioctl,
+	.unlocked_ioctl	= i8k_unlocked_ioctl,
 };
 
 struct smm_regs {
@@ -307,7 +308,7 @@ static int i8k_get_dell_signature(int req_fn)
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
 }
 
-static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
+static int i8k_ioctl(struct file *fp, unsigned int cmd,
 		     unsigned long arg)
 {
 	int val = 0;
@@ -395,6 +396,18 @@ static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 	return 0;
 }
 
+static long
+i8k_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = i8k_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  * Print the information for /proc/i8k.
  */
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 57b2990..d8ec92a 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -228,8 +228,7 @@ static int handle_send_req(ipmi_user_t     user,
 	return rv;
 }
 
-static int ipmi_ioctl(struct inode  *inode,
-		      struct file   *file,
+static int ipmi_ioctl(struct file   *file,
 		      unsigned int  cmd,
 		      unsigned long data)
 {
@@ -630,6 +629,23 @@ static int ipmi_ioctl(struct inode  *inode,
 	return rv;
 }
 
+/*
+ * Note: it doesn't make sense to take the BKL here but
+ *       not in compat_ipmi_ioctl. -arnd
+ */
+static long ipmi_unlocked_ioctl(struct file   *file,
+			        unsigned int  cmd,
+			        unsigned long data)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ipmi_ioctl(file, cmd, data);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 
 /*
@@ -802,7 +818,7 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 		if (copy_to_user(precv64, &recv64, sizeof(recv64)))
 			return -EFAULT;
 
-		rc = ipmi_ioctl(filep->f_path.dentry->d_inode, filep,
+		rc = ipmi_ioctl(filep,
 				((cmd == COMPAT_IPMICTL_RECEIVE_MSG)
 				 ? IPMICTL_RECEIVE_MSG
 				 : IPMICTL_RECEIVE_MSG_TRUNC),
@@ -819,14 +835,14 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 		return rc;
 	}
 	default:
-		return ipmi_ioctl(filep->f_path.dentry->d_inode, filep, cmd, arg);
+		return ipmi_ioctl(filep, cmd, arg);
 	}
 }
 #endif
 
 static const struct file_operations ipmi_fops = {
 	.owner		= THIS_MODULE,
-	.bkl_ioctl	= ipmi_ioctl,
+	.unlocked_ioctl	= ipmi_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = compat_ipmi_ioctl,
 #endif
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index e8d478e..82bcdb2 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -659,7 +659,7 @@ static struct watchdog_info ident = {
 	.identity	= "IPMI"
 };
 
-static int ipmi_ioctl(struct inode *inode, struct file *file,
+static int ipmi_ioctl(struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -730,6 +730,19 @@ static int ipmi_ioctl(struct inode *inode, struct file *file,
 	}
 }
 
+static long ipmi_unlocked_ioctl(struct file *file,
+				unsigned int cmd,
+				unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ipmi_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static ssize_t ipmi_write(struct file *file,
 			  const char  __user *buf,
 			  size_t      len,
@@ -880,7 +893,7 @@ static const struct file_operations ipmi_wdog_fops = {
 	.read    = ipmi_read,
 	.poll    = ipmi_poll,
 	.write   = ipmi_write,
-	.bkl_ioctl   = ipmi_ioctl,
+	.unlocked_ioctl = ipmi_unlocked_ioctl,
 	.open    = ipmi_open,
 	.release = ipmi_close,
 	.fasync  = ipmi_fasync,
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 2688c4e..66d2917 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -296,8 +296,8 @@ checksum_err:
 	return -EIO;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long nvram_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
 {
 	int i;
 
@@ -308,6 +308,7 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
+		lock_kernel();
 		spin_lock_irq(&rtc_lock);
 
 		for (i = 0; i < NVRAM_BYTES; ++i)
@@ -315,6 +316,7 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 		__nvram_set_checksum();
 
 		spin_unlock_irq(&rtc_lock);
+		unlock_kernel();
 		return 0;
 
 	case NVRAM_SETCKS:
@@ -323,9 +325,11 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
+		lock_kernel();
 		spin_lock_irq(&rtc_lock);
 		__nvram_set_checksum();
 		spin_unlock_irq(&rtc_lock);
+		unlock_kernel();
 		return 0;
 
 	default:
@@ -422,7 +426,7 @@ static const struct file_operations nvram_fops = {
 	.llseek		= nvram_llseek,
 	.read		= nvram_read,
 	.write		= nvram_write,
-	.bkl_ioctl	= nvram_ioctl,
+	.unlocked_ioctl	= nvram_ioctl,
 	.open		= nvram_open,
 	.release	= nvram_release,
 };
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index 636b9f8..043a1c7 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -94,8 +94,9 @@ static int get_flash_id(void)
 	return c2;
 }
 
-static int flash_ioctl(struct inode *inodep, struct file *filep, unsigned int cmd, unsigned long arg)
+static long flash_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
+	lock_kernel();
 	switch (cmd) {
 	case CMD_WRITE_DISABLE:
 		gbWriteBase64Enable = 0;
@@ -113,8 +114,10 @@ static int flash_ioctl(struct inode *inodep, struct file *filep, unsigned int cm
 	default:
 		gbWriteBase64Enable = 0;
 		gbWriteEnable = 0;
+		unlock_kernel();
 		return -EINVAL;
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -631,7 +634,7 @@ static const struct file_operations flash_fops =
 	.llseek		= flash_llseek,
 	.read		= flash_read,
 	.write		= flash_write,
-	.bkl_ioctl	= flash_ioctl,
+	.unlocked_ioctl	= flash_ioctl,
 };
 
 static struct miscdevice flash_miscdev =
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index e0ece78..b38942f 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -121,13 +121,17 @@ static int raw_release(struct inode *inode, struct file *filp)
 /*
  * Forward ioctls to the underlying block device.
  */
-static int
-raw_ioctl(struct inode *inode, struct file *filp,
-		  unsigned int command, unsigned long arg)
+static long
+raw_ioctl(struct file *filp, unsigned int command, unsigned long arg)
 {
 	struct block_device *bdev = filp->private_data;
+	int ret;
+
+	lock_kernel();
+	ret = blkdev_ioctl(bdev, 0, command, arg);
+	unlock_kernel();
 
-	return blkdev_ioctl(bdev, 0, command, arg);
+	return ret;
 }
 
 static void bind_device(struct raw_config_request *rq)
@@ -141,13 +145,14 @@ static void bind_device(struct raw_config_request *rq)
  * Deal with ioctls against the raw-device control interface, to bind
  * and unbind other raw devices.
  */
-static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
-			unsigned int command, unsigned long arg)
+static long raw_ctl_ioctl(struct file *filp, unsigned int command,
+			  unsigned long arg)
 {
 	struct raw_config_request rq;
 	struct raw_device_data *rawdev;
 	int err = 0;
 
+	lock_kernel();
 	switch (command) {
 	case RAW_SETBIND:
 	case RAW_GETBIND:
@@ -240,25 +245,26 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 		break;
 	}
 out:
+	unlock_kernel();
 	return err;
 }
 
 static const struct file_operations raw_fops = {
-	.read	=	do_sync_read,
-	.aio_read = 	generic_file_aio_read,
-	.write	=	do_sync_write,
-	.aio_write =	blkdev_aio_write,
-	.fsync	=	blkdev_fsync,
-	.open	=	raw_open,
-	.release=	raw_release,
-	.bkl_ioctl =	raw_ioctl,
-	.owner	=	THIS_MODULE,
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= blkdev_aio_write,
+	.fsync		= blkdev_fsync,
+	.open		= raw_open,
+	.release	= raw_release,
+	.unlocked_ioctl = raw_ioctl,
+	.owner		= THIS_MODULE,
 };
 
 static const struct file_operations raw_ctl_fops = {
-	.bkl_ioctl =	raw_ctl_ioctl,
-	.open	=	raw_open,
-	.owner	=	THIS_MODULE,
+	.unlocked_ioctl = raw_ctl_ioctl,
+	.open		= raw_open,
+	.owner		= THIS_MODULE,
 };
 
 static struct cdev raw_cdev;
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index fa60ff2..b7ca2a9 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -38,6 +38,7 @@
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/smp_lock.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
@@ -847,8 +848,7 @@ static ssize_t watchdog_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-static int watchdog_ioctl(struct inode *inode, struct file *filp,
-	unsigned int cmd, unsigned long arg)
+static long watchdog_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
@@ -858,6 +858,7 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
 	int i, ret = 0;
 	struct fschmd_data *data = filp->private_data;
 
+	lock_kernel();
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ident.firmware_version = data->revision;
@@ -914,7 +915,7 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
 	default:
 		ret = -ENOTTY;
 	}
-
+	unlock_kernel();
 	return ret;
 }
 
@@ -924,7 +925,7 @@ static const struct file_operations watchdog_fops = {
 	.open = watchdog_open,
 	.release = watchdog_release,
 	.write = watchdog_write,
-	.bkl_ioctl = watchdog_ioctl,
+	.unlocked_ioctl = watchdog_ioctl,
 };
 
 
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 6f63623..697202e 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
+#include <linux/smp_lock.h>
 #include <linux/hwmon-vid.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
@@ -1319,8 +1320,8 @@ static ssize_t watchdog_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-static int watchdog_ioctl(struct inode *inode, struct file *filp,
-			  unsigned int cmd, unsigned long arg)
+static long watchdog_ioctl(struct file *filp, unsigned int cmd,
+			   unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING |
@@ -1332,6 +1333,7 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
 	int val, ret = 0;
 	struct w83793_data *data = filp->private_data;
 
+	lock_kernel();
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		if (!nowayout)
@@ -1385,7 +1387,7 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
 	default:
 		ret = -ENOTTY;
 	}
-
+	unlock_kernel();
 	return ret;
 }
 
@@ -1395,7 +1397,7 @@ static const struct file_operations watchdog_fops = {
 	.open = watchdog_open,
 	.release = watchdog_close,
 	.write = watchdog_write,
-	.bkl_ioctl = watchdog_ioctl,
+	.unlocked_ioctl = watchdog_ioctl,
 };
 
 /*
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 0fdfd20..e00a1cc 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -43,6 +43,7 @@
 #include <linux/proc_fs.h>
 #include <linux/poll.h>
 #include <linux/rtc.h>
+#include <linux/smp_lock.h>
 #include <linux/semaphore.h>
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
@@ -64,8 +65,8 @@ static DECLARE_WAIT_QUEUE_HEAD(hp_sdc_rtc_wait);
 static ssize_t hp_sdc_rtc_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos);
 
-static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg);
+static long hp_sdc_rtc_unlocked_ioctl(struct file *file,
+				      unsigned int cmd, unsigned long arg);
 
 static unsigned int hp_sdc_rtc_poll(struct file *file, poll_table *wait);
 
@@ -512,7 +513,7 @@ static int hp_sdc_rtc_read_proc(char *page, char **start, off_t off,
         return len;
 }
 
-static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file, 
+static int hp_sdc_rtc_ioctl(struct file *file, 
 			    unsigned int cmd, unsigned long arg)
 {
 #if 1
@@ -659,14 +660,27 @@ static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file,
 #endif
 }
 
+static long hp_sdc_rtc_unlocked_ioctl(struct file *file,
+				      unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = hp_sdc_rtc_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 static const struct file_operations hp_sdc_rtc_fops = {
-        .owner =	THIS_MODULE,
-        .llseek =	no_llseek,
-        .read =		hp_sdc_rtc_read,
-        .poll =		hp_sdc_rtc_poll,
-        .bkl_ioctl =	hp_sdc_rtc_ioctl,
-        .open =		hp_sdc_rtc_open,
-        .fasync =	hp_sdc_rtc_fasync,
+        .owner =		THIS_MODULE,
+        .llseek =		no_llseek,
+        .read =			hp_sdc_rtc_read,
+        .poll =			hp_sdc_rtc_poll,
+        .unlocked_ioctl = 	hp_sdc_rtc_ioctl,
+        .open =			hp_sdc_rtc_open,
+        .fasync =		hp_sdc_rtc_fasync,
 };
 
 static struct miscdevice hp_sdc_rtc_dev = {
diff --git a/drivers/macintosh/nvram.c b/drivers/macintosh/nvram.c
index 6a3115f..a271c82 100644
--- a/drivers/macintosh/nvram.c
+++ b/drivers/macintosh/nvram.c
@@ -100,7 +100,7 @@ const struct file_operations nvram_fops = {
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
 	.write		= write_nvram,
-	.bkl_ioctl	= nvram_ioctl,
+	.unlocked_ioctl	= nvram_ioctl,
 };
 
 static struct miscdevice nvram_dev = {
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 1cac03c..3d4fc0f 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2273,8 +2273,7 @@ static int register_pmu_pm_ops(void)
 device_initcall(register_pmu_pm_ops);
 #endif
 
-static int
-pmu_ioctl(struct inode * inode, struct file *filp,
+static int pmu_ioctl(struct file *filp,
 		     u_int cmd, u_long arg)
 {
 	__u32 __user *argp = (__u32 __user *)arg;
@@ -2337,11 +2336,23 @@ pmu_ioctl(struct inode * inode, struct file *filp,
 	return error;
 }
 
+static long pmu_unlocked_ioctl(struct file *filp,
+			       u_int cmd, u_long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = pmu_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations pmu_device_fops = {
 	.read		= pmu_read,
 	.write		= pmu_write,
 	.poll		= pmu_fpoll,
-	.bkl_ioctl	= pmu_ioctl,
+	.unlocked_ioctl	= pmu_unlocked_ioctl,
 	.open		= pmu_open,
 	.release	= pmu_release,
 };
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 57b48c4..6749c2f 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -450,8 +450,7 @@ static int mtd_do_readoob(struct mtd_info *mtd, uint64_t start,
 	return ret;
 }
 
-static int mtd_ioctl(struct inode *inode, struct file *file,
-		     u_int cmd, u_long arg)
+static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
@@ -822,6 +821,17 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 	return ret;
 } /* memory_ioctl */
 
+static long mtd_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = mtd_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 
 struct mtd_oob_buf32 {
@@ -836,7 +846,6 @@ struct mtd_oob_buf32 {
 static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 	unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	void __user *argp = compat_ptr(arg);
@@ -874,7 +883,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 		break;
 	}
 	default:
-		ret = mtd_ioctl(inode, file, cmd, (unsigned long)argp);
+		ret = mtd_ioctl(file, cmd, (unsigned long)argp);
 	}
 
 	unlock_kernel();
@@ -942,7 +951,7 @@ static const struct file_operations mtd_fops = {
 	.llseek		= mtd_lseek,
 	.read		= mtd_read,
 	.write		= mtd_write,
-	.bkl_ioctl	= mtd_ioctl,
+	.unlocked_ioctl	= mtd_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= mtd_compat_ioctl,
 #endif
diff --git a/drivers/pcmcia/pcmcia_ioctl.c b/drivers/pcmcia/pcmcia_ioctl.c
index ca84016..a3b1b5b 100644
--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ b/drivers/pcmcia/pcmcia_ioctl.c
@@ -821,8 +821,7 @@ static u_int ds_poll(struct file *file, poll_table *wait)
 
 /*====================================================================*/
 
-static int ds_ioctl(struct inode *inode, struct file *file,
-		    u_int cmd, u_long arg)
+static int ds_ioctl(struct file *file, u_int cmd, u_long arg)
 {
     struct pcmcia_socket *s;
     void __user *uarg = (char __user *)arg;
@@ -1031,13 +1030,25 @@ free_out:
     return err;
 } /* ds_ioctl */
 
+static long ds_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ds_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 /*====================================================================*/
 
 static const struct file_operations ds_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ds_open,
 	.release	= ds_release,
-	.bkl_ioctl	= ds_ioctl,
+	.unlocked_ioctl	= ds_unlocked_ioctl,
 	.read		= ds_read,
 	.write		= ds_write,
 	.poll		= ds_poll,
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index e662d61..038095d 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -623,7 +623,7 @@ static ssize_t wdt_read(struct file *file, char __user *buf,
  *	according to their available features. We only actually usefully support
  *	querying capabilities and current status.
  */
-static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+static int wdt_ioctl(struct file *file, unsigned int cmd,
 		     unsigned long arg)
 {
 	int new_margin, rv;
@@ -676,6 +676,18 @@ static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return -ENOTTY;
 }
 
+static long wdt_unlocked_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = wdt_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /**
  *	wdt_open:
  *	@inode: inode of device
@@ -736,7 +748,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 static const struct file_operations wdt_fops = {
 	.owner	= THIS_MODULE,
 	.read	= wdt_read,
-	.bkl_ioctl = wdt_ioctl,
+	.unlocked_ioctl = wdt_unlocked_ioctl,
 	.write	= wdt_write,
 	.open	= wdt_open,
 	.release = wdt_release,
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 1fdc1a9..d53e62a 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -298,9 +298,9 @@ static int opromgetbootargs(void __user *argp, struct openpromio *op, int bufsiz
 /*
  *	SunOS and Solaris /dev/openprom ioctl calls.
  */
-static int openprom_sunos_ioctl(struct inode * inode, struct file * file,
-				unsigned int cmd, unsigned long arg,
-				struct device_node *dp)
+static long openprom_sunos_ioctl(struct file * file,
+				 unsigned int cmd, unsigned long arg,
+				 struct device_node *dp)
 {
 	DATA *data = file->private_data;
 	struct openpromio *opp = NULL;
@@ -316,6 +316,8 @@ static int openprom_sunos_ioctl(struct inode * inode, struct file * file,
 	if (bufsize < 0)
 		return bufsize;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case OPROMGETOPT:
 	case OPROMGETPROP:
@@ -365,6 +367,8 @@ static int openprom_sunos_ioctl(struct inode * inode, struct file * file,
 	}
 
 	kfree(opp);
+	unlock_kernel();
+
 	return error;
 }
 
@@ -547,13 +551,14 @@ static int opiocgetnext(unsigned int cmd, void __user *argp)
 	return 0;
 }
 
-static int openprom_bsd_ioctl(struct inode * inode, struct file * file,
+static int openprom_bsd_ioctl(struct file * file,
 			      unsigned int cmd, unsigned long arg)
 {
 	DATA *data = (DATA *) file->private_data;
 	void __user *argp = (void __user *)arg;
 	int err;
 
+	lock_kernel();
 	switch (cmd) {
 	case OPIOCGET:
 		err = opiocget(argp, data);
@@ -570,10 +575,10 @@ static int openprom_bsd_ioctl(struct inode * inode, struct file * file,
 	case OPIOCGETOPTNODE:
 		BUILD_BUG_ON(sizeof(phandle) != sizeof(int));
 
+		err = 0;
 		if (copy_to_user(argp, &options_node->phandle, sizeof(phandle)))
-			return -EFAULT;
-
-		return 0;
+			err = -EFAULT;
+		break;
 
 	case OPIOCGETNEXT:
 	case OPIOCGETCHILD:
@@ -581,9 +586,10 @@ static int openprom_bsd_ioctl(struct inode * inode, struct file * file,
 		break;
 
 	default:
-		return -EINVAL;
-
+		err = -EINVAL;
+		break;
 	};
+	unlock_kernel();
 
 	return err;
 }
@@ -592,8 +598,8 @@ static int openprom_bsd_ioctl(struct inode * inode, struct file * file,
 /*
  *	Handoff control to the correct ioctl handler.
  */
-static int openprom_ioctl(struct inode * inode, struct file * file,
-			  unsigned int cmd, unsigned long arg)
+static long openprom_ioctl(struct file * file,
+			   unsigned int cmd, unsigned long arg)
 {
 	DATA *data = (DATA *) file->private_data;
 
@@ -602,14 +608,14 @@ static int openprom_ioctl(struct inode * inode, struct file * file,
 	case OPROMNXTOPT:
 		if ((file->f_mode & FMODE_READ) == 0)
 			return -EPERM;
-		return openprom_sunos_ioctl(inode, file, cmd, arg,
+		return openprom_sunos_ioctl(file, cmd, arg,
 					    options_node);
 
 	case OPROMSETOPT:
 	case OPROMSETOPT2:
 		if ((file->f_mode & FMODE_WRITE) == 0)
 			return -EPERM;
-		return openprom_sunos_ioctl(inode, file, cmd, arg,
+		return openprom_sunos_ioctl(file, cmd, arg,
 					    options_node);
 
 	case OPROMNEXT:
@@ -618,7 +624,7 @@ static int openprom_ioctl(struct inode * inode, struct file * file,
 	case OPROMNXTPROP:
 		if ((file->f_mode & FMODE_READ) == 0)
 			return -EPERM;
-		return openprom_sunos_ioctl(inode, file, cmd, arg,
+		return openprom_sunos_ioctl(file, cmd, arg,
 					    data->current_node);
 
 	case OPROMU2P:
@@ -630,7 +636,7 @@ static int openprom_ioctl(struct inode * inode, struct file * file,
 	case OPROMPATH2NODE:
 		if ((file->f_mode & FMODE_READ) == 0)
 			return -EPERM;
-		return openprom_sunos_ioctl(inode, file, cmd, arg, NULL);
+		return openprom_sunos_ioctl(file, cmd, arg, NULL);
 
 	case OPIOCGET:
 	case OPIOCNEXTPROP:
@@ -639,12 +645,12 @@ static int openprom_ioctl(struct inode * inode, struct file * file,
 	case OPIOCGETCHILD:
 		if ((file->f_mode & FMODE_READ) == 0)
 			return -EBADF;
-		return openprom_bsd_ioctl(inode,file,cmd,arg);
+		return openprom_bsd_ioctl(file,cmd,arg);
 
 	case OPIOCSET:
 		if ((file->f_mode & FMODE_WRITE) == 0)
 			return -EBADF;
-		return openprom_bsd_ioctl(inode,file,cmd,arg);
+		return openprom_bsd_ioctl(file,cmd,arg);
 
 	default:
 		return -EINVAL;
@@ -676,7 +682,7 @@ static long openprom_compat_ioctl(struct file *file, unsigned int cmd,
 	case OPROMSETCUR:
 	case OPROMPCI2NODE:
 	case OPROMPATH2NODE:
-		rval = openprom_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		rval = openprom_ioctl(file, cmd, arg);
 		break;
 	}
 
@@ -709,7 +715,7 @@ static int openprom_release(struct inode * inode, struct file * file)
 static const struct file_operations openprom_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.bkl_ioctl =	openprom_ioctl,
+	.unlocked_ioctl = openprom_ioctl,
 	.compat_ioctl =	openprom_compat_ioctl,
 	.open =		openprom_open,
 	.release =	openprom_release,
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 9ce7c74..5594772 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -954,8 +954,7 @@ static int mon_bin_queued(struct mon_reader_bin *rp)
 
 /*
  */
-static int mon_bin_ioctl(struct inode *inode, struct file *file,
-    unsigned int cmd, unsigned long arg)
+static int mon_bin_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct mon_reader_bin *rp = file->private_data;
 	// struct mon_bus* mbus = rp->r.m_bus;
@@ -1095,6 +1094,19 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
+static long mon_bin_unlocked_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = mon_bin_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 #ifdef CONFIG_COMPAT
 static long mon_bin_compat_ioctl(struct file *file,
     unsigned int cmd, unsigned long arg)
@@ -1148,14 +1160,13 @@ static long mon_bin_compat_ioctl(struct file *file,
 		return 0;
 
 	case MON_IOCG_STATS:
-		return mon_bin_ioctl(NULL, file, cmd,
-					    (unsigned long) compat_ptr(arg));
+		return mon_bin_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 
 	case MON_IOCQ_URB_LEN:
 	case MON_IOCQ_RING_SIZE:
 	case MON_IOCT_RING_SIZE:
 	case MON_IOCH_MFLUSH:
-		return mon_bin_ioctl(NULL, file, cmd, arg);
+		return mon_bin_ioctl(file, cmd, arg);
 
 	default:
 		;
@@ -1239,7 +1250,7 @@ static const struct file_operations mon_fops_binary = {
 	.read =		mon_bin_read,
 	/* .write =	mon_text_write, */
 	.poll =		mon_bin_poll,
-	.bkl_ioctl =	mon_bin_ioctl,
+	.unlocked_ioctl = mon_bin_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
diff --git a/drivers/usb/mon/mon_stat.c b/drivers/usb/mon/mon_stat.c
index 091e7fb..8ec94f1 100644
--- a/drivers/usb/mon/mon_stat.c
+++ b/drivers/usb/mon/mon_stat.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/fs.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 #include "usb_mon.h"
@@ -63,6 +64,6 @@ const struct file_operations mon_fops_stat = {
 	.read =		mon_stat_read,
 	/* .write =	mon_stat_write, */
 	/* .poll =		mon_stat_poll, */
-	/* .bkl_ioctl =	mon_stat_ioctl, */
+	/* .unlocked_ioctl =	mon_stat_ioctl, */
 	.release =	mon_stat_release,
 };
-- 
1.6.6.1

