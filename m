Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0FCANy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:13:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab0FCANn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:13:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: [RFC 1/5] BKL: autoconvert trivial users to private mutex
Date: Thu,  3 Jun 2010 02:13:15 +0200
Message-Id: <1275523999-27462-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275523999-27462-1-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+6uOv5yJrjKg61HGOilfyPZXX7tdPSNJzzucC
 ppSEOyu8huwyewlCRye2Q04ml4iYu7RA8FzS25m2N6YkGoMUrc
 6sjLyW1vhrvoCSkmb+FlA==
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
---
 arch/cris/arch-v10/drivers/eeprom.c        |    2 -
 arch/cris/arch-v10/drivers/i2c.c           |    2 -
 arch/cris/arch-v32/drivers/cryptocop.c     |    2 -
 arch/cris/arch-v32/drivers/i2c.c           |    2 -
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
 drivers/char/ipmi/ipmi_devintf.c           |   14 ++++----
 drivers/char/ipmi/ipmi_watchdog.c          |    8 ++--
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
 drivers/isdn/capi/capi.c                   |    6 ++--
 drivers/isdn/divert/divert_procfs.c        |    7 ++--
 drivers/isdn/hardware/eicon/divamnt.c      |    7 ++--
 drivers/isdn/hardware/eicon/divasi.c       |    2 -
 drivers/isdn/hardware/eicon/divasmain.c    |    2 -
 drivers/isdn/hysdn/hysdn_procconf.c        |   21 +++++++------
 drivers/isdn/hysdn/hysdn_proclog.c         |   15 +++++----
 drivers/isdn/i4l/isdn_common.c             |   27 +++++++++--------
 drivers/isdn/mISDN/timerdev.c              |    7 ++--
 drivers/macintosh/adb.c                    |   10 +++---
 drivers/macintosh/smu.c                    |    6 ++--
 drivers/macintosh/via-pmu.c                |   11 ++++---
 drivers/media/dvb/bt8xx/dst_ca.c           |    7 ++--
 drivers/media/video/cx88/cx88-blackbird.c  |   13 ++++----
 drivers/media/video/dabusb.c               |   18 ++++++------
 drivers/media/video/se401.c                |    9 +++--
 drivers/media/video/stradis.c              |    9 +++--
 drivers/media/video/stv680.c               |    6 ++--
 drivers/media/video/usbvideo/vicam.c       |   14 ++++----
 drivers/message/fusion/mptctl.c            |   15 +++++----
 drivers/message/i2o/i2o_config.c           |   23 +++++++-------
 drivers/misc/phantom.c                     |   11 ++++---
 drivers/mtd/mtdchar.c                      |   15 +++++----
 drivers/net/ppp_generic.c                  |   19 ++++++------
 drivers/net/wan/cosa.c                     |   10 +++---
 drivers/pci/hotplug/cpqphp_sysfs.c         |   13 ++++----
 drivers/rtc/rtc-m41t80.c                   |   13 ++++----
 drivers/sbus/char/display7seg.c            |    8 ++--
 drivers/sbus/char/envctrl.c                |    2 -
 drivers/sbus/char/flash.c                  |   15 +++++----
 drivers/sbus/char/openprom.c               |   15 +++++----
 drivers/sbus/char/uctrl.c                  |    7 ++--
 drivers/scsi/3w-9xxx.c                     |    7 ++--
 drivers/scsi/3w-sas.c                      |    7 ++--
 drivers/scsi/3w-xxxx.c                     |    9 ++---
 drivers/scsi/aacraid/linit.c               |   15 +++++----
 drivers/scsi/ch.c                          |    8 ++--
 drivers/scsi/dpt_i2o.c                     |   18 ++++++------
 drivers/scsi/gdth.c                        |   11 ++++---
 drivers/scsi/megaraid.c                    |    8 ++--
 drivers/scsi/megaraid/megaraid_mm.c        |    8 ++--
 drivers/scsi/megaraid/megaraid_sas.c       |    2 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   11 ++++---
 drivers/scsi/osst.c                        |   15 +++++----
 drivers/scsi/scsi_tgt_if.c                 |    2 -
 drivers/staging/crystalhd/crystalhd_lnx.c  |    9 +++--
 drivers/staging/dt3155/dt3155_drv.c        |    7 ++--
 drivers/staging/vme/devices/vme_user.c     |    7 ++--
 drivers/telephony/ixj.c                    |    7 ++--
 drivers/usb/gadget/printer.c               |    7 ++--
 drivers/usb/misc/iowarrior.c               |   15 +++++----
 drivers/usb/misc/rio500.c                  |   15 +++++----
 drivers/usb/misc/usblcd.c                  |   16 +++++-----
 drivers/watchdog/cpwd.c                    |   15 +++++----
 fs/hfsplus/ioctl.c                         |   11 ++++---
 net/wanrouter/wanmain.c                    |    7 ++--
 net/wanrouter/wanproc.c                    |    7 ++--
 92 files changed, 496 insertions(+), 464 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/eeprom.c b/arch/cris/arch-v10/drivers/eeprom.c
index c340550..5047a33 100644
--- a/arch/cris/arch-v10/drivers/eeprom.c
+++ b/arch/cris/arch-v10/drivers/eeprom.c
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
 #include "i2c.h"
@@ -376,7 +375,6 @@ int __init eeprom_init(void)
 /* Opens the device. */
 static int eeprom_open(struct inode * inode, struct file * file)
 {
-  cycle_kernel_lock();
   if(iminor(inode) != EEPROM_MINOR_NR)
      return -ENXIO;
   if(imajor(inode) != EEPROM_MAJOR_NR)
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index a8737a8..f34fe71 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -566,7 +565,6 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 static int
 i2c_open(struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b70fb34..9f80da0 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -11,7 +11,6 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 
@@ -2307,7 +2306,6 @@ static int cryptocop_open(struct inode *inode, struct file *filp)
 {
 	int p = iminor(inode);
 
-	cycle_kernel_lock();
 	if (p != CRYPTOCOP_MINOR) return -EINVAL;
 
 	filp->private_data = NULL;
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 5068263..b26b6ca 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -32,7 +32,6 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 
 #include <asm/etraxi2c.h>
 
@@ -636,7 +635,6 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 static int
 i2c_open(struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
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
index 911e1da..be1e502 100644
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
 
@@ -2893,7 +2894,7 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 	printk (KERN_DEBUG "IP2IPL: ioctl cmd %d, arg %ld\n", cmd, arg );
 #endif
 
-	lock_kernel();
+	mutex_lock(&ip2_mutex);
 
 	switch ( iplminor ) {
 	case 0:	    // IPL device
@@ -2955,7 +2956,7 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 		rc = -ENODEV;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&ip2_mutex);
 	return rc;
 }
 
@@ -2976,7 +2977,6 @@ ip2_ipl_open( struct inode *pInode, struct file *pFile )
 #ifdef IP2DEBUG_IPL
 	printk (KERN_DEBUG "IP2IPL: open\n" );
 #endif
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index d8ec92a..44833de 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -44,7 +44,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 
 struct ipmi_file_private
 {
@@ -59,6 +58,7 @@ struct ipmi_file_private
 	unsigned int         default_retry_time_ms;
 };
 
+static DEFINE_MUTEX(ipmi_mutex);
 static void file_receive_handler(struct ipmi_recv_msg *msg,
 				 void                 *handler_data)
 {
@@ -102,9 +102,9 @@ static int ipmi_fasync(int fd, struct file *file, int on)
 	struct ipmi_file_private *priv = file->private_data;
 	int                      result;
 
-	lock_kernel(); /* could race against open() otherwise */
+	mutex_lock(&ipmi_mutex); /* could race against open() otherwise */
 	result = fasync_helper(fd, file, on, &priv->fasync_queue);
-	unlock_kernel();
+	mutex_unlock(&ipmi_mutex);
 
 	return (result);
 }
@@ -125,7 +125,7 @@ static int ipmi_open(struct inode *inode, struct file *file)
 	if (!priv)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&ipmi_mutex);
 	priv->file = file;
 
 	rv = ipmi_create_user(if_num,
@@ -150,7 +150,7 @@ static int ipmi_open(struct inode *inode, struct file *file)
 	priv->default_retry_time_ms = 0;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&ipmi_mutex);
 	return rv;
 }
 
@@ -639,9 +639,9 @@ static long ipmi_unlocked_ioctl(struct file   *file,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ipmi_mutex);
 	ret = ipmi_ioctl(file, cmd, data);
-	unlock_kernel();
+	mutex_unlock(&ipmi_mutex);
 
 	return ret;
 }
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 82bcdb2..d80b8c9 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -35,7 +35,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ipmi.h>
 #include <linux/ipmi_smi.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/watchdog.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
@@ -149,6 +149,7 @@
 #define	WDIOC_GET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 22, int)
 #endif
 
+static DEFINE_MUTEX(ipmi_watchdog_mutex);
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 static ipmi_user_t watchdog_user;
@@ -736,9 +737,9 @@ static long ipmi_unlocked_ioctl(struct file *file,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ipmi_watchdog_mutex);
 	ret = ipmi_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ipmi_watchdog_mutex);
 
 	return ret;
 }
@@ -832,7 +833,6 @@ static int ipmi_open(struct inode *ino, struct file *filep)
 		if (test_and_set_bit(0, &ipmi_wdog_open))
 			return -EBUSY;
 
