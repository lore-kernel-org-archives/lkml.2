Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab0GGVlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:41:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab0GGVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:41:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Julia Lawall <julia@diku.dk>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/18] llseek: automatically add .llseek fop
Date: Wed,  7 Jul 2010 23:40:18 +0200
Message-Id: <1278538820-1392-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:LXliWOJQRHX/BMVEbCiSbzBqpN6auzhB3ny1greAdVf
 pw9m4vLoQI1L1+gddEIif2Xvt5wzzF/Fids4j8tUib7OLqEGR8
 N39mVuhhB4hTsJIHujV2qSCbIqfUIVjlG9vOvaizyleH7wCwP0
 ++qpEW1HJiYgWXysHR1aRJA495BV1Mm3gqV8BCCPQcdQhNGzlY
 600P/VNLbkLPGdX2sJuiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All file_operations should get a .llseek
operation so we can make nonseekable_open
the default for future file operations
without a .llseek pointer.

The three cases that we can automatically
detect are no_llseek, seq_lseek and
default_llseek. For cases where we can
we can automatically prove that the
file offset is always ignored, we use
noop_llseek, which maintains the current
behavior of not returning an error from
a seek.

New drivers should normally not use
noop_llseek but instead use no_llseek and
call nonseekable_open at open time.
Existing drivers can be converted to do
the same when the maintainer knows for
certain that no user code relies on calling
seek on the device file.

The generated code is often incorrectly
indented and right now contains comments that
clarify for each added line why a specific
variant was chosen. In the version that gets
submitted upstream, the comments will be gone
and I will manually fix the indentation,
because there does not seem to be a way to
do that using coccinelle.

Some amount of new code is currently sitting
in linux-next that should get the same
modifications, which I will do at the end of
the merge window.

This specific posted version of the patch only
covers first few files in order to avoid
spamming everybody's inbox. I think you still
get the point. The diffstat is complete, and
the full patch is available in the 'llseek'
branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git

Many thanks to Julia Lawall for helping me
learn to write a semantic patch that does
all this.

===== begin semantic patch =====
// This adds an llseek= method to all file operations,
// as a preparation for making no_llseek the default.
//
// The rules are
// - use no_llseek explicitly if we do nonseekable_open
// - use seq_lseek for sequential files
// - use default_llseek if we know we access f_pos
// - use noop_llseek if we know we don't access f_pos,
//   but we still want to allow users to call lseek
//
@ open1 exists @
identifier nested_open;
@@
nested_open(...)
{
<+...
nonseekable_open(...)
...+>
}

@ open exists@
identifier open_f;
identifier i, f;
identifier open1.nested_open;
@@
int open_f(struct inode *i, struct file *f)
{
<+...
(
nonseekable_open(...)
|
nested_open(...)
)
...+>
}

@ read disable optional_qualifier exists @
identifier read_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
expression E;
identifier func;
@@
ssize_t read_f(struct file *f, char *p, size_t s, loff_t *off)
{
<+...
(
   *off = E
|
   *off += E
|
   func(..., off, ...)
|
   E = *off
)
...+>
}

@ read_no_fpos disable optional_qualifier exists @
identifier read_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
@@
ssize_t read_f(struct file *f, char *p, size_t s, loff_t *off)
{
... when != off
}

@ write @
identifier write_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
expression E;
identifier func;
@@
ssize_t write_f(struct file *f, const char *p, size_t s, loff_t *off)
{
<+...
(
  *off = E
|
  *off += E
|
  func(..., off, ...)
|
  E = *off
)
...+>
}

@ write_no_fpos @
identifier write_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
@@
ssize_t write_f(struct file *f, const char *p, size_t s, loff_t *off)
{
... when != off
}

@ fops0 @
identifier fops;
@@
struct file_operations fops = {
 ...
};

@ has_llseek depends on fops0 @
identifier fops0.fops;
identifier llseek_f;
@@
struct file_operations fops = {
...
 .llseek = llseek_f,
...
};

@ has_read depends on fops0 @
identifier fops0.fops;
identifier read_f;
@@
struct file_operations fops = {
...
 .read = read_f,
...
};

