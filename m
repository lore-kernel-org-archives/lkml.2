Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0DZWYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:24:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab0DZWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:24:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] scsi: push down BKL into ioctl functions
Date: Tue, 27 Apr 2010 00:24:01 +0200
Message-Id: <1272320645-8671-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201004262112.39906.arnd@arndb.de>
References: <201004262112.39906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Lnr3t/RPcvMM6/b+jUS1bVwuKDquNVR+fox3
 8tW+QFkSHvVgFGal0/U+0aMYMdAI1ss02usqYU4KlYwG0Zlfoh
 keTI1WQAeTMJA0LcO/dYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/3w-9xxx.c              |   10 +++++++---
 drivers/scsi/3w-sas.c               |    7 +++++--
 drivers/scsi/3w-xxxx.c              |   10 +++++++---
 drivers/scsi/aacraid/linit.c        |   11 ++++++++---
 drivers/scsi/dpt_i2o.c              |   20 +++++++++++++++++---
 drivers/scsi/gdth.c                 |   20 +++++++++++++++-----
 drivers/scsi/megaraid.c             |   20 +++++++++++++++++---
 drivers/scsi/megaraid/megaraid_mm.c |   22 +++++++++++++++++-----
 drivers/scsi/osst.c                 |   14 ++++++++++----
 drivers/scsi/sg.c                   |   17 ++++++++++++++---
 10 files changed, 117 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e9788f5..4f74850 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -123,7 +123,7 @@ static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id);
 static char *twa_aen_severity_lookup(unsigned char severity_code);
 static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id);
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static int twa_chrdev_open(struct inode *inode, struct file *file);
 static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_sense, int print_host);
 static void twa_free_request_id(TW_Device_Extension *tw_dev,int request_id);
@@ -218,7 +218,7 @@ static struct device_attribute *twa_host_attrs[] = {
 /* File operations struct for character device */
 static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= twa_chrdev_ioctl,
+	.unlocked_ioctl	= twa_chrdev_ioctl,
 	.open		= twa_chrdev_open,
 	.release	= NULL
 };
@@ -635,8 +635,9 @@ out:
 } /* End twa_check_srl() */
 
 /* This function handles ioctl for the character device */
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	long timeout;
 	unsigned long *cpu_addr, data_buffer_length_adjusted = 0, flags = 0;
 	dma_addr_t dma_handle;
@@ -655,6 +656,8 @@ static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 	int retval = TW_IOCTL_ERROR_OS_EFAULT;
 	void __user *argp = (void __user *)arg;
 
+	lock_kernel();
+
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
 		retval = TW_IOCTL_ERROR_OS_EINTR;
@@ -874,6 +877,7 @@ out3:
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
+	unlock_kernel();
 	return retval;
 } /* End twa_chrdev_ioctl() */
 
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 54c5ffb..ab4ad09 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -750,7 +750,7 @@ static void twl_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 
 /* This function handles ioctl for the character device
    This interface is used by smartmontools open source software */
-static int twl_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long timeout;
 	unsigned long *cpu_addr, data_buffer_length_adjusted = 0, flags = 0;
@@ -763,6 +763,8 @@ static int twl_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 	int retval = -EFAULT;
 	void __user *argp = (void __user *)arg;
 
+	lock_kernel();
+
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
 		retval = -EINTR;
@@ -858,6 +860,7 @@ out3:
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
+	unlock_kernel();
 	return retval;
 } /* End twl_chrdev_ioctl() */
 
@@ -884,7 +887,7 @@ out:
 /* File operations struct for character device */
 static const struct file_operations twl_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= twl_chrdev_ioctl,
+	.unlocked_ioctl	= twl_chrdev_ioctl,
 	.open		= twl_chrdev_open,
 	.release	= NULL
 };
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 5faf903..45a737c 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -880,7 +880,7 @@ static int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 } /* End tw_allocate_memory() */
 
 /* This function handles ioctl for the character device */
-static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int request_id;
 	dma_addr_t dma_handle;
@@ -898,9 +898,12 @@ static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 
 	dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl()\n");
 
+	lock_kernel();
 	/* Only let one of these through at a time */
-	if (mutex_lock_interruptible(&tw_dev->ioctl_lock))
+	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
+		unlock_kernel();
 		return -EINTR;