-		cycle_kernel_lock();
 
 		/*
 		 * Don't start the timer now, let it start on the
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
index e7956ac..dd56d77 100644
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
 
@@ -56,6 +56,7 @@
 			   __func__ , ## args);		\
 	} while (0)
 
+static DEFINE_MUTEX(cmm_mutex);
 static char *version = "cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte";
 
 #define	T_1SEC		(HZ)
@@ -1419,7 +1420,7 @@ static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	       iminor(inode), ioctl_names[_IOC_NR(cmd)]);
 #endif
 
-	lock_kernel();
+	mutex_lock(&cmm_mutex);
 	rc = -ENODEV;
 	link = dev_table[iminor(inode)];
 	if (!pcmcia_dev_present(link)) {
@@ -1627,7 +1628,7 @@ static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		rc = -ENOTTY;
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&cmm_mutex);
 	return rc;
 }
 
@@ -1641,7 +1642,7 @@ static int cmm_open(struct inode *inode, struct file *filp)
 	if (minor >= CM4000_MAX_DEV)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&cmm_mutex);
 	link = dev_table[minor];
 	if (link == NULL || !pcmcia_dev_present(link)) {
 		ret = -ENODEV;
@@ -1686,7 +1687,7 @@ static int cmm_open(struct inode *inode, struct file *filp)
 	DEBUGP(2, dev, "<- cmm_open\n");
 	ret = nonseekable_open(inode, filp);
 out:
-	unlock_kernel();
+	mutex_unlock(&cmm_mutex);
 	return ret;
 }
 
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index c0775c8..42ab8ab 100644
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
@@ -50,6 +50,7 @@
 			   __func__ , ## args);		\
 	} while (0)
 
+static DEFINE_MUTEX(cm4040_mutex);
 static char *version =
 "OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte";
 
@@ -445,7 +446,7 @@ static int cm4040_open(struct inode *inode, struct file *filp)
 	if (minor >= CM_MAX_DEV)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&cm4040_mutex);
 	link = dev_table[minor];
 	if (link == NULL || !pcmcia_dev_present(link)) {
 		ret = -ENODEV;
@@ -474,7 +475,7 @@ static int cm4040_open(struct inode *inode, struct file *filp)
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
index ed8a9ce..ee45acd 100644
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
@@ -111,6 +110,7 @@
 #define HWICAP_DEVICES 1
 
 /* An array, which is set to true when the device is registered. */
+static DEFINE_MUTEX(hwicap_mutex);
 static bool probed_devices[HWICAP_DEVICES];
 static struct mutex icap_sem;
 
@@ -501,7 +501,7 @@ static int hwicap_open(struct inode *inode, struct file *file)
 	struct hwicap_drvdata *drvdata;
 	int status;
 
-	lock_kernel();
+	mutex_lock(&hwicap_mutex);
 	drvdata = container_of(inode->i_cdev, struct hwicap_drvdata, cdev);
 
 	status = mutex_lock_interruptible(&drvdata->sem);
@@ -527,7 +527,7 @@ static int hwicap_open(struct inode *inode, struct file *file)
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
index e00a1cc..2a90e7c 100644
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
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 0cabe31..b0a4a69 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -20,7 +20,6 @@
 #include <linux/signal.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/tty.h>
@@ -50,6 +49,7 @@ MODULE_LICENSE("GPL");
 
 /* -------- driver information -------------------------------------- */
 
+static DEFINE_MUTEX(capi_mutex);
 static struct class *capi_class;
 static int capi_major = 68;		/* allocated */
 
@@ -985,9 +985,9 @@ capi_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&capi_mutex);
 	ret = capi_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&capi_mutex);
 
 	return ret;
 }
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index c53e241..33ec9e4 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -20,7 +20,7 @@
 #include <linux/sched.h>
 #include <linux/isdnif.h>
 #include <net/net_namespace.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include "isdn_divert.h"
 
 
@@ -28,6 +28,7 @@
 /* Variables for interface queue */
 /*********************************/
 ulong if_used = 0;		/* number of interface users */
+static DEFINE_MUTEX(isdn_divert_mutex);
 static struct divert_info *divert_info_head = NULL;	/* head of queue */
 static struct divert_info *divert_info_tail = NULL;	/* pointer to last entry */
 static DEFINE_SPINLOCK(divert_info_lock);/* lock for queue */
@@ -261,9 +262,9 @@ static long isdn_divert_ioctl(struct file *file, uint cmd, ulong arg)
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&isdn_divert_mutex);
 	ret = isdn_divert_ioctl_unlocked(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&isdn_divert_mutex);
 
 	return ret;
 }
diff --git a/drivers/isdn/hardware/eicon/divamnt.c b/drivers/isdn/hardware/eicon/divamnt.c
index 1e85f74..f1d464f 100644
--- a/drivers/isdn/hardware/eicon/divamnt.c
+++ b/drivers/isdn/hardware/eicon/divamnt.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #include "platform.h"
@@ -22,6 +22,7 @@
 #include "divasync.h"
 #include "debug_if.h"
 
+static DEFINE_MUTEX(maint_mutex);
 static char *main_revision = "$Revision: 1.32.6.10 $";
 
 static int major;
@@ -130,7 +131,7 @@ static int maint_open(struct inode *ino, struct file *filep)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&maint_mutex);
 	/* only one open is allowed, so we test
 	   it atomically */
 	if (test_and_set_bit(0, &opened))
@@ -139,7 +140,7 @@ static int maint_open(struct inode *ino, struct file *filep)
 		filep->private_data = NULL;
 		ret = nonseekable_open(ino, filep);
 	}
-	unlock_kernel();
+	mutex_unlock(&maint_mutex);
 	return ret;
 }
 
diff --git a/drivers/isdn/hardware/eicon/divasi.c b/drivers/isdn/hardware/eicon/divasi.c
index f577719..42d3b83 100644
--- a/drivers/isdn/hardware/eicon/divasi.c
+++ b/drivers/isdn/hardware/eicon/divasi.c
@@ -18,7 +18,6 @@
 #include <linux/proc_fs.h>
 #include <linux/skbuff.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 #include "platform.h"
@@ -402,7 +401,6 @@ static unsigned int um_idi_poll(struct file *file, poll_table * wait)
 
 static int um_idi_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return (0);
 }
 
diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index fbbcb27..16a874b 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -21,7 +21,6 @@
 #include <linux/list.h>
 #include <linux/poll.h>
 #include <linux/kmod.h>
-#include <linux/smp_lock.h>
 
 #include "platform.h"
 #undef ID_MASK
@@ -581,7 +580,6 @@ xdi_copy_from_user(void *os_handle, void *dst, const void __user *src, int lengt
  */
 static int divas_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return (0);
 }
 
diff --git a/drivers/isdn/hysdn/hysdn_procconf.c b/drivers/isdn/hysdn/hysdn_procconf.c
index 8096646..96b3e39 100644
--- a/drivers/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/isdn/hysdn/hysdn_procconf.c
@@ -17,11 +17,12 @@
 #include <linux/proc_fs.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <net/net_namespace.h>
 
 #include "hysdn_defs.h"
 
+static DEFINE_MUTEX(hysdn_conf_mutex);
 static char *hysdn_procconf_revision = "$Revision: 1.8.6.4 $";
 
 #define INFO_OUT_LEN 80		/* length of info line including lf */
@@ -234,7 +235,7 @@ hysdn_conf_open(struct inode *ino, struct file *filep)
 	char *cp, *tmp;
 
 	/* now search the addressed card */
-	lock_kernel();
+	mutex_lock(&hysdn_conf_mutex);
 	card = card_root;
 	while (card) {
 		pd = card->procconf;
@@ -243,7 +244,7 @@ hysdn_conf_open(struct inode *ino, struct file *filep)
 		card = card->next;	/* search next entry */
 	}
 	if (!card) {
-		unlock_kernel();
+		mutex_unlock(&hysdn_conf_mutex);
 		return (-ENODEV);	/* device is unknown/invalid */
 	}
 	if (card->debug_flags & (LOG_PROC_OPEN | LOG_PROC_ALL))
@@ -255,7 +256,7 @@ hysdn_conf_open(struct inode *ino, struct file *filep)
 		/* write only access -> write boot file or conf line */
 
 		if (!(cnf = kmalloc(sizeof(struct conf_writedata), GFP_KERNEL))) {
-			unlock_kernel();
+			mutex_unlock(&hysdn_conf_mutex);
 			return (-EFAULT);
 		}
 		cnf->card = card;
@@ -267,7 +268,7 @@ hysdn_conf_open(struct inode *ino, struct file *filep)
 		/* read access -> output card info data */
 
 		if (!(tmp = kmalloc(INFO_OUT_LEN * 2 + 2, GFP_KERNEL))) {
-			unlock_kernel();
+			mutex_unlock(&hysdn_conf_mutex);
 			return (-EFAULT);	/* out of memory */
 		}
 		filep->private_data = tmp;	/* start of string */
@@ -301,10 +302,10 @@ hysdn_conf_open(struct inode *ino, struct file *filep)
 		*cp++ = '\n';
 		*cp = 0;	/* end of string */
 	} else {		/* simultaneous read/write access forbidden ! */
-		unlock_kernel();
+		mutex_unlock(&hysdn_conf_mutex);
 		return (-EPERM);	/* no permission this time */
 	}
-	unlock_kernel();
+	mutex_unlock(&hysdn_conf_mutex);
 	return nonseekable_open(ino, filep);
 }				/* hysdn_conf_open */
 
@@ -319,7 +320,7 @@ hysdn_conf_close(struct inode *ino, struct file *filep)
 	int retval = 0;
 	struct proc_dir_entry *pd;
 
