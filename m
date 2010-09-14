Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0INTzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0INTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:53:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/7] drivers: autoconvert trivial BKL users to private mutex
Date: Tue, 14 Sep 2010 21:53:40 +0200
Message-Id: <1284494022-7346-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284494022-7346-1-git-send-email-arnd@arndb.de>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xYyogNjNV1RMmzs30QXH4xO5woPISZM5kEs/dpvJyIW
 F7+Ha8WoG9BYxe6GqW7jEc1M/eEHJhUyWjxv19Uj00mQUTQE+e
 iBO7I0XO6hJNZ0sQLj/f6nnlbp4OD+ytOAlsxEo1pSYk1xVKFI
 q0NocJK0q4W85f+uM6jzHtDV1Ta8Sp0jjdOU8hOhj5fTz9ORvr
 NdtmMmHeT15A8dY8wJY3A==
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

These drivers do not seem to be under active
maintainance from my brief investigation. Apologies
to those maintainers that I have missed.

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
---
 drivers/block/paride/pg.c                  |    7 ++--
 drivers/block/paride/pt.c                  |   19 ++++++------
 drivers/char/apm-emulation.c               |   11 ++++---
 drivers/char/applicom.c                    |    9 +++--
 drivers/char/ds1302.c                      |   15 +++++----
 drivers/char/ds1620.c                      |    8 ++--
 drivers/char/dsp56k.c                      |   27 +++++++++--------
 drivers/char/dtlk.c                        |    8 ++--
 drivers/char/generic_nvram.c               |    7 ++--
 drivers/char/genrtc.c                      |   13 ++++----
 drivers/char/i8k.c                         |    7 ++--
 drivers/char/ip2/ip2main.c                 |    8 ++--
 drivers/char/lp.c                          |   15 +++++----
 drivers/char/mbcs.c                        |    8 ++--
 drivers/char/mmtimer.c                     |    7 ++--
 drivers/char/mwave/mwavedd.c               |   44 ++++++++++++++--------------
 drivers/char/nvram.c                       |   11 ++++---
 drivers/char/nwflash.c                     |   12 ++++----
 drivers/char/pcmcia/cm4000_cs.c            |   11 ++++---
 drivers/char/pcmcia/cm4040_cs.c            |    7 ++--
 drivers/char/ppdev.c                       |    8 ++--
 drivers/char/rio/rio_linux.c               |    7 ++--
 drivers/char/snsc.c                        |    9 +++--
 drivers/char/toshiba.c                     |    9 +++--
 drivers/char/viotape.c                     |   11 ++++---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    6 ++--
 drivers/hwmon/fschmd.c                     |    6 ++--
 drivers/hwmon/w83793.c                     |    6 ++--
 drivers/input/misc/hp_sdc_rtc.c            |    7 ++--
 drivers/misc/phantom.c                     |   11 ++++---
 drivers/pci/hotplug/cpqphp_sysfs.c         |   13 ++++----
 drivers/rtc/rtc-m41t80.c                   |   13 ++++----
 drivers/sbus/char/jsflash.c                |   24 ++++++++-------
 drivers/telephony/ixj.c                    |    7 ++--
 drivers/watchdog/cpwd.c                    |   15 +++++----
 fs/hfsplus/ioctl.c                         |   11 ++++---
 36 files changed, 222 insertions(+), 195 deletions(-)

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index c397b3d..bed29cb 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -162,7 +162,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_DLY};
 #include <linux/pg.h>
 #include <linux/device.h>
 #include <linux/sched.h>	/* current, TASK_* */
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
@@ -193,6 +193,7 @@ module_param_array(drive3, int, NULL, 0);
 
 #define ATAPI_IDENTIFY		0x12
 
+static DEFINE_MUTEX(pg_mutex);
 static int pg_open(struct inode *inode, struct file *file);
 static int pg_release(struct inode *inode, struct file *file);
 static ssize_t pg_read(struct file *filp, char __user *buf,
@@ -518,7 +519,7 @@ static int pg_open(struct inode *inode, struct file *file)
 	struct pg *dev = &devices[unit];
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&pg_mutex);
 	if ((unit >= PG_UNITS) || (!dev->present)) {
 		ret = -ENODEV;
 		goto out;
@@ -547,7 +548,7 @@ static int pg_open(struct inode *inode, struct file *file)
 	file->private_data = dev;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&pg_mutex);
 	return ret;
 }
 
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index bc5825f..e4dda28 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -146,7 +146,7 @@ static int (*drives[4])[6] = {&drive0, &drive1, &drive2, &drive3};
 #include <linux/mtio.h>
 #include <linux/device.h>
 #include <linux/sched.h>	/* current, TASK_*, schedule_timeout() */
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
 
@@ -189,6 +189,7 @@ module_param_array(drive3, int, NULL, 0);
 #define ATAPI_MODE_SENSE	0x1a
 #define ATAPI_LOG_SENSE		0x4d
 
+static DEFINE_MUTEX(pt_mutex);
 static int pt_open(struct inode *inode, struct file *file);
 static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static int pt_release(struct inode *inode, struct file *file);
@@ -650,9 +651,9 @@ static int pt_open(struct inode *inode, struct file *file)
 	struct pt_unit *tape = pt + unit;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&pt_mutex);
 	if (unit >= PT_UNITS || (!tape->present)) {
-		unlock_kernel();
+		mutex_unlock(&pt_mutex);
 		return -ENODEV;
 	}
 
@@ -681,12 +682,12 @@ static int pt_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = tape;
-	unlock_kernel();
+	mutex_unlock(&pt_mutex);
 	return 0;
 
 out:
 	atomic_inc(&tape->available);
-	unlock_kernel();
+	mutex_unlock(&pt_mutex);
 	return err;
 }
 