+	}
 
 	/* First copy down the buffer length */
 	if (copy_from_user(&data_buffer_length, argp, sizeof(unsigned int)))
@@ -1029,6 +1032,7 @@ out2:
 	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, cpu_addr, dma_handle);
 out:
 	mutex_unlock(&tw_dev->ioctl_lock);
+	unlock_kernel();
 	return retval;
 } /* End tw_chrdev_ioctl() */
 
@@ -1051,7 +1055,7 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 /* File operations struct for character device */
 static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= tw_chrdev_ioctl,
+	.unlocked_ioctl	= tw_chrdev_ioctl,
 	.open		= tw_chrdev_open,
 	.release	= NULL
 };
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index e9373a2..33898b6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -705,12 +705,17 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
  *	Bugs: Needs to handle hot plugging
  */
 
-static int aac_cfg_ioctl(struct inode *inode, struct file *file,
+static long aac_cfg_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
+	int ret;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
+	lock_kernel();
+	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
+	unlock_kernel();
+
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1029,7 +1034,7 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 
 static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= aac_cfg_ioctl,
+	.unlocked_ioctl	= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = aac_compat_cfg_ioctl,
 #endif
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 0435d04..b0c576f 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -114,12 +114,13 @@ static int hba_count = 0;
 
 static struct class *adpt_sysfs_class;
 
+static long adpt_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 #ifdef CONFIG_COMPAT
 static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
 #endif
 
 static const struct file_operations adpt_fops = {
-	.ioctl		= adpt_ioctl,
+	.unlocked_ioctl	= adpt_unlocked_ioctl,
 	.open		= adpt_open,
 	.release	= adpt_close,
 #ifdef CONFIG_COMPAT
@@ -2069,8 +2070,7 @@ static int adpt_system_info(void __user *buffer)
 	return 0;
 }
 
-static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
-	      ulong arg)
+static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 {
 	int minor;
 	int error = 0;
@@ -2153,6 +2153,20 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 	return error;
 }
 
+static long adpt_unlocked_ioctl(struct file *file, uint cmd, ulong arg)
+{
+	struct inode *inode;
+	long ret;
+ 
+	inode = file->f_dentry->d_inode;
+ 
+	lock_kernel();
+	ret = adpt_ioctl(inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 static long compat_adpt_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 35a4b30..d3f335d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -180,8 +180,8 @@ static const char *gdth_ctr_name(gdth_ha_str *ha);
 
 static int gdth_open(struct inode *inode, struct file *filep);
 static int gdth_close(struct inode *inode, struct file *filep);
-static int gdth_ioctl(struct inode *inode, struct file *filep,
-                      unsigned int cmd, unsigned long arg);
+static long gdth_unlocked_ioctl(struct file *filep, unsigned int cmd,
+			        unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
@@ -369,7 +369,7 @@ MODULE_LICENSE("GPL");
 
 /* ioctl interface */
 static const struct file_operations gdth_fops = {
-    .ioctl   = gdth_ioctl,
+    .unlocked_ioctl   = gdth_unlocked_ioctl,
     .open    = gdth_open,
     .release = gdth_close,
 };
@@ -4462,8 +4462,7 @@ free_fail:
     return rc;
 }
   
-static int gdth_ioctl(struct inode *inode, struct file *filep,
-                      unsigned int cmd, unsigned long arg)
+static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
     gdth_ha_str *ha; 
     Scsi_Cmnd *scp;
@@ -4611,6 +4610,17 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
     return 0;
 }
 
+static long gdth_unlocked_ioctl(struct file *file, unsigned int cmd,
+			        unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = gdth_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
 
 /* flush routine */
 static void gdth_flush(gdth_ha_str *ha)
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4bf7edc..c20b621 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -91,12 +91,15 @@ static struct proc_dir_entry *mega_proc_dir_entry;
 /* For controller re-ordering */
 static struct mega_hbas mega_hbas[MAX_CONTROLLERS];
 
+static long
+megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+
 /*
  * The File Operations structure for the serial/ioctl interface of the driver
  */
 static const struct file_operations megadev_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= megadev_ioctl,
+	.unlocked_ioctl	= megadev_unlocked_ioctl,
 	.open		= megadev_open,
 };
 
@@ -3302,8 +3305,7 @@ megadev_open (struct inode *inode, struct file *filep)
  * controller.
  */
 static int
-megadev_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
-		unsigned long arg)
+megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	adapter_t	*adapter;
 	nitioctl_t	uioc;
@@ -3694,6 +3696,18 @@ freemem_and_return:
 	return 0;
 }
 
+static long
+megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = megadev_ioctl(filep, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /**
  * mega_m_to_n()
  * @arg - user address
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 36e0b7d..41f82f7 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -22,7 +22,7 @@
 
 // Entry points for char node driver
 static int mraid_mm_open(struct inode *, struct file *);
-static int mraid_mm_ioctl(struct inode *, struct file *, uint, unsigned long);
+static long mraid_mm_unlocked_ioctl(struct file *, uint, unsigned long);
 
 
 // routines to convert to and from the old the format
@@ -70,7 +70,7 @@ static wait_queue_head_t wait_q;
 
 static const struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
-	.ioctl	= mraid_mm_ioctl,
+	.unlocked_ioctl = mraid_mm_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = mraid_mm_compat_ioctl,
 #endif
@@ -110,8 +110,7 @@ mraid_mm_open(struct inode *inode, struct file *filep)
  * @arg		: user ioctl packet
  */
 static int
-mraid_mm_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
-							unsigned long arg)
+mraid_mm_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	uioc_t		*kioc;
 	char		signature[EXT_IOCTL_SIGN_SZ]	= {0};
@@ -218,6 +217,19 @@ mraid_mm_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
 	return rval;
 }
 
+static long
+mraid_mm_unlocked_ioctl(struct file *filep, unsigned int cmd,
+		        unsigned long arg)
+{
+	int err;
+
+	/* inconsistant: mraid_mm_compat_ioctl doesn't take the BKL */
+	lock_kernel();
+	err = mraid_mm_ioctl(filep, cmd, arg);
+	unlock_kernel();
+
+	return err;
+}
 
 /**
  * mraid_mm_get_adapter - Returns corresponding adapters for the mimd packet
@@ -1225,7 +1237,7 @@ mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
 {
 	int err;
 
-	err = mraid_mm_ioctl(NULL, filep, cmd, arg);
+	err = mraid_mm_ioctl(filep, cmd, arg);
 
 	return err;
 }
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index b219118..8dbf1c3 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4932,7 +4932,7 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
 
 
 /* The ioctl command */
-static int osst_ioctl(struct inode * inode,struct file * file,
+static long osst_ioctl(struct file * file,
 	 unsigned int cmd_in, unsigned long arg)
 {
 	int		      i, cmd_nr, cmd_type, blk, retval = 0;
@@ -4943,8 +4943,11 @@ static int osst_ioctl(struct inode * inode,struct file * file,
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	if (mutex_lock_interruptible(&STp->lock))
+	lock_kernel();
+	if (mutex_lock_interruptible(&STp->lock)) {
+		unlock_kernel();
 		return -ERESTARTSYS;
+	}
 
 #if DEBUG
 	if (debugging && !STp->in_use) {
@@ -5256,12 +5259,15 @@ static int osst_ioctl(struct inode * inode,struct file * file,
 
 	mutex_unlock(&STp->lock);
 
-	return scsi_ioctl(STp->device, cmd_in, p);
+	retval = scsi_ioctl(STp->device, cmd_in, p);
+	unlock_kernel();
+	return retval;
 
 out:
 	if (SRpnt) osst_release_request(SRpnt);
 
 	mutex_unlock(&STp->lock);
+	unlock_kernel();
 
 	return retval;
 }
@@ -5613,7 +5619,7 @@ static const struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
 	.write =        osst_write,
-	.ioctl =        osst_ioctl,
+	.unlocked_ioctl = osst_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = osst_compat_ioctl,
 #endif
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dee1c96..ef752b2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -758,8 +758,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 }
 
 static int
-sg_ioctl(struct inode *inode, struct file *filp,
-	 unsigned int cmd_in, unsigned long arg)
+sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
@@ -1078,6 +1077,18 @@ sg_ioctl(struct inode *inode, struct file *filp,
 	}
 }
 
+static long
+sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = sg_ioctl(filp, cmd_in, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1322,7 +1333,7 @@ static const struct file_operations sg_fops = {
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.ioctl = sg_ioctl,
+	.unlocked_ioctl = sg_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
-- 
1.7.0.4