-	lock_kernel();
+	mutex_lock(&hysdn_conf_mutex);
 	/* search the addressed card */
 	card = card_root;
 	while (card) {
@@ -329,7 +330,7 @@ hysdn_conf_close(struct inode *ino, struct file *filep)
 		card = card->next;	/* search next entry */
 	}
 	if (!card) {
-		unlock_kernel();
+		mutex_unlock(&hysdn_conf_mutex);
 		return (-ENODEV);	/* device is unknown/invalid */
 	}
 	if (card->debug_flags & (LOG_PROC_OPEN | LOG_PROC_ALL))
@@ -352,7 +353,7 @@ hysdn_conf_close(struct inode *ino, struct file *filep)
 
 		kfree(filep->private_data);	/* release memory */
 	}
-	unlock_kernel();
+	mutex_unlock(&hysdn_conf_mutex);
 	return (retval);
 }				/* hysdn_conf_close */
 
diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
index e83f6fd..37a9dd3 100644
--- a/drivers/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/isdn/hysdn/hysdn_proclog.c
@@ -15,13 +15,14 @@
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include "hysdn_defs.h"
 
 /* the proc subdir for the interface is defined in the procconf module */
 extern struct proc_dir_entry *hysdn_proc_entry;
 
+static DEFINE_MUTEX(hysdn_log_mutex);
 static void put_log_buffer(hysdn_card * card, char *cp);
 
 /*************************************************/
@@ -251,7 +252,7 @@ hysdn_log_open(struct inode *ino, struct file *filep)
 	struct procdata *pd = NULL;
 	unsigned long flags;
 
-	lock_kernel();
+	mutex_lock(&hysdn_log_mutex);
 	card = card_root;
 	while (card) {
 		pd = card->proclog;
@@ -260,7 +261,7 @@ hysdn_log_open(struct inode *ino, struct file *filep)
 		card = card->next;	/* search next entry */
 	}
 	if (!card) {
-		unlock_kernel();
+		mutex_unlock(&hysdn_log_mutex);
 		return (-ENODEV);	/* device is unknown/invalid */
 	}
 	filep->private_data = card;	/* remember our own card */
@@ -278,10 +279,10 @@ hysdn_log_open(struct inode *ino, struct file *filep)
 			filep->private_data = &pd->log_head;
 		spin_unlock_irqrestore(&card->hysdn_lock, flags);
 	} else {		/* simultaneous read/write access forbidden ! */
-		unlock_kernel();
+		mutex_unlock(&hysdn_log_mutex);
 		return (-EPERM);	/* no permission this time */
 	}
-	unlock_kernel();
+	mutex_unlock(&hysdn_log_mutex);
 	return nonseekable_open(ino, filep);
 }				/* hysdn_log_open */
 
@@ -300,7 +301,7 @@ hysdn_log_close(struct inode *ino, struct file *filep)
 	hysdn_card *card;
 	int retval = 0;
 
-	lock_kernel();
+	mutex_lock(&hysdn_log_mutex);
 	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
 		/* write only access -> write debug level written */
 		retval = 0;	/* success */
@@ -339,7 +340,7 @@ hysdn_log_close(struct inode *ino, struct file *filep)
 					kfree(inf);
 				}
 	}			/* read access */
-	unlock_kernel();
+	mutex_unlock(&hysdn_log_mutex);
 
 	return (retval);
 }				/* hysdn_log_close */
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index a44cdb4..15632bd 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/isdn.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include "isdn_common.h"
 #include "isdn_tty.h"
 #include "isdn_net.h"
@@ -42,6 +42,7 @@ MODULE_LICENSE("GPL");
 
 isdn_dev *dev;
 
+static DEFINE_MUTEX(isdn_mutex);
 static char *isdn_revision = "$Revision: 1.1.2.3 $";
 
 extern char *isdn_net_revision;
@@ -1070,7 +1071,7 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t * off)
 	int retval;
 	char *p;
 
-	lock_kernel();
+	mutex_lock(&isdn_mutex);
 	if (minor == ISDN_MINOR_STATUS) {
 		if (!file->private_data) {
 			if (file->f_flags & O_NONBLOCK) {
@@ -1163,7 +1164,7 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t * off)
 #endif
 	retval = -ENODEV;
  out:
-	unlock_kernel();
+	mutex_unlock(&isdn_mutex);
 	return retval;
 }
 
@@ -1180,7 +1181,7 @@ isdn_write(struct file *file, const char __user *buf, size_t count, loff_t * off
 	if (!dev->drivers)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&isdn_mutex);
 	if (minor <= ISDN_MINOR_BMAX) {
 		printk(KERN_WARNING "isdn_write minor %d obsolete!\n", minor);
 		drvidx = isdn_minor2drv(minor);
@@ -1225,7 +1226,7 @@ isdn_write(struct file *file, const char __user *buf, size_t count, loff_t * off
 #endif
 	retval = -ENODEV;
  out:
-	unlock_kernel();
+	mutex_unlock(&isdn_mutex);
 	return retval;
 }
 
@@ -1236,7 +1237,7 @@ isdn_poll(struct file *file, poll_table * wait)
 	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	int drvidx = isdn_minor2drv(minor - ISDN_MINOR_CTRL);
 
-	lock_kernel();
+	mutex_lock(&isdn_mutex);
 	if (minor == ISDN_MINOR_STATUS) {
 		poll_wait(file, &(dev->info_waitq), wait);
 		/* mask = POLLOUT | POLLWRNORM; */
@@ -1266,7 +1267,7 @@ isdn_poll(struct file *file, poll_table * wait)
 #endif
 	mask = POLLERR;
  out:
-	unlock_kernel();
+	mutex_unlock(&isdn_mutex);
 	return mask;
 }
 
@@ -1727,9 +1728,9 @@ isdn_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&isdn_mutex);
 	ret = isdn_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&isdn_mutex);
 
 	return ret;
 }
@@ -1745,7 +1746,7 @@ isdn_open(struct inode *ino, struct file *filep)
 	int chidx;
 	int retval = -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&isdn_mutex);
 	if (minor == ISDN_MINOR_STATUS) {
 		infostruct *p;
 
@@ -1796,7 +1797,7 @@ isdn_open(struct inode *ino, struct file *filep)
 #endif
  out:
 	nonseekable_open(ino, filep);
-	unlock_kernel();
+	mutex_unlock(&isdn_mutex);
 	return retval;
 }
 
@@ -1805,7 +1806,7 @@ isdn_close(struct inode *ino, struct file *filep)
 {
 	uint minor = iminor(ino);
 
-	lock_kernel();
+	mutex_lock(&isdn_mutex);
 	if (minor == ISDN_MINOR_STATUS) {
 		infostruct *p = dev->infochain;
 		infostruct *q = NULL;
@@ -1839,7 +1840,7 @@ isdn_close(struct inode *ino, struct file *filep)
 #endif
 
  out:
-	unlock_kernel();
+	mutex_unlock(&isdn_mutex);
 	return 0;
 }
 
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 81048b8..de43c8c 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -24,9 +24,10 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mISDNif.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include "core.h"
 
+static DEFINE_MUTEX(mISDN_mutex);
 static u_int	*debug;
 
 
@@ -224,7 +225,7 @@ mISDN_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	if (*debug & DEBUG_TIMER)
 		printk(KERN_DEBUG "%s(%p, %x, %lx)\n", __func__,
 		    filep, cmd, arg);
-	lock_kernel();
+	mutex_lock(&mISDN_mutex);
 	switch (cmd) {
 	case IMADDTIMER:
 		if (get_user(tout, (int __user *)arg)) {
@@ -256,7 +257,7 @@ mISDN_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	default:
 		ret = -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&mISDN_mutex);
 	return ret;
 }
 
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 1c4ee6e..e75e3be 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -24,7 +24,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/adb.h>
 #include <linux/cuda.h>
 #include <linux/pmu.h>
@@ -55,6 +54,7 @@ extern struct adb_driver adb_iop_driver;
 extern struct adb_driver via_pmu_driver;
 extern struct adb_driver macio_adb_driver;
 
+static DEFINE_MUTEX(adb_mutex);
 static struct adb_driver *adb_driver_list[] = {
 #ifdef CONFIG_ADB_MACII
 	&via_macii_driver,
@@ -647,7 +647,7 @@ static int adb_open(struct inode *inode, struct file *file)
 	struct adbdev_state *state;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&adb_mutex);
 	if (iminor(inode) > 0 || adb_controller == NULL) {
 		ret = -ENXIO;
 		goto out;
@@ -665,7 +665,7 @@ static int adb_open(struct inode *inode, struct file *file)
 	state->inuse = 1;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&adb_mutex);
 	return ret;
 }
 
@@ -674,7 +674,7 @@ static int adb_release(struct inode *inode, struct file *file)
 	struct adbdev_state *state = file->private_data;
 	unsigned long flags;
 