@ has_write depends on fops0 @
identifier fops0.fops;
identifier write_f;
@@
struct file_operations fops = {
...
 .write = write_f,
...
};

@ has_open depends on fops0 @
identifier fops0.fops;
identifier open_f;
@@
struct file_operations fops = {
...
 .open = open_f,
...
};

// use no_llseek if we call nonseekable_open
////////////////////////////////////////////
@ nonseekable1 depends on !has_llseek && has_open @
identifier fops0.fops;
identifier nso ~= "nonseekable_open";
@@
struct file_operations fops = {
...  .open = nso, ...
+.llseek = no_llseek, /* nonseekable */
};

@ nonseekable2 depends on !has_llseek @
identifier fops0.fops;
identifier open.open_f;
@@
struct file_operations fops = {
...  .open = open_f, ...
+.llseek = no_llseek, /* open uses nonseekable */
};

// use seq_lseek for sequential files
/////////////////////////////////////
@ seq depends on !has_llseek @
identifier fops0.fops;
identifier sr ~= "seq_read";
@@
struct file_operations fops = {
...  .read = sr, ...
+.llseek = seq_lseek, /* we have seq_read */
};

// use default_llseek if there is a readdir
///////////////////////////////////////////
@ fops1 depends on !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
identifier readdir_e;
@@
// any other fop is used that changes pos
struct file_operations fops = {
... .readdir = readdir_e, ...
+.llseek = default_llseek, /* readdir is present */
};

// use default_llseek if at least one of read/write touches f_pos
/////////////////////////////////////////////////////////////////
@ fops2 depends on !fops1 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
identifier read.read_f;
@@
// read fops use offset
struct file_operations fops = {
... .read = read_f, ...
+.llseek = default_llseek, /* read accesses f_pos */
};

@ fops3 depends on !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
identifier write.write_f;
@@
// write fops use offset
struct file_operations fops = {
... .write = write_f, ...
+	.llseek = default_llseek, /* write accesses f_pos */
};

// Use noop_llseek if neither read nor write accesses f_pos
///////////////////////////////////////////////////////////

@ fops4 depends on !fops1 && !fops2 && !fops3 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
identifier read_no_fpos.read_f;
identifier write_no_fpos.write_f;
@@
// write fops use offset
struct file_operations fops = {
...
 .write = write_f,
 .read = read_f,
...
+.llseek = noop_llseek, /* read and write both use no f_pos */
};

@ depends on has_write && !has_read && !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
identifier write_no_fpos.write_f;
@@
struct file_operations fops = {
... .write = write_f, ...
+.llseek = noop_llseek, /* write uses no f_pos */
};

@ depends on has_read && !has_write && !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
identifier read_no_fpos.read_f;
@@
struct file_operations fops = {
... .read = read_f, ...
+.llseek = noop_llseek, /* read uses no f_pos */
};