@@ -704,15 +705,15 @@ static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		switch (mtop.mt_op) {
 
 		case MTREW:
-			lock_kernel();
+			mutex_lock(&pt_mutex);
 			pt_rewind(tape);
-			unlock_kernel();
+			mutex_unlock(&pt_mutex);
 			return 0;
 
 		case MTWEOF:
-			lock_kernel();
+			mutex_lock(&pt_mutex);
 			pt_write_fm(tape);
-			unlock_kernel();
+			mutex_unlock(&pt_mutex);
 			return 0;
 
 		default:
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 033e150..6a420ba 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
@@ -126,6 +126,7 @@ struct apm_user {
 /*
  * Local variables
  */
+static DEFINE_MUTEX(apm_mutex);
 static atomic_t suspend_acks_pending = ATOMIC_INIT(0);
 static atomic_t userspace_notification_inhibit = ATOMIC_INIT(0);
 static int apm_disabled;
@@ -274,7 +275,7 @@ apm_ioctl(struct file *filp, u_int cmd, u_long arg)
 	if (!as->suser || !as->writer)
 		return -EPERM;
 
-	lock_kernel();
+	mutex_lock(&apm_mutex);
 	switch (cmd) {
 	case APM_IOC_SUSPEND:
 		mutex_lock(&state_lock);
@@ -335,7 +336,7 @@ apm_ioctl(struct file *filp, u_int cmd, u_long arg)
 		mutex_unlock(&state_lock);
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&apm_mutex);
 
 	return err;
 }
@@ -370,7 +371,7 @@ static int apm_open(struct inode * inode, struct file * filp)
 {
 	struct apm_user *as;
 
-	lock_kernel();
+	mutex_lock(&apm_mutex);
 	as = kzalloc(sizeof(*as), GFP_KERNEL);
 	if (as) {
 		/*
@@ -390,7 +391,7 @@ static int apm_open(struct inode * inode, struct file * filp)
 
 		filp->private_data = as;
 	}
-	unlock_kernel();
+	mutex_unlock(&apm_mutex);
 
 	return as ? 0 : -ENOMEM;
 }
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index f4ae0e0..e7ba774 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -26,7 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/miscdevice.h>
 #include <linux/pci.h>
 #include <linux/wait.h>
@@ -60,6 +60,7 @@
 #define PCI_DEVICE_ID_APPLICOM_PCI2000PFB     0x0003
 #endif
 
+static DEFINE_MUTEX(ac_mutex);
 static char *applicom_pci_devnames[] = {
 	"PCI board",
 	"PCI2000IBS / PCI2000CAN",
@@ -707,7 +708,7 @@ static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (IS_ERR(adgl))
 		return PTR_ERR(adgl);
 
-	lock_kernel();	
+	mutex_lock(&ac_mutex);	
 	IndexCard = adgl->num_card-1;
 	 
 	if(cmd != 6 && ((IndexCard >= MAX_BOARD) || !apbs[IndexCard].RamIO)) {
@@ -717,7 +718,7 @@ static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			warncount--;
 		}
 		kfree(adgl);
-		unlock_kernel();
+		mutex_unlock(&ac_mutex);
 		return -EINVAL;
 	}
 
@@ -835,7 +836,7 @@ static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 	Dummy = readb(apbs[IndexCard].RamIO + VERS);
 	kfree(adgl);
-	unlock_kernel();
+	mutex_unlock(&ac_mutex);
 	return 0;
 }
 
diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index 170693c..e3d72aa 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -20,7 +20,7 @@
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/bcd.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
@@ -32,6 +32,7 @@
 
 #define RTC_MAJOR_NR 121 /* local major, change later */
 
+static DEFINE_MUTEX(rtc_mutex);
 static const char ds1302_name[] = "ds1302";
 
 /* Send 8 bits. */
@@ -164,9 +165,9 @@ static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			struct rtc_time rtc_tm;
 
 			memset(&rtc_tm, 0, sizeof (struct rtc_time));
-			lock_kernel();
+			mutex_lock(&rtc_mutex);
 			get_rtc_time(&rtc_tm);
-			unlock_kernel();
+			mutex_unlock(&rtc_mutex);
 			if (copy_to_user((struct rtc_time*)arg, &rtc_tm, sizeof(struct rtc_time)))
 				return -EFAULT;
 			return 0;
@@ -218,7 +219,7 @@ static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			mon = bin2bcd(mon);
 			yrs = bin2bcd(yrs);
 
-			lock_kernel();
+			mutex_lock(&rtc_mutex);
 			local_irq_save(flags);
 			CMOS_WRITE(yrs, RTC_YEAR);
 			CMOS_WRITE(mon, RTC_MONTH);
@@ -227,7 +228,7 @@ static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			CMOS_WRITE(min, RTC_MINUTES);
 			CMOS_WRITE(sec, RTC_SECONDS);
 			local_irq_restore(flags);
-			unlock_kernel();
+			mutex_unlock(&rtc_mutex);
 
 			/* Notice that at this point, the RTC is updated but
 			 * the kernel is still running with the old time.
@@ -247,10 +248,10 @@ static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if(copy_from_user(&tcs_val, (int*)arg, sizeof(int)))
 				return -EFAULT;
 
-			lock_kernel();
+			mutex_lock(&rtc_mutex);
 			tcs_val = RTC_TCR_PATTERN | (tcs_val & 0x0F);
 			ds1302_writereg(RTC_TRICKLECHARGER, tcs_val);
-			unlock_kernel();
+			mutex_unlock(&rtc_mutex);
 			return 0;
 		}
 		default:
diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index dbee868..9aa1fd0 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -8,7 +8,7 @@
 #include <linux/proc_fs.h>
 #include <linux/capability.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -34,6 +34,7 @@
 #define CFG_CPU			2
 #define CFG_1SHOT		1
 
+static DEFINE_MUTEX(ds1620_mutex);
 static const char *fan_state[] = { "off", "on", "on (hardwired)" };
 
 /*
@@ -210,7 +211,6 @@ static void ds1620_read_state(struct therm *therm)
 
 static int ds1620_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return nonseekable_open(inode, file);
 }
 
@@ -321,9 +321,9 @@ ds1620_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ds1620_mutex);
 	ret = ds1620_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ds1620_mutex);
 
 	return ret;
 }
diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index 8a1b28a..b3c7562 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -32,7 +32,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/device.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>	/* For put_user and get_user */
@@ -94,6 +94,7 @@
 	} \
 }
 
+static DEFINE_MUTEX(dsp56k_mutex);
 static struct dsp56k_device {
 	unsigned long in_use;
 	long maxio, timeout;
@@ -330,9 +331,9 @@ static long dsp56k_ioctl(struct file *file, unsigned int cmd,
 			if (len > DSP56K_MAX_BINARY_LENGTH) {
 				return -EINVAL;
 			}
-			lock_kernel();
+			mutex_lock(&dsp56k_mutex);
 			r = dsp56k_upload(bin, len);
-			unlock_kernel();
+			mutex_unlock(&dsp56k_mutex);
 			if (r < 0) {
 				return r;
 			}
@@ -342,16 +343,16 @@ static long dsp56k_ioctl(struct file *file, unsigned int cmd,
 		case DSP56K_SET_TX_WSIZE:
 			if (arg > 4 || arg < 1)
 				return -EINVAL;
-			lock_kernel();
+			mutex_lock(&dsp56k_mutex);
 			dsp56k.tx_wsize = (int) arg;
-			unlock_kernel();
+			mutex_unlock(&dsp56k_mutex);
 			break;
 		case DSP56K_SET_RX_WSIZE:
 			if (arg > 4 || arg < 1)
 				return -EINVAL;
-			lock_kernel();
+			mutex_lock(&dsp56k_mutex);
 			dsp56k.rx_wsize = (int) arg;
-			unlock_kernel();
+			mutex_unlock(&dsp56k_mutex);
 			break;
 		case DSP56K_HOST_FLAGS:
 		{
@@ -363,7 +364,7 @@ static long dsp56k_ioctl(struct file *file, unsigned int cmd,
 			if(get_user(out, &hf->out) < 0)
 				return -EFAULT;
 
-			lock_kernel();
+			mutex_lock(&dsp56k_mutex);
 			if ((dir & 0x1) && (out & 0x1))
 				dsp56k_host_interface.icr |= DSP56K_ICR_HF0;
 			else if (dir & 0x1)
@@ -378,16 +379,16 @@ static long dsp56k_ioctl(struct file *file, unsigned int cmd,
 			if (dsp56k_host_interface.icr & DSP56K_ICR_HF1) status |= 0x2;
 			if (dsp56k_host_interface.isr & DSP56K_ISR_HF2) status |= 0x4;
 			if (dsp56k_host_interface.isr & DSP56K_ISR_HF3) status |= 0x8;
-			unlock_kernel();
+			mutex_unlock(&dsp56k_mutex);
 			return put_user(status, &hf->status);
 		}
 		case DSP56K_HOST_CMD:
 			if (arg > 31 || arg < 0)
 				return -EINVAL;
-			lock_kernel();
+			mutex_lock(&dsp56k_mutex);
 			dsp56k_host_interface.cvr = (u_char)((arg & DSP56K_CVR_HV_MASK) |
 							     DSP56K_CVR_HC);
-			unlock_kernel();
+			mutex_unlock(&dsp56k_mutex);
 			break;
 		default:
 			return -EINVAL;
@@ -427,7 +428,7 @@ static int dsp56k_open(struct inode *inode, struct file *file)
 	int dev = iminor(inode) & 0x0f;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&dsp56k_mutex);
 	switch(dev)
 	{
 	case DSP56K_DEV_56001:
@@ -454,7 +455,7 @@ static int dsp56k_open(struct inode *inode, struct file *file)
 		ret = -ENODEV;
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&dsp56k_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index e3859d4..8dd040a 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -57,7 +57,7 @@
 #include <linux/ioport.h>	/* for request_region */
 #include <linux/delay.h>	/* for loops_per_jiffy */
 #include <linux/sched.h>
-#include <linux/smp_lock.h>	/* cycle_kernel_lock() */
+#include <linux/mutex.h>
 #include <asm/io.h>		/* for inb_p, outb_p, inb, outb, etc. */
 #include <asm/uaccess.h>	/* for get_user, etc. */
 #include <linux/wait.h>		/* for wait_queue */
@@ -73,6 +73,7 @@
 #define TRACE_RET ((void) 0)
 #endif				/* TRACING */
 
+static DEFINE_MUTEX(dtlk_mutex);
 static void dtlk_timer_tick(unsigned long data);
 
 static int dtlk_major;
@@ -275,9 +276,9 @@ static long dtlk_ioctl(struct file *file,
 	switch (cmd) {
 
 	case DTLK_INTERROGATE:
-		lock_kernel();
+		mutex_lock(&dtlk_mutex);
 		sp = dtlk_interrogate();
-		unlock_kernel();
+		mutex_unlock(&dtlk_mutex);
 		if (copy_to_user(argp, sp, sizeof(struct dtlk_settings)))
 			return -EINVAL;
 		return 0;
@@ -296,7 +297,6 @@ static int dtlk_open(struct inode *inode, struct file *file)
 {
 	TRACE_TEXT("(dtlk_open");
 
-	cycle_kernel_lock();
 	nonseekable_open(inode, file);
 	switch (iminor(inode)) {
 	case DTLK_MINOR:
diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index 82b5a88..0e941b5 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -19,7 +19,7 @@
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/nvram.h>
 #ifdef CONFIG_PPC_PMAC
@@ -28,6 +28,7 @@
 
 #define NVRAM_SIZE	8192
 
+static DEFINE_MUTEX(nvram_mutex);
 static ssize_t nvram_len;
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
@@ -120,9 +121,9 @@ static long nvram_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned l
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&nvram_mutex);
 	ret = nvram_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&nvram_mutex);
 
 	return ret;
 }
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index b6c2cc1..2aa69f9 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -52,7 +52,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
@@ -66,6 +66,7 @@
  *	ioctls.
  */
 
+static DEFINE_MUTEX(gen_rtc_mutex);
 static DECLARE_WAIT_QUEUE_HEAD(gen_rtc_wait);
 
 /*
@@ -337,9 +338,9 @@ static long gen_rtc_unlocked_ioctl(struct file *file, unsigned int cmd,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&gen_rtc_mutex);
 	ret = gen_rtc_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&gen_rtc_mutex);
 
 	return ret;
 }
@@ -352,16 +353,16 @@ static long gen_rtc_unlocked_ioctl(struct file *file, unsigned int cmd,
 
 static int gen_rtc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&gen_rtc_mutex);
 	if (gen_rtc_status & RTC_IS_OPEN) {
-		unlock_kernel();
+		mutex_unlock(&gen_rtc_mutex);
 		return -EBUSY;
 	}
 
 	gen_rtc_status |= RTC_IS_OPEN;
 	gen_rtc_irq_data = 0;
 	irq_active = 0;
-	unlock_kernel();
+	mutex_unlock(&gen_rtc_mutex);
 
 	return 0;
 }
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 4cd8b22..3bc0eef 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -23,7 +23,7 @@
 #include <linux/seq_file.h>
 #include <linux/dmi.h>
 #include <linux/capability.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -56,6 +56,7 @@
 
 #define I8K_TEMPERATURE_BUG	1
 
+static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 
 MODULE_AUTHOR("Massimo Dal Zotto (dz@debian.org)");
@@ -399,9 +400,9 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&i8k_mutex);
 	ret = i8k_ioctl_unlocked(fp, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&i8k_mutex);
 
 	return ret;
 }
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index d4b71e8..dfbdf49 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -98,7 +98,7 @@
 #include <linux/major.h>
 #include <linux/wait.h>
 #include <linux/device.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 
@@ -138,6 +138,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
+static DEFINE_MUTEX(ip2_mutex);
 static const struct file_operations ip2mem_proc_fops;
 static const struct file_operations ip2_proc_fops;
 
@@ -2897,7 +2898,7 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 	printk (KERN_DEBUG "IP2IPL: ioctl cmd %d, arg %ld\n", cmd, arg );
 #endif
 
-	lock_kernel();
+	mutex_lock(&ip2_mutex);
 
 	switch ( iplminor ) {
 	case 0:	    // IPL device
@@ -2961,7 +2962,7 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 		rc = -ENODEV;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&ip2_mutex);
 	return rc;
 }
 
@@ -2982,7 +2983,6 @@ ip2_ipl_open( struct inode *pInode, struct file *pFile )
 #ifdef IP2DEBUG_IPL
 	printk (KERN_DEBUG "IP2IPL: open\n" );
 #endif
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 938a3a2..598d278 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -126,7 +126,7 @@
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 
 #include <linux/parport.h>
@@ -140,6 +140,7 @@
 /* if you have more than 8 printers, remember to increase LP_NO */
 #define LP_NO 8
 
+static DEFINE_MUTEX(lp_mutex);
 static struct lp_struct lp_table[LP_NO];
 
 static unsigned int lp_count = 0;
@@ -493,7 +494,7 @@ static int lp_open(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&lp_mutex);
 	if (minor >= LP_NO) {
 		ret = -ENXIO;
 		goto out;
@@ -554,7 +555,7 @@ static int lp_open(struct inode * inode, struct file * file)
 	lp_release_parport (&lp_table[minor]);
 	lp_table[minor].current_mode = IEEE1284_MODE_COMPAT;
 out:
-	unlock_kernel();
+	mutex_unlock(&lp_mutex);
 	return ret;
 }
 
@@ -680,7 +681,7 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
-	lock_kernel();
+	mutex_lock(&lp_mutex);
 	switch (cmd) {
 	case LPSETTIMEOUT:
 		if (copy_from_user(&par_timeout, (void __user *)arg,
@@ -694,7 +695,7 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
 		ret = lp_do_ioctl(minor, cmd, arg, (void __user *)arg);
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&lp_mutex);
 
 	return ret;
 }
@@ -709,7 +710,7 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
-	lock_kernel();
+	mutex_lock(&lp_mutex);
 	switch (cmd) {
 	case LPSETTIMEOUT:
 		tc = compat_ptr(arg);
@@ -730,7 +731,7 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 		ret = lp_do_ioctl(minor, cmd, arg, compat_ptr(arg));
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&lp_mutex);
 
 	return ret;
 }
diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 83bef4e..1aeaaba 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -42,6 +41,7 @@
 #else
 #define DBG(fmt...)
 #endif
+static DEFINE_MUTEX(mbcs_mutex);
 static int mbcs_major;
 
 static LIST_HEAD(soft_list);
@@ -385,19 +385,19 @@ static int mbcs_open(struct inode *ip, struct file *fp)
 	struct mbcs_soft *soft;
 	int minor;
 
-	lock_kernel();
+	mutex_lock(&mbcs_mutex);
 	minor = iminor(ip);
 
 	/* Nothing protects access to this list... */
 	list_for_each_entry(soft, &soft_list, list) {
 		if (soft->nasid == minor) {
 			fp->private_data = soft->cxdev;
-			unlock_kernel();
+			mutex_unlock(&mbcs_mutex);
 			return 0;
 		}
 	}
 
-	unlock_kernel();
+	mutex_unlock(&mbcs_mutex);
 	return -ENODEV;
 }
 
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index ea7c99f..fe46978 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -32,7 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/math64.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
@@ -59,6 +59,7 @@ extern unsigned long sn_rtc_cycles_per_second;
 
 #define rtc_time()              (*RTC_COUNTER_ADDR)
 
+static DEFINE_MUTEX(mmtimer_mutex);
 static long mmtimer_ioctl(struct file *file, unsigned int cmd,
 						unsigned long arg);
 static int mmtimer_mmap(struct file *file, struct vm_area_struct *vma);
@@ -371,7 +372,7 @@ static long mmtimer_ioctl(struct file *file, unsigned int cmd,
 {
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&mmtimer_mutex);
 
 	switch (cmd) {
 	case MMTIMER_GETOFFSET:	/* offset of the counter */
@@ -414,7 +415,7 @@ static long mmtimer_ioctl(struct file *file, unsigned int cmd,
 		ret = -ENOTTY;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&mmtimer_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index a4ec50c..e5df26b 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -56,7 +56,7 @@
 #include <linux/serial.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/serial_8250.h>
 #include "smapi.h"
@@ -73,6 +73,7 @@ MODULE_LICENSE("GPL");
 * checks are made against other devices (ie. superio) for conflicts.
 * We'll depend on users using the tpctl utility to do that for now
 */
+static DEFINE_MUTEX(mwave_mutex);
 int mwave_debug = 0;
 int mwave_3780i_irq = 0;
 int mwave_3780i_io = 0;
@@ -101,7 +102,6 @@ static int mwave_open(struct inode *inode, struct file *file)
 	PRINTK_2(TRACE_MWAVE,
 		"mwavedd::mwave_open, exit return retval %x\n", retval);
 
-	cycle_kernel_lock();
 	return retval;
 }
 
@@ -136,9 +136,9 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 			PRINTK_1(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RESET"
 				" calling tp3780I_ResetDSP\n");
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_ResetDSP(&pDrvData->rBDData);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RESET"
 				" retval %x from tp3780I_ResetDSP\n",
@@ -149,9 +149,9 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 			PRINTK_1(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RUN"
 				" calling tp3780I_StartDSP\n");
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_StartDSP(&pDrvData->rBDData);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RUN"
 				" retval %x from tp3780I_StartDSP\n",
@@ -165,10 +165,10 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				"mwavedd::mwave_ioctl,"
 				" IOCTL_MW_DSP_ABILITIES calling"
 				" tp3780I_QueryAbilities\n");
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_QueryAbilities(&pDrvData->rBDData,
 					&rAbilities);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_DSP_ABILITIES"
 				" retval %x from tp3780I_QueryAbilities\n",
@@ -199,13 +199,13 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				"mwavedd::mwave_ioctl IOCTL_MW_READ_DATA,"
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rReadData.ulDataLength, ioarg, pusBuffer);
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 					iocmd,
 					pusBuffer,
 					rReadData.ulDataLength,
 					rReadData.usDspAddress);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 		}
 			break;
 	
@@ -223,12 +223,12 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rReadData.ulDataLength / 2, ioarg,
 				pusBuffer);
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 				iocmd, pusBuffer,
 				rReadData.ulDataLength / 2,
 				rReadData.usDspAddress);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 		}
 			break;
 	
@@ -246,12 +246,12 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rWriteData.ulDataLength, ioarg,
 				pusBuffer);
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 					iocmd, pusBuffer,
 					rWriteData.ulDataLength,
 					rWriteData.usDspAddress);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 		}
 			break;
 	
@@ -269,12 +269,12 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rWriteData.ulDataLength, ioarg,
 				pusBuffer);
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			retval = tp3780I_ReadWriteDspIStore(&pDrvData->rBDData,
 					iocmd, pusBuffer,
 					rWriteData.ulDataLength,
 					rWriteData.usDspAddress);
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 		}
 			break;
 	
@@ -295,10 +295,10 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				ipcnum,
 				pDrvData->IPCs[ipcnum].usIntCount);
 
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			pDrvData->IPCs[ipcnum].bIsHere = FALSE;
 			pDrvData->IPCs[ipcnum].bIsEnabled = TRUE;
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 	
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
@@ -323,7 +323,7 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 				ipcnum,
 				pDrvData->IPCs[ipcnum].usIntCount);
 	
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
 				DECLARE_WAITQUEUE(wait, current);
 
@@ -364,7 +364,7 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 					" processing\n",
 					ipcnum);
 			}
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 		}
 			break;
 	
@@ -383,14 +383,14 @@ static long mwave_ioctl(struct file *file, unsigned int iocmd,
 						ipcnum);
 				return -EINVAL;
 			}
-			lock_kernel();
+			mutex_lock(&mwave_mutex);
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
 				pDrvData->IPCs[ipcnum].bIsEnabled = FALSE;
 				if (pDrvData->IPCs[ipcnum].bIsHere == TRUE) {
 					wake_up_interruptible(&pDrvData->IPCs[ipcnum].ipc_wait_queue);
 				}
 			}
-			unlock_kernel();
+			mutex_unlock(&mwave_mutex);
 		}
 			break;
 	
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 66d2917..166f1e7 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -109,10 +109,11 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/system.h>
 
+static DEFINE_MUTEX(nvram_mutex);
 static DEFINE_SPINLOCK(nvram_state_lock);
 static int nvram_open_cnt;	/* #times opened */
 static int nvram_open_mode;	/* special open modes */
@@ -308,7 +309,7 @@ static long nvram_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		lock_kernel();
+		mutex_lock(&nvram_mutex);
 		spin_lock_irq(&rtc_lock);
 
 		for (i = 0; i < NVRAM_BYTES; ++i)
@@ -316,7 +317,7 @@ static long nvram_ioctl(struct file *file, unsigned int cmd,
 		__nvram_set_checksum();
 
 		spin_unlock_irq(&rtc_lock);
-		unlock_kernel();
+		mutex_unlock(&nvram_mutex);
 		return 0;
 
 	case NVRAM_SETCKS:
@@ -325,11 +326,11 @@ static long nvram_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		lock_kernel();
+		mutex_lock(&nvram_mutex);
 		spin_lock_irq(&rtc_lock);
 		__nvram_set_checksum();
 		spin_unlock_irq(&rtc_lock);
-		unlock_kernel();
+		mutex_unlock(&nvram_mutex);
 		return 0;
 
 	default:
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index 043a1c7..a12f524 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -25,7 +25,6 @@
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
 
@@ -41,6 +40,7 @@
 
 #define	NWFLASH_VERSION "6.4"
 
+static DEFINE_MUTEX(flash_mutex);
 static void kick_open(void);
 static int get_flash_id(void);
 static int erase_block(int nBlock);
@@ -96,7 +96,7 @@ static int get_flash_id(void)
 
 static long flash_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
-	lock_kernel();
+	mutex_lock(&flash_mutex);
 	switch (cmd) {
 	case CMD_WRITE_DISABLE:
 		gbWriteBase64Enable = 0;
@@ -114,10 +114,10 @@ static long flash_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	default:
 		gbWriteBase64Enable = 0;
 		gbWriteEnable = 0;
-		unlock_kernel();
+		mutex_unlock(&flash_mutex);
 		return -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&flash_mutex);
 	return 0;
 }
 