-	lock_kernel();
+	mutex_lock(&adb_mutex);
 	if (state) {
 		file->private_data = NULL;
 		spin_lock_irqsave(&state->lock, flags);
@@ -687,7 +687,7 @@ static int adb_release(struct inode *inode, struct file *file)
 			spin_unlock_irqrestore(&state->lock, flags);
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&adb_mutex);
 	return 0;
 }
 
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 2506c95..8775dd4 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -19,7 +19,6 @@
  *    the userland interface
  */
 
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
@@ -97,6 +96,7 @@ struct smu_device {
  * I don't think there will ever be more than one SMU, so
  * for now, just hard code that
  */
+static DEFINE_MUTEX(smu_mutex);
 static struct smu_device	*smu;
 static DEFINE_MUTEX(smu_part_access);
 static int smu_irq_inited;
@@ -1095,12 +1095,12 @@ static int smu_open(struct inode *inode, struct file *file)
 	pp->mode = smu_file_commands;
 	init_waitqueue_head(&pp->wait);
 
-	lock_kernel();
+	mutex_lock(&smu_mutex);
 	spin_lock_irqsave(&smu_clist_lock, flags);
 	list_add(&pp->list, &smu_clist);
 	spin_unlock_irqrestore(&smu_clist_lock, flags);
 	file->private_data = pp;
-	unlock_kernel();
+	mutex_unlock(&smu_mutex);
 
 	return 0;
 }
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 3d4fc0f..28e4822 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -18,7 +18,7 @@
  *
  */
 #include <stdarg.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -72,6 +72,7 @@
 /* How many iterations between battery polls */
 #define BATTERY_POLLING_COUNT	2
 
+static DEFINE_MUTEX(pmu_info_proc_mutex);
 static volatile unsigned char __iomem *via;
 
 /* VIA registers - spaced 0x200 bytes apart */
@@ -2076,7 +2077,7 @@ pmu_open(struct inode *inode, struct file *file)
 	pp->rb_get = pp->rb_put = 0;
 	spin_lock_init(&pp->lock);
 	init_waitqueue_head(&pp->wait);
-	lock_kernel();
+	mutex_lock(&pmu_info_proc_mutex);
 	spin_lock_irqsave(&all_pvt_lock, flags);
 #if defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_PMAC_BACKLIGHT)
 	pp->backlight_locker = 0;
@@ -2084,7 +2085,7 @@ pmu_open(struct inode *inode, struct file *file)
 	list_add(&pp->list, &all_pmu_pvt);
 	spin_unlock_irqrestore(&all_pvt_lock, flags);
 	file->private_data = pp;
-	unlock_kernel();
+	mutex_unlock(&pmu_info_proc_mutex);
 	return 0;
 }
 
@@ -2341,9 +2342,9 @@ static long pmu_unlocked_ioctl(struct file *filp,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pmu_info_proc_mutex);
 	ret = pmu_ioctl(filp, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&pmu_info_proc_mutex);
 
 	return ret;
 }
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 770243c..f0c59c0 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -22,7 +22,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/dvb/ca.h>
 #include "dvbdev.h"
@@ -52,6 +52,7 @@
 } while(0)
 
 
+static DEFINE_MUTEX(dst_ca_mutex);
 static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
@@ -564,7 +565,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	void __user *arg = (void __user *)ioctl_arg;
 	int result = 0;
 
-	lock_kernel();
+	mutex_lock(&dst_ca_mutex);
 	dvbdev = (struct dvb_device *)file->private_data;
 	state = (struct dst_state *)dvbdev->priv;
 	p_ca_message = kmalloc(sizeof (struct ca_msg), GFP_KERNEL);
@@ -652,7 +653,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	kfree (p_ca_slot_info);
 	kfree (p_ca_caps);
 
-	unlock_kernel();
+	mutex_unlock(&dst_ca_mutex);
 	return result;
 }
 
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index e46e1ce..6bb59f1 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -33,7 +33,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
@@ -44,6 +44,7 @@ MODULE_DESCRIPTION("driver for cx2388x/cx23416 based mpeg encoder cards");
 MODULE_AUTHOR("Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
+static DEFINE_MUTEX(mpeg_mutex);
 static unsigned int mpegbufs = 32;
 module_param(mpegbufs,int,0644);
 MODULE_PARM_DESC(mpegbufs,"number of mpeg buffers, range 2-32");
@@ -1057,7 +1058,7 @@ static int mpeg_open(struct file *file)
 
 	dprintk( 1, "%s\n", __func__);
 
-	lock_kernel();
+	mutex_lock(&mpeg_mutex);
 
 	/* Make sure we can acquire the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
@@ -1065,7 +1066,7 @@ static int mpeg_open(struct file *file)
 		err = drv->request_acquire(drv);
 		if(err != 0) {
 			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-			unlock_kernel();
+			mutex_unlock(&mpeg_mutex);
 			return err;
 		}
 	}
@@ -1073,7 +1074,7 @@ static int mpeg_open(struct file *file)
 	if (!atomic_read(&dev->core->mpeg_users) && blackbird_initialize_codec(dev) < 0) {
 		if (drv)
 			drv->request_release(drv);
-		unlock_kernel();
+		mutex_unlock(&mpeg_mutex);
 		return -EINVAL;
 	}
 	dprintk(1, "open dev=%s\n", video_device_node_name(vdev));
@@ -1083,7 +1084,7 @@ static int mpeg_open(struct file *file)
 	if (NULL == fh) {
 		if (drv)
 			drv->request_release(drv);
-		unlock_kernel();
+		mutex_unlock(&mpeg_mutex);
 		return -ENOMEM;
 	}
 	file->private_data = fh;
@@ -1099,7 +1100,7 @@ static int mpeg_open(struct file *file)
 	/* FIXME: locking against other video device */
 	cx88_set_scale(dev->core, dev->width, dev->height,
 			fh->mpegq.field);
-	unlock_kernel();
+	mutex_unlock(&mpeg_mutex);
 
 	atomic_inc(&dev->core->mpeg_users);
 
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 0f50508..716d0ee 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -32,7 +32,6 @@
 #include <linux/list.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -61,6 +60,7 @@
 
 /*-------------------------------------------------------------------*/
 
+static DEFINE_MUTEX(dabusb_mutex);
 static dabusb_t dabusb[NRDABUSB];
 static int buffers = 256;
 static struct usb_driver dabusb_driver;
@@ -621,7 +621,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	if (devnum < DABUSB_MINOR || devnum >= (DABUSB_MINOR + NRDABUSB))
 		return -EIO;
 
-	lock_kernel();
+	mutex_lock(&dabusb_mutex);
 	s = &dabusb[devnum - DABUSB_MINOR];
 
 	dbg("dabusb_open");
@@ -636,7 +636,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 		msleep_interruptible(500);
 
 		if (signal_pending (current)) {
-			unlock_kernel();
+			mutex_unlock(&dabusb_mutex);
 			return -EAGAIN;
 		}
 		mutex_lock(&s->mutex);
@@ -644,7 +644,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
 		mutex_unlock(&s->mutex);
 		dev_err(&s->usbdev->dev, "set_interface failed\n");
-		unlock_kernel();
+		mutex_unlock(&dabusb_mutex);
 		return -EINVAL;
 	}
 	s->opened = 1;
@@ -654,7 +654,7 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	file->private_data = s;
 
 	r = nonseekable_open(inode, file);
-	unlock_kernel();
+	mutex_unlock(&dabusb_mutex);
 	return r;
 }
 
@@ -689,9 +689,9 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 
 	dbg("dabusb_ioctl");
 
-	lock_kernel();
+	mutex_lock(&dabusb_mutex);
 	if (s->remove_pending) {
-		unlock_kernel();
+		mutex_unlock(&dabusb_mutex);
 		return -EIO;
 	}
 
@@ -699,7 +699,7 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 
 	if (!s->usbdev) {
 		mutex_unlock(&s->mutex);
-		unlock_kernel();
+		mutex_unlock(&dabusb_mutex);
 		return -EIO;
 	}
 
@@ -740,7 +740,7 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 		break;
 	}
 	mutex_unlock(&s->mutex);
-	unlock_kernel();
+	mutex_unlock(&dabusb_mutex);
 	return ret;
 }
 
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 41d0166..87cfdd9 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -31,11 +31,12 @@ static const char version[] = "0.24";
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/usb.h>
 #include "se401.h"
 
+static DEFINE_MUTEX(se401_mutex);
 static int flickerless;
 static int video_nr = -1;
 
@@ -951,9 +952,9 @@ static int se401_open(struct file *file)
 	struct usb_se401 *se401 = (struct usb_se401 *)dev;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&se401_mutex);
 	if (se401->user) {
-		unlock_kernel();
+		mutex_unlock(&se401_mutex);
 		return -EBUSY;
 	}
 	se401->fbuf = rvmalloc(se401->maxframesize * SE401_NUMFRAMES);
@@ -962,7 +963,7 @@ static int se401_open(struct file *file)
 	else
 		err = -ENOMEM;
 	se401->user = !err;
-	unlock_kernel();
+	mutex_unlock(&se401_mutex);
 
 	return err;
 }
diff --git a/drivers/media/video/stradis.c b/drivers/media/video/stradis.c
index a057824..844ef47 100644
--- a/drivers/media/video/stradis.c
+++ b/drivers/media/video/stradis.c
@@ -26,7 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -58,6 +58,7 @@
 
 #define SAA7146_MAX 6
 
+static DEFINE_MUTEX(saa_mutex);
 static struct saa7146 saa7146s[SAA7146_MAX];
 
 static int saa_num;		/* number of SAA7146s in use */
@@ -1883,16 +1884,16 @@ static int saa_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146 *saa = container_of(vdev, struct saa7146, video_dev);
 
-	lock_kernel();
+	mutex_lock(&saa_mutex);
 	file->private_data = saa;
 
 	saa->user++;
 	if (saa->user > 1) {
-		unlock_kernel();
+		mutex_unlock(&saa_mutex);
 		return 0;	/* device open already, don't reset */
 	}
 	saa->writemode = VID_WRITE_MPEG_VID;	/* default to video */
-	unlock_kernel();
+	mutex_unlock(&saa_mutex);
 	return 0;
 }
 
diff --git a/drivers/media/video/stv680.c b/drivers/media/video/stv680.c
index 5938ad8..f1aae69 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -62,7 +62,6 @@
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/errno.h>
 #include <linux/videodev.h>
@@ -73,6 +72,7 @@
 
 #include "stv680.h"
 
+static DEFINE_MUTEX(stv_mutex);
 static int video_nr = -1;
 
 static int swapRGB;	/* 0 = default for auto select */
@@ -1089,7 +1089,7 @@ static int stv_open(struct file *file)
 	int err = 0;
 
 	/* we are called with the BKL held */
-	lock_kernel();
+	mutex_lock(&stv_mutex);
 	stv680->user = 1;
 	err = stv_init (stv680);	/* main initialization routine for camera */
 
@@ -1103,7 +1103,7 @@ static int stv_open(struct file *file)
 	}
 	if (err)
 		stv680->user = 0;
-	unlock_kernel();
+	mutex_unlock(&stv_mutex);
 
 	return err;
 }
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 6030410..a87b5b4 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -43,7 +43,6 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/firmware.h>
 #include <linux/ihex.h>
@@ -81,6 +80,7 @@
  * in the future.
  *
 */
+static DEFINE_MUTEX(vicam_mutex);
 static void *rvmalloc(unsigned long size)
 {
 	void *mem;
@@ -488,24 +488,24 @@ vicam_open(struct file *file)
 	 * rely on this fact forever.
 	 */
 
-	lock_kernel();
+	mutex_lock(&vicam_mutex);
 	if (cam->open_count > 0) {
 		printk(KERN_INFO
 		       "vicam_open called on already opened camera");
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -EBUSY;
 	}
 
 	cam->raw_image = kmalloc(VICAM_MAX_READ_SIZE, GFP_KERNEL);
 	if (!cam->raw_image) {
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -ENOMEM;
 	}
 
 	cam->framebuf = rvmalloc(VICAM_MAX_FRAME_SIZE * VICAM_FRAMES);
 	if (!cam->framebuf) {
 		kfree(cam->raw_image);
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -ENOMEM;
 	}
 
@@ -513,7 +513,7 @@ vicam_open(struct file *file)
 	if (!cam->cntrlbuf) {
 		kfree(cam->raw_image);
 		rvfree(cam->framebuf, VICAM_MAX_FRAME_SIZE * VICAM_FRAMES);
-		unlock_kernel();
+		mutex_unlock(&vicam_mutex);
 		return -ENOMEM;
 	}
 
@@ -531,7 +531,7 @@ vicam_open(struct file *file)
 	cam->open_count++;
 
 	file->private_data = cam;
-	unlock_kernel();
+	mutex_unlock(&vicam_mutex);
 
 	return 0;
 }
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index f06b291..5c6f206 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -54,7 +54,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>	/* for mdelay */
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 
 #include <asm/io.h>
@@ -83,6 +83,7 @@ MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
+static DEFINE_MUTEX(mpctl_mutex);
 static u8 mptctl_id = MPT_MAX_PROTOCOL_DRIVERS;
 static u8 mptctl_taskmgmt_id = MPT_MAX_PROTOCOL_DRIVERS;
 
@@ -593,12 +594,12 @@ mptctl_fasync(int fd, struct file *filep, int mode)
 	MPT_ADAPTER	*ioc;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&mpctl_mutex);
 	list_for_each_entry(ioc, &ioc_list, list)
 		ioc->aen_event_read_flag=0;
 
 	ret = fasync_helper(fd, filep, mode, &async_queue);
-	unlock_kernel();
+	mutex_unlock(&mpctl_mutex);
 	return ret;
 }
 
@@ -690,9 +691,9 @@ static long
 mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&mpctl_mutex);
 	ret = __mptctl_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mpctl_mutex);
 	return ret;
 }
 
@@ -2908,7 +2909,7 @@ compat_mpt_command(struct file *filp, unsigned int cmd,
 static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&mpctl_mutex);
 	switch (cmd) {
 	case MPTIOCINFO:
 	case MPTIOCINFO1:
@@ -2933,7 +2934,7 @@ static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long a
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&mpctl_mutex);
 	return ret;
 }
 
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c4b117f..771640a 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -31,7 +31,7 @@
  */
 
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
 
@@ -41,6 +41,7 @@
 
 #define SG_TABLESIZE		30
 
+static DEFINE_MUTEX(i2o_cfg_mutex);
 static long i2o_cfg_ioctl(struct file *, unsigned int, unsigned long);
 
 static spinlock_t i2o_config_lock;
@@ -739,7 +740,7 @@ static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 				 unsigned long arg)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_ioctl(file, cmd, arg);
@@ -751,7 +752,7 @@ static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
@@ -979,7 +980,7 @@ static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_getiops(arg);
@@ -1035,7 +1036,7 @@ static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		osm_debug("unknown ioctl called!\n");
 		ret = -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
@@ -1049,7 +1050,7 @@ static int cfg_open(struct inode *inode, struct file *file)
 	if (!tmp)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	file->private_data = (void *)(i2o_cfg_info_id++);
 	tmp->fp = file;
 	tmp->fasync = NULL;
@@ -1063,7 +1064,7 @@ static int cfg_open(struct inode *inode, struct file *file)
 	spin_lock_irqsave(&i2o_config_lock, flags);
 	open_files = tmp;
 	spin_unlock_irqrestore(&i2o_config_lock, flags);
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 
 	return 0;
 }
@@ -1074,14 +1075,14 @@ static int cfg_fasync(int fd, struct file *fp, int on)
 	struct i2o_cfg_info *p;
 	int ret = -EBADF;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	for (p = open_files; p; p = p->next)
 		if (p->q_id == id)
 			break;
 
 	if (p)
 		ret = fasync_helper(fd, fp, on, &p->fasync);
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
@@ -1091,7 +1092,7 @@ static int cfg_release(struct inode *inode, struct file *file)
 	struct i2o_cfg_info *p, **q;
 	unsigned long flags;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	spin_lock_irqsave(&i2o_config_lock, flags);
 	for (q = &open_files; (p = *q) != NULL; q = &p->next) {
 		if (p->q_id == id) {
@@ -1101,7 +1102,7 @@ static int cfg_release(struct inode *inode, struct file *file)
 		}
 	}
 	spin_unlock_irqrestore(&i2o_config_lock, flags);
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 
 	return 0;
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
 
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 000d65e..fb85942 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -12,7 +12,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/backing-dev.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
@@ -23,6 +23,7 @@
 #include <asm/uaccess.h>
 
 #define MTD_INODE_FS_MAGIC 0x11307854
+static DEFINE_MUTEX(mtd_mutex);
 static struct vfsmount *mtd_inode_mnt __read_mostly;
 
 /*
@@ -76,7 +77,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	if ((file->f_mode & FMODE_WRITE) && (minor & 1))
 		return -EACCES;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 	mtd = get_mtd_device(NULL, devnum);
 
 	if (IS_ERR(mtd)) {
@@ -124,7 +125,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	file->private_data = mfi;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 	return ret;
 } /* mtd_open */
 
@@ -843,9 +844,9 @@ static long mtd_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 	ret = mtd_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 
 	return ret;
 }
@@ -869,7 +870,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = compat_ptr(arg);
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 
 	switch (cmd) {
 	case MEMWRITEOOB32:
@@ -904,7 +905,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 		ret = mtd_ioctl(file, cmd, (unsigned long)argp);
 	}
 
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 
 	return ret;
 }
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index c5f8eb1..adecead 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -40,7 +40,6 @@
 #include <linux/if_arp.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
 #include <linux/stddef.h>
@@ -181,6 +180,7 @@ struct channel {
  * channel.downl.
  */
 
+static DEFINE_MUTEX(ppp_mutex);
 static atomic_t ppp_unit_count = ATOMIC_INIT(0);
 static atomic_t channel_count = ATOMIC_INIT(0);
 
@@ -363,7 +363,6 @@ static const int npindex_to_ethertype[NUM_NP] = {
  */
 static int ppp_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	/*
 	 * This could (should?) be enforced by the permissions on /dev/ppp.
 	 */
@@ -588,7 +587,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 * this fd and reopening /dev/ppp.
 		 */
 		err = -EINVAL;
-		lock_kernel();
+		mutex_lock(&ppp_mutex);
 		if (pf->kind == INTERFACE) {
 			ppp = PF_TO_PPP(pf);
 			if (file == ppp->owner)
@@ -600,7 +599,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		} else
 			printk(KERN_DEBUG "PPPIOCDETACH file->f_count=%ld\n",
 			       atomic_long_read(&file->f_count));
-		unlock_kernel();
+		mutex_unlock(&ppp_mutex);
 		return err;
 	}
 
@@ -608,7 +607,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct channel *pch;
 		struct ppp_channel *chan;
 
-		lock_kernel();
+		mutex_lock(&ppp_mutex);
 		pch = PF_TO_CHANNEL(pf);
 
 		switch (cmd) {
@@ -630,7 +629,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				err = chan->ops->ioctl(chan, cmd, arg);
 			up_read(&pch->chan_sem);
 		}
-		unlock_kernel();
+		mutex_unlock(&ppp_mutex);
 		return err;
 	}
 
@@ -640,7 +639,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return -EINVAL;
 	}
 
-	lock_kernel();
+	mutex_lock(&ppp_mutex);
 	ppp = PF_TO_PPP(pf);
 	switch (cmd) {
 	case PPPIOCSMRU:
@@ -788,7 +787,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		err = -ENOTTY;
 	}
-	unlock_kernel();
+	mutex_unlock(&ppp_mutex);
 	return err;
 }
 
@@ -801,7 +800,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 	struct ppp_net *pn;
 	int __user *p = (int __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&ppp_mutex);
 	switch (cmd) {
 	case PPPIOCNEWUNIT:
 		/* Create a new ppp unit */
@@ -852,7 +851,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 	default:
 		err = -ENOTTY;
 	}
-	unlock_kernel();
+	mutex_unlock(&ppp_mutex);
 	return err;
 }
 
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index f0bd70f..04c6cd4 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -89,7 +89,6 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
-#include <linux/smp_lock.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
@@ -174,6 +173,7 @@ struct cosa_data {
  * Character device major number. 117 was allocated for us.
  * The value of 0 means to allocate a first free one.
  */
+static DEFINE_MUTEX(cosa_chardev_mutex);
 static int cosa_major = 117;
 
 /*
@@ -944,7 +944,7 @@ static int cosa_open(struct inode *inode, struct file *file)
 	int n;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&cosa_chardev_mutex);
 	if ((n=iminor(file->f_path.dentry->d_inode)>>CARD_MINOR_BITS)
 		>= nr_cards) {
 		ret = -ENODEV;
@@ -976,7 +976,7 @@ static int cosa_open(struct inode *inode, struct file *file)
 	chan->rx_done = chrdev_rx_done;
 	spin_unlock_irqrestore(&cosa->lock, flags);
 out:
-	unlock_kernel();
+	mutex_unlock(&cosa_chardev_mutex);
 	return ret;
 }
 
@@ -1212,10 +1212,10 @@ static long cosa_chardev_ioctl(struct file *file, unsigned int cmd,
 	struct cosa_data *cosa;
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&cosa_chardev_mutex);
 	cosa = channel->cosa;
 	ret = cosa_ioctl_common(cosa, channel, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&cosa_chardev_mutex);
 	return ret;
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
index 6dc4e62..7d0e03c 100644
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
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e20b7bd..09a139f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -92,7 +92,6 @@
 #include <linux/pci.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -105,6 +104,7 @@
 
 /* Globals */
 #define TW_DRIVER_VERSION "2.26.02.014"
+static DEFINE_MUTEX(twa_chrdev_mutex);
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -658,7 +658,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	int retval = TW_IOCTL_ERROR_OS_EFAULT;
 	void __user *argp = (void __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&twa_chrdev_mutex);
 
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
@@ -879,7 +879,7 @@ out3:
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
-	unlock_kernel();
+	mutex_unlock(&twa_chrdev_mutex);
 	return retval;
 } /* End twa_chrdev_ioctl() */
 
@@ -890,7 +890,6 @@ static int twa_chrdev_open(struct inode *inode, struct file *file)
 	unsigned int minor_number;
 	int retval = TW_IOCTL_ERROR_OS_ENODEV;
 
-	cycle_kernel_lock();
 	minor_number = iminor(inode);
 	if (minor_number >= twa_device_extension_count)
 		goto out;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f481e73..7e5f238 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -64,7 +64,6 @@
 #include <linux/pci.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -77,6 +76,7 @@
 
 /* Globals */
 #define TW_DRIVER_VERSION "3.26.02.000"
+static DEFINE_MUTEX(twl_chrdev_mutex);
 static TW_Device_Extension *twl_device_extension_list[TW_MAX_SLOT];
 static unsigned int twl_device_extension_count;
 static int twl_major = -1;
@@ -764,7 +764,7 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	int retval = -EFAULT;
 	void __user *argp = (void __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&twl_chrdev_mutex);
 
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
@@ -861,7 +861,7 @@ out3:
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
-	unlock_kernel();
+	mutex_unlock(&twl_chrdev_mutex);
 	return retval;
 } /* End twl_chrdev_ioctl() */
 
@@ -876,7 +876,6 @@ static int twl_chrdev_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	cycle_kernel_lock();
 	minor_number = iminor(inode);
 	if (minor_number >= twl_device_extension_count)
 		goto out;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 30d735a..081c864 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -199,7 +199,6 @@
 
 #include <linux/module.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
@@ -221,6 +220,7 @@
 
 /* Globals */
 #define TW_DRIVER_VERSION "1.26.02.003"
+static DEFINE_MUTEX(tw_mutex);
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -900,10 +900,10 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 
 	dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl()\n");
 
-	lock_kernel();
+	mutex_lock(&tw_mutex);
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
-		unlock_kernel();
+		mutex_unlock(&tw_mutex);
 		return -EINTR;
 	}
 
@@ -1034,7 +1034,7 @@ out2:
 	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, cpu_addr, dma_handle);
 out:
 	mutex_unlock(&tw_dev->ioctl_lock);
-	unlock_kernel();
+	mutex_unlock(&tw_mutex);
 	return retval;
 } /* End tw_chrdev_ioctl() */
 
@@ -1044,7 +1044,6 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 {
 	unsigned int minor_number;
 
-	cycle_kernel_lock();
 	dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_open()\n");
 
 	minor_number = iminor(inode);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 33898b6..39e8395 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -38,7 +38,7 @@
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/delay.h>
@@ -76,6 +76,7 @@ MODULE_DESCRIPTION("Dell PERC2, 2/Si, 3/Si, 3/Di, "
 MODULE_LICENSE("GPL");
 MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
 
+static DEFINE_MUTEX(aac_mutex);
 static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
@@ -678,7 +679,7 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 	unsigned minor_number = iminor(inode);
 	int err = -ENODEV;
 
-	lock_kernel();  /* BKL pushdown: nothing else protects this list */
+	mutex_lock(&aac_mutex);  /* BKL pushdown: nothing else protects this list */
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id == minor_number) {
 			file->private_data = aac;
@@ -686,7 +687,7 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 			break;
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&aac_mutex);
 
 	return err;
 }
@@ -711,9 +712,9 @@ static long aac_cfg_ioctl(struct file *file,
 	int ret;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	lock_kernel();
+	mutex_lock(&aac_mutex);
 	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
-	unlock_kernel();
+	mutex_unlock(&aac_mutex);
 
 	return ret;
 }
@@ -722,7 +723,7 @@ static long aac_cfg_ioctl(struct file *file,
 static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&aac_mutex);
 	switch (cmd) {
 	case FSACTL_MINIPORT_REV_CHECK:
 	case FSACTL_SENDFIB:
@@ -756,7 +757,7 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&aac_mutex);
 	return ret;
 }
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4799d43..9ac271f 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -22,7 +22,6 @@
 #include <linux/chio.h>			/* here are all the ioctls */
 #include <linux/mutex.h>
 #include <linux/idr.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
@@ -44,6 +43,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MEDIUM_CHANGER);
 
+static DEFINE_MUTEX(ch_mutex);
 static int init = 1;
 module_param(init, int, 0444);
 MODULE_PARM_DESC(init, \
@@ -580,19 +580,19 @@ ch_open(struct inode *inode, struct file *file)
 	scsi_changer *ch;
 	int minor = iminor(inode);
 
-	lock_kernel();
+	mutex_lock(&ch_mutex);
 	spin_lock(&ch_index_lock);
 	ch = idr_find(&ch_index_idr, minor);
 
 	if (NULL == ch || scsi_device_get(ch->device)) {
 		spin_unlock(&ch_index_lock);
-		unlock_kernel();
+		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
 	spin_unlock(&ch_index_lock);
 
 	file->private_data = ch;
-	unlock_kernel();
+	mutex_unlock(&ch_mutex);
 	return 0;
 }
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b0c576f..0416ed8 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -49,7 +49,6 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
 #include <linux/kernel.h>	/* for printk */
 #include <linux/sched.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 
@@ -76,6 +75,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
  * Needed for our management apps
  *============================================================================
  */
+static DEFINE_MUTEX(adpt_mutex);
 static dpt_sig_S DPTI_sig = {
 	{'d', 'P', 't', 'S', 'i', 'G'}, SIG_VERSION,
 #ifdef __i386__
@@ -1732,12 +1732,12 @@ static int adpt_open(struct inode *inode, struct file *file)
 	int minor;
 	adpt_hba* pHba;
 
-	lock_kernel();
+	mutex_lock(&adpt_mutex);
 	//TODO check for root access
 	//
 	minor = iminor(inode);
 	if (minor >= hba_count) {
-		unlock_kernel();
+		mutex_unlock(&adpt_mutex);
 		return -ENXIO;
 	}
 	mutex_lock(&adpt_configuration_lock);
@@ -1748,7 +1748,7 @@ static int adpt_open(struct inode *inode, struct file *file)
 	}
 	if (pHba == NULL) {
 		mutex_unlock(&adpt_configuration_lock);
-		unlock_kernel();
+		mutex_unlock(&adpt_mutex);
 		return -ENXIO;
 	}
 
@@ -1759,7 +1759,7 @@ static int adpt_open(struct inode *inode, struct file *file)
 
 	pHba->in_use = 1;
 	mutex_unlock(&adpt_configuration_lock);
-	unlock_kernel();
+	mutex_unlock(&adpt_mutex);
 
 	return 0;
 }
@@ -2160,9 +2160,9 @@ static long adpt_unlocked_ioctl(struct file *file, uint cmd, ulong arg)
  
 	inode = file->f_dentry->d_inode;
  
-	lock_kernel();
+	mutex_lock(&adpt_mutex);
 	ret = adpt_ioctl(inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&adpt_mutex);
 
 	return ret;
 }
@@ -2176,7 +2176,7 @@ static long compat_adpt_ioctl(struct file *file,
  
 	inode = file->f_dentry->d_inode;
  
-	lock_kernel();
+	mutex_lock(&adpt_mutex);
  
 	switch(cmd) {
 		case DPT_SIGNATURE:
@@ -2194,7 +2194,7 @@ static long compat_adpt_ioctl(struct file *file,
 			ret =  -ENOIOCTLCMD;
 	}
  
-	unlock_kernel();
+	mutex_unlock(&adpt_mutex);
  
 	return ret;
 }
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index f672d62..56eb6c9 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -120,7 +120,7 @@
 #include <linux/timer.h>
 #include <linux/dma-mapping.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #ifdef GDTH_RTC
@@ -140,6 +140,7 @@
 #include <scsi/scsi_host.h>
 #include "gdth.h"
 
+static DEFINE_MUTEX(gdth_mutex);
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(u32 size, u32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
@@ -4042,12 +4043,12 @@ static int gdth_open(struct inode *inode, struct file *filep)
 {
     gdth_ha_str *ha;
 
-    lock_kernel();
+    mutex_lock(&gdth_mutex);
     list_for_each_entry(ha, &gdth_instances, list) {
         if (!ha->sdev)
             ha->sdev = scsi_get_host_dev(ha->shost);
     }
-    unlock_kernel();
+    mutex_unlock(&gdth_mutex);
 
     TRACE(("gdth_open()\n"));
     return 0;
@@ -4615,9 +4616,9 @@ static long gdth_unlocked_ioctl(struct file *file, unsigned int cmd,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&gdth_mutex);
 	ret = gdth_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&gdth_mutex);
 
 	return ret;
 }
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 0b6e322..4d0cf5c 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -46,7 +46,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsicam.h>
 
@@ -62,6 +62,7 @@ MODULE_DESCRIPTION ("LSI Logic MegaRAID legacy driver");
 MODULE_LICENSE ("GPL");
 MODULE_VERSION(MEGARAID_MODULE_VERSION);
 
+static DEFINE_MUTEX(megadev_mutex);
 static unsigned int max_cmd_per_lun = DEF_CMD_PER_LUN;
 module_param(max_cmd_per_lun, uint, 0);
 MODULE_PARM_DESC(max_cmd_per_lun, "Maximum number of commands which can be issued to a single LUN (default=DEF_CMD_PER_LUN=63)");
@@ -3282,7 +3283,6 @@ mega_init_scb(adapter_t *adapter)
 static int
 megadev_open (struct inode *inode, struct file *filep)
 {
-	cycle_kernel_lock();
 	/*
 	 * Only allow superuser to access private ioctl interface
 	 */
@@ -3701,9 +3701,9 @@ megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&megadev_mutex);
 	ret = megadev_ioctl(filep, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&megadev_mutex);
 
 	return ret;
 }
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 41f82f7..42770a1 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -16,11 +16,12 @@
  */
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include "megaraid_mm.h"
 
 
 // Entry points for char node driver
+static DEFINE_MUTEX(mraid_mm_mutex);
 static int mraid_mm_open(struct inode *, struct file *);
 static long mraid_mm_unlocked_ioctl(struct file *, uint, unsigned long);
 
@@ -98,7 +99,6 @@ mraid_mm_open(struct inode *inode, struct file *filep)
 	 */
 	if (!capable(CAP_SYS_ADMIN)) return (-EACCES);
 
-	cycle_kernel_lock();
 	return 0;
 }
 
@@ -224,9 +224,9 @@ mraid_mm_unlocked_ioctl(struct file *filep, unsigned int cmd,
 	int err;
 
 	/* inconsistant: mraid_mm_compat_ioctl doesn't take the BKL */
-	lock_kernel();
+	mutex_lock(&mraid_mm_mutex);
 	err = mraid_mm_ioctl(filep, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mraid_mm_mutex);
 
 	return err;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 99e4478..c4a595d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -33,7 +33,6 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/uio.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
@@ -3557,7 +3556,6 @@ static void megasas_shutdown(struct pci_dev *pdev)
  */
 static int megasas_mgmt_open(struct inode *inode, struct file *filep)
 {
-	cycle_kernel_lock();
 	/*
 	 * Allow only those users with admin rights
 	 */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index d88e975..56d08c0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -51,7 +51,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 #include <linux/poll.h>
 
@@ -61,6 +61,7 @@
 #include "mpt2sas_base.h"
 #include "mpt2sas_ctl.h"
 
+static DEFINE_MUTEX(_ctl_mutex);
 static struct fasync_struct *async_queue;
 static DECLARE_WAIT_QUEUE_HEAD(ctl_poll_wait);
 
@@ -2159,9 +2160,9 @@ _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&_ctl_mutex);
 	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg);
-	unlock_kernel();
+	mutex_unlock(&_ctl_mutex);
 	return ret;
 }
 
@@ -2230,12 +2231,12 @@ _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&_ctl_mutex);
 	if (cmd == MPT2COMMAND32)
 		ret = _ctl_compat_mpt_command(file, cmd, arg);
 	else
 		ret = _ctl_ioctl_main(file, cmd, (void __user *)arg);
-	unlock_kernel();
+	mutex_unlock(&_ctl_mutex);
 	return ret;
 }
 #endif
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index d64b717..358fd9c 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -51,7 +51,7 @@ static const char * osst_version = "0.99.4";
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -80,6 +80,7 @@ static const char * osst_version = "0.99.4";
 #include "osst_options.h"
 #include "osst_detect.h"
 
+static DEFINE_MUTEX(osst_int_mutex);
 static int max_dev = 0;
 static int write_threshold_kbs = 0;
 static int max_sg_segs = 0;
@@ -4807,9 +4808,9 @@ static int os_scsi_tape_open(struct inode * inode, struct file * filp)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&osst_int_mutex);
 	ret = __os_scsi_tape_open(inode, filp);
-	unlock_kernel();
+	mutex_unlock(&osst_int_mutex);
 	return ret;
 }
 
@@ -4943,9 +4944,9 @@ static long osst_ioctl(struct file * file,
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&osst_int_mutex);
 	if (mutex_lock_interruptible(&STp->lock)) {
-		unlock_kernel();
+		mutex_unlock(&osst_int_mutex);
 		return -ERESTARTSYS;
 	}
 
@@ -5260,14 +5261,14 @@ static long osst_ioctl(struct file * file,
 	mutex_unlock(&STp->lock);
 
 	retval = scsi_ioctl(STp->device, cmd_in, p);
-	unlock_kernel();
+	mutex_unlock(&osst_int_mutex);
 	return retval;
 
 out:
 	if (SRpnt) osst_release_request(SRpnt);
 
 	mutex_unlock(&STp->lock);
-	unlock_kernel();
+	mutex_unlock(&osst_int_mutex);
 
 	return retval;
 }
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index a87e21c..0203446 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -22,7 +22,6 @@
 #include <linux/miscdevice.h>
 #include <linux/gfp.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -323,7 +322,6 @@ static int tgt_open(struct inode *inode, struct file *file)
 {
 	tx_ring.tr_idx = rx_ring.tr_idx = 0;
 
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index a4ec891..e4b9caa 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -15,11 +15,12 @@
   along with this driver.  If not, see <http://www.gnu.org/licenses/>.
 ***************************************************************************/
 
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include "crystalhd_lnx.h"
 
+static DEFINE_MUTEX(chd_dec_mutex);
 static struct class *crystalhd_class;
 
 static struct crystalhd_adp *g_adp_info;
@@ -279,16 +280,16 @@ static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 		return -ENODATA;
 	}
 
-	lock_kernel();
+	mutex_lock(&chd_dec_mutex);
 	cproc = crystalhd_get_cmd_proc(&adp->cmds, cmd, uc);
 	if (!cproc) {
 		BCMLOG_ERR("Unhandled command: %d\n", cmd);
-		unlock_kernel();
+		mutex_unlock(&chd_dec_mutex);
 		return -EINVAL;
 	}
 
 	ret = chd_dec_api_cmd(adp, ua, uc->uid, cmd, cproc);
-	unlock_kernel();
+	mutex_unlock(&chd_dec_mutex);
 	return ret;
 }
 
diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 40ef97f..bc9a3ee 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -63,7 +63,7 @@ extern void printques(int);
 #include <linux/types.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -78,6 +78,7 @@ extern void printques(int);
 MODULE_LICENSE("GPL");
 
 /* Error variable.  Zero means no error. */
+static DEFINE_MUTEX(dt3155_mutex);
 int dt3155_errno = 0;
 
 #ifndef PCI_DEVICE_ID_INTEL_7116
@@ -841,9 +842,9 @@ dt3155_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&dt3155_mutex);
 	ret = dt3155_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&dt3155_mutex);
 
 	return ret;
 }
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index bc16fc0..73a67a8 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -31,7 +31,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 
 #include <asm/io.h>
@@ -40,6 +40,7 @@
 #include "../vme.h"
 #include "vme_user.h"
 
+static DEFINE_MUTEX(vme_user_mutex);
 static char driver_name[] = "vme_user";
 
 static int bus[USER_BUS_MAX];
@@ -560,9 +561,9 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&vme_user_mutex);
 	ret = vme_user_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&vme_user_mutex);
 
 	return ret;
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
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 43abf55..f6465d2 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -25,7 +25,7 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/timer.h>
@@ -70,6 +70,7 @@
 #define DRIVER_DESC		"Printer Gadget"
 #define DRIVER_VERSION		"2007 OCT 06"
 
+static DEFINE_MUTEX(printer_mutex);
 static const char shortname [] = "printer";
 static const char driver_desc [] = DRIVER_DESC;
 
@@ -476,7 +477,7 @@ printer_open(struct inode *inode, struct file *fd)
 	unsigned long		flags;
 	int			ret = -EBUSY;
 
-	lock_kernel();
+	mutex_lock(&printer_mutex);
 	dev = container_of(inode->i_cdev, struct printer_dev, printer_cdev);
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -492,7 +493,7 @@ printer_open(struct inode *inode, struct file *fd)
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	DBG(dev, "printer_open returned %x\n", ret);
-	unlock_kernel();
+	mutex_unlock(&printer_mutex);
 	return ret;
 }
 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 7dc9d3c..8296645 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/usb/iowarrior.h>
 
@@ -61,6 +61,7 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 /* Module parameters */
+static DEFINE_MUTEX(iowarrior_mutex);
 static int debug = 0;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "debug=1 enables debugging messages");
@@ -493,7 +494,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 		return -ENOMEM;
 
 	/* lock this object */
-	lock_kernel();
+	mutex_lock(&iowarrior_mutex);
 	mutex_lock(&dev->mutex);
 
 	/* verify that the device wasn't unplugged */
@@ -585,7 +586,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 error_out:
 	/* unlock the device */
 	mutex_unlock(&dev->mutex);
-	unlock_kernel();
+	mutex_unlock(&iowarrior_mutex);
 	kfree(buffer);
 	return retval;
 }
@@ -602,12 +603,12 @@ static int iowarrior_open(struct inode *inode, struct file *file)
 
 	dbg("%s", __func__);
 
-	lock_kernel();
+	mutex_lock(&iowarrior_mutex);
 	subminor = iminor(inode);
 
 	interface = usb_find_interface(&iowarrior_driver, subminor);
 	if (!interface) {
-		unlock_kernel();
+		mutex_unlock(&iowarrior_mutex);
 		err("%s - error, can't find device for minor %d", __func__,
 		    subminor);
 		return -ENODEV;
@@ -617,7 +618,7 @@ static int iowarrior_open(struct inode *inode, struct file *file)
 	dev = usb_get_intfdata(interface);
 	if (!dev) {
 		mutex_unlock(&iowarrior_open_disc_lock);
-		unlock_kernel();
+		mutex_unlock(&iowarrior_mutex);
 		return -ENODEV;
 	}
 
@@ -644,7 +645,7 @@ static int iowarrior_open(struct inode *inode, struct file *file)
 
 out:
 	mutex_unlock(&dev->mutex);
-	unlock_kernel();
+	mutex_unlock(&iowarrior_mutex);
 	return retval;
 }
 
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index a85771b..cc13ae6 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -32,7 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/errno.h>
 #include <linux/random.h>
 #include <linux/poll.h>
@@ -72,6 +72,7 @@ struct rio_usb_data {
 	struct mutex lock;          /* general race avoidance */
 };
 
+static DEFINE_MUTEX(rio500_mutex);
 static struct rio_usb_data rio_instance;
 
 static int open_rio(struct inode *inode, struct file *file)
@@ -79,12 +80,12 @@ static int open_rio(struct inode *inode, struct file *file)
 	struct rio_usb_data *rio = &rio_instance;
 
 	/* against disconnect() */
-	lock_kernel();
+	mutex_lock(&rio500_mutex);
 	mutex_lock(&(rio->lock));
 
 	if (rio->isopen || !rio->present) {
 		mutex_unlock(&(rio->lock));
-		unlock_kernel();
+		mutex_unlock(&rio500_mutex);
 		return -EBUSY;
 	}
 	rio->isopen = 1;
@@ -94,7 +95,7 @@ static int open_rio(struct inode *inode, struct file *file)
 	mutex_unlock(&(rio->lock));
 
 	dev_info(&rio->rio_dev->dev, "Rio opened.\n");
-	unlock_kernel();
+	mutex_unlock(&rio500_mutex);
 
 	return 0;
 }
@@ -491,7 +492,7 @@ static void disconnect_rio(struct usb_interface *intf)
 	struct rio_usb_data *rio = usb_get_intfdata (intf);
 
 	usb_set_intfdata (intf, NULL);
-	lock_kernel();
+	mutex_lock(&rio500_mutex);
 	if (rio) {
 		usb_deregister_dev(intf, &usb_rio_class);
 
@@ -501,7 +502,7 @@ static void disconnect_rio(struct usb_interface *intf)
 			/* better let it finish - the release will do whats needed */
 			rio->rio_dev = NULL;
 			mutex_unlock(&(rio->lock));
-			unlock_kernel();
+			mutex_unlock(&rio500_mutex);
 			return;
 		}
 		kfree(rio->ibuf);
@@ -512,7 +513,7 @@ static void disconnect_rio(struct usb_interface *intf)
 		rio->present = 0;
 		mutex_unlock(&(rio->lock));
 	}
-	unlock_kernel();
+	mutex_unlock(&rio500_mutex);
 }
 
 static const struct usb_device_id rio_table[] = {
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 7828c76..6ae39e3 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -30,6 +29,7 @@
 #define IOCTL_GET_DRV_VERSION	2
 
 
+static DEFINE_MUTEX(lcd_mutex);
 static const struct usb_device_id id_table[] = {
 	{ .idVendor = 0x10D2, .match_flags = USB_DEVICE_ID_MATCH_VENDOR, },
 	{ },
@@ -74,12 +74,12 @@ static int lcd_open(struct inode *inode, struct file *file)
 	struct usb_interface *interface;
 	int subminor, r;
 
-	lock_kernel();
+	mutex_lock(&lcd_mutex);
 	subminor = iminor(inode);
 
 	interface = usb_find_interface(&lcd_driver, subminor);
 	if (!interface) {
-		unlock_kernel();
+		mutex_unlock(&lcd_mutex);
 		err ("USBLCD: %s - error, can't find device for minor %d",
 		     __func__, subminor);
 		return -ENODEV;
@@ -89,7 +89,7 @@ static int lcd_open(struct inode *inode, struct file *file)
 	dev = usb_get_intfdata(interface);
 	if (!dev) {
 		mutex_unlock(&open_disc_mutex);
-		unlock_kernel();
+		mutex_unlock(&lcd_mutex);
 		return -ENODEV;
 	}
 
@@ -101,13 +101,13 @@ static int lcd_open(struct inode *inode, struct file *file)
 	r = usb_autopm_get_interface(interface);
 	if (r < 0) {
 		kref_put(&dev->kref, lcd_delete);
-		unlock_kernel();
+		mutex_unlock(&lcd_mutex);
 		return r;
 	}
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
-	unlock_kernel();
+	mutex_unlock(&lcd_mutex);
 
 	return 0;
 }
@@ -164,14 +164,14 @@ static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	
 	switch (cmd) {
 	case IOCTL_GET_HARD_VERSION:
-		lock_kernel();
+		mutex_lock(&lcd_mutex);
 		bcdDevice = le16_to_cpu((dev->udev)->descriptor.bcdDevice);
 		sprintf(buf,"%1d%1d.%1d%1d",
 			(bcdDevice & 0xF000)>>12,
 			(bcdDevice & 0xF00)>>8,
 			(bcdDevice & 0xF0)>>4,
 			(bcdDevice & 0xF));
-		unlock_kernel();
+		mutex_unlock(&lcd_mutex);
 		if (copy_to_user((void __user *)arg,buf,strlen(buf))!=0)
 			return -EFAULT;
 		break;
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index d62b9ce..ecd3981 100644
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
diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 258daa8..2bf2340 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -48,7 +48,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>	/* support for loadable modules */
 #include <linux/slab.h>		/* kmalloc(), kfree() */
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/string.h>	/* inline mem*, str* functions */
 
@@ -71,6 +71,7 @@
  *	WAN device IOCTL handlers
  */
 
+static DEFINE_MUTEX(wanrouter_mutex);
 static int wanrouter_device_setup(struct wan_device *wandev,
 				  wandev_conf_t __user *u_conf);
 static int wanrouter_device_stat(struct wan_device *wandev,
@@ -376,7 +377,7 @@ long wanrouter_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (wandev->magic != ROUTER_MAGIC)
 		return -EINVAL;
 
-	lock_kernel();
+	mutex_lock(&wanrouter_mutex);
 	switch (cmd) {
 	case ROUTER_SETUP:
 		err = wanrouter_device_setup(wandev, data);
@@ -408,7 +409,7 @@ long wanrouter_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			err = wandev->ioctl(wandev, cmd, arg);
 		else err = -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&wanrouter_mutex);
 	return err;
 }
 
diff --git a/net/wanrouter/wanproc.c b/net/wanrouter/wanproc.c
index c44d96b..11f25c7 100644
--- a/net/wanrouter/wanproc.c
+++ b/net/wanrouter/wanproc.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/wanrouter.h>	/* WAN router API definitions */
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <net/net_namespace.h>
 #include <asm/io.h>
@@ -66,6 +66,7 @@
  *	/proc/net/router
  */
 
+static DEFINE_MUTEX(config_mutex);
 static struct proc_dir_entry *proc_router;
 
 /* Strings */
@@ -85,7 +86,7 @@ static void *r_start(struct seq_file *m, loff_t *pos)
 	struct wan_device *wandev;
 	loff_t l = *pos;
 
-	lock_kernel();
+	mutex_lock(&config_mutex);
 	if (!l--)
 		return SEQ_START_TOKEN;
 	for (wandev = wanrouter_router_devlist; l-- && wandev;
@@ -104,7 +105,7 @@ static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 static void r_stop(struct seq_file *m, void *v)
 	__releases(kernel_lock)
 {
-	unlock_kernel();
+	mutex_unlock(&config_mutex);
 }
 
 static int config_show(struct seq_file *m, void *v)
-- 
1.7.0.4