@ depends on !has_read && !has_write && !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
identifier fops0.fops;
@@
struct file_operations fops = {
...
+.llseek = noop_llseek, /* no read or write fn */
};
===== End semantic patch =====

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Julia Lawall <julia@diku.dk>
Cc: Christoph Hellwig <hch@infradead.org>
---
 arch/arm/kernel/etm.c                         |    1 +
 arch/arm/mach-msm/last_radio_log.c            |    3 +-
 arch/arm/mach-msm/smd_debug.c                 |    1 +
 arch/arm/plat-mxc/audmux-v2.c                 |    1 +
 arch/avr32/boards/mimc200/fram.c              |    1 +
 arch/blackfin/kernel/kgdb_test.c              |    1 +
 arch/blackfin/mach-bf561/coreb.c              |    1 +
 arch/cris/arch-v10/drivers/ds1302.c           |    1 +
 arch/cris/arch-v10/drivers/gpio.c             |    1 +
 arch/cris/arch-v10/drivers/i2c.c              |    1 +
 arch/cris/arch-v10/drivers/pcf8563.c          |    1 +
 arch/cris/arch-v10/drivers/sync_serial.c      |    3 +-
 arch/cris/arch-v32/drivers/cryptocop.c        |    3 +-
 arch/cris/arch-v32/drivers/i2c.c              |    1 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c     |    1 +
 arch/cris/arch-v32/drivers/mach-fs/gpio.c     |    1 +
 arch/cris/arch-v32/drivers/pcf8563.c          |    1 +
 arch/cris/arch-v32/drivers/sync_serial.c      |    3 +-
 arch/cris/kernel/profile.c                    |    1 +
 arch/ia64/kernel/salinfo.c                    |    2 +
 arch/ia64/sn/kernel/sn2/sn_hwperf.c           |    1 +
 arch/m68k/bvme6000/rtc.c                      |    1 +
 arch/m68k/mvme16x/rtc.c                       |    1 +
 arch/mips/kernel/rtlx.c                       |    3 +-
 arch/mips/kernel/vpe.c                        |    3 +-
 arch/mips/sibyte/common/sb_tbprof.c           |    1 +
 arch/powerpc/kernel/lparcfg.c                 |    1 +
 arch/powerpc/kernel/rtas_flash.c              |    3 ++
 arch/powerpc/kernel/rtasd.c                   |    1 +
 arch/powerpc/platforms/iseries/mf.c           |    1 +
 arch/powerpc/platforms/pseries/reconfig.c     |    3 +-
 arch/powerpc/platforms/pseries/scanlog.c      |    1 +
 arch/s390/crypto/prng.c                       |    1 +
 arch/s390/hypfs/hypfs_diag.c                  |    1 +
 arch/s390/hypfs/hypfs_vm.c                    |    1 +
 arch/s390/hypfs/inode.c                       |    1 +
 arch/s390/kernel/debug.c                      |    1 +
 arch/sh/boards/mach-landisk/gio.c             |    1 +
 arch/sparc/kernel/apc.c                       |    1 +
 arch/sparc/kernel/mdesc.c                     |    1 +
 arch/um/drivers/harddog_kern.c                |    1 +
 arch/um/drivers/mconsole_kern.c               |    1 +
 arch/um/drivers/mmapper_kern.c                |    1 +
 arch/um/drivers/random.c                      |    1 +
 arch/x86/kernel/apm_32.c                      |    1 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c     |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c              |    1 +
 arch/x86/kernel/kdebugfs.c                    |    1 +
 arch/x86/kernel/microcode_core.c              |    1 +
 arch/x86/xen/debugfs.c                        |    1 +
 block/bsg.c                                   |    1 +
 drivers/acpi/debug.c                          |    1 +
 drivers/acpi/event.c                          |    1 +
 drivers/acpi/system.c                         |    2 +
 drivers/block/DAC960.c                        |    3 +-
 drivers/block/aoe/aoechr.c                    |    1 +
 drivers/block/paride/pg.c                     |    1 +
 drivers/block/paride/pt.c                     |    1 +
 drivers/block/pktcdvd.c                       |    1 +
 drivers/bluetooth/btmrvl_debugfs.c            |   10 +++++++
 drivers/bluetooth/hci_vhci.c                  |    1 +
 drivers/char/apm-emulation.c                  |    1 +
 drivers/char/bfin-otp.c                       |    1 +
 drivers/char/briq_panel.c                     |    1 +
 drivers/char/bsr.c                            |    1 +
 drivers/char/cs5535_gpio.c                    |    3 +-
 drivers/char/ds1302.c                         |    1 +
 drivers/char/ds1620.c                         |    1 +
 drivers/char/dsp56k.c                         |    1 +
 drivers/char/dtlk.c                           |    1 +
 drivers/char/genrtc.c                         |    1 +
 drivers/char/hw_random/core.c                 |    1 +
 drivers/char/ip2/ip2main.c                    |    1 +
 drivers/char/ipmi/ipmi_devintf.c              |    1 +
 drivers/char/ipmi/ipmi_watchdog.c             |    1 +
 drivers/char/istallion.c                      |    1 +
 drivers/char/lp.c                             |    1 +
 drivers/char/mem.c                            |    3 ++
 drivers/char/misc.c                           |    1 +
 drivers/char/mmtimer.c                        |    1 +
 drivers/char/mspec.c                          |    9 ++++--
 drivers/char/mwave/mwavedd.c                  |    3 +-
 drivers/char/nwbutton.c                       |    1 +
 drivers/char/pc8736x_gpio.c                   |    1 +
 drivers/char/pcmcia/cm4000_cs.c               |    1 +
 drivers/char/pcmcia/cm4040_cs.c               |    1 +
 drivers/char/random.c                         |    2 +
 drivers/char/rio/rio_linux.c                  |    1 +
 drivers/char/scx200_gpio.c                    |    1 +
 drivers/char/snsc.c                           |    1 +
 drivers/char/stallion.c                       |    1 +
 drivers/char/sx.c                             |    1 +
 drivers/char/sysrq.c                          |    1 +
 drivers/char/tb0219.c                         |    1 +
 drivers/char/tlclk.c                          |    1 +
 drivers/char/toshiba.c                        |    1 +
 drivers/char/uv_mmtimer.c                     |    1 +
 drivers/char/virtio_console.c                 |    3 ++
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |    1 +
 drivers/dma/coh901318.c                       |    1 +
 drivers/gpu/drm/drm_drv.c                     |    3 +-
 drivers/gpu/drm/i810/i810_dma.c               |    1 +
 drivers/gpu/drm/i830/i830_dma.c               |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c           |    1 +
 drivers/gpu/vga/vgaarb.c                      |    1 +
 drivers/hid/hid-debug.c                       |    1 +
 drivers/hid/hid-roccat.c                      |    1 +
 drivers/hid/hidraw.c                          |    1 +
 drivers/hid/usbhid/hiddev.c                   |    1 +
 drivers/hwmon/asus_atk0110.c                  |    1 +
 drivers/ide/ide-tape.c                        |    1 +
 drivers/idle/i7300_idle.c                     |    1 +
 drivers/infiniband/hw/cxgb4/device.c          |    1 +
 drivers/infiniband/hw/ipath/ipath_diag.c      |    4 ++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |    3 +-
 drivers/infiniband/hw/ipath/ipath_fs.c        |    3 ++
 drivers/infiniband/hw/qib/qib_diag.c          |    4 ++-
 drivers/infiniband/hw/qib/qib_file_ops.c      |    3 +-
 drivers/infiniband/hw/qib/qib_fs.c            |    1 +
 drivers/input/evdev.c                         |    3 +-
 drivers/input/input.c                         |    1 +
 drivers/input/joydev.c                        |    1 +
 drivers/input/misc/uinput.c                   |    1 +
 drivers/input/mousedev.c                      |    1 +
 drivers/input/serio/serio_raw.c               |    1 +
 drivers/isdn/mISDN/timerdev.c                 |    1 +
 drivers/lguest/lguest_user.c                  |    1 +
 drivers/macintosh/ans-lcd.c                   |    1 +
 drivers/macintosh/via-pmu.c                   |    1 +
 drivers/md/dm-ioctl.c                         |    1 +
 drivers/media/IR/imon.c                       |    6 +++-
 drivers/media/dvb/bt8xx/dst_ca.c              |    3 +-
 drivers/media/dvb/dvb-core/dmxdev.c           |    2 +
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c   |    1 +
 drivers/media/dvb/dvb-core/dvb_frontend.c     |    3 +-
 drivers/media/dvb/dvb-core/dvb_net.c          |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c           |    1 +
 drivers/media/dvb/firewire/firedtv-ci.c       |    1 +
 drivers/media/dvb/ttpci/av7110.c              |    1 +
 drivers/media/dvb/ttpci/av7110_av.c           |    2 +
 drivers/media/dvb/ttpci/av7110_ca.c           |    1 +
 drivers/media/dvb/ttpci/av7110_ir.c           |    1 +
 drivers/mfd/ab3100-core.c                     |    1 +
 drivers/misc/hpilo.c                          |    1 +
 drivers/misc/phantom.c                        |    1 +
 drivers/misc/sgi-gru/grufile.c                |    1 +
 drivers/mmc/core/debugfs.c                    |    1 +
 drivers/mtd/ubi/cdev.c                        |    1 +
 drivers/net/cxgb4/cxgb4_main.c                |    1 +
 drivers/net/ppp_generic.c                     |    3 +-
 drivers/net/wimax/i2400m/debugfs.c            |    2 +
 drivers/net/wireless/airo.c                   |   24 ++++++++++++------
 drivers/net/wireless/ath/ath5k/debug.c        |    6 ++++
 drivers/net/wireless/ath/ath9k/debug.c        |   33 ++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 ++++--
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |    3 ++
 drivers/net/wireless/iwmc3200wifi/debugfs.c   |    4 +++
 drivers/net/wireless/iwmc3200wifi/sdio.c      |    1 +
 drivers/net/wireless/libertas/debugfs.c       |    1 +
 drivers/net/wireless/ray_cs.c                 |    2 +
 drivers/net/wireless/rt2x00/rt2x00debug.c     |    4 +++
 drivers/net/wireless/wl12xx/wl1251_debugfs.c  |    2 +
 drivers/net/wireless/wl12xx/wl1271_debugfs.c  |    4 ++-
 drivers/oprofile/oprofile_files.c             |    8 +++++-
 drivers/oprofile/oprofilefs.c                 |    3 ++
 drivers/pci/pcie/aer/aer_inject.c             |    1 +
 drivers/pcmcia/pcmcia_ioctl.c                 |    1 +
 drivers/platform/x86/sony-laptop.c            |    1 +
 drivers/rtc/rtc-m41t80.c                      |    1 +
 drivers/s390/block/dasd_eer.c                 |    1 +
 drivers/s390/char/fs3270.c                    |    1 +
 drivers/s390/char/monreader.c                 |    1 +
 drivers/s390/char/monwriter.c                 |    1 +
 drivers/s390/char/tape_char.c                 |    1 +
 drivers/s390/char/vmcp.c                      |    1 +
 drivers/s390/char/vmlogrdr.c                  |    1 +
 drivers/s390/char/vmwatchdog.c                |    1 +
 drivers/s390/char/zcore.c                     |    2 +
 drivers/s390/cio/chsc_sch.c                   |    1 +
 drivers/s390/cio/css.c                        |    1 +
 drivers/s390/crypto/zcrypt_api.c              |    3 +-
 drivers/s390/scsi/zfcp_cfdc.c                 |    3 +-
 drivers/sbus/char/display7seg.c               |    1 +
 drivers/sbus/char/envctrl.c                   |    1 +
 drivers/scsi/3w-9xxx.c                        |    3 +-
 drivers/scsi/3w-sas.c                         |    3 +-
 drivers/scsi/3w-xxxx.c                        |    3 +-
 drivers/scsi/aacraid/linit.c                  |    1 +
 drivers/scsi/ch.c                             |    1 +
 drivers/scsi/dpt_i2o.c                        |    1 +
 drivers/scsi/gdth.c                           |    1 +
 drivers/scsi/megaraid.c                       |    1 +
 drivers/scsi/megaraid/megaraid_mm.c           |    1 +
 drivers/scsi/megaraid/megaraid_sas.c          |    1 +
 drivers/scsi/mpt2sas/mpt2sas_ctl.c            |    1 +
 drivers/scsi/osd/osd_uld.c                    |    1 +
 drivers/scsi/pmcraid.c                        |    1 +
 drivers/scsi/qla2xxx/qla_os.c                 |    1 +
 drivers/scsi/scsi_tgt_if.c                    |    1 +
 drivers/scsi/sg.c                             |    1 +
 drivers/spi/dw_spi.c                          |    1 +
 drivers/spi/spidev.c                          |    1 +
 drivers/staging/batman-adv/device.c           |    1 +
 drivers/staging/comedi/comedi_fops.c          |    1 +
 drivers/staging/crystalhd/crystalhd_lnx.c     |    1 +
 drivers/staging/dream/camera/msm_camera.c     |    3 ++
 drivers/staging/dream/pmem.c                  |    2 +
 drivers/staging/dream/qdsp5/adsp_driver.c     |    1 +
 drivers/staging/dream/qdsp5/audio_aac.c       |    1 +
 drivers/staging/dream/qdsp5/audio_amrnb.c     |    1 +
 drivers/staging/dream/qdsp5/audio_evrc.c      |    1 +
 drivers/staging/dream/qdsp5/audio_in.c        |    2 +
 drivers/staging/dream/qdsp5/audio_mp3.c       |    1 +
 drivers/staging/dream/qdsp5/audio_out.c       |    2 +
 drivers/staging/dream/qdsp5/audio_qcelp.c     |    1 +
 drivers/staging/dream/qdsp5/evlog.h           |    1 +
 drivers/staging/dream/qdsp5/snd.c             |    1 +
 drivers/staging/dt3155/dt3155_drv.c           |    3 +-
 drivers/staging/frontier/alphatrack.c         |    1 +
 drivers/staging/frontier/tranzport.c          |    1 +
 drivers/staging/iio/industrialio-core.c       |    1 +
 drivers/staging/iio/industrialio-ring.c       |    1 +
 drivers/staging/memrar/memrar_handler.c       |    1 +
 drivers/staging/panel/panel.c                 |    1 +
 drivers/staging/sep/sep_driver.c              |    1 +
 drivers/telephony/ixj.c                       |    3 +-
 drivers/telephony/phonedev.c                  |    1 +
 drivers/uio/uio.c                             |    1 +
 drivers/usb/class/cdc-wdm.c                   |    3 +-
 drivers/usb/class/usblp.c                     |    1 +
 drivers/usb/class/usbtmc.c                    |    1 +
 drivers/usb/core/file.c                       |    1 +
 drivers/usb/gadget/f_hid.c                    |    1 +
 drivers/usb/gadget/printer.c                  |    3 +-
 drivers/usb/host/ehci-dbg.c                   |    3 ++
 drivers/usb/host/ohci-dbg.c                   |    3 ++
 drivers/usb/image/mdc800.c                    |    1 +
 drivers/usb/misc/adutux.c                     |    1 +
 drivers/usb/misc/idmouse.c                    |    1 +
 drivers/usb/misc/iowarrior.c                  |    1 +
 drivers/usb/misc/ldusb.c                      |    1 +
 drivers/usb/misc/rio500.c                     |    1 +
 drivers/usb/misc/usblcd.c                     |    1 +
 drivers/usb/usb-skeleton.c                    |    1 +
 drivers/vhost/net.c                           |    1 +
 drivers/video/fbmem.c                         |    1 +
 drivers/video/mbx/mbxdebugfs.c                |    6 ++++
 drivers/watchdog/ar7_wdt.c                    |    1 +
 drivers/watchdog/cpwd.c                       |    1 +
 drivers/watchdog/ep93xx_wdt.c                 |    1 +
 drivers/watchdog/omap_wdt.c                   |    1 +
 drivers/xen/evtchn.c                          |    1 +
 drivers/xen/xenfs/super.c                     |    1 +
 drivers/xen/xenfs/xenbus.c                    |    1 +
 fs/afs/mntpt.c                                |    1 +
 fs/autofs4/dev-ioctl.c                        |    1 +
 fs/binfmt_misc.c                              |    3 ++
 fs/btrfs/super.c                              |    1 +
 fs/cachefiles/daemon.c                        |    1 +
 fs/char_dev.c                                 |    1 +
 fs/coda/pioctl.c                              |    1 +
 fs/coda/psdev.c                               |    1 +
 fs/debugfs/file.c                             |    3 ++
 fs/dlm/debug_fs.c                             |    3 +-
 fs/dlm/plock.c                                |    3 +-
 fs/dlm/user.c                                 |    3 ++
 fs/ecryptfs/file.c                            |    1 +
 fs/ecryptfs/miscdev.c                         |    1 +
 fs/eventfd.c                                  |    1 +
 fs/eventpoll.c                                |    3 +-
 fs/fifo.c                                     |    1 +
 fs/fuse/control.c                             |    4 +++
 fs/fuse/cuse.c                                |    1 +
 fs/gfs2/file.c                                |    2 +
 fs/hppfs/hppfs.c                              |    1 +
 fs/hugetlbfs/inode.c                          |    1 +
 fs/logfs/dir.c                                |    1 +
 fs/nfsd/nfsctl.c                              |    1 +
 fs/no-block.c                                 |    1 +
 fs/notify/inotify/inotify_user.c              |    1 +
 fs/ntfs/file.c                                |    3 +-
 fs/ocfs2/dlmfs/dlmfs.c                        |    1 +
 fs/ocfs2/stack_user.c                         |    1 +
 fs/proc/base.c                                |    7 +++++
 fs/proc/proc_sysctl.c                         |    1 +
 fs/proc/root.c                                |    1 +
 fs/proc/task_mmu.c                            |    1 +
 fs/romfs/super.c                              |    1 +
 fs/signalfd.c                                 |    1 +
 fs/squashfs/dir.c                             |    3 +-
 fs/timerfd.c                                  |    1 +
 fs/ubifs/debug.c                              |    1 +
 ipc/mqueue.c                                  |    1 +
 ipc/shm.c                                     |    2 +
 kernel/configs.c                              |    1 +
 kernel/gcov/fs.c                              |    1 +
 kernel/kprobes.c                              |    1 +
 kernel/pm_qos_params.c                        |    1 +
 kernel/profile.c                              |    1 +
 kernel/trace/blktrace.c                       |    2 +
 kernel/trace/ftrace.c                         |    2 +
 kernel/trace/ring_buffer.c                    |    1 +
 kernel/trace/trace_events.c                   |    7 +++++
 kernel/trace/trace_ksym.c                     |    1 +
 kernel/trace/trace_stack.c                    |    1 +
 kernel/trace/trace_sysprof.c                  |    1 +
 lib/dma-debug.c                               |    1 +
 net/atm/proc.c                                |    1 +
 net/dccp/probe.c                              |    1 +
 net/ipv4/tcp_probe.c                          |    1 +
 net/mac80211/debugfs.c                        |   19 ++++++++++----
 net/mac80211/rate.c                           |    1 +
 net/mac80211/rc80211_minstrel_debugfs.c       |    1 +
 net/mac80211/rc80211_pid_debugfs.c            |    1 +
 net/netfilter/xt_recent.c                     |    1 +
 net/nonet.c                                   |    1 +
 net/rfkill/core.c                             |    1 +
 net/sctp/probe.c                              |    1 +
 net/socket.c                                  |    1 +
 net/sunrpc/cache.c                            |    2 +
 net/wireless/debugfs.c                        |    1 +
 samples/tracepoints/tracepoint-sample.c       |    1 +
 security/inode.c                              |    1 +
 security/smack/smackfs.c                      |    5 ++++
 security/tomoyo/common.c                      |    1 +
 sound/core/seq/oss/seq_oss.c                  |    1 +
 sound/core/sound.c                            |    3 +-
 sound/oss/au1550_ac97.c                       |    2 +
 sound/oss/msnd_pinnacle.c                     |    1 +
 sound/oss/sh_dac_audio.c                      |    1 +
 sound/soc/soc-core.c                          |    1 +
 sound/soc/soc-dapm.c                          |    1 +
 sound/sound_core.c                            |    1 +
 virt/kvm/kvm_main.c                           |    3 ++
 335 files changed, 528 insertions(+), 69 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8277539..88f48c7 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -314,6 +314,7 @@ static const struct file_operations etb_fops = {
 	.read = etb_read,
 	.open = etb_open,
 	.release = etb_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice etb_miscdev = {
diff --git a/arch/arm/mach-msm/last_radio_log.c b/arch/arm/mach-msm/last_radio_log.c
index b64ba5a..81058a3 100644
--- a/arch/arm/mach-msm/last_radio_log.c
+++ b/arch/arm/mach-msm/last_radio_log.c
@@ -48,7 +48,8 @@ static ssize_t last_radio_log_read(struct file *file, char __user *buf,
 }
 
 static struct file_operations last_radio_log_fops = {
-	.read = last_radio_log_read
+	.read = last_radio_log_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void msm_init_last_radio_log(struct module *owner)
diff --git a/arch/arm/mach-msm/smd_debug.c b/arch/arm/mach-msm/smd_debug.c
index 3b2dd71..e01a1ef 100644
--- a/arch/arm/mach-msm/smd_debug.c
+++ b/arch/arm/mach-msm/smd_debug.c
@@ -212,6 +212,7 @@ static int debug_open(struct inode *inode, struct file *file)
 static const struct file_operations debug_ops = {
 	.read = debug_read,
 	.open = debug_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void debug_create(const char *name, mode_t mode,
diff --git a/arch/arm/plat-mxc/audmux-v2.c b/arch/arm/plat-mxc/audmux-v2.c
index 0c2cc5c..7de36c6 100644
--- a/arch/arm/plat-mxc/audmux-v2.c
+++ b/arch/arm/plat-mxc/audmux-v2.c
@@ -141,6 +141,7 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
 static const struct file_operations audmux_debugfs_fops = {
 	.open = audmux_open_file,
 	.read = audmux_read_file,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void audmux_debugfs_init(void)
diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
index 54fbd95..a34cf5d 100644
--- a/arch/avr32/boards/mimc200/fram.c
+++ b/arch/avr32/boards/mimc200/fram.c
@@ -41,6 +41,7 @@ static int fram_mmap(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations fram_fops = {
 	.owner			= THIS_MODULE,
 	.mmap			= fram_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 #define FRAM_MINOR	0
diff --git a/arch/blackfin/kernel/kgdb_test.c b/arch/blackfin/kernel/kgdb_test.c
index 9a4b075..1a5fae7 100644
--- a/arch/blackfin/kernel/kgdb_test.c
+++ b/arch/blackfin/kernel/kgdb_test.c
@@ -88,6 +88,7 @@ static const struct file_operations kgdb_test_proc_fops = {
 	.owner = THIS_MODULE,
 	.read  = kgdb_test_proc_read,
 	.write = kgdb_test_proc_write,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init kgdbtest_init(void)
diff --git a/arch/blackfin/mach-bf561/coreb.c b/arch/blackfin/mach-bf561/coreb.c
index deb2271..0cb1f77 100644
--- a/arch/blackfin/mach-bf561/coreb.c
+++ b/arch/blackfin/mach-bf561/coreb.c
@@ -51,6 +51,7 @@ coreb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static const struct file_operations coreb_fops = {
 	.owner          = THIS_MODULE,
 	.unlocked_ioctl = coreb_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice coreb_dev = {
diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 8842756..b6d8d33 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -387,6 +387,7 @@ print_rtc_status(void)
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl = rtc_unlocked_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 }; 
 
 /* Probe for the chip by writing something to its RAM and try reading it back. */
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 4b0f65f..2516c2e 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -719,6 +719,7 @@ static const struct file_operations gpio_fops = {
 	.write       = gpio_write,
 	.open        = gpio_open,
 	.release     = gpio_release,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static void ioif_watcher(const unsigned int gpio_in_available,
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index a8737a8..fc25b5f 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -622,6 +622,7 @@ static const struct file_operations i2c_fops = {
 	.ioctl    = i2c_ioctl,
 	.open     = i2c_open,
 	.release  = i2c_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 int __init
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 7dcb1f8..fbf135b 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -64,6 +64,7 @@ static int voltage_low;
 static const struct file_operations pcf8563_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = pcf8563_unlocked_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 unsigned char
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 109dcd8..dd9b18b 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -250,7 +250,8 @@ static const struct file_operations sync_serial_fops = {
 	.poll    = sync_serial_poll,
 	.ioctl   = sync_serial_ioctl,
 	.open    = sync_serial_open,
-	.release = sync_serial_release
+	.release = sync_serial_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init etrax_sync_serial_init(void)
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b70fb34..540d94d 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -282,7 +282,8 @@ const struct file_operations cryptocop_fops = {
 	.owner =	THIS_MODULE,
 	.open =		cryptocop_open,
 	.release =	cryptocop_release,
-	.ioctl =	cryptocop_ioctl
+	.ioctl =	cryptocop_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 2fd6a74..69a1d9a 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -698,6 +698,7 @@ static const struct file_operations i2c_fops = {
 	.unlocked_ioctl = i2c_ioctl,
 	.open		= i2c_open,
 	.release	= i2c_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __init i2c_init(void)
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index 97357cf..13bf637 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -883,6 +883,7 @@ static const struct file_operations gpio_fops = {
 	.write       = gpio_write,
 	.open        = gpio_open,
 	.release     = gpio_release,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO

