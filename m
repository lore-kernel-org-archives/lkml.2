Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0DZSLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:11:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab0DZSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:11:10 -0400
Date: Mon, 26 Apr 2010 11:08:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <201004261030.21751.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <20100425173912.GA5375@nowhere> <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org> <201004261030.21751.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Apr 2010, Arnd Bergmann wrote:
> 
> We could also stop playing games with with this and just kill the
> locked variant of ioctl right away. No rename to bkl_ioctl, no
> helper functions.

I wouldn't mind that. But we've not found people to do it so far, so...

Anyway, I spent some time automating the ioctl -> bkl_ioctl conversion. 
The following is the end result. Comments?

Regardless of _what_ we do, renaming 'ioctl' to 'bkl_ioctl' is a good 
thing. It means that we can reliably grep for these usages, whether it is 
then to later introduce a CONFIG_BKL or if it is to get rid of the 
bkl_ioctl entirely.

NOTE! This has gone through a "allmodconfig" (with staging drivers), but 
only on x86-64. There are quite probably missing architecture conversions
and/or drivers. But this should be the bulk of them.

It doesn't look that bad. Just about 100 files affected. 

		Linus
---
commit 5312f12ed68dd43acca09ce646fdce3896a292bb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Apr 26 10:55:23 2010 -0700

    Rename 'struct file_operations' 'ioctl' fn pointer to 'bkl_ioctl'
    
    This makes it much easier to grep for the use of implicit BKL usage in
    the traditional 'ioctl' function pointer.
    
    The patch was mostly auto-generated with the following shell scripting:
    
    	# Create an approximate file list of ioctl initializers
    	git grep -w -20 file_operations |
    		grep '\.ioctl[ 	]*=' |
    		sed 's/-[        ]*\.ioctl.*$//' |
    		sort -u > f
    
    	# Run a sed script to replace 'ioctl' with 'bkl_ioctl'
    	cat f | while read i; do
    		j="$i.sed"
    		sed 's/\.ioctl([      ]*)=/.bkl_ioctl\1=/' < $i > $j
    		mv $j $i
    	done
    
    followed by some similarly trivial scripting to then mostly fix up
    places that tried to align all the initializers with tabs or spaces.
    
    Finally, some manual fixup, and testing of the end result with a
    allmodconfig make (with 'staging' drivers explicitly enabled).
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/cris/arch-v10/drivers/ds1302.c         |    2 +-
 arch/cris/arch-v10/drivers/gpio.c           |    2 +-
 arch/cris/arch-v10/drivers/i2c.c            |    2 +-
 arch/cris/arch-v10/drivers/pcf8563.c        |    2 +-
 arch/cris/arch-v10/drivers/sync_serial.c    |    2 +-
 arch/cris/arch-v32/drivers/cryptocop.c      |    2 +-
 arch/cris/arch-v32/drivers/i2c.c            |    2 +-
 arch/cris/arch-v32/drivers/mach-a3/gpio.c   |    2 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c   |    2 +-
 arch/cris/arch-v32/drivers/pcf8563.c        |    2 +-
 arch/cris/arch-v32/drivers/sync_serial.c    |    2 +-
 arch/ia64/kernel/perfmon.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c         |    2 +-
 arch/m68k/bvme6000/rtc.c                    |    2 +-
 arch/m68k/mvme16x/rtc.c                     |    2 +-
 arch/um/drivers/harddog_kern.c              |    2 +-
 arch/um/drivers/hostaudio_kern.c            |    4 ++--
 arch/um/drivers/mmapper_kern.c              |    2 +-
 drivers/block/pktcdvd.c                     |    2 +-
 drivers/char/apm-emulation.c                |    2 +-
 drivers/char/applicom.c                     |    2 +-
 drivers/char/ds1620.c                       |    2 +-
 drivers/char/dtlk.c                         |    2 +-
 drivers/char/generic_nvram.c                |    2 +-
 drivers/char/genrtc.c                       |    2 +-
 drivers/char/hpet.c                         |    2 +-
 drivers/char/i8k.c                          |    2 +-
 drivers/char/ipmi/ipmi_devintf.c            |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c           |    2 +-
 drivers/char/nvram.c                        |    2 +-
 drivers/char/nwflash.c                      |    2 +-
 drivers/char/raw.c                          |    4 ++--
 drivers/hwmon/fschmd.c                      |    2 +-
 drivers/hwmon/w83793.c                      |    2 +-
 drivers/input/misc/hp_sdc_rtc.c             |    2 +-
 drivers/isdn/capi/capi.c                    |    2 +-
 drivers/isdn/divert/divert_procfs.c         |    2 +-
 drivers/isdn/i4l/isdn_common.c              |    2 +-
 drivers/isdn/mISDN/timerdev.c               |    2 +-
 drivers/macintosh/nvram.c                   |    2 +-
 drivers/macintosh/via-pmu.c                 |    2 +-
 drivers/media/dvb/dvb-core/dmxdev.c         |    4 ++--
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c   |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c        |    2 +-
 drivers/media/dvb/firewire/firedtv-ci.c     |    2 +-
 drivers/media/dvb/ttpci/av7110.c            |    2 +-
 drivers/media/dvb/ttpci/av7110_av.c         |    4 ++--
 drivers/media/dvb/ttpci/av7110_ca.c         |    2 +-
 drivers/media/video/v4l2-compat-ioctl32.c   |    6 +++---
 drivers/media/video/v4l2-dev.c              |    2 +-
 drivers/mtd/mtdchar.c                       |    2 +-
 drivers/pcmcia/pcmcia_ioctl.c               |    2 +-
 drivers/rtc/rtc-m41t80.c                    |    2 +-
 drivers/sbus/char/openprom.c                |    2 +-
 drivers/scsi/3w-9xxx.c                      |    2 +-
 drivers/scsi/3w-sas.c                       |    2 +-
 drivers/scsi/3w-xxxx.c                      |    2 +-
 drivers/scsi/aacraid/linit.c                |    2 +-
 drivers/scsi/dpt_i2o.c                      |    2 +-
 drivers/scsi/gdth.c                         |    2 +-
 drivers/scsi/megaraid.c                     |    2 +-
 drivers/scsi/megaraid/megaraid_mm.c         |    2 +-
 drivers/scsi/osst.c                         |    2 +-
 drivers/scsi/sg.c                           |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c   |    2 +-
 drivers/staging/dt3155/dt3155_drv.c         |    4 ++--
 drivers/staging/poch/poch.c                 |    2 +-
 drivers/staging/vme/devices/vme_user.c      |    2 +-
 drivers/usb/mon/mon_bin.c                   |    2 +-
 drivers/usb/mon/mon_stat.c                  |    2 +-
 fs/autofs/root.c                            |    2 +-
 fs/autofs4/root.c                           |    2 +-
 fs/bad_inode.c                              |    2 +-
 fs/coda/pioctl.c                            |    2 +-
 fs/coda/psdev.c                             |    2 +-
 fs/compat_ioctl.c                           |    2 +-
 fs/ecryptfs/file.c                          |    9 +++++----
 fs/fat/dir.c                                |    2 +-
 fs/fat/file.c                               |    2 +-
 fs/hfsplus/dir.c                            |    2 +-
 fs/hfsplus/inode.c                          |    2 +-
 fs/ioctl.c                                  |    4 ++--
 fs/logfs/dir.c                              |    2 +-
 fs/logfs/file.c                             |    2 +-
 fs/ncpfs/dir.c                              |    2 +-
 fs/ncpfs/file.c                             |    2 +-
 fs/ntfs/dir.c                               |    2 +-
 fs/ntfs/file.c                              |    2 +-
 fs/proc/inode.c                             |    8 ++++----
 fs/smbfs/dir.c                              |    2 +-
 fs/smbfs/file.c                             |    2 +-
 fs/udf/dir.c                                |    2 +-
 fs/udf/file.c                               |    2 +-
 include/linux/fs.h                          |    2 +-
 net/sunrpc/cache.c                          |    4 ++--
 net/sunrpc/rpc_pipe.c                       |    2 +-
 sound/oss/dmasound/dmasound_core.c          |    4 ++--
 sound/oss/msnd_pinnacle.c                   |    2 +-
 sound/oss/sh_dac_audio.c                    |    2 +-
 sound/oss/swarm_cs4297a.c                   |    4 ++--
 sound/oss/vwsnd.c                           |    4 ++--
 102 files changed, 121 insertions(+), 120 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 77630df..a921861 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -376,7 +376,7 @@ print_rtc_status(void)
 
 static const struct file_operations rtc_fops = {
 	.owner =	THIS_MODULE,
-	.ioctl =	rtc_ioctl,
+	.bkl_ioctl =	rtc_ioctl,
 }; 
 
 /* Probe for the chip by writing something to its RAM and try reading it back. */
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 4b0f65f..54db6cb 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -715,7 +715,7 @@ gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 static const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
-	.ioctl       = gpio_ioctl,
+	.bkl_ioctl   = gpio_ioctl,
 	.write       = gpio_write,
 	.open        = gpio_open,
 	.release     = gpio_release,
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index a8737a8..2e7eb8a 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -619,7 +619,7 @@ i2c_ioctl(struct inode *inode, struct file *file,
 
 static const struct file_operations i2c_fops = {
 	.owner    = THIS_MODULE,
-	.ioctl    = i2c_ioctl,
+	.bkl_ioctl    = i2c_ioctl,
 	.open     = i2c_open,
 	.release  = i2c_release,
 };
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 1e90c1a..1a1f0f3 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -62,7 +62,7 @@ static int voltage_low;
 
 static const struct file_operations pcf8563_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = pcf8563_ioctl,
+	.bkl_ioctl = pcf8563_ioctl,
 };
 
 unsigned char
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 109dcd8..04e7339 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -248,7 +248,7 @@ static const struct file_operations sync_serial_fops = {
 	.write   = sync_serial_write,
 	.read    = sync_serial_read,
 	.poll    = sync_serial_poll,
-	.ioctl   = sync_serial_ioctl,
+	.bkl_ioctl   = sync_serial_ioctl,
 	.open    = sync_serial_open,
 	.release = sync_serial_release
 };
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b70fb34..9022dae 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -282,7 +282,7 @@ const struct file_operations cryptocop_fops = {
 	.owner =	THIS_MODULE,
 	.open =		cryptocop_open,
 	.release =	cryptocop_release,
-	.ioctl =	cryptocop_ioctl
+	.bkl_ioctl =	cryptocop_ioctl
 };
 
 
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 5068263..6cfe2cf 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -689,7 +689,7 @@ i2c_ioctl(struct inode *inode, struct file *file,
 
 static const struct file_operations i2c_fops = {
 	.owner =    THIS_MODULE,
-	.ioctl =    i2c_ioctl,
+	.bkl_ioctl =    i2c_ioctl,
 	.open =     i2c_open,
 	.release =  i2c_release,
 };
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index 97357cf..0031713 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -879,7 +879,7 @@ static int gpio_pwm_ioctl(struct gpio_private *priv, unsigned int cmd,
 static const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
-	.ioctl       = gpio_ioctl,
+	.bkl_ioctl   = gpio_ioctl,
 	.write       = gpio_write,
 	.open        = gpio_open,
 	.release     = gpio_release,
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index d89ab80..72ffbfa 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -858,7 +858,7 @@ gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 static const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
-	.ioctl       = gpio_ioctl,
+	.bkl_ioctl   = gpio_ioctl,
 	.write       = gpio_write,
 	.open        = gpio_open,
 	.release     = gpio_release,
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index f447850..223081a 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -58,7 +58,7 @@ static int voltage_low;
 
 static const struct file_operations pcf8563_fops = {
 	.owner =	THIS_MODULE,
-	.ioctl =	pcf8563_ioctl
+	.bkl_ioctl =	pcf8563_ioctl
 };
 
 unsigned char
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index 4889f19..8ce4f32 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -245,7 +245,7 @@ static const struct file_operations sync_serial_fops = {
 	.write   = sync_serial_write,
 	.read    = sync_serial_read,
 	.poll    = sync_serial_poll,
-	.ioctl   = sync_serial_ioctl,
+	.bkl_ioctl   = sync_serial_ioctl,
 	.open    = sync_serial_open,
 	.release = sync_serial_release
 };
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index ab985f7..0c4326c 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2178,7 +2178,7 @@ static const struct file_operations pfm_file_ops = {
 	.read     = pfm_read,
 	.write    = pfm_write,
 	.poll     = pfm_poll,
-	.ioctl    = pfm_ioctl,
+	.bkl_ioctl    = pfm_ioctl,
 	.open     = pfm_no_open,	/* special open code to disallow open via /proc */
 	.fasync   = pfm_fasync,
 	.release  = pfm_close,
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 55ac3c4..ffc65e1 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -864,7 +864,7 @@ error:
 }
 
 static const struct file_operations sn_hwperf_fops = {
-	.ioctl = sn_hwperf_ioctl,
+	.bkl_ioctl = sn_hwperf_ioctl,
 };
 
 static struct miscdevice sn_hwperf_dev = {
diff --git a/arch/m68k/bvme6000/rtc.c b/arch/m68k/bvme6000/rtc.c
index b46ea17..fb939c6 100644
--- a/arch/m68k/bvme6000/rtc.c
+++ b/arch/m68k/bvme6000/rtc.c
@@ -163,7 +163,7 @@ static int rtc_release(struct inode *inode, struct file *file)
  */
 
 static const struct file_operations rtc_fops = {
-	.ioctl =	rtc_ioctl,
+	.bkl_ioctl =	rtc_ioctl,
 	.open =		rtc_open,
 	.release =	rtc_release,
 };
diff --git a/arch/m68k/mvme16x/rtc.c b/arch/m68k/mvme16x/rtc.c
index 8da9c25..9cebd9f 100644
--- a/arch/m68k/mvme16x/rtc.c
+++ b/arch/m68k/mvme16x/rtc.c
@@ -150,7 +150,7 @@ static int rtc_release(struct inode *inode, struct file *file)
  */
 
 static const struct file_operations rtc_fops = {
-	.ioctl =	rtc_ioctl,
+	.bkl_ioctl =	rtc_ioctl,
 	.open =		rtc_open,
 	.release =	rtc_release,
 };
diff --git a/arch/um/drivers/harddog_kern.c b/arch/um/drivers/harddog_kern.c
index d332503..6cb24a1 100644
--- a/arch/um/drivers/harddog_kern.c
+++ b/arch/um/drivers/harddog_kern.c
@@ -151,7 +151,7 @@ static int harddog_ioctl(struct inode *inode, struct file *file,
 static const struct file_operations harddog_fops = {
 	.owner		= THIS_MODULE,
 	.write		= harddog_write,
-	.ioctl		= harddog_ioctl,
+	.bkl_ioctl	= harddog_ioctl,
 	.open		= harddog_open,
 	.release	= harddog_release,
 };
diff --git a/arch/um/drivers/hostaudio_kern.c b/arch/um/drivers/hostaudio_kern.c
index 368219c..cbc7366 100644
--- a/arch/um/drivers/hostaudio_kern.c
+++ b/arch/um/drivers/hostaudio_kern.c
@@ -289,7 +289,7 @@ static const struct file_operations hostaudio_fops = {
 	.read           = hostaudio_read,
 	.write          = hostaudio_write,
 	.poll           = hostaudio_poll,
-	.ioctl          = hostaudio_ioctl,
+	.bkl_ioctl      = hostaudio_ioctl,
 	.mmap           = NULL,
 	.open           = hostaudio_open,
 	.release        = hostaudio_release,
@@ -298,7 +298,7 @@ static const struct file_operations hostaudio_fops = {
 static const struct file_operations hostmixer_fops = {
 	.owner          = THIS_MODULE,
 	.llseek         = no_llseek,
-	.ioctl          = hostmixer_ioctl_mixdev,
+	.bkl_ioctl      = hostmixer_ioctl_mixdev,
 	.open           = hostmixer_open_mixdev,
 	.release        = hostmixer_release,
 };
diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index d22f9e5..50f7976 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -90,7 +90,7 @@ static const struct file_operations mmapper_fops = {
 	.owner		= THIS_MODULE,
 	.read		= mmapper_read,
 	.write		= mmapper_write,
-	.ioctl		= mmapper_ioctl,
+	.bkl_ioctl	= mmapper_ioctl,
 	.mmap		= mmapper_mmap,
 	.open		= mmapper_open,
 	.release	= mmapper_release,
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ddf1942..d0bb5c7 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -3023,7 +3023,7 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 
 
 static const struct file_operations pkt_ctl_fops = {
-	.ioctl	 = pkt_ctl_ioctl,
+	.bkl_ioctl	 = pkt_ctl_ioctl,
 	.owner	 = THIS_MODULE,
 };
 
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 4f568cb..a7d3df3 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -397,7 +397,7 @@ static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
-	.ioctl		= apm_ioctl,
+	.bkl_ioctl	= apm_ioctl,
 	.open		= apm_open,
 	.release	= apm_release,
 };
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index a7424bf..8a845bd 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -115,7 +115,7 @@ static const struct file_operations ac_fops = {
 	.llseek = no_llseek,
 	.read = ac_read,
 	.write = ac_write,
-	.ioctl = ac_ioctl,
+	.bkl_ioctl = ac_ioctl,
 };
 
 static struct miscdevice ac_miscdev = {
diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index 61f0146..de8f7ba 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -344,7 +344,7 @@ static const struct file_operations ds1620_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ds1620_open,
 	.read		= ds1620_read,
-	.ioctl		= ds1620_ioctl,
+	.bkl_ioctl	= ds1620_ioctl,
 };
 
 static struct miscdevice ds1620_miscdev = {
diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index 045c930..da15fb9 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -102,7 +102,7 @@ static const struct file_operations dtlk_fops =
 	.read		= dtlk_read,
 	.write		= dtlk_write,
 	.poll		= dtlk_poll,
-	.ioctl		= dtlk_ioctl,
+	.bkl_ioctl	= dtlk_ioctl,
 	.open		= dtlk_open,
 	.release	= dtlk_release,
 };
diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index fda4181..0947ad9 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -121,7 +121,7 @@ const struct file_operations nvram_fops = {
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
 	.write		= write_nvram,
-	.ioctl		= nvram_ioctl,
+	.bkl_ioctl	= nvram_ioctl,
 };
 
 static struct miscdevice nvram_dev = {
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 31e7c91..414ca68 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -482,7 +482,7 @@ static const struct file_operations gen_rtc_fops = {
 	.read		= gen_rtc_read,
 	.poll		= gen_rtc_poll,
 #endif
-	.ioctl		= gen_rtc_ioctl,
+	.bkl_ioctl	= gen_rtc_ioctl,
 	.open		= gen_rtc_open,
 	.release	= gen_rtc_release,
 };
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 9ded667..09c33d1 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -654,7 +654,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.bkl_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index fc8cf7a..2a211d5 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -91,7 +91,7 @@ static const struct file_operations i8k_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
-	.ioctl		= i8k_ioctl,
+	.bkl_ioctl	= i8k_ioctl,
 };
 
 struct smm_regs {
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 65545de..57b2990 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -826,7 +826,7 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 
 static const struct file_operations ipmi_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= ipmi_ioctl,
+	.bkl_ioctl	= ipmi_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = compat_ipmi_ioctl,
 #endif
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index a4d57e3..e8d478e 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -880,7 +880,7 @@ static const struct file_operations ipmi_wdog_fops = {
 	.read    = ipmi_read,
 	.poll    = ipmi_poll,
 	.write   = ipmi_write,
-	.ioctl   = ipmi_ioctl,
+	.bkl_ioctl   = ipmi_ioctl,
 	.open    = ipmi_open,
 	.release = ipmi_close,
 	.fasync  = ipmi_fasync,
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 47e8f7b..2688c4e 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -422,7 +422,7 @@ static const struct file_operations nvram_fops = {
 	.llseek		= nvram_llseek,
 	.read		= nvram_read,
 	.write		= nvram_write,
-	.ioctl		= nvram_ioctl,
+	.bkl_ioctl	= nvram_ioctl,
 	.open		= nvram_open,
 	.release	= nvram_release,
 };
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index f808109..636b9f8 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -631,7 +631,7 @@ static const struct file_operations flash_fops =
 	.llseek		= flash_llseek,
 	.read		= flash_read,
 	.write		= flash_write,
-	.ioctl		= flash_ioctl,
+	.bkl_ioctl	= flash_ioctl,
 };
 
 static struct miscdevice flash_miscdev =
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 8756ab0..e0ece78 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -251,12 +251,12 @@ static const struct file_operations raw_fops = {
 	.fsync	=	blkdev_fsync,
 	.open	=	raw_open,
 	.release=	raw_release,
-	.ioctl	=	raw_ioctl,
+	.bkl_ioctl =	raw_ioctl,
 	.owner	=	THIS_MODULE,
 };
 
 static const struct file_operations raw_ctl_fops = {
-	.ioctl	=	raw_ctl_ioctl,
+	.bkl_ioctl =	raw_ctl_ioctl,
 	.open	=	raw_open,
 	.owner	=	THIS_MODULE,
 };
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index 0627f7a..fa60ff2 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -924,7 +924,7 @@ static const struct file_operations watchdog_fops = {
 	.open = watchdog_open,
 	.release = watchdog_release,
 	.write = watchdog_write,
-	.ioctl = watchdog_ioctl,
+	.bkl_ioctl = watchdog_ioctl,
 };
 
 
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 612807d..6f63623 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1395,7 +1395,7 @@ static const struct file_operations watchdog_fops = {
 	.open = watchdog_open,
 	.release = watchdog_close,
 	.write = watchdog_write,
-	.ioctl = watchdog_ioctl,
+	.bkl_ioctl = watchdog_ioctl,
 };
 
 /*
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index ad730e1..0fdfd20 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -664,7 +664,7 @@ static const struct file_operations hp_sdc_rtc_fops = {
         .llseek =	no_llseek,
         .read =		hp_sdc_rtc_read,
         .poll =		hp_sdc_rtc_poll,
-        .ioctl =	hp_sdc_rtc_ioctl,
+        .bkl_ioctl =	hp_sdc_rtc_ioctl,
         .open =		hp_sdc_rtc_open,
         .fasync =	hp_sdc_rtc_fasync,
 };
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index ee58375..6bc9766 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1026,7 +1026,7 @@ static const struct file_operations capi_fops =
 	.read		= capi_read,
 	.write		= capi_write,
 	.poll		= capi_poll,
-	.ioctl		= capi_ioctl,
+	.bkl_ioctl	= capi_ioctl,
 	.open		= capi_open,
 	.release	= capi_release,
 };
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index 9f49d90..ae0244f 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -265,7 +265,7 @@ static const struct file_operations isdn_fops =
 	.read           = isdn_divert_read,
 	.write          = isdn_divert_write,
 	.poll           = isdn_divert_poll,
-	.ioctl          = isdn_divert_ioctl,
+	.bkl_ioctl      = isdn_divert_ioctl,
 	.open           = isdn_divert_open,
 	.release        = isdn_divert_close,                                      
 };
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 70044ee..08ba72d 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1838,7 +1838,7 @@ static const struct file_operations isdn_fops =
 	.read		= isdn_read,
 	.write		= isdn_write,
 	.poll		= isdn_poll,
-	.ioctl		= isdn_ioctl,
+	.bkl_ioctl	= isdn_ioctl,
 	.open		= isdn_open,
 	.release	= isdn_close,
 };
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 8785004..fc7d777 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -263,7 +263,7 @@ mISDN_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
 static const struct file_operations mISDN_fops = {
 	.read		= mISDN_read,
 	.poll		= mISDN_poll,
-	.ioctl		= mISDN_ioctl,
+	.bkl_ioctl	= mISDN_ioctl,
 	.open		= mISDN_open,
 	.release	= mISDN_close,
 };
diff --git a/drivers/macintosh/nvram.c b/drivers/macintosh/nvram.c
index c876349..6a3115f 100644
--- a/drivers/macintosh/nvram.c
+++ b/drivers/macintosh/nvram.c
@@ -100,7 +100,7 @@ const struct file_operations nvram_fops = {
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
 	.write		= write_nvram,
-	.ioctl		= nvram_ioctl,
+	.bkl_ioctl	= nvram_ioctl,
 };
 
 static struct miscdevice nvram_dev = {
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 4276484..1cac03c 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2341,7 +2341,7 @@ static const struct file_operations pmu_device_fops = {
 	.read		= pmu_read,
 	.write		= pmu_write,
 	.poll		= pmu_fpoll,
-	.ioctl		= pmu_ioctl,
+	.bkl_ioctl	= pmu_ioctl,
 	.open		= pmu_open,
 	.release	= pmu_release,
 };
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 9ddc579..a6c4f2f 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -1139,7 +1139,7 @@ static int dvb_demux_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_demux_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_demux_read,
-	.ioctl = dvb_demux_ioctl,
+	.bkl_ioctl = dvb_demux_ioctl,
 	.open = dvb_demux_open,
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
@@ -1208,7 +1208,7 @@ static const struct file_operations dvb_dvr_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_dvr_read,
 	.write = dvb_dvr_write,
-	.ioctl = dvb_dvr_ioctl,
+	.bkl_ioctl = dvb_dvr_ioctl,
 	.open = dvb_dvr_open,
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index cb22da5..4609c7e 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1611,7 +1611,7 @@ static const struct file_operations dvb_ca_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_ca_en50221_io_read,
 	.write = dvb_ca_en50221_io_write,
-	.ioctl = dvb_ca_en50221_io_ioctl,
+	.bkl_ioctl = dvb_ca_en50221_io_ioctl,
 	.open = dvb_ca_en50221_io_open,
 	.release = dvb_ca_en50221_io_release,
 	.poll = dvb_ca_en50221_io_poll,
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 55ea260..5ebf731 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -2022,7 +2022,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
+	.bkl_ioctl	= dvb_generic_ioctl,
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 441c064..7ae8ef1 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1459,7 +1459,7 @@ static int dvb_net_close(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_net_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = dvb_net_ioctl,
+	.bkl_ioctl = dvb_net_ioctl,
 	.open =	dvb_generic_open,
 	.release = dvb_net_close,
 };
diff --git a/drivers/media/dvb/firewire/firedtv-ci.c b/drivers/media/dvb/firewire/firedtv-ci.c
index 853e04b..9378618 100644
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -217,7 +217,7 @@ static unsigned int fdtv_ca_io_poll(struct file *file, poll_table *wait)
 
 static const struct file_operations fdtv_ca_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
+	.bkl_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
 	.release	= dvb_generic_release,
 	.poll		= fdtv_ca_io_poll,
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 3891559..0e606af 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -727,7 +727,7 @@ static int dvb_osd_ioctl(struct inode *inode, struct file *file,
 
 static const struct file_operations dvb_osd_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= dvb_generic_ioctl,
+	.bkl_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
 	.release	= dvb_generic_release,
 };
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 5388481..62d3b1f 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -1517,7 +1517,7 @@ static int dvb_audio_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_video_fops = {
 	.owner		= THIS_MODULE,
 	.write		= dvb_video_write,
-	.ioctl		= dvb_generic_ioctl,
+	.bkl_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_video_open,
 	.release	= dvb_video_release,
 	.poll		= dvb_video_poll,
@@ -1535,7 +1535,7 @@ static struct dvb_device dvbdev_video = {
 static const struct file_operations dvb_audio_fops = {
 	.owner		= THIS_MODULE,
 	.write		= dvb_audio_write,
-	.ioctl		= dvb_generic_ioctl,
+	.bkl_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_audio_open,
 	.release	= dvb_audio_release,
 	.poll		= dvb_audio_poll,
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index ac7779c..94e0668 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -350,7 +350,7 @@ static const struct file_operations dvb_ca_fops = {
 	.owner		= THIS_MODULE,
 	.read		= dvb_ca_read,
 	.write		= dvb_ca_write,
-	.ioctl		= dvb_generic_ioctl,
+	.bkl_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_ca_open,
 	.release	= dvb_generic_release,
 	.poll		= dvb_ca_poll,
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index f77f84b..befb4ea 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -228,9 +228,9 @@ static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	if (file->f_op->unlocked_ioctl)
 		ret = file->f_op->unlocked_ioctl(file, cmd, arg);
-	else if (file->f_op->ioctl) {
+	else if (file->f_op->bkl_ioctl) {
 		lock_kernel();
-		ret = file->f_op->ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		ret = file->f_op->bkl_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
 		unlock_kernel();
 	}
 
@@ -973,7 +973,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret = -ENOIOCTLCMD;
 
-	if (!file->f_op->ioctl && !file->f_op->unlocked_ioctl)
+	if (!file->f_op->bkl_ioctl && !file->f_op->unlocked_ioctl)
 		return ret;
 
 	switch (cmd) {
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 7090699..c48143a 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -330,7 +330,7 @@ static const struct file_operations v4l2_fops = {
 	.open = v4l2_open,
 	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
-	.ioctl = v4l2_ioctl,
+	.bkl_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
 #endif
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5b081cb..57b48c4 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -942,7 +942,7 @@ static const struct file_operations mtd_fops = {
 	.llseek		= mtd_lseek,
 	.read		= mtd_read,
 	.write		= mtd_write,
-	.ioctl		= mtd_ioctl,
+	.bkl_ioctl	= mtd_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= mtd_compat_ioctl,
 #endif
diff --git a/drivers/pcmcia/pcmcia_ioctl.c b/drivers/pcmcia/pcmcia_ioctl.c
index 104e73d..ca84016 100644
--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ b/drivers/pcmcia/pcmcia_ioctl.c
@@ -1037,7 +1037,7 @@ static const struct file_operations ds_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ds_open,
 	.release	= ds_release,
-	.ioctl		= ds_ioctl,
+	.bkl_ioctl	= ds_ioctl,
 	.read		= ds_read,
 	.write		= ds_write,
 	.poll		= ds_poll,
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 60fe266..e662d61 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -736,7 +736,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 static const struct file_operations wdt_fops = {
 	.owner	= THIS_MODULE,
 	.read	= wdt_read,
-	.ioctl	= wdt_ioctl,
+	.bkl_ioctl = wdt_ioctl,
 	.write	= wdt_write,
 	.open	= wdt_open,
 	.release = wdt_release,
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index fc2f676..1fdc1a9 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -709,7 +709,7 @@ static int openprom_release(struct inode * inode, struct file * file)
 static const struct file_operations openprom_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.ioctl =	openprom_ioctl,
+	.bkl_ioctl =	openprom_ioctl,
 	.compat_ioctl =	openprom_compat_ioctl,
 	.open =		openprom_open,
 	.release =	openprom_release,
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e9788f5..32da0ef 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -218,7 +218,7 @@ static struct device_attribute *twa_host_attrs[] = {
 /* File operations struct for character device */
 static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= twa_chrdev_ioctl,
+	.bkl_ioctl	= twa_chrdev_ioctl,
 	.open		= twa_chrdev_open,
 	.release	= NULL
 };
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 54c5ffb..3cac9e4 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -884,7 +884,7 @@ out:
 /* File operations struct for character device */
 static const struct file_operations twl_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= twl_chrdev_ioctl,
+	.bkl_ioctl	= twl_chrdev_ioctl,
 	.open		= twl_chrdev_open,
 	.release	= NULL
 };
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 5faf903..2713dd5 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1051,7 +1051,7 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 /* File operations struct for character device */
 static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= tw_chrdev_ioctl,
+	.bkl_ioctl	= tw_chrdev_ioctl,
 	.open		= tw_chrdev_open,
 	.release	= NULL
 };
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index e9373a2..c2b037d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1029,7 +1029,7 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 
 static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= aac_cfg_ioctl,
+	.bkl_ioctl	= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = aac_compat_cfg_ioctl,
 #endif
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 0435d04..6ec5682 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -119,7 +119,7 @@ static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
 #endif
 
 static const struct file_operations adpt_fops = {
-	.ioctl		= adpt_ioctl,
+	.bkl_ioctl	= adpt_ioctl,
 	.open		= adpt_open,
 	.release	= adpt_close,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 35a4b30..69c1629 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -369,7 +369,7 @@ MODULE_LICENSE("GPL");
 
 /* ioctl interface */
 static const struct file_operations gdth_fops = {
-    .ioctl   = gdth_ioctl,
+    .bkl_ioctl   = gdth_ioctl,
     .open    = gdth_open,
     .release = gdth_close,
 };
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4bf7edc..49a3501 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -96,7 +96,7 @@ static struct mega_hbas mega_hbas[MAX_CONTROLLERS];
  */
 static const struct file_operations megadev_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= megadev_ioctl,
+	.bkl_ioctl	= megadev_ioctl,
 	.open		= megadev_open,
 };
 
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 36e0b7d..9bd7787 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -70,7 +70,7 @@ static wait_queue_head_t wait_q;
 
 static const struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
-	.ioctl	= mraid_mm_ioctl,
+	.bkl_ioctl = mraid_mm_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = mraid_mm_compat_ioctl,
 #endif
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index b219118..a1a78bb 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5613,7 +5613,7 @@ static const struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
 	.write =        osst_write,
-	.ioctl =        osst_ioctl,
+	.bkl_ioctl =        osst_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = osst_compat_ioctl,
 #endif
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dee1c96..93d043e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1322,7 +1322,7 @@ static const struct file_operations sg_fops = {
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.ioctl = sg_ioctl,
+	.bkl_ioctl = sg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 54bad65..3d6b773 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -345,7 +345,7 @@ static int chd_dec_close(struct inode *in, struct file *fd)
 
 static const struct file_operations chd_dec_fops = {
 	.owner   = THIS_MODULE,
-	.ioctl   = chd_dec_ioctl,
+	.bkl_ioctl   = chd_dec_ioctl,
 	.open    = chd_dec_open,
 	.release = chd_dec_close,
 };
diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index e2c44ec..09fb197 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -843,9 +843,9 @@ static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
  *****************************************************/
 static struct file_operations dt3155_fops = {
   read:		dt3155_read,
-  ioctl:		dt3155_ioctl,
+  bkl_ioctl:	dt3155_ioctl,
   mmap:		dt3155_mmap,
-  poll:           dt3155_poll,
+  poll:         dt3155_poll,
   open:		dt3155_open,
   release:	dt3155_close
 };
diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index f940a34..edc8c58 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -1037,7 +1037,7 @@ static struct file_operations poch_fops = {
 	.owner = THIS_MODULE,
 	.open = poch_open,
 	.release = poch_release,
-	.ioctl = poch_ioctl,
+	.bkl_ioctl = poch_ioctl,
 	.poll = poch_poll,
 	.mmap = poch_mmap
 };
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 1ab9a98..7ba7149 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -142,7 +142,7 @@ static struct file_operations vme_user_fops = {
         .read = vme_user_read,
         .write = vme_user_write,
         .llseek = vme_user_llseek,
-        .ioctl = vme_user_ioctl,
+        .bkl_ioctl = vme_user_ioctl,
 };
 
 
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index ddf7f9a..9ce7c74 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1239,7 +1239,7 @@ static const struct file_operations mon_fops_binary = {
 	.read =		mon_bin_read,
 	/* .write =	mon_text_write, */
 	.poll =		mon_bin_poll,
-	.ioctl =	mon_bin_ioctl,
+	.bkl_ioctl =	mon_bin_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
diff --git a/drivers/usb/mon/mon_stat.c b/drivers/usb/mon/mon_stat.c
index 1becdc3..091e7fb 100644
--- a/drivers/usb/mon/mon_stat.c
+++ b/drivers/usb/mon/mon_stat.c
@@ -63,6 +63,6 @@ const struct file_operations mon_fops_stat = {
 	.read =		mon_stat_read,
 	/* .write =	mon_stat_write, */
 	/* .poll =		mon_stat_poll, */
-	/* .ioctl =	mon_stat_ioctl, */
+	/* .bkl_ioctl =	mon_stat_ioctl, */
 	.release =	mon_stat_release,
 };
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 8713c7c..b838f68 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -30,7 +30,7 @@ static int autofs_root_ioctl(struct inode *, struct file *,unsigned int,unsigned
 const struct file_operations autofs_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
-	.ioctl		= autofs_root_ioctl,
+	.bkl_ioctl	= autofs_root_ioctl,
 };
 
 const struct inode_operations autofs_root_inode_operations = {
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 109a6c6..e764eb1 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -38,7 +38,7 @@ const struct file_operations autofs4_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
-	.ioctl		= autofs4_root_ioctl,
+	.bkl_ioctl	= autofs4_root_ioctl,
 };
 
 const struct file_operations autofs4_dir_operations = {
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index a05287a..3fd4ada 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -160,7 +160,7 @@ static const struct file_operations bad_file_ops =
 	.aio_write	= bad_file_aio_write,
 	.readdir	= bad_file_readdir,
 	.poll		= bad_file_poll,
-	.ioctl		= bad_file_ioctl,
+	.bkl_ioctl	= bad_file_ioctl,
 	.unlocked_ioctl	= bad_file_unlocked_ioctl,
 	.compat_ioctl	= bad_file_compat_ioctl,
 	.mmap		= bad_file_mmap,
diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index 773f2ce..72184f0 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -37,7 +37,7 @@ const struct inode_operations coda_ioctl_inode_operations =
 
 const struct file_operations coda_ioctl_operations = {
 	.owner		= THIS_MODULE,
-	.ioctl		= coda_pioctl,
+	.bkl_ioctl	= coda_pioctl,
 };
 
 /* the coda pioctl inode ops */
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index be4392c..70a98a8 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -344,7 +344,7 @@ static const struct file_operations coda_psdev_fops = {
 	.read		= coda_psdev_read,
 	.write		= coda_psdev_write,
 	.poll		= coda_psdev_poll,
-	.ioctl		= coda_psdev_ioctl,
+	.bkl_ioctl	= coda_psdev_ioctl,
 	.open		= coda_psdev_open,
 	.release	= coda_psdev_release,
 };
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c32a1b6..3561d04 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1733,7 +1733,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 		}
 
 		if (!filp->f_op ||
-		    (!filp->f_op->ioctl && !filp->f_op->unlocked_ioctl))
+		    (!filp->f_op->bkl_ioctl && !filp->f_op->unlocked_ioctl))
 			goto do_ioctl;
 		break;
 	}
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index e7440a6..a5fa728 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -299,7 +299,7 @@ static int ecryptfs_ioctl(struct inode *inode, struct file *file,
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.bkl_ioctl = ecryptfs_ioctl,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
 	.release = ecryptfs_release,
@@ -315,7 +315,7 @@ const struct file_operations ecryptfs_main_fops = {
 	.write = do_sync_write,
 	.aio_write = generic_file_aio_write,
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.bkl_ioctl = ecryptfs_ioctl,
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -334,8 +334,9 @@ ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 	if (ecryptfs_file_to_private(file))
 		lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file && lower_file->f_op && lower_file->f_op->ioctl)
-		rc = lower_file->f_op->ioctl(ecryptfs_inode_to_lower(inode),
+	/* This is some seriously buggy crap. What about the non-BKL ioctl? */
+	if (lower_file && lower_file->f_op && lower_file->f_op->bkl_ioctl)
+		rc = lower_file->f_op->bkl_ioctl(ecryptfs_inode_to_lower(inode),
 					     lower_file, cmd, arg);
 	else
 		rc = -ENOTTY;
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 530b4ca..f5473d4 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -836,7 +836,7 @@ const struct file_operations fat_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= fat_readdir,
-	.ioctl		= fat_dir_ioctl,
+	.bkl_ioctl	= fat_dir_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= fat_compat_dir_ioctl,
 #endif
diff --git a/fs/fat/file.c b/fs/fat/file.c
index e8c159d..1ddabe7 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -159,7 +159,7 @@ const struct file_operations fat_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.release	= fat_file_release,
-	.ioctl		= fat_generic_ioctl,
+	.bkl_ioctl	= fat_generic_ioctl,
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
 };
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 5f40236..d30ab33 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -494,7 +494,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
 const struct file_operations hfsplus_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= hfsplus_readdir,
-	.ioctl          = hfsplus_ioctl,
+	.bkl_ioctl      = hfsplus_ioctl,
 	.llseek		= generic_file_llseek,
 	.release	= hfsplus_dir_release,
 };
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1bcf597..c0a5c46 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -285,7 +285,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.fsync		= file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-	.ioctl          = hfsplus_ioctl,
+	.bkl_ioctl      = hfsplus_ioctl,
 };
 
 struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 7faefb4..921f727 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -47,9 +47,9 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 		if (error == -ENOIOCTLCMD)
 			error = -EINVAL;
 		goto out;
-	} else if (filp->f_op->ioctl) {
+	} else if (filp->f_op->bkl_ioctl) {
 		lock_kernel();
-		error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
+		error = filp->f_op->bkl_ioctl(filp->f_path.dentry->d_inode,
 					  filp, cmd, arg);
 		unlock_kernel();
 	}
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 2396a85..02e7719 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -821,7 +821,7 @@ const struct inode_operations logfs_dir_iops = {
 };
 const struct file_operations logfs_dir_fops = {
 	.fsync		= logfs_fsync,
-	.ioctl		= logfs_ioctl,
+	.bkl_ioctl	= logfs_ioctl,
 	.readdir	= logfs_readdir,
 	.read		= generic_read_dir,
 };
diff --git a/fs/logfs/file.c b/fs/logfs/file.c
index 370f367..4618614 100644
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@ -243,7 +243,7 @@ const struct file_operations logfs_reg_fops = {
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= logfs_fsync,
-	.ioctl		= logfs_ioctl,
+	.bkl_ioctl	= logfs_ioctl,
 	.llseek		= generic_file_llseek,
 	.mmap		= generic_file_readonly_mmap,
 	.open		= generic_file_open,
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 7edfcd4..ba898f9 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -51,7 +51,7 @@ const struct file_operations ncp_dir_operations =
 {
 	.read		= generic_read_dir,
 	.readdir	= ncp_readdir,
-	.ioctl		= ncp_ioctl,
+	.bkl_ioctl	= ncp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ncp_compat_ioctl,
 #endif
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 1daabb9..1138914 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -295,7 +295,7 @@ const struct file_operations ncp_file_operations =
 	.llseek 	= ncp_remote_llseek,
 	.read		= ncp_file_read,
 	.write		= ncp_file_write,
-	.ioctl		= ncp_ioctl,
+	.bkl_ioctl	= ncp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ncp_compat_ioctl,
 #endif
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index fe44d3f..8cf00ab 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1570,7 +1570,7 @@ const struct file_operations ntfs_dir_ops = {
 	/*.aio_fsync	= ,*/			/* Sync all outstanding async
 						   i/o operations on a kiocb. */
 #endif /* NTFS_RW */
-	/*.ioctl	= ,*/			/* Perform function on the
+	/*.bkl_ioctl = ,*/			/* Perform function on the
 						   mounted filesystem. */
 	.open		= ntfs_dir_open,	/* Open directory. */
 };
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 8804f09..50a7f6d 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2221,7 +2221,7 @@ const struct file_operations ntfs_file_ops = {
 						    i/o operations on a
 						    kiocb. */
 #endif /* NTFS_RW */
-	/*.ioctl	= ,*/			 /* Perform function on the
+	/*.bkl_ioctl = ,*/			 /* Perform function on the
 						    mounted filesystem. */
 	.mmap		= generic_file_mmap,	 /* Mmap file. */
 	.open		= ntfs_file_open,	 /* Open file. */
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index d35b232..8e8f813 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -215,7 +215,7 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
 	long (*unlocked_ioctl)(struct file *, unsigned int, unsigned long);
-	int (*ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
+	int (*bkl_ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
 
 	spin_lock(&pde->pde_unload_lock);
 	if (!pde->proc_fops) {
@@ -224,16 +224,16 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 	}
 	pde->pde_users++;
 	unlocked_ioctl = pde->proc_fops->unlocked_ioctl;
-	ioctl = pde->proc_fops->ioctl;
+	bkl_ioctl = pde->proc_fops->bkl_ioctl;
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (unlocked_ioctl) {
 		rv = unlocked_ioctl(file, cmd, arg);
 		if (rv == -ENOIOCTLCMD)
 			rv = -EINVAL;
-	} else if (ioctl) {
+	} else if (bkl_ioctl) {
 		lock_kernel();
-		rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		rv = bkl_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
 		unlock_kernel();
 	}
 
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 3e4803b..a2eac18 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -39,7 +39,7 @@ const struct file_operations smb_dir_operations =
 {
 	.read		= generic_read_dir,
 	.readdir	= smb_readdir,
-	.ioctl		= smb_ioctl,
+	.bkl_ioctl	= smb_ioctl,
 	.open		= smb_dir_open,
 };
 
diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
index dbf6548..dbdb834 100644
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -437,7 +437,7 @@ const struct file_operations smb_file_operations =
 	.aio_read	= smb_file_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= smb_file_aio_write,
-	.ioctl		= smb_ioctl,
+	.bkl_ioctl	= smb_ioctl,
 	.mmap		= smb_file_mmap,
 	.open		= smb_file_open,
 	.release	= smb_file_release,
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index f0f2a43..d4f8f0c 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -209,6 +209,6 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.readdir		= udf_readdir,
-	.ioctl			= udf_ioctl,
+	.bkl_ioctl			= udf_ioctl,
 	.fsync			= simple_fsync,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 4b6a46c..443066b 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -207,7 +207,7 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 const struct file_operations udf_file_operations = {
 	.read			= do_sync_read,
 	.aio_read		= generic_file_aio_read,
-	.ioctl			= udf_ioctl,
+	.bkl_ioctl			= udf_ioctl,
 	.open			= dquot_file_open,
 	.mmap			= generic_file_mmap,
 	.write			= do_sync_write,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..1a82f78 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1491,7 +1491,7 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
+	int (*bkl_ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 39bddba..278deab 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1359,7 +1359,7 @@ static const struct file_operations cache_file_operations_procfs = {
 	.read		= cache_read_procfs,
 	.write		= cache_write_procfs,
 	.poll		= cache_poll_procfs,
-	.ioctl		= cache_ioctl_procfs, /* for FIONREAD */
+	.bkl_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
 	.open		= cache_open_procfs,
 	.release	= cache_release_procfs,
 };
@@ -1553,7 +1553,7 @@ const struct file_operations cache_file_operations_pipefs = {
 	.read		= cache_read_pipefs,
 	.write		= cache_write_pipefs,
 	.poll		= cache_poll_pipefs,
-	.ioctl		= cache_ioctl_pipefs, /* for FIONREAD */
+	.bkl_ioctl	= cache_ioctl_pipefs, /* for FIONREAD */
 	.open		= cache_open_pipefs,
 	.release	= cache_release_pipefs,
 };
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 20e30c6..b6dd719 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -337,7 +337,7 @@ static const struct file_operations rpc_pipe_fops = {
 	.read		= rpc_pipe_read,
 	.write		= rpc_pipe_write,
 	.poll		= rpc_pipe_poll,
-	.ioctl		= rpc_pipe_ioctl,
+	.bkl_ioctl	= rpc_pipe_ioctl,
 	.open		= rpc_pipe_open,
 	.release	= rpc_pipe_release,
 };
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index 3f3c3f7..3c43220 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -366,7 +366,7 @@ static const struct file_operations mixer_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= mixer_ioctl,
+	.bkl_ioctl	= mixer_ioctl,
 	.open		= mixer_open,
 	.release	= mixer_release,
 };
@@ -1125,7 +1125,7 @@ static const struct file_operations sq_fops =
 	.llseek		= no_llseek,
 	.write		= sq_write,
 	.poll		= sq_poll,
-	.ioctl		= sq_ioctl,
+	.bkl_ioctl	= sq_ioctl,
 	.open		= sq_open,
 	.release	= sq_release,
 };
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index a1e3f96..0070ddc 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1105,7 +1105,7 @@ static const struct file_operations dev_fileops = {
 	.owner		= THIS_MODULE,
 	.read		= dev_read,
 	.write		= dev_write,
-	.ioctl		= dev_ioctl,
+	.bkl_ioctl	= dev_ioctl,
 	.open		= dev_open,
 	.release	= dev_release,
 };
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index 4153752..c21d1da 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -238,7 +238,7 @@ static int dac_audio_release(struct inode *inode, struct file *file)
 const struct file_operations dac_audio_fops = {
       .read =		dac_audio_read,
       .write =	dac_audio_write,
-      .ioctl =	dac_audio_ioctl,
+      .bkl_ioctl =	dac_audio_ioctl,
       .open =		dac_audio_open,
       .release =	dac_audio_release,
 };
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 3136c88..57006ae 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -1580,7 +1580,7 @@ static int cs4297a_ioctl_mixdev(struct inode *inode, struct file *file,
 static const struct file_operations cs4297a_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= cs4297a_ioctl_mixdev,
+	.bkl_ioctl	= cs4297a_ioctl_mixdev,
 	.open		= cs4297a_open_mixdev,
 	.release	= cs4297a_release_mixdev,
 };
@@ -2496,7 +2496,7 @@ static const struct file_operations cs4297a_audio_fops = {
 	.read		= cs4297a_read,
 	.write		= cs4297a_write,
 	.poll		= cs4297a_poll,
-	.ioctl		= cs4297a_ioctl,
+	.bkl_ioctl	= cs4297a_ioctl,
 	.mmap		= cs4297a_mmap,
 	.open		= cs4297a_open,
 	.release	= cs4297a_release,
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 20b3b32..300720c 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -3044,7 +3044,7 @@ static const struct file_operations vwsnd_audio_fops = {
 	.read =		vwsnd_audio_read,
 	.write =	vwsnd_audio_write,
 	.poll =		vwsnd_audio_poll,
-	.ioctl =	vwsnd_audio_ioctl,
+	.bkl_ioctl =	vwsnd_audio_ioctl,
 	.mmap =		vwsnd_audio_mmap,
 	.open =		vwsnd_audio_open,
 	.release =	vwsnd_audio_release,
@@ -3231,7 +3231,7 @@ static int vwsnd_mixer_ioctl(struct inode *ioctl,
 static const struct file_operations vwsnd_mixer_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.ioctl =	vwsnd_mixer_ioctl,
+	.bkl_ioctl =	vwsnd_mixer_ioctl,
 	.open =		vwsnd_mixer_open,
 	.release =	vwsnd_mixer_release,
 };