@@ -282,7 +282,7 @@ static loff_t flash_llseek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret;
 
-	lock_kernel();
+	mutex_lock(&flash_mutex);
 	if (flashdebug)
 		printk(KERN_DEBUG "flash_llseek: offset=0x%X, orig=0x%X.\n",
 		       (unsigned int) offset, orig);
@@ -317,7 +317,7 @@ static loff_t flash_llseek(struct file *file, loff_t offset, int orig)
 	default:
 		ret = -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&flash_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index ec73d9f..7d091b6 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -30,7 +30,7 @@
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/bitrev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
@@ -55,6 +55,7 @@
 			   __func__ , ## args);		\
 	} while (0)
 
+static DEFINE_MUTEX(cmm_mutex);
 static char *version = "cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte";
 
 #define	T_1SEC		(HZ)
@@ -1418,7 +1419,7 @@ static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	       iminor(inode), ioctl_names[_IOC_NR(cmd)]);
 #endif
 
-	lock_kernel();
+	mutex_lock(&cmm_mutex);
 	rc = -ENODEV;
 	link = dev_table[iminor(inode)];
 	if (!pcmcia_dev_present(link)) {
@@ -1626,7 +1627,7 @@ static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		rc = -ENOTTY;
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&cmm_mutex);
 	return rc;
 }
 
@@ -1640,7 +1641,7 @@ static int cmm_open(struct inode *inode, struct file *filp)
 	if (minor >= CM4000_MAX_DEV)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&cmm_mutex);
 	link = dev_table[minor];
 	if (link == NULL || !pcmcia_dev_present(link)) {
 		ret = -ENODEV;
@@ -1685,7 +1686,7 @@ static int cmm_open(struct inode *inode, struct file *filp)
 	DEBUGP(2, dev, "<- cmm_open\n");
 	ret = nonseekable_open(inode, filp);
 out:
-	unlock_kernel();
+	mutex_unlock(&cmm_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 815cde1..04c0a89 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -24,7 +24,7 @@
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -49,6 +49,7 @@
 			   __func__ , ## args);		\
 	} while (0)
 
+static DEFINE_MUTEX(cm4040_mutex);
 static char *version =
 "OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte";
 
@@ -444,7 +445,7 @@ static int cm4040_open(struct inode *inode, struct file *filp)
 	if (minor >= CM_MAX_DEV)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&cm4040_mutex);
 	link = dev_table[minor];
 	if (link == NULL || !pcmcia_dev_present(link)) {
 		ret = -ENODEV;
@@ -473,7 +474,7 @@ static int cm4040_open(struct inode *inode, struct file *filp)
 	DEBUGP(2, dev, "<- cm4040_open (successfully)\n");
 	ret = nonseekable_open(inode, filp);
 out:
-	unlock_kernel();
+	mutex_unlock(&cm4040_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 02abfdd..723152d 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -67,7 +67,7 @@
 #include <linux/slab.h>
 #include <linux/major.h>
 #include <linux/ppdev.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/uaccess.h>
 
 #define PP_VERSION "ppdev: user-space parallel port driver"
@@ -97,6 +97,7 @@ struct pp_struct {
 /* ROUND_UP macro from fs/select.c */
 #define ROUND_UP(x,y) (((x)+(y)-1)/(y))
 
+static DEFINE_MUTEX(pp_do_mutex);
 static inline void pp_enable_irq (struct pp_struct *pp)
 {
 	struct parport *port = pp->pdev->port;
@@ -630,9 +631,9 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static long pp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&pp_do_mutex);
 	ret = pp_do_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&pp_do_mutex);
 	return ret;
 }
 
@@ -641,7 +642,6 @@ static int pp_open (struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	struct pp_struct *pp;
 
-	cycle_kernel_lock();
 	if (minor >= PARPORT_MAX)
 		return -ENXIO;
 
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index d58c2eb..e06a597 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -44,7 +44,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
 
@@ -122,6 +122,7 @@ more than 512 ports.... */
 
 
 /* These constants are derived from SCO Source */
+static DEFINE_MUTEX(rio_fw_mutex);
 static struct Conf
  RIOConf = {
 	/* locator */ "RIO Config here",
@@ -566,9 +567,9 @@ static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	func_enter();
 
 	/* The "dev" argument isn't used. */
-	lock_kernel();
+	mutex_lock(&rio_fw_mutex);
 	rc = riocontrol(p, 0, cmd, arg, capable(CAP_SYS_ADMIN));
-	unlock_kernel();
+	mutex_unlock(&rio_fw_mutex);
 
 	func_exit();
 	return rc;
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 32b74de..208e257 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -21,7 +21,7 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/sn/io.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/module.h>
@@ -34,6 +34,7 @@
 #define SCDRV_BUFSZ	2048
 #define SCDRV_TIMEOUT	1000
 
+static DEFINE_MUTEX(scdrv_mutex);
 static irqreturn_t
 scdrv_interrupt(int irq, void *subch_data)
 {
@@ -105,7 +106,7 @@ scdrv_open(struct inode *inode, struct file *file)
 	file->private_data = sd;
 
 	/* hook this subchannel up to the system controller interrupt */
-	lock_kernel();
+	mutex_lock(&scdrv_mutex);
 	rv = request_irq(SGI_UART_VECTOR, scdrv_interrupt,
 			 IRQF_SHARED | IRQF_DISABLED,
 			 SYSCTL_BASENAME, sd);
@@ -113,10 +114,10 @@ scdrv_open(struct inode *inode, struct file *file)
 		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
 		kfree(sd);
 		printk("%s: irq request failed (%d)\n", __func__, rv);
-		unlock_kernel();
+		mutex_unlock(&scdrv_mutex);
 		return -EBUSY;
 	}
-	unlock_kernel();
+	mutex_unlock(&scdrv_mutex);
 	return 0;
 }
 
diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index f8bc79f..f8f09ab 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -68,7 +68,7 @@
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/toshiba.h>
 
 #define TOSH_MINOR_DEV 181
@@ -78,6 +78,7 @@ MODULE_AUTHOR("Jonathan Buzzard <jonathan@buzzard.org.uk>");
 MODULE_DESCRIPTION("Toshiba laptop SMM driver");
 MODULE_SUPPORTED_DEVICE("toshiba");
 
+static DEFINE_MUTEX(tosh_mutex);
 static int tosh_fn;
 module_param_named(fn, tosh_fn, int, 0);
 MODULE_PARM_DESC(fn, "User specified Fn key detection port");
@@ -274,16 +275,16 @@ static long tosh_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				return -EINVAL;
 
 			/* do we need to emulate the fan ? */
-			lock_kernel();
+			mutex_lock(&tosh_mutex);
 			if (tosh_fan==1) {
 				if (((ax==0xf300) || (ax==0xf400)) && (bx==0x0004)) {
 					err = tosh_emulate_fan(&regs);
-					unlock_kernel();
+					mutex_unlock(&tosh_mutex);
 					break;
 				}
 			}
 			err = tosh_smm(&regs);
-			unlock_kernel();
+			mutex_unlock(&tosh_mutex);
 			break;
 		default:
 			return -EINVAL;
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 42f7fa4..6f954a8 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -46,7 +46,7 @@
 #include <linux/completion.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
@@ -64,6 +64,7 @@
 #define VIOTAPE_KERN_WARN	KERN_WARNING "viotape: "
 #define VIOTAPE_KERN_INFO	KERN_INFO "viotape: "
 
+static DEFINE_MUTEX(proc_viotape_mutex);
 static int viotape_numdev;
 
 /*
@@ -684,9 +685,9 @@ static long viotap_unlocked_ioctl(struct file *file,
 {
 	long rc;
 
-	lock_kernel();
+	mutex_lock(&proc_viotape_mutex);
 	rc = viotap_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&proc_viotape_mutex);
 	return rc;
 }
 
@@ -700,7 +701,7 @@ static int viotap_open(struct inode *inode, struct file *file)
 	if (op == NULL)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&proc_viotape_mutex);
 	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
 	/* Note: We currently only support one mode! */
@@ -731,7 +732,7 @@ static int viotap_open(struct inode *inode, struct file *file)
 
 free_op:
 	free_op_struct(op);
-	unlock_kernel();
+	mutex_unlock(&proc_viotape_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index b663d57..d985204 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -81,7 +81,6 @@
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/fs.h>
 #include <linux/cdev.h>
@@ -112,6 +111,7 @@
 #define HWICAP_DEVICES 1
 
 /* An array, which is set to true when the device is registered. */
+static DEFINE_MUTEX(hwicap_mutex);
 static bool probed_devices[HWICAP_DEVICES];
 static struct mutex icap_sem;
 
@@ -502,7 +502,7 @@ static int hwicap_open(struct inode *inode, struct file *file)
 	struct hwicap_drvdata *drvdata;
 	int status;
 
-	lock_kernel();
+	mutex_lock(&hwicap_mutex);
 	drvdata = container_of(inode->i_cdev, struct hwicap_drvdata, cdev);
 
 	status = mutex_lock_interruptible(&drvdata->sem);
@@ -528,7 +528,7 @@ static int hwicap_open(struct inode *inode, struct file *file)
  error:
 	mutex_unlock(&drvdata->sem);
  out:
-	unlock_kernel();
+	mutex_unlock(&hwicap_mutex);
 	return status;
 }
 
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index b7ca2a9..d4d4ca6 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -38,7 +38,6 @@
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/smp_lock.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
@@ -50,6 +49,7 @@
 #include <linux/kref.h>
 
 /* Addresses to scan */
+static DEFINE_MUTEX(watchdog_mutex);
 static const unsigned short normal_i2c[] = { 0x73, I2C_CLIENT_END };
 
 /* Insmod parameters */
@@ -858,7 +858,7 @@ static long watchdog_ioctl(struct file *filp, unsigned int cmd, unsigned long ar
 	int i, ret = 0;
 	struct fschmd_data *data = filp->private_data;
 
-	lock_kernel();
+	mutex_lock(&watchdog_mutex);
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ident.firmware_version = data->revision;
@@ -915,7 +915,7 @@ static long watchdog_ioctl(struct file *filp, unsigned int cmd, unsigned long ar
 	default:
 		ret = -ENOTTY;
 	}
-	unlock_kernel();
+	mutex_unlock(&watchdog_mutex);
 	return ret;
 }
 
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 697202e..8e540ad 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -35,7 +35,6 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
-#include <linux/smp_lock.h>
 #include <linux/hwmon-vid.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
@@ -52,6 +51,7 @@
 #define WATCHDOG_TIMEOUT 2	/* 2 minute default timeout */
 
 /* Addresses to scan */
+static DEFINE_MUTEX(watchdog_mutex);
 static const unsigned short normal_i2c[] = { 0x2c, 0x2d, 0x2e, 0x2f,
 						I2C_CLIENT_END };
 
@@ -1333,7 +1333,7 @@ static long watchdog_ioctl(struct file *filp, unsigned int cmd,
 	int val, ret = 0;
 	struct w83793_data *data = filp->private_data;
 
-	lock_kernel();
+	mutex_lock(&watchdog_mutex);
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		if (!nowayout)
@@ -1387,7 +1387,7 @@ static long watchdog_ioctl(struct file *filp, unsigned int cmd,
 	default:
 		ret = -ENOTTY;
 	}
-	unlock_kernel();
+	mutex_unlock(&watchdog_mutex);
 	return ret;
 }
 
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index c190664..0733706 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -43,7 +43,7 @@
 #include <linux/proc_fs.h>
 #include <linux/poll.h>
 #include <linux/rtc.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/semaphore.h>
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
@@ -52,6 +52,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 #define RTC_VERSION "1.10d"
 
+static DEFINE_MUTEX(hp_sdc_rtc_mutex);
 static unsigned long epoch = 2000;
 
 static struct semaphore i8042tregs;
@@ -665,9 +666,9 @@ static long hp_sdc_rtc_unlocked_ioctl(struct file *file,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&hp_sdc_rtc_mutex);
 	ret = hp_sdc_rtc_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&hp_sdc_rtc_mutex);
 
 	return ret;
 }
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 75ee0d3..3712e50 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/phantom.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/atomic.h>
 #include <asm/io.h>
@@ -38,6 +38,7 @@
 #define PHB_RUNNING		1
 #define PHB_NOT_OH		2
 
+static DEFINE_MUTEX(phantom_mutex);
 static struct class *phantom_class;
 static int phantom_major;
 
@@ -215,17 +216,17 @@ static int phantom_open(struct inode *inode, struct file *file)
 	struct phantom_device *dev = container_of(inode->i_cdev,
 			struct phantom_device, cdev);
 
-	lock_kernel();
+	mutex_lock(&phantom_mutex);
 	nonseekable_open(inode, file);
 
 	if (mutex_lock_interruptible(&dev->open_lock)) {
-		unlock_kernel();
+		mutex_unlock(&phantom_mutex);
 		return -ERESTARTSYS;
 	}
 
 	if (dev->opened) {
 		mutex_unlock(&dev->open_lock);
-		unlock_kernel();
+		mutex_unlock(&phantom_mutex);
 		return -EINVAL;
 	}
 
@@ -236,7 +237,7 @@ static int phantom_open(struct inode *inode, struct file *file)
 	atomic_set(&dev->counter, 0);
 	dev->opened++;
 	mutex_unlock(&dev->open_lock);
-	unlock_kernel();
+	mutex_unlock(&phantom_mutex);
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/cpqphp_sysfs.c b/drivers/pci/hotplug/cpqphp_sysfs.c
index 5621532..4cb3044 100644
--- a/drivers/pci/hotplug/cpqphp_sysfs.c
+++ b/drivers/pci/hotplug/cpqphp_sysfs.c
@@ -34,10 +34,11 @@
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include "cpqphp.h"
 
+static DEFINE_MUTEX(cpqphp_mutex);
 static int show_ctrl (struct controller *ctrl, char *buf)
 {
 	char *out = buf;
@@ -147,7 +148,7 @@ static int open(struct inode *inode, struct file *file)
 	struct ctrl_dbg *dbg;
 	int retval = -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&cpqphp_mutex);
 	dbg = kmalloc(sizeof(*dbg), GFP_KERNEL);
 	if (!dbg)
 		goto exit;
@@ -160,7 +161,7 @@ static int open(struct inode *inode, struct file *file)
 	file->private_data = dbg;
 	retval = 0;
 exit:
-	unlock_kernel();
+	mutex_unlock(&cpqphp_mutex);
 	return retval;
 }
 
@@ -169,7 +170,7 @@ static loff_t lseek(struct file *file, loff_t off, int whence)
 	struct ctrl_dbg *dbg;
 	loff_t new = -1;
 
-	lock_kernel();
+	mutex_lock(&cpqphp_mutex);
 	dbg = file->private_data;
 
 	switch (whence) {
@@ -181,10 +182,10 @@ static loff_t lseek(struct file *file, loff_t off, int whence)
 		break;
 	}
 	if (new < 0 || new > dbg->size) {
-		unlock_kernel();
+		mutex_unlock(&cpqphp_mutex);
 		return -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&cpqphp_mutex);
 	return (file->f_pos = new);
 }
 
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 66377f3..6c07410 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -20,7 +20,7 @@
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/string.h>
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 #include <linux/fs.h>
@@ -68,6 +68,7 @@
 
 #define DRV_VERSION "0.05"
 
+static DEFINE_MUTEX(m41t80_rtc_mutex);
 static const struct i2c_device_id m41t80_id[] = {
 	{ "m41t62", M41T80_FEATURE_SQ | M41T80_FEATURE_SQ_ALT },
 	{ "m41t65", M41T80_FEATURE_HT | M41T80_FEATURE_WD },
@@ -677,9 +678,9 @@ static long wdt_unlocked_ioctl(struct file *file, unsigned int cmd,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&m41t80_rtc_mutex);
 	ret = wdt_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&m41t80_rtc_mutex);
 
 	return ret;
 }
@@ -693,16 +694,16 @@ static long wdt_unlocked_ioctl(struct file *file, unsigned int cmd,
 static int wdt_open(struct inode *inode, struct file *file)
 {
 	if (MINOR(inode->i_rdev) == WATCHDOG_MINOR) {
-		lock_kernel();
+		mutex_lock(&m41t80_rtc_mutex);
 		if (test_and_set_bit(0, &wdt_is_open)) {
-			unlock_kernel();
+			mutex_unlock(&m41t80_rtc_mutex);
 			return -EBUSY;
 		}
 		/*
 		 *	Activate
 		 */
 		wdt_is_open = 1;
-		unlock_kernel();
+		mutex_unlock(&m41t80_rtc_mutex);
 		return nonseekable_open(inode, file);
 	}
 	return -ENODEV;
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 4942050..13f48e2 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -27,7 +27,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
@@ -68,6 +68,8 @@
 #define JSF_PART_BITS	 2	/* 2 bits of minors to cover JSF_NPART */
 #define JSF_PART_MASK	 0x3	/* 2 bits mask */
 
+static DEFINE_MUTEX(jsf_mutex);
+
 /*
  * Access functions.
  * We could ioremap(), but it's easier this way.
@@ -225,7 +227,7 @@ static loff_t jsf_lseek(struct file * file, loff_t offset, int orig)
 {
 	loff_t ret;
 
-	lock_kernel();
+	mutex_lock(&jsf_mutex);
 	switch (orig) {
 		case 0:
 			file->f_pos = offset;
@@ -238,7 +240,7 @@ static loff_t jsf_lseek(struct file * file, loff_t offset, int orig)
 		default:
 			ret = -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&jsf_mutex);
 	return ret;
 }
 
@@ -384,18 +386,18 @@ static int jsf_ioctl_program(void __user *arg)
 
 static long jsf_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
-	lock_kernel();
+	mutex_lock(&jsf_mutex);
 	int error = -ENOTTY;
 	void __user *argp = (void __user *)arg;
 
 	if (!capable(CAP_SYS_ADMIN)) {
-		unlock_kernel();
+		mutex_unlock(&jsf_mutex);
 		return -EPERM;
 	}
 	switch (cmd) {
 	case JSFLASH_IDENT:
 		if (copy_to_user(argp, &jsf0.id, JSFIDSZ)) {
-			unlock_kernel();
+			mutex_unlock(&jsf_mutex);
 			return -EFAULT;
 		}
 		break;
@@ -407,7 +409,7 @@ static long jsf_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&jsf_mutex);
 	return error;
 }
 
@@ -418,17 +420,17 @@ static int jsf_mmap(struct file * file, struct vm_area_struct * vma)
 
 static int jsf_open(struct inode * inode, struct file * filp)
 {
-	lock_kernel();
+	mutex_lock(&jsf_mutex);
 	if (jsf0.base == 0) {
-		unlock_kernel();
+		mutex_unlock(&jsf_mutex);
 		return -ENXIO;
 	}
 	if (test_and_set_bit(0, (void *)&jsf0.busy) != 0) {
-		unlock_kernel();
+		mutex_unlock(&jsf_mutex);
 		return -EBUSY;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&jsf_mutex);
 	return 0;	/* XXX What security? */
 }
 
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index b53deee..b1e4699 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -257,7 +257,7 @@
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
@@ -277,6 +277,7 @@
 #define TYPE(inode) (iminor(inode) >> 4)
 #define NUM(inode) (iminor(inode) & 0xf)
 
+static DEFINE_MUTEX(ixj_mutex);
 static int ixjdebug;
 static int hertz = HZ;
 static int samplerate = 100;
@@ -6655,9 +6656,9 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 static long ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&ixj_mutex);
 	ret = do_ixj_ioctl(file_p, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ixj_mutex);
 	return ret;
 }
 
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 566343b..b7d96e6 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -25,7 +25,7 @@
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -89,6 +89,7 @@ struct cpwd {
 	} devs[WD_NUMDEVS];
 };
 
+static DEFINE_MUTEX(cpwd_mutex);
 static struct cpwd *cpwd_device;
 
 /* Sun uses Altera PLD EPF8820ATC144-4
@@ -368,7 +369,7 @@ static int cpwd_open(struct inode *inode, struct file *f)
 {
 	struct cpwd *p = cpwd_device;
 
-	lock_kernel();
+	mutex_lock(&cpwd_mutex);
 	switch (iminor(inode)) {
 	case WD0_MINOR:
 	case WD1_MINOR:
@@ -376,7 +377,7 @@ static int cpwd_open(struct inode *inode, struct file *f)
 		break;
 
 	default:
-		unlock_kernel();
+		mutex_unlock(&cpwd_mutex);
 		return -ENODEV;
 	}
 
@@ -386,13 +387,13 @@ static int cpwd_open(struct inode *inode, struct file *f)
 				IRQF_SHARED, DRIVER_NAME, p)) {
 			printk(KERN_ERR PFX "Cannot register IRQ %d\n",
 				p->irq);
-			unlock_kernel();
+			mutex_unlock(&cpwd_mutex);
 			return -EBUSY;
 		}
 		p->initialized = true;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&cpwd_mutex);
 
 	return nonseekable_open(inode, f);
 }
@@ -482,9 +483,9 @@ static long cpwd_compat_ioctl(struct file *file, unsigned int cmd,
 	case WIOCSTART:
 	case WIOCSTOP:
 	case WIOCGSTAT:
-		lock_kernel();
+		mutex_lock(&cpwd_mutex);
 		rval = cpwd_ioctl(file, cmd, arg);
-		unlock_kernel();
+		mutex_unlock(&cpwd_mutex);
 		break;
 
 	/* everything else is handled by the generic compat layer */
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index ac405f0..af7c95e 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -17,16 +17,17 @@
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/xattr.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include "hfsplus_fs.h"
 
+static DEFINE_MUTEX(hfsplus_mutex);
 long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
 
-	lock_kernel();
+	mutex_lock(&hfsplus_mutex);
 	switch (cmd) {
 	case HFSPLUS_IOC_EXT2_GETFLAGS:
 		flags = 0;
@@ -41,7 +42,7 @@ long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		int err = 0;
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err) {
-			unlock_kernel();
+			mutex_unlock(&hfsplus_mutex);
 			return err;
 		}
 
@@ -89,11 +90,11 @@ long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		mark_inode_dirty(inode);
 setflags_out:
 		mnt_drop_write(filp->f_path.mnt);
-		unlock_kernel();
+		mutex_unlock(&hfsplus_mutex);
 		return err;
 	}
 	default:
-		unlock_kernel();
+		mutex_unlock(&hfsplus_mutex);
 		return -ENOTTY;
 	}
 }
-- 
1.7.1

