Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0INUYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:24:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0INUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:24:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Julia Lawall <julia@diku.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/15] llseek: automatically add .llseek fop
Date: Tue, 14 Sep 2010 22:22:41 +0200
Message-Id: <1284495763-7506-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0AacC/UG9MVTV8vwal74FXF90YSraMh06C75XWHgNb6
 EXthZda09xNYiC2JBGQ7dgUukR08CSWMjheOMPGxpU2gTtuZJV
 NGNsfI5ABKbWFwT5AcGBLiamSIksm2fHm1gALlDTVCBw0OlrkV
 AONCiS1jisuEp/Ln7oEZwr6zw6TkwdEFBli/qOJMfhY5O0+rn7
 RlcgVF+nmF+bHbEiJQm3A==
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
 arch/arm/kernel/etm.c                            |    1 +
 arch/arm/mach-msm/last_radio_log.c               |    3 +-
 arch/arm/mach-msm/smd_debug.c                    |    1 +
 arch/arm/plat-mxc/audmux-v2.c                    |    1 +
 arch/avr32/boards/mimc200/fram.c                 |    1 +
 arch/blackfin/kernel/kgdb_test.c                 |    1 +
 arch/blackfin/mach-bf561/coreb.c                 |    1 +
 arch/cris/arch-v10/drivers/ds1302.c              |    1 +
 arch/cris/arch-v10/drivers/gpio.c                |    1 +
 arch/cris/arch-v10/drivers/i2c.c                 |    1 +
 arch/cris/arch-v10/drivers/pcf8563.c             |    1 +
 arch/cris/arch-v10/drivers/sync_serial.c         |    3 +-
 arch/cris/arch-v32/drivers/cryptocop.c           |    3 +-
 arch/cris/arch-v32/drivers/i2c.c                 |    1 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c        |    1 +
 arch/cris/arch-v32/drivers/mach-fs/gpio.c        |    1 +
 arch/cris/arch-v32/drivers/pcf8563.c             |    1 +
 arch/cris/arch-v32/drivers/sync_serial.c         |    3 +-
 arch/cris/kernel/profile.c                       |    1 +
 arch/ia64/kernel/salinfo.c                       |    2 +
 arch/ia64/sn/kernel/sn2/sn_hwperf.c              |    1 +
 arch/m68k/bvme6000/rtc.c                         |    1 +
 arch/m68k/mvme16x/rtc.c                          |    1 +
 arch/mips/kernel/rtlx.c                          |    3 +-
 arch/mips/kernel/vpe.c                           |    3 +-
 arch/mips/sibyte/common/sb_tbprof.c              |    1 +
 arch/powerpc/kernel/lparcfg.c                    |    1 +
 arch/powerpc/kernel/rtas_flash.c                 |    3 ++
 arch/powerpc/kernel/rtasd.c                      |    1 +
 arch/powerpc/platforms/iseries/mf.c              |    1 +
 arch/powerpc/platforms/pseries/reconfig.c        |    3 +-
 arch/powerpc/platforms/pseries/scanlog.c         |    1 +
 arch/s390/crypto/prng.c                          |    1 +
 arch/s390/hypfs/hypfs_diag.c                     |    1 +
 arch/s390/hypfs/hypfs_vm.c                       |    1 +
 arch/s390/hypfs/inode.c                          |    1 +
 arch/s390/kernel/debug.c                         |    1 +
 arch/sh/boards/mach-landisk/gio.c                |    1 +
 arch/sparc/kernel/apc.c                          |    1 +
 arch/sparc/kernel/mdesc.c                        |    1 +
 arch/tile/kernel/hardwall.c                      |    1 +
 arch/um/drivers/harddog_kern.c                   |    1 +
 arch/um/drivers/mconsole_kern.c                  |    1 +
 arch/um/drivers/mmapper_kern.c                   |    1 +
 arch/um/drivers/random.c                         |    1 +
 arch/x86/kernel/apm_32.c                         |    1 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c        |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c                 |    1 +
 arch/x86/kernel/kdebugfs.c                       |    1 +
 arch/x86/kernel/microcode_core.c                 |    1 +
 arch/x86/kernel/tlb_uv.c                         |    1 +
 arch/x86/xen/debugfs.c                           |    1 +
 block/bsg.c                                      |    1 +
 drivers/acpi/ec_sys.c                            |    1 +
 drivers/acpi/event.c                             |    1 +
 drivers/block/DAC960.c                           |    3 +-
 drivers/block/aoe/aoechr.c                       |    1 +
 drivers/block/paride/pg.c                        |    1 +
 drivers/block/paride/pt.c                        |    1 +
 drivers/block/pktcdvd.c                          |    1 +
 drivers/bluetooth/btmrvl_debugfs.c               |   10 ++++++
 drivers/bluetooth/hci_vhci.c                     |    1 +
 drivers/char/apm-emulation.c                     |    1 +
 drivers/char/bfin-otp.c                          |    1 +
 drivers/char/briq_panel.c                        |    1 +
 drivers/char/bsr.c                               |    1 +
 drivers/char/cs5535_gpio.c                       |    3 +-
 drivers/char/ds1302.c                            |    1 +
 drivers/char/ds1620.c                            |    1 +
 drivers/char/dsp56k.c                            |    1 +
 drivers/char/dtlk.c                              |    1 +
 drivers/char/genrtc.c                            |    1 +
 drivers/char/hw_random/core.c                    |    1 +
 drivers/char/ip2/ip2main.c                       |    1 +
 drivers/char/ipmi/ipmi_devintf.c                 |    1 +
 drivers/char/ipmi/ipmi_watchdog.c                |    1 +
 drivers/char/istallion.c                         |    1 +
 drivers/char/lp.c                                |    1 +
 drivers/char/mem.c                               |    3 ++
 drivers/char/misc.c                              |    1 +
 drivers/char/mmtimer.c                           |    1 +
 drivers/char/mspec.c                             |    9 ++++--
 drivers/char/mwave/mwavedd.c                     |    3 +-
 drivers/char/nwbutton.c                          |    1 +
 drivers/char/pc8736x_gpio.c                      |    1 +
 drivers/char/pcmcia/cm4000_cs.c                  |    1 +
 drivers/char/pcmcia/cm4040_cs.c                  |    1 +
 drivers/char/random.c                            |    2 +
 drivers/char/rio/rio_linux.c                     |    1 +
 drivers/char/scx200_gpio.c                       |    1 +
 drivers/char/snsc.c                              |    1 +
 drivers/char/stallion.c                          |    1 +
 drivers/char/sx.c                                |    1 +
 drivers/char/sysrq.c                             |    1 +
 drivers/char/tb0219.c                            |    1 +
 drivers/char/tlclk.c                             |    1 +
 drivers/char/toshiba.c                           |    1 +
 drivers/char/uv_mmtimer.c                        |    1 +
 drivers/char/virtio_console.c                    |    3 ++
 drivers/char/xilinx_hwicap/xilinx_hwicap.c       |    1 +
 drivers/dma/coh901318.c                          |    1 +
 drivers/firewire/nosy.c                          |    1 +
 drivers/gpu/drm/drm_drv.c                        |    3 +-
 drivers/gpu/drm/i810/i810_dma.c                  |    1 +
 drivers/gpu/drm/i830/i830_dma.c                  |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c              |    1 +
 drivers/gpu/vga/vgaarb.c                         |    1 +
 drivers/hid/hid-debug.c                          |    1 +
 drivers/hid/hid-roccat.c                         |    1 +
 drivers/hid/hidraw.c                             |    1 +
 drivers/hid/usbhid/hiddev.c                      |    1 +
 drivers/hwmon/asus_atk0110.c                     |    1 +
 drivers/ide/ide-tape.c                           |    1 +
 drivers/idle/i7300_idle.c                        |    1 +
 drivers/infiniband/hw/cxgb4/device.c             |    1 +
 drivers/infiniband/hw/ipath/ipath_diag.c         |    4 ++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c     |    3 +-
 drivers/infiniband/hw/ipath/ipath_fs.c           |    3 ++
 drivers/infiniband/hw/qib/qib_diag.c             |    4 ++-
 drivers/infiniband/hw/qib/qib_file_ops.c         |    3 +-
 drivers/infiniband/hw/qib/qib_fs.c               |    1 +
 drivers/input/evdev.c                            |    3 +-
 drivers/input/input.c                            |    1 +
 drivers/input/joydev.c                           |    1 +
 drivers/input/misc/uinput.c                      |    1 +
 drivers/input/mousedev.c                         |    1 +
 drivers/input/serio/serio_raw.c                  |    1 +
 drivers/isdn/mISDN/timerdev.c                    |    1 +
 drivers/lguest/lguest_user.c                     |    1 +
 drivers/macintosh/ans-lcd.c                      |    1 +
 drivers/macintosh/via-pmu.c                      |    1 +
 drivers/md/dm-ioctl.c                            |    1 +
 drivers/media/IR/imon.c                          |    6 ++-
 drivers/media/IR/lirc_dev.c                      |    1 +
 drivers/media/dvb/bt8xx/dst_ca.c                 |    3 +-
 drivers/media/dvb/dvb-core/dmxdev.c              |    2 +
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c      |    1 +
 drivers/media/dvb/dvb-core/dvb_frontend.c        |    3 +-
 drivers/media/dvb/dvb-core/dvb_net.c             |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c              |    1 +
 drivers/media/dvb/firewire/firedtv-ci.c          |    1 +
 drivers/media/dvb/ttpci/av7110.c                 |    1 +
 drivers/media/dvb/ttpci/av7110_av.c              |    2 +
 drivers/media/dvb/ttpci/av7110_ca.c              |    1 +
 drivers/media/dvb/ttpci/av7110_ir.c              |    1 +
 drivers/mfd/ab3100-core.c                        |    1 +
 drivers/misc/hpilo.c                             |    1 +
 drivers/misc/phantom.c                           |    1 +
 drivers/misc/sgi-gru/grufile.c                   |    1 +
 drivers/mmc/core/debugfs.c                       |    1 +
 drivers/mtd/ubi/cdev.c                           |    1 +
 drivers/net/caif/caif_spi.c                      |    6 ++-
 drivers/net/cxgb4/cxgb4_main.c                   |    1 +
 drivers/net/ppp_generic.c                        |    3 +-
 drivers/net/wimax/i2400m/debugfs.c               |    2 +
 drivers/net/wireless/airo.c                      |   24 ++++++++++-----
 drivers/net/wireless/ath/ath5k/debug.c           |    7 ++++
 drivers/net/wireless/ath/ath9k/debug.c           |   33 ++++++++++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c    |    9 ++++--
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    3 ++
 drivers/net/wireless/iwmc3200wifi/debugfs.c      |    4 ++
 drivers/net/wireless/iwmc3200wifi/sdio.c         |    1 +
 drivers/net/wireless/libertas/debugfs.c          |    1 +
 drivers/net/wireless/ray_cs.c                    |    2 +
 drivers/net/wireless/rt2x00/rt2x00debug.c        |    4 ++
 drivers/net/wireless/wl12xx/wl1251_debugfs.c     |    2 +
 drivers/net/wireless/wl12xx/wl1271_debugfs.c     |    4 ++-
 drivers/oprofile/oprofile_files.c                |    8 ++++-
 drivers/oprofile/oprofilefs.c                    |    3 ++
 drivers/pci/pcie/aer/aer_inject.c                |    1 +
 drivers/platform/x86/sony-laptop.c               |    1 +
 drivers/rtc/rtc-m41t80.c                         |    1 +
 drivers/s390/block/dasd_eer.c                    |    1 +
 drivers/s390/char/fs3270.c                       |    1 +
 drivers/s390/char/monreader.c                    |    1 +
 drivers/s390/char/monwriter.c                    |    1 +
 drivers/s390/char/tape_char.c                    |    1 +
 drivers/s390/char/vmcp.c                         |    1 +
 drivers/s390/char/vmlogrdr.c                     |    1 +
 drivers/s390/char/vmwatchdog.c                   |    1 +
 drivers/s390/char/zcore.c                        |    2 +
 drivers/s390/cio/chsc_sch.c                      |    1 +
 drivers/s390/cio/css.c                           |    1 +
 drivers/s390/crypto/zcrypt_api.c                 |    3 +-
 drivers/s390/scsi/zfcp_cfdc.c                    |    3 +-
 drivers/sbus/char/display7seg.c                  |    1 +
 drivers/sbus/char/envctrl.c                      |    1 +
 drivers/scsi/3w-9xxx.c                           |    3 +-
 drivers/scsi/3w-sas.c                            |    3 +-
 drivers/scsi/3w-xxxx.c                           |    3 +-
 drivers/scsi/aacraid/linit.c                     |    1 +
 drivers/scsi/ch.c                                |    1 +
 drivers/scsi/dpt_i2o.c                           |    1 +
 drivers/scsi/gdth.c                              |    1 +
 drivers/scsi/megaraid.c                          |    1 +
 drivers/scsi/megaraid/megaraid_mm.c              |    1 +
 drivers/scsi/megaraid/megaraid_sas.c             |    1 +
 drivers/scsi/mpt2sas/mpt2sas_ctl.c               |    1 +
 drivers/scsi/osd/osd_uld.c                       |    1 +
 drivers/scsi/pmcraid.c                           |    1 +
 drivers/scsi/qla2xxx/qla_os.c                    |    1 +
 drivers/scsi/scsi_tgt_if.c                       |    1 +
 drivers/scsi/sg.c                                |    1 +
 drivers/serial/mfd.c                             |    2 +
 drivers/spi/dw_spi.c                             |    1 +
 drivers/spi/spidev.c                             |    1 +
 drivers/staging/batman-adv/bat_debugfs.c         |    1 +
 drivers/staging/batman-adv/icmp_socket.c         |    1 +
 drivers/staging/comedi/comedi_fops.c             |    1 +
 drivers/staging/crystalhd/crystalhd_lnx.c        |    1 +
 drivers/staging/dream/camera/msm_camera.c        |    3 ++
 drivers/staging/dream/pmem.c                     |    2 +
 drivers/staging/dream/qdsp5/adsp_driver.c        |    1 +
 drivers/staging/dream/qdsp5/audio_aac.c          |    1 +
 drivers/staging/dream/qdsp5/audio_amrnb.c        |    1 +
 drivers/staging/dream/qdsp5/audio_evrc.c         |    1 +
 drivers/staging/dream/qdsp5/audio_in.c           |    2 +
 drivers/staging/dream/qdsp5/audio_mp3.c          |    1 +
 drivers/staging/dream/qdsp5/audio_out.c          |    2 +
 drivers/staging/dream/qdsp5/audio_qcelp.c        |    1 +
 drivers/staging/dream/qdsp5/evlog.h              |    1 +
 drivers/staging/dream/qdsp5/snd.c                |    1 +
 drivers/staging/frontier/alphatrack.c            |    1 +
 drivers/staging/frontier/tranzport.c             |    1 +
 drivers/staging/iio/industrialio-core.c          |    1 +
 drivers/staging/iio/industrialio-ring.c          |    1 +
 drivers/staging/lirc/lirc_imon.c                 |    3 +-
 drivers/staging/lirc/lirc_it87.c                 |    1 +
 drivers/staging/lirc/lirc_sasem.c                |    1 +
 drivers/staging/memrar/memrar_handler.c          |    1 +
 drivers/staging/panel/panel.c                    |    1 +
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    1 +
 drivers/telephony/ixj.c                          |    3 +-
 drivers/telephony/phonedev.c                     |    1 +
 drivers/uio/uio.c                                |    1 +
 drivers/usb/class/cdc-wdm.c                      |    3 +-
 drivers/usb/class/usblp.c                        |    1 +
 drivers/usb/class/usbtmc.c                       |    1 +
 drivers/usb/core/file.c                          |    1 +
 drivers/usb/gadget/f_hid.c                       |    1 +
 drivers/usb/gadget/printer.c                     |    3 +-
 drivers/usb/host/ehci-dbg.c                      |    4 ++
 drivers/usb/host/ohci-dbg.c                      |    3 ++
 drivers/usb/image/mdc800.c                       |    1 +
 drivers/usb/misc/adutux.c                        |    1 +
 drivers/usb/misc/idmouse.c                       |    1 +
 drivers/usb/misc/iowarrior.c                     |    1 +
 drivers/usb/misc/ldusb.c                         |    1 +
 drivers/usb/misc/rio500.c                        |    1 +
 drivers/usb/misc/usblcd.c                        |    1 +
 drivers/usb/usb-skeleton.c                       |    1 +
 drivers/vhost/net.c                              |    1 +
 drivers/video/fbmem.c                            |    1 +
 drivers/video/mbx/mbxdebugfs.c                   |    6 ++++
 drivers/watchdog/ar7_wdt.c                       |    1 +
 drivers/watchdog/cpwd.c                          |    1 +
 drivers/watchdog/ep93xx_wdt.c                    |    1 +
 drivers/watchdog/omap_wdt.c                      |    1 +
 drivers/xen/evtchn.c                             |    1 +
 drivers/xen/xenfs/super.c                        |    1 +
 drivers/xen/xenfs/xenbus.c                       |    1 +
 fs/afs/mntpt.c                                   |    1 +
 fs/autofs4/dev-ioctl.c                           |    1 +
 fs/binfmt_misc.c                                 |    3 ++
 fs/btrfs/super.c                                 |    1 +
 fs/cachefiles/daemon.c                           |    1 +
 fs/char_dev.c                                    |    1 +
 fs/coda/pioctl.c                                 |    1 +
 fs/coda/psdev.c                                  |    1 +
 fs/debugfs/file.c                                |    3 ++
 fs/dlm/debug_fs.c                                |    3 +-
 fs/dlm/plock.c                                   |    3 +-
 fs/dlm/user.c                                    |    3 ++
 fs/ecryptfs/file.c                               |    1 +
 fs/ecryptfs/miscdev.c                            |    1 +
 fs/eventfd.c                                     |    1 +
 fs/eventpoll.c                                   |    3 +-
 fs/fifo.c                                        |    1 +
 fs/fuse/control.c                                |    4 ++
 fs/fuse/cuse.c                                   |    1 +
 fs/gfs2/file.c                                   |    2 +
 fs/hppfs/hppfs.c                                 |    1 +
 fs/hugetlbfs/inode.c                             |    1 +
 fs/logfs/dir.c                                   |    1 +
 fs/nfsd/nfsctl.c                                 |    1 +
 fs/no-block.c                                    |    1 +
 fs/notify/fanotify/fanotify_user.c               |    1 +
 fs/notify/inotify/inotify_user.c                 |    1 +
 fs/ntfs/file.c                                   |    3 +-
 fs/ocfs2/dlmfs/dlmfs.c                           |    1 +
 fs/ocfs2/stack_user.c                            |    1 +
 fs/proc/base.c                                   |    8 +++++
 fs/proc/proc_sysctl.c                            |    1 +
 fs/proc/root.c                                   |    1 +
 fs/proc/task_mmu.c                               |    1 +
 fs/romfs/super.c                                 |    1 +
 fs/signalfd.c                                    |    1 +
 fs/squashfs/dir.c                                |    3 +-
 fs/timerfd.c                                     |    1 +
 fs/ubifs/debug.c                                 |    1 +
 ipc/mqueue.c                                     |    1 +
 ipc/shm.c                                        |    2 +
 kernel/configs.c                                 |    1 +
 kernel/gcov/fs.c                                 |    1 +
 kernel/kprobes.c                                 |    1 +
 kernel/pm_qos_params.c                           |    1 +
 kernel/profile.c                                 |    1 +
 kernel/trace/blktrace.c                          |    2 +
 kernel/trace/ftrace.c                            |    2 +
 kernel/trace/ring_buffer.c                       |    1 +
 kernel/trace/trace_events.c                      |    6 ++++
 kernel/trace/trace_stack.c                       |    1 +
 lib/dma-debug.c                                  |    1 +
 net/atm/proc.c                                   |    1 +
 net/dccp/probe.c                                 |    1 +
 net/ipv4/tcp_probe.c                             |    1 +
 net/mac80211/debugfs.c                           |   19 ++++++++----
 net/mac80211/rate.c                              |    1 +
 net/mac80211/rc80211_minstrel_debugfs.c          |    1 +
 net/mac80211/rc80211_pid_debugfs.c               |    1 +
 net/netfilter/xt_recent.c                        |    1 +
 net/nonet.c                                      |    1 +
 net/rfkill/core.c                                |    1 +
 net/sctp/probe.c                                 |    1 +
 net/socket.c                                     |    1 +
 net/sunrpc/cache.c                               |    2 +
 net/wireless/debugfs.c                           |    1 +
 samples/kfifo/bytestream-example.c               |    1 +
 samples/kfifo/inttype-example.c                  |    1 +
 samples/kfifo/record-example.c                   |    1 +
 samples/tracepoints/tracepoint-sample.c          |    1 +
 security/apparmor/apparmorfs.c                   |    9 ++++--
 security/inode.c                                 |    1 +
 security/smack/smackfs.c                         |    5 +++
 sound/core/seq/oss/seq_oss.c                     |    1 +
 sound/core/sound.c                               |    3 +-
 sound/oss/msnd_pinnacle.c                        |    1 +
 sound/oss/sh_dac_audio.c                         |    1 +
 sound/soc/soc-core.c                             |    1 +
 sound/soc/soc-dapm.c                             |    1 +
 sound/sound_core.c                               |    1 +
 virt/kvm/kvm_main.c                              |    3 ++
 343 files changed, 545 insertions(+), 74 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 33c7077..5f282ab 100644
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
index f9e7cdb..ea34dea 100644
--- a/arch/arm/plat-mxc/audmux-v2.c
+++ b/arch/arm/plat-mxc/audmux-v2.c
@@ -137,6 +137,7 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
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
index a07b6d2..2ffe170 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -745,6 +745,7 @@ static const struct file_operations gpio_fops = {
 	.write          = gpio_write,
 	.open           = gpio_open,
 	.release        = gpio_release,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static void ioif_watcher(const unsigned int gpio_in_available,
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index 77a9418..a76e283 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -617,6 +617,7 @@ static const struct file_operations i2c_fops = {
 	.unlocked_ioctl	= i2c_ioctl,
 	.open		= i2c_open,
 	.release	= i2c_release,
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
index ee2dd43..308531e 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -250,7 +250,8 @@ static const struct file_operations sync_serial_fops = {
 	.poll		= sync_serial_poll,
 	.unlocked_ioctl	= sync_serial_ioctl,
 	.open		= sync_serial_open,
-	.release	= sync_serial_release
+	.release	= sync_serial_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init etrax_sync_serial_init(void)
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b07646a..7ceceaa 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -281,7 +281,8 @@ const struct file_operations cryptocop_fops = {
 	.owner		= THIS_MODULE,
 	.open		= cryptocop_open,
 	.release	= cryptocop_release,
-	.unlocked_ioctl = cryptocop_ioctl
+	.unlocked_ioctl = cryptocop_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 5a3e900..89240c9 100644
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
index 2dcd27a..16a1569 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -893,6 +893,7 @@ static const struct file_operations gpio_fops = {
 	.write		= gpio_write,
 	.open		= gpio_open,
 	.release	= gpio_release,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index 5ec8a7d..3c5441b 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -870,6 +870,7 @@ static const struct file_operations gpio_fops = {
 	.write		= gpio_write,
 	.open		= gpio_open,
 	.release	= gpio_release,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index bef6eb5..25af66d 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -60,6 +60,7 @@ static int voltage_low;
 static const struct file_operations pcf8563_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl = pcf8563_unlocked_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 unsigned char
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index ca248f3..76b17f6 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -247,7 +247,8 @@ static const struct file_operations sync_serial_fops = {
 	.poll		= sync_serial_poll,
 	.unlocked_ioctl	= sync_serial_ioctl,
 	.open		= sync_serial_open,
-	.release	= sync_serial_release
+	.release	= sync_serial_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init etrax_sync_serial_init(void)
diff --git a/arch/cris/kernel/profile.c b/arch/cris/kernel/profile.c
index 195ec5f..5339bd7 100644
--- a/arch/cris/kernel/profile.c
+++ b/arch/cris/kernel/profile.c
@@ -59,6 +59,7 @@ write_cris_profile(struct file *file, const char __user *buf,
 static const struct file_operations cris_proc_profile_operations = {
 	.read		= read_cris_profile,
 	.write		= write_cris_profile,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __init init_cris_profile(void)
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index aa8b5fa..2c612eb 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -354,6 +354,7 @@ retry:
 static const struct file_operations salinfo_event_fops = {
 	.open  = salinfo_event_open,
 	.read  = salinfo_event_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static int
@@ -571,6 +572,7 @@ static const struct file_operations salinfo_data_fops = {
 	.release = salinfo_log_release,
 	.read    = salinfo_log_read,
 	.write   = salinfo_log_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __cpuinit
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index fa1ecee..44f02e1 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -860,6 +860,7 @@ error:
 
 static const struct file_operations sn_hwperf_fops = {
 	.unlocked_ioctl = sn_hwperf_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice sn_hwperf_dev = {
diff --git a/arch/m68k/bvme6000/rtc.c b/arch/m68k/bvme6000/rtc.c
index cb8617b..825a463 100644
--- a/arch/m68k/bvme6000/rtc.c
+++ b/arch/m68k/bvme6000/rtc.c
@@ -155,6 +155,7 @@ static const struct file_operations rtc_fops = {
 	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice rtc_dev = {
diff --git a/arch/m68k/mvme16x/rtc.c b/arch/m68k/mvme16x/rtc.c
index 11ac6f6..d96c847 100644
--- a/arch/m68k/mvme16x/rtc.c
+++ b/arch/m68k/mvme16x/rtc.c
@@ -144,6 +144,7 @@ static const struct file_operations rtc_fops = {
 	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice rtc_dev=
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index 26f9b9a..ab2778e 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -468,7 +468,8 @@ static const struct file_operations rtlx_fops = {
 	.release = file_release,
 	.write =   file_write,
 	.read =    file_read,
-	.poll =    file_poll
+	.poll =    file_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct irqaction rtlx_irq = {
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 2bd2151..f76a64b 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1192,7 +1192,8 @@ static const struct file_operations vpe_fops = {
 	.owner = THIS_MODULE,
 	.open = vpe_open,
 	.release = vpe_release,
-	.write = vpe_write
+	.write = vpe_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /* module wrapper entry points */
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index d4ed7a9..fe9f590 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -545,6 +545,7 @@ static const struct file_operations sbprof_tb_fops = {
 	.unlocked_ioctl	= sbprof_tb_ioctl,
 	.compat_ioctl	= sbprof_tb_ioctl,
 	.mmap		= NULL,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct class *tb_class;
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 50362b6..c8c41fb 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -780,6 +780,7 @@ static const struct file_operations lparcfg_fops = {
 	.write		= lparcfg_write,
 	.open		= lparcfg_open,
 	.release	= single_release,
+	.llseek = seq_lseek,/* we have seq_read */
 };
 
 static int __init lparcfg_init(void)
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 67a84d8..8d151bb 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -716,6 +716,7 @@ static const struct file_operations rtas_flash_operations = {
 	.write		= rtas_flash_write,
 	.open		= rtas_excl_open,
 	.release	= rtas_flash_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations manage_flash_operations = {
@@ -724,6 +725,7 @@ static const struct file_operations manage_flash_operations = {
 	.write		= manage_flash_write,
 	.open		= rtas_excl_open,
 	.release	= rtas_excl_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations validate_flash_operations = {
@@ -732,6 +734,7 @@ static const struct file_operations validate_flash_operations = {
 	.write		= validate_flash_write,
 	.open		= rtas_excl_open,
 	.release	= validate_flash_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __init rtas_flash_init(void)
diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 638883e..e7be4a0 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -354,6 +354,7 @@ static const struct file_operations proc_rtas_log_operations = {
 	.poll =		rtas_log_poll,
 	.open =		rtas_log_open,
 	.release =	rtas_log_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static int enable_surveillance(int timeout)
diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 33e5fc7..b9a8b70 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -1249,6 +1249,7 @@ out:
 
 static const struct file_operations proc_vmlinux_operations = {
 	.write		= proc_mf_change_vmlinux,
+	.llseek = default_llseek,/* write accesses f_pos */
 };
 
 static int __init mf_proc_init(void)
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 57ddbb4..475035f 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -539,7 +539,8 @@ out:
 }
 
 static const struct file_operations ofdt_fops = {
-	.write = ofdt_write
+	.write = ofdt_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /* create /proc/powerpc/ofdt write-only by root */
diff --git a/arch/powerpc/platforms/pseries/scanlog.c b/arch/powerpc/platforms/pseries/scanlog.c
index 80e9e76..0da0d9f 100644
--- a/arch/powerpc/platforms/pseries/scanlog.c
+++ b/arch/powerpc/platforms/pseries/scanlog.c
@@ -170,6 +170,7 @@ const struct file_operations scanlog_fops = {
 	.write		= scanlog_write,
 	.open		= scanlog_open,
 	.release	= scanlog_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init scanlog_init(void)
diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index aa819da..298643b 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -152,6 +152,7 @@ static const struct file_operations prng_fops = {
 	.open		= &prng_open,
 	.release	= NULL,
 	.read		= &prng_read,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice prng_dev = {
diff --git a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
index 1211bb1..82c4723 100644
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -618,6 +618,7 @@ static const struct file_operations dbfs_d204_ops = {
 	.open		= dbfs_d204_open,
 	.read		= dbfs_d204_read,
 	.release	= dbfs_d204_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int hypfs_dbfs_init(void)
diff --git a/arch/s390/hypfs/hypfs_vm.c b/arch/s390/hypfs/hypfs_vm.c
index ee5ab1a..91f9907 100644
--- a/arch/s390/hypfs/hypfs_vm.c
+++ b/arch/s390/hypfs/hypfs_vm.c
@@ -275,6 +275,7 @@ static const struct file_operations dbfs_d2fc_ops = {
 	.open		= dbfs_d2fc_open,
 	.read		= dbfs_d2fc_read,
 	.release	= dbfs_d2fc_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 int hypfs_vm_init(void)
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 98a4a4c..2b71442 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -449,6 +449,7 @@ static const struct file_operations hypfs_file_ops = {
 	.write		= do_sync_write,
 	.aio_read	= hypfs_aio_read,
 	.aio_write	= hypfs_aio_write,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct file_system_type hypfs_type = {
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 9819226..e5d93f5 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -174,6 +174,7 @@ static const struct file_operations debug_file_ops = {
 	.write   = debug_input,
 	.open    = debug_open,
 	.release = debug_close,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct dentry *debug_debugfs_root_entry;
diff --git a/arch/sh/boards/mach-landisk/gio.c b/arch/sh/boards/mach-landisk/gio.c
index 01e6abb..2e70744 100644
--- a/arch/sh/boards/mach-landisk/gio.c
+++ b/arch/sh/boards/mach-landisk/gio.c
@@ -128,6 +128,7 @@ static const struct file_operations gio_fops = {
 	.open = gio_open,	/* open */
 	.release = gio_close,	/* release */
 	.unlocked_ioctl = gio_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __init gio_init(void)
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 2c0046e..f46ee7a 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -132,6 +132,7 @@ static const struct file_operations apc_fops = {
 	.unlocked_ioctl =	apc_ioctl,
 	.open =			apc_open,
 	.release =		apc_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice apc_miscdev = { APC_MINOR, APC_DEVNAME, &apc_fops };
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 83e85c2..329d113 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -890,6 +890,7 @@ static ssize_t mdesc_read(struct file *file, char __user *buf,
 static const struct file_operations mdesc_fops = {
 	.read	= mdesc_read,
 	.owner	= THIS_MODULE,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice mdesc_misc = {
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 584b965..71525d8 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -774,6 +774,7 @@ static const struct file_operations dev_hardwall_fops = {
 #endif
 	.flush          = hardwall_flush,
 	.release        = hardwall_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct cdev hardwall_dev;
diff --git a/arch/um/drivers/harddog_kern.c b/arch/um/drivers/harddog_kern.c
index cfcac1f..3a038c0 100644
--- a/arch/um/drivers/harddog_kern.c
+++ b/arch/um/drivers/harddog_kern.c
@@ -166,6 +166,7 @@ static const struct file_operations harddog_fops = {
 	.unlocked_ioctl	= harddog_ioctl,
 	.open		= harddog_open,
 	.release	= harddog_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice harddog_miscdev = {
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index ebc6807..63b14b6 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -843,6 +843,7 @@ static ssize_t mconsole_proc_write(struct file *file,
 static const struct file_operations mconsole_proc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= mconsole_proc_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static int create_proc_mconsole(void)
diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index 7158393..775a86b 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -93,6 +93,7 @@ static const struct file_operations mmapper_fops = {
 	.mmap		= mmapper_mmap,
 	.open		= mmapper_open,
 	.release	= mmapper_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /*
diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 4949044..c23e6b3 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -100,6 +100,7 @@ static const struct file_operations rng_chrdev_ops = {
 	.owner		= THIS_MODULE,
 	.open		= rng_dev_open,
 	.read		= rng_dev_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 /* rng_init shouldn't be called more than once at boot time */
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 4c9c67b..5dbf024 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1926,6 +1926,7 @@ static const struct file_operations apm_bios_fops = {
 	.unlocked_ioctl	= do_ioctl,
 	.open		= do_open,
 	.release	= do_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice apm_device = {
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 8a85dd1..b7c1af3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -192,6 +192,7 @@ static const struct file_operations severities_coverage_fops = {
 	.release	= seq_release,
 	.read		= seq_read,
 	.write		= severities_coverage_write,
+	.llseek = seq_lseek,/* we have seq_read */
 };
 
 static int __init severities_debugfs_init(void)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ed41562..f7324dd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1665,6 +1665,7 @@ struct file_operations mce_chrdev_ops = {
 	.read			= mce_read,
 	.poll			= mce_poll,
 	.unlocked_ioctl		= mce_ioctl,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 8afd9f3..3b50ef8 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -78,6 +78,7 @@ static int setup_data_open(struct inode *inode, struct file *file)
 static const struct file_operations fops_setup_data = {
 	.read		= setup_data_read,
 	.open		= setup_data_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __init
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fa6551d..f36c58c 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -232,6 +232,7 @@ static const struct file_operations microcode_fops = {
 	.owner			= THIS_MODULE,
 	.write			= microcode_write,
 	.open			= microcode_open,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice microcode_dev = {
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 312ef02..88ad34d 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1285,6 +1285,7 @@ static const struct file_operations tunables_fops = {
 	.open		= tunables_open,
 	.read		= tunables_read,
 	.write		= tunables_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __init uv_ptc_init(void)
diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
index 1304bce..a34bb18 100644
--- a/arch/x86/xen/debugfs.c
+++ b/arch/x86/xen/debugfs.c
@@ -106,6 +106,7 @@ static const struct file_operations u32_array_fops = {
 	.open	= u32_array_open,
 	.release= xen_array_release,
 	.read	= u32_array_read,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..22292f1 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -968,6 +968,7 @@ static const struct file_operations bsg_fops = {
 	.release	=	bsg_release,
 	.unlocked_ioctl	=	bsg_ioctl,
 	.owner		=	THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void bsg_unregister_queue(struct request_queue *q)
diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index 0e869b3..cbc9106 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -101,6 +101,7 @@ static struct file_operations acpi_ec_io_ops = {
 	.open  = acpi_ec_open_io,
 	.read  = acpi_ec_read_io,
 	.write = acpi_ec_write_io,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 int acpi_ec_add_debugfs(struct acpi_ec *ec, unsigned int ec_device_count)
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index d439314..0900ca1 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -110,6 +110,7 @@ static const struct file_operations acpi_system_event_ops = {
 	.read = acpi_system_read_event,
 	.release = acpi_system_close_event,
 	.poll = acpi_system_poll_event,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 #endif	/* CONFIG_ACPI_PROC_EVENT */
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 4e2c367..ae7c628 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -7062,7 +7062,8 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 
 static const struct file_operations DAC960_gam_fops = {
 	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= DAC960_gam_ioctl
+	.unlocked_ioctl	= DAC960_gam_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice DAC960_gam_dev = {
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 4a1b9e7..f2a5f24 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -265,6 +265,7 @@ static const struct file_operations aoe_fops = {
 	.open = aoechr_open,
 	.release = aoechr_rel,
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static char *aoe_devnode(struct device *dev, mode_t *mode)
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index c397b3d..cd7a96d 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -234,6 +234,7 @@ static const struct file_operations pg_fops = {
 	.write = pg_write,
 	.open = pg_open,
 	.release = pg_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static void pg_init_units(void)
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index bc5825f..58de287 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -239,6 +239,7 @@ static const struct file_operations pt_fops = {
 	.unlocked_ioctl = pt_ioctl,
 	.open = pt_open,
 	.release = pt_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /* sysfs class support */
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b1cbeb5..bffef7e 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -3046,6 +3046,7 @@ static const struct file_operations pkt_ctl_fops = {
 	.compat_ioctl	= pkt_ctl_compat_ioctl,
 #endif
 	.owner		= THIS_MODULE,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static struct miscdevice pkt_misc = {
diff --git a/drivers/bluetooth/btmrvl_debugfs.c b/drivers/bluetooth/btmrvl_debugfs.c
index 54739b0..c25df43 100644
--- a/drivers/bluetooth/btmrvl_debugfs.c
+++ b/drivers/bluetooth/btmrvl_debugfs.c
@@ -92,6 +92,7 @@ static const struct file_operations btmrvl_hscfgcmd_fops = {
 	.read	= btmrvl_hscfgcmd_read,
 	.write	= btmrvl_hscfgcmd_write,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_psmode_write(struct file *file, const char __user *ubuf,
@@ -130,6 +131,7 @@ static const struct file_operations btmrvl_psmode_fops = {
 	.read	= btmrvl_psmode_read,
 	.write	= btmrvl_psmode_write,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_pscmd_write(struct file *file, const char __user *ubuf,
@@ -173,6 +175,7 @@ static const struct file_operations btmrvl_pscmd_fops = {
 	.read = btmrvl_pscmd_read,
 	.write = btmrvl_pscmd_write,
 	.open = btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_gpiogap_write(struct file *file, const char __user *ubuf,
@@ -211,6 +214,7 @@ static const struct file_operations btmrvl_gpiogap_fops = {
 	.read	= btmrvl_gpiogap_read,
 	.write	= btmrvl_gpiogap_write,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_hscmd_write(struct file *file, const char __user *ubuf,
@@ -252,6 +256,7 @@ static const struct file_operations btmrvl_hscmd_fops = {
 	.read	= btmrvl_hscmd_read,
 	.write	= btmrvl_hscmd_write,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_hsmode_write(struct file *file, const char __user *ubuf,
@@ -289,6 +294,7 @@ static const struct file_operations btmrvl_hsmode_fops = {
 	.read	= btmrvl_hsmode_read,
 	.write	= btmrvl_hsmode_write,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_curpsmode_read(struct file *file, char __user *userbuf,
@@ -306,6 +312,7 @@ static ssize_t btmrvl_curpsmode_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_curpsmode_fops = {
 	.read	= btmrvl_curpsmode_read,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_psstate_read(struct file *file, char __user * userbuf,
@@ -323,6 +330,7 @@ static ssize_t btmrvl_psstate_read(struct file *file, char __user * userbuf,
 static const struct file_operations btmrvl_psstate_fops = {
 	.read	= btmrvl_psstate_read,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_hsstate_read(struct file *file, char __user *userbuf,
@@ -340,6 +348,7 @@ static ssize_t btmrvl_hsstate_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_hsstate_fops = {
 	.read	= btmrvl_hsstate_read,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t btmrvl_txdnldready_read(struct file *file, char __user *userbuf,
@@ -358,6 +367,7 @@ static ssize_t btmrvl_txdnldready_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_txdnldready_fops = {
 	.read	= btmrvl_txdnldready_read,
 	.open	= btmrvl_open_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void btmrvl_debugfs_init(struct hci_dev *hdev)
diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 3aa7b2a..f82c640 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -282,6 +282,7 @@ static const struct file_operations vhci_fops = {
 	.poll		= vhci_poll,
 	.open		= vhci_open,
 	.release	= vhci_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice vhci_miscdev= {
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 033e150..51c41aa 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -402,6 +402,7 @@ static const struct file_operations apm_bios_fops = {
 	.unlocked_ioctl	= apm_ioctl,
 	.open		= apm_open,
 	.release	= apm_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice apm_device = {
diff --git a/drivers/char/bfin-otp.c b/drivers/char/bfin-otp.c
index 836d4f0..53e55c4 100644
--- a/drivers/char/bfin-otp.c
+++ b/drivers/char/bfin-otp.c
@@ -222,6 +222,7 @@ static const struct file_operations bfin_otp_fops = {
 	.unlocked_ioctl = bfin_otp_ioctl,
 	.read           = bfin_otp_read,
 	.write          = bfin_otp_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct miscdevice bfin_otp_misc_device = {
diff --git a/drivers/char/briq_panel.c b/drivers/char/briq_panel.c
index d5fa113..ffd008d 100644
--- a/drivers/char/briq_panel.c
+++ b/drivers/char/briq_panel.c
@@ -186,6 +186,7 @@ static const struct file_operations briq_panel_fops = {
 	.write		= briq_panel_write,
 	.open		= briq_panel_open,
 	.release	= briq_panel_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice briq_panel_miscdev = {
diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 9191713..84cc95a 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -155,6 +155,7 @@ static const struct file_operations bsr_fops = {
 	.owner = THIS_MODULE,
 	.mmap  = bsr_mmap,
 	.open  = bsr_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static void bsr_cleanup_devs(void)
diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index 4d830dc..b16c977 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -169,7 +169,8 @@ static const struct file_operations cs5535_gpio_fops = {
 	.owner	= THIS_MODULE,
 	.write	= cs5535_gpio_write,
 	.read	= cs5535_gpio_read,
-	.open	= cs5535_gpio_open
+	.open	= cs5535_gpio_open,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int __init cs5535_gpio_init(void)
diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index 170693c..b5e87ff 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -288,6 +288,7 @@ get_rtc_status(char *buf)
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= rtc_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* Probe for the chip by writing something to its RAM and try reading it back. */
diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index dbee868..91f0583 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -357,6 +357,7 @@ static const struct file_operations ds1620_fops = {
 	.open		= ds1620_open,
 	.read		= ds1620_read,
 	.unlocked_ioctl	= ds1620_unlocked_ioctl,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice ds1620_miscdev = {
diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index 8a1b28a..f6d23b2 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -482,6 +482,7 @@ static const struct file_operations dsp56k_fops = {
 	.unlocked_ioctl	= dsp56k_ioctl,
 	.open		= dsp56k_open,
 	.release	= dsp56k_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 
diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index e3859d4..4c24123 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -105,6 +105,7 @@ static const struct file_operations dtlk_fops =
 	.unlocked_ioctl	= dtlk_ioctl,
 	.open		= dtlk_open,
 	.release	= dtlk_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /* local prototypes */
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index b6c2cc1..b68a038 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -497,6 +497,7 @@ static const struct file_operations gen_rtc_fops = {
 	.unlocked_ioctl	= gen_rtc_unlocked_ioctl,
 	.open		= gen_rtc_open,
 	.release	= gen_rtc_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice rtc_gen_dev =
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 3d9c61e..46918bd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -170,6 +170,7 @@ static const struct file_operations rng_chrdev_ops = {
 	.owner		= THIS_MODULE,
 	.open		= rng_dev_open,
 	.read		= rng_dev_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice rng_miscdev = {
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index d4b71e8..693b89b 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -236,6 +236,7 @@ static const struct file_operations ip2_ipl = {
 	.write		= ip2_ipl_write,
 	.unlocked_ioctl	= ip2_ipl_ioctl,
 	.open		= ip2_ipl_open,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 }; 
 
 static unsigned long irq_counter;
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index d8ec92a..ba253e9 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -850,6 +850,7 @@ static const struct file_operations ipmi_fops = {
 	.release	= ipmi_release,
 	.fasync		= ipmi_fasync,
 	.poll		= ipmi_poll,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 #define DEVICE_NAME     "ipmidev"
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 654d566..66d1d3e 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -909,6 +909,7 @@ static const struct file_operations ipmi_wdog_fops = {
 	.open    = ipmi_open,
 	.release = ipmi_close,
 	.fasync  = ipmi_fasync,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice ipmi_wdog_miscdev = {
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index be28391..d25b085 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -704,6 +704,7 @@ static const struct file_operations	stli_fsiomem = {
 	.read		= stli_memread,
 	.write		= stli_memwrite,
 	.unlocked_ioctl	= stli_memioctl,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /*****************************************************************************/
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 938a3a2..1192f9d 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -748,6 +748,7 @@ static const struct file_operations lp_fops = {
 #ifdef CONFIG_PARPORT_1284
 	.read		= lp_read,
 #endif
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /* --- support for console on the line printer ----------------- */
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a398ecd..3a7ad8b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -804,6 +804,7 @@ static const struct file_operations full_fops = {
 static const struct file_operations oldmem_fops = {
 	.read	= read_oldmem,
 	.open	= open_oldmem,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 #endif
 
@@ -830,6 +831,7 @@ static ssize_t kmsg_write(struct file *file, const char __user *buf,
 
 static const struct file_operations kmsg_fops = {
 	.write = kmsg_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static const struct memdev {
@@ -881,6 +883,7 @@ static int memory_open(struct inode *inode, struct file *filp)
 
 static const struct file_operations memory_fops = {
 	.open = memory_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static char *mem_devnode(struct device *dev, mode_t *mode)
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index abdafd4..c75196d 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -162,6 +162,7 @@ static struct class *misc_class;
 static const struct file_operations misc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= misc_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /**
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index ea7c99f..2ff746b 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -72,6 +72,7 @@ static const struct file_operations mmtimer_fops = {
 	.owner = THIS_MODULE,
 	.mmap =	mmtimer_mmap,
 	.unlocked_ioctl = mmtimer_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index ecb89d7..2168bf2 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -316,7 +316,8 @@ uncached_mmap(struct file *file, struct vm_area_struct *vma)
 
 static const struct file_operations fetchop_fops = {
 	.owner = THIS_MODULE,
-	.mmap = fetchop_mmap
+	.mmap = fetchop_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice fetchop_miscdev = {
@@ -327,7 +328,8 @@ static struct miscdevice fetchop_miscdev = {
 
 static const struct file_operations cached_fops = {
 	.owner = THIS_MODULE,
-	.mmap = cached_mmap
+	.mmap = cached_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice cached_miscdev = {
@@ -338,7 +340,8 @@ static struct miscdevice cached_miscdev = {
 
 static const struct file_operations uncached_fops = {
 	.owner = THIS_MODULE,
-	.mmap = uncached_mmap
+	.mmap = uncached_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice uncached_miscdev = {
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index a4ec50c..0e20d32 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -479,7 +479,8 @@ static const struct file_operations mwave_fops = {
 	.write		= mwave_write,
 	.unlocked_ioctl	= mwave_ioctl,
 	.open		= mwave_open,
-	.release	= mwave_close
+	.release	= mwave_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 2604246..fcf7c21 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -182,6 +182,7 @@ static int button_read (struct file *filp, char __user *buffer,
 static const struct file_operations button_fops = {
 	.owner		= THIS_MODULE,
 	.read		= button_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 /* 
diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index 8ecbcc1..a93a0f7 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -234,6 +234,7 @@ static const struct file_operations pc8736x_gpio_fileops = {
 	.open	= pc8736x_gpio_open,
 	.write	= nsc_gpio_write,
 	.read	= nsc_gpio_read,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static void __init pc8736x_init_shadow(void)
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index ec73d9f..04bc3ba 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1880,6 +1880,7 @@ static const struct file_operations cm4000_fops = {
 	.unlocked_ioctl	= cmm_ioctl,
 	.open	= cmm_open,
 	.release= cmm_close,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct pcmcia_device_id cm4000_ids[] = {
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 815cde1..6385ad8 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -650,6 +650,7 @@ static const struct file_operations reader_fops = {
 	.open		= cm4040_open,
 	.release	= cm4040_close,
 	.poll		= cm4040_poll,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct pcmcia_device_id cm4040_ids[] = {
diff --git a/drivers/char/random.c b/drivers/char/random.c
index caef35a..3dbd4f2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1165,6 +1165,7 @@ const struct file_operations random_fops = {
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 const struct file_operations urandom_fops = {
@@ -1172,6 +1173,7 @@ const struct file_operations urandom_fops = {
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /***************************************************************
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index d58c2eb..9a2eb57 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -241,6 +241,7 @@ static struct real_driver rio_real_driver = {
 static const struct file_operations rio_fw_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = rio_fw_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice rio_fw_device = {
diff --git a/drivers/char/scx200_gpio.c b/drivers/char/scx200_gpio.c
index 99e5272..9574028 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -67,6 +67,7 @@ static const struct file_operations scx200_gpio_fileops = {
 	.read    = nsc_gpio_read,
 	.open    = scx200_gpio_open,
 	.release = scx200_gpio_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct cdev scx200_gpio_cdev;  /* use 1 cdev for all pins */
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 32b74de..6be49e9 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -357,6 +357,7 @@ static const struct file_operations scdrv_fops = {
 	.poll =		scdrv_poll,
 	.open =		scdrv_open,
 	.release =	scdrv_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct class *snsc_class;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index f2167f8..f0cd08b 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -608,6 +608,7 @@ static unsigned int	sc26198_baudtable[] = {
 static const struct file_operations	stl_fsiomem = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= stl_memioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct class *stallion_class;
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 5b24db4..a172543 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -397,6 +397,7 @@ static struct real_driver sx_real_driver = {
 static const struct file_operations sx_fw_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = sx_fw_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice sx_fw_device = {
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index ef31bb8..a2ab218 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -772,6 +772,7 @@ static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
 
 static const struct file_operations proc_sysrq_trigger_operations = {
 	.write		= write_sysrq_trigger,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static void sysrq_init_procfs(void)
diff --git a/drivers/char/tb0219.c b/drivers/char/tb0219.c
index cad4eb6..789e9df 100644
--- a/drivers/char/tb0219.c
+++ b/drivers/char/tb0219.c
@@ -261,6 +261,7 @@ static const struct file_operations tb0219_fops = {
 	.write		= tanbac_tb0219_write,
 	.open		= tanbac_tb0219_open,
 	.release	= tanbac_tb0219_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static void tb0219_restart(char *command)
diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 80ea6bc..ae792f1 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -268,6 +268,7 @@ static const struct file_operations tlclk_fops = {
 	.open = tlclk_open,
 	.release = tlclk_release,
 
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice tlclk_miscdev = {
diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index f8bc79f..34734d5 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -95,6 +95,7 @@ static long tosh_ioctl(struct file *, unsigned int,
 static const struct file_operations tosh_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= tosh_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice tosh_device = {
diff --git a/drivers/char/uv_mmtimer.c b/drivers/char/uv_mmtimer.c
index c7072ba..9aef403 100644
--- a/drivers/char/uv_mmtimer.c
+++ b/drivers/char/uv_mmtimer.c
@@ -52,6 +52,7 @@ static const struct file_operations uv_mmtimer_fops = {
 	.owner = THIS_MODULE,
 	.mmap =	uv_mmtimer_mmap,
 	.unlocked_ioctl = uv_mmtimer_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /**
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 942a982..524907b 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -728,6 +728,7 @@ static const struct file_operations port_fops = {
 	.write = port_fops_write,
 	.poll  = port_fops_poll,
 	.release = port_fops_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /*
@@ -949,6 +950,7 @@ static const struct file_operations port_debugfs_ops = {
 	.owner = THIS_MODULE,
 	.open  = debugfs_open,
 	.read  = debugfs_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void set_console_size(struct port *port, u16 rows, u16 cols)
@@ -1477,6 +1479,7 @@ fail:
 
 static const struct file_operations portdev_fops = {
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index b663d57..6ec6735 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -567,6 +567,7 @@ static const struct file_operations hwicap_fops = {
 	.read = hwicap_read,
 	.open = hwicap_open,
 	.release = hwicap_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __devinit hwicap_setup(struct device *dev, int id,
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 557e227..be80c43 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -157,6 +157,7 @@ static const struct file_operations coh901318_debugfs_status_operations = {
 	.owner		= THIS_MODULE,
 	.open		= coh901318_debugfs_open,
 	.read		= coh901318_debugfs_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 8528b10..8b693c4 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -405,6 +405,7 @@ static const struct file_operations nosy_ops = {
 	.poll =			nosy_poll,
 	.open =			nosy_open,
 	.release =		nosy_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 #define PHY_PACKET_SIZE 12 /* 1 payload, 1 inverse, 1 ack = 3 quadlets */
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 84da748..17b666e 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -284,7 +284,8 @@ EXPORT_SYMBOL(drm_exit);
 /** File operations structure */
 static const struct file_operations drm_stub_fops = {
 	.owner = THIS_MODULE,
-	.open = drm_stub_open
+	.open = drm_stub_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __init drm_core_init(void)
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index 61b4caf..73828f0 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -119,6 +119,7 @@ static const struct file_operations i810_buffer_fops = {
 	.unlocked_ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
 	.fasync = drm_fasync,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int i810_map_buffer(struct drm_buf *buf, struct drm_file *file_priv)
diff --git a/drivers/gpu/drm/i830/i830_dma.c b/drivers/gpu/drm/i830/i830_dma.c
index 671aa18..72d2f24 100644
--- a/drivers/gpu/drm/i830/i830_dma.c
+++ b/drivers/gpu/drm/i830/i830_dma.c
@@ -121,6 +121,7 @@ static const struct file_operations i830_buffer_fops = {
 	.unlocked_ioctl = drm_ioctl,
 	.mmap = i830_mmap_buffers,
 	.fasync = drm_fasync,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int i830_map_buffer(struct drm_buf *buf, struct drm_file *file_priv)
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 92d5605..d484405 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -733,6 +733,7 @@ static const struct file_operations i915_wedged_fops = {
 	.open = i915_wedged_open,
 	.read = i915_wedged_read,
 	.write = i915_wedged_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /* As the drm_debugfs_init() routines are called before dev->dev_private is
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index b87569e..329f4df 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -1211,6 +1211,7 @@ static const struct file_operations vga_arb_device_fops = {
 	.poll = vga_arb_fpoll,
 	.open = vga_arb_open,
 	.release = vga_arb_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice vga_arb_device = {
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 850d02a..f1151a9 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -1051,6 +1051,7 @@ static const struct file_operations hid_debug_events_fops = {
 	.read           = hid_debug_events_read,
 	.poll		= hid_debug_events_poll,
 	.release        = hid_debug_events_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index f6e80c7..96c46e3 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -384,6 +384,7 @@ static const struct file_operations roccat_ops = {
 	.poll = roccat_poll,
 	.open = roccat_open,
 	.release = roccat_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static int __init roccat_init(void)
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 47d70c5..0615e2c 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -329,6 +329,7 @@ static const struct file_operations hidraw_ops = {
 	.open =         hidraw_open,
 	.release =      hidraw_release,
 	.unlocked_ioctl = hidraw_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 0a29c51..76cbfac 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -847,6 +847,7 @@ static const struct file_operations hiddev_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= hiddev_compat_ioctl,
 #endif
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static char *hiddev_devnode(struct device *dev, mode_t *mode)
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 653db1b..ef82ed2 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -762,6 +762,7 @@ static const struct file_operations atk_debugfs_ggrp_fops = {
 	.read		= atk_debugfs_ggrp_read,
 	.open		= atk_debugfs_ggrp_open,
 	.release	= atk_debugfs_ggrp_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static void atk_debugfs_init(struct atk_data *data)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6d622cb..691d1c3 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1903,6 +1903,7 @@ static const struct file_operations idetape_fops = {
 	.unlocked_ioctl	= idetape_chrdev_ioctl,
 	.open		= idetape_chrdev_open,
 	.release	= idetape_chrdev_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int idetape_open(struct block_device *bdev, fmode_t mode)
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index 15341fc..bc59930 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -536,6 +536,7 @@ static ssize_t stats_read_ul(struct file *fp, char __user *ubuf, size_t count,
 static const struct file_operations idle_fops = {
 	.open	= stats_open_generic,
 	.read	= stats_read_ul,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 struct debugfs_file_info {
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 9bbf491..308498c 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -186,6 +186,7 @@ static const struct file_operations qp_debugfs_fops = {
 	.open    = qp_open,
 	.release = qp_release,
 	.read    = qp_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int setup_debugfs(struct c4iw_dev *devp)
diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index d4ce8b6..ad76f68 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -65,7 +65,8 @@ static const struct file_operations diag_file_ops = {
 	.write = ipath_diag_write,
 	.read = ipath_diag_read,
 	.open = ipath_diag_open,
-	.release = ipath_diag_release
+	.release = ipath_diag_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t ipath_diagpkt_write(struct file *fp,
@@ -75,6 +76,7 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 static const struct file_operations diagpkt_file_ops = {
 	.owner = THIS_MODULE,
 	.write = ipath_diagpkt_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static atomic_t diagpkt_count = ATOMIC_INIT(0);
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 65eb892..69c1dcc 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -63,7 +63,8 @@ static const struct file_operations ipath_file_ops = {
 	.open = ipath_open,
 	.release = ipath_close,
 	.poll = ipath_poll,
-	.mmap = ipath_mmap
+	.mmap = ipath_mmap,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /*
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 2fca708..3ce1f68 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -103,6 +103,7 @@ static ssize_t atomic_stats_read(struct file *file, char __user *buf,
 
 static const struct file_operations atomic_stats_ops = {
 	.read = atomic_stats_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t atomic_counters_read(struct file *file, char __user *buf,
@@ -120,6 +121,7 @@ static ssize_t atomic_counters_read(struct file *file, char __user *buf,
 
 static const struct file_operations atomic_counters_ops = {
 	.read = atomic_counters_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t flash_read(struct file *file, char __user *buf,
@@ -224,6 +226,7 @@ bail:
 static const struct file_operations flash_ops = {
 	.read = flash_read,
 	.write = flash_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int create_device_files(struct super_block *sb,
diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index 05dcf0d..edd941d 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -136,7 +136,8 @@ static const struct file_operations diag_file_ops = {
 	.write = qib_diag_write,
 	.read = qib_diag_read,
 	.open = qib_diag_open,
-	.release = qib_diag_release
+	.release = qib_diag_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static atomic_t diagpkt_count = ATOMIC_INIT(0);
@@ -149,6 +150,7 @@ static ssize_t qib_diagpkt_write(struct file *fp, const char __user *data,
 static const struct file_operations diagpkt_file_ops = {
 	.owner = THIS_MODULE,
 	.write = qib_diagpkt_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 int qib_diag_add(struct qib_devdata *dd)
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 6b11645..cfc8281 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -63,7 +63,8 @@ static const struct file_operations qib_file_ops = {
 	.open = qib_open,
 	.release = qib_close,
 	.poll = qib_poll,
-	.mmap = qib_mmapf
+	.mmap = qib_mmapf,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 9f989c0..c11f205 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -367,6 +367,7 @@ bail:
 static const struct file_operations flash_ops = {
 	.read = flash_read,
 	.write = flash_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int add_cntr_files(struct super_block *sb, struct qib_devdata *dd)
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c908c5f..a52c81d 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -761,7 +761,8 @@ static const struct file_operations evdev_fops = {
 	.compat_ioctl	= evdev_ioctl_compat,
 #endif
 	.fasync		= evdev_fasync,
-	.flush		= evdev_flush
+	.flush		= evdev_flush,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int evdev_install_chrdev(struct evdev *evdev)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index a9b025f..3457a48 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2040,6 +2040,7 @@ out:
 static const struct file_operations input_fops = {
 	.owner = THIS_MODULE,
 	.open = input_open_file,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __init input_init(void)
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index d85bd8a..9ea2072 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -736,6 +736,7 @@ static const struct file_operations joydev_fops = {
 	.compat_ioctl	= joydev_compat_ioctl,
 #endif
 	.fasync		= joydev_fasync,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int joydev_install_chrdev(struct joydev *joydev)
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 0d4266a..5afdf2f 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -804,6 +804,7 @@ static const struct file_operations uinput_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= uinput_compat_ioctl,
 #endif
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice uinput_misc = {
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index d528a2d..830d997 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -792,6 +792,7 @@ static const struct file_operations mousedev_fops = {
 	.open =		mousedev_open,
 	.release =	mousedev_release,
 	.fasync =	mousedev_fasync,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int mousedev_install_chrdev(struct mousedev *mousedev)
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 9986648..c14fd53 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -243,6 +243,7 @@ static const struct file_operations serio_raw_fops = {
 	.write =	serio_raw_write,
 	.poll =		serio_raw_poll,
 	.fasync =	serio_raw_fasync,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index de43c8c..502a5fb 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -267,6 +267,7 @@ static const struct file_operations mISDN_fops = {
 	.unlocked_ioctl	= mISDN_ioctl,
 	.open		= mISDN_open,
 	.release	= mISDN_close,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice mISDNtimer = {
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 85b714d..8d71d43 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -514,6 +514,7 @@ static const struct file_operations lguest_fops = {
 	.release = close,
 	.write	 = write,
 	.read	 = read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /*
diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
index a3d25da..d4559e0 100644
--- a/drivers/macintosh/ans-lcd.c
+++ b/drivers/macintosh/ans-lcd.c
@@ -137,6 +137,7 @@ const struct file_operations anslcd_fops = {
 	.write		= anslcd_write,
 	.unlocked_ioctl	= anslcd_ioctl,
 	.open		= anslcd_open,
+	.llseek = default_llseek,/* write accesses f_pos */
 };
 
 static struct miscdevice anslcd_dev = {
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 2d17e76..b0a0c0d 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2398,6 +2398,7 @@ static const struct file_operations pmu_device_fops = {
 #endif
 	.open		= pmu_open,
 	.release	= pmu_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice pmu_device = {
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 3e39193..04001e8 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1596,6 +1596,7 @@ static const struct file_operations _ctl_fops = {
 	.unlocked_ioctl	 = dm_ctl_ioctl,
 	.compat_ioctl = dm_compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice _dm_misc = {
diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index c185422..0fb2de2 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -151,7 +151,8 @@ static const struct file_operations vfd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= &display_open,
 	.write		= &vfd_write,
-	.release	= &display_close
+	.release	= &display_close,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* lcd character device file operations */
@@ -159,7 +160,8 @@ static const struct file_operations lcd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= &display_open,
 	.write		= &lcd_write,
-	.release	= &display_close
+	.release	= &display_close,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 enum {
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 5b145e8..f6d571f 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -163,6 +163,7 @@ static struct file_operations fops = {
 	.unlocked_ioctl	= lirc_dev_fop_ioctl,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int lirc_cdev_add(struct irctl *ir)
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index cf87051..a0cd66c 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -694,7 +694,8 @@ static const struct file_operations dst_ca_fops = {
 	.open = dst_ca_open,
 	.release = dst_ca_release,
 	.read = dst_ca_read,
-	.write = dst_ca_write
+	.write = dst_ca_write,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct dvb_device dvbdev_ca = {
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 0042306..fc607eb 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -1150,6 +1150,7 @@ static const struct file_operations dvb_demux_fops = {
 	.open = dvb_demux_open,
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct dvb_device dvbdev_demux = {
@@ -1225,6 +1226,7 @@ static const struct file_operations dvb_dvr_fops = {
 	.open = dvb_dvr_open,
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct dvb_device dvbdev_dvr = {
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index cb97e6b..1da67f4 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1628,6 +1628,7 @@ static const struct file_operations dvb_ca_fops = {
 	.open = dvb_ca_en50221_io_open,
 	.release = dvb_ca_en50221_io_release,
 	.poll = dvb_ca_en50221_io_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct dvb_device dvbdev_ca = {
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4d45b7d..a2e3d33 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -2034,7 +2034,8 @@ static const struct file_operations dvb_frontend_fops = {
 	.unlocked_ioctl	= dvb_generic_ioctl,
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
-	.release	= dvb_frontend_release
+	.release	= dvb_frontend_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 int dvb_register_frontend(struct dvb_adapter* dvb,
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 6c3a8a0..283ca66 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1475,6 +1475,7 @@ static const struct file_operations dvb_net_fops = {
 	.unlocked_ioctl = dvb_net_ioctl,
 	.open =	dvb_generic_open,
 	.release = dvb_net_close,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct dvb_device dvbdev_net = {
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index b915c39..99b06a4 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -105,6 +105,7 @@ static const struct file_operations dvb_device_fops =
 {
 	.owner =	THIS_MODULE,
 	.open =		dvb_device_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct cdev dvb_device_cdev;
diff --git a/drivers/media/dvb/firewire/firedtv-ci.c b/drivers/media/dvb/firewire/firedtv-ci.c
index d3c2cf6..02e487b 100644
--- a/drivers/media/dvb/firewire/firedtv-ci.c
+++ b/drivers/media/dvb/firewire/firedtv-ci.c
@@ -220,6 +220,7 @@ static const struct file_operations fdtv_ca_fops = {
 	.open		= dvb_generic_open,
 	.release	= dvb_generic_release,
 	.poll		= fdtv_ca_io_poll,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct dvb_device fdtv_ca = {
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index a6be529..98b2b58 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -730,6 +730,7 @@ static const struct file_operations dvb_osd_fops = {
 	.unlocked_ioctl	= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
 	.release	= dvb_generic_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct dvb_device dvbdev_osd = {
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 13efba9..e45904d 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -1521,6 +1521,7 @@ static const struct file_operations dvb_video_fops = {
 	.open		= dvb_video_open,
 	.release	= dvb_video_release,
 	.poll		= dvb_video_poll,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static struct dvb_device dvbdev_video = {
@@ -1539,6 +1540,7 @@ static const struct file_operations dvb_audio_fops = {
 	.open		= dvb_audio_open,
 	.release	= dvb_audio_release,
 	.poll		= dvb_audio_poll,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static struct dvb_device dvbdev_audio = {
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index 4eba35a..2612c60 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -353,6 +353,7 @@ static const struct file_operations dvb_ca_fops = {
 	.open		= dvb_ca_open,
 	.release	= dvb_generic_release,
 	.poll		= dvb_ca_poll,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct dvb_device dvbdev_ca = {
diff --git a/drivers/media/dvb/ttpci/av7110_ir.c b/drivers/media/dvb/ttpci/av7110_ir.c
index b070e88..7cafbc3 100644
--- a/drivers/media/dvb/ttpci/av7110_ir.c
+++ b/drivers/media/dvb/ttpci/av7110_ir.c
@@ -312,6 +312,7 @@ static ssize_t av7110_ir_proc_write(struct file *file, const char __user *buffer
 static const struct file_operations av7110_ir_proc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= av7110_ir_proc_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /* interrupt handler */
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 66379b4..9c82923 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -583,6 +583,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 static const struct file_operations ab3100_get_set_reg_fops = {
 	.open = ab3100_get_set_reg_open_file,
 	.write = ab3100_get_set_reg,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static struct dentry *ab3100_dir;
diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 557a8c2..c74e71e 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -640,6 +640,7 @@ static const struct file_operations ilo_fops = {
 	.poll		= ilo_poll,
 	.open 		= ilo_open,
 	.release 	= ilo_close,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static irqreturn_t ilo_isr(int irq, void *data)
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 75ee0d3..b6e63ab 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -279,6 +279,7 @@ static const struct file_operations phantom_file_ops = {
 	.unlocked_ioctl = phantom_ioctl,
 	.compat_ioctl = phantom_compat_ioctl,
 	.poll = phantom_poll,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static irqreturn_t phantom_isr(int irq, void *data)
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index cb3b4d2..d84450e 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -587,6 +587,7 @@ static const struct file_operations gru_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= gru_file_unlocked_ioctl,
 	.mmap		= gru_file_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice gru_miscdev = {
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 53cb380..21f8b46 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -245,6 +245,7 @@ static const struct file_operations mmc_dbg_ext_csd_fops = {
 	.open		= mmc_ext_csd_open,
 	.read		= mmc_ext_csd_read,
 	.release	= mmc_ext_csd_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void mmc_add_card_debugfs(struct mmc_card *card)
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 4dfa6b9..f0d30cc 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -1100,4 +1100,5 @@ const struct file_operations ubi_ctrl_cdev_operations = {
 	.owner          = THIS_MODULE,
 	.unlocked_ioctl = ctrl_cdev_ioctl,
 	.compat_ioctl   = ctrl_cdev_compat_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index f5058ff..2da9387 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -240,13 +240,15 @@ static ssize_t dbgfs_frame(struct file *file, char __user *user_buf,
 static const struct file_operations dbgfs_state_fops = {
 	.open = dbgfs_open,
 	.read = dbgfs_state,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations dbgfs_frame_fops = {
 	.open = dbgfs_open,
 	.read = dbgfs_frame,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static inline void dev_debugfs_add(struct cfspi *cfspi)
diff --git a/drivers/net/cxgb4/cxgb4_main.c b/drivers/net/cxgb4/cxgb4_main.c
index c327527..95058a4 100644
--- a/drivers/net/cxgb4/cxgb4_main.c
+++ b/drivers/net/cxgb4/cxgb4_main.c
@@ -2026,6 +2026,7 @@ static const struct file_operations mem_debugfs_fops = {
 	.owner   = THIS_MODULE,
 	.open    = mem_open,
 	.read    = mem_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void __devinit add_debugfs_mem(struct adapter *adap, const char *name,
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 6695a51..c34cac9 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -856,7 +856,8 @@ static const struct file_operations ppp_device_fops = {
 	.poll		= ppp_poll,
 	.unlocked_ioctl	= ppp_ioctl,
 	.open		= ppp_open,
-	.release	= ppp_release
+	.release	= ppp_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static __net_init int ppp_init_net(struct net *net)
diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index b1aec3e..ac04c31 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -119,6 +119,7 @@ const struct file_operations i2400m_rx_stats_fops = {
 	.open =		i2400m_stats_open,
 	.read =		i2400m_rx_stats_read,
 	.write =	i2400m_rx_stats_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -171,6 +172,7 @@ const struct file_operations i2400m_tx_stats_fops = {
 	.open =		i2400m_stats_open,
 	.read =		i2400m_tx_stats_read,
 	.write =	i2400m_tx_stats_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 1d05445..8a611b1 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4430,21 +4430,24 @@ static const struct file_operations proc_statsdelta_ops = {
 	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_statsdelta_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_stats_ops = {
 	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_stats_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_status_ops = {
 	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_status_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_SSID_ops = {
@@ -4452,7 +4455,8 @@ static const struct file_operations proc_SSID_ops = {
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_SSID_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_BSSList_ops = {
@@ -4460,7 +4464,8 @@ static const struct file_operations proc_BSSList_ops = {
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_BSSList_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_APList_ops = {
@@ -4468,7 +4473,8 @@ static const struct file_operations proc_APList_ops = {
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_APList_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_config_ops = {
@@ -4476,7 +4482,8 @@ static const struct file_operations proc_config_ops = {
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_config_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_wepkey_ops = {
@@ -4484,7 +4491,8 @@ static const struct file_operations proc_wepkey_ops = {
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_wepkey_open,
-	.release	= proc_close
+	.release	= proc_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct proc_dir_entry *airo_entry;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 4cccc29..ec386b1 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -271,6 +271,7 @@ static const struct file_operations fops_beacon = {
 	.write = write_file_beacon,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -290,6 +291,7 @@ static const struct file_operations fops_reset = {
 	.write = write_file_reset,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 
@@ -369,6 +371,7 @@ static const struct file_operations fops_debug = {
 	.write = write_file_debug,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -480,6 +483,7 @@ static const struct file_operations fops_antenna = {
 	.write = write_file_antenna,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -591,6 +595,7 @@ static const struct file_operations fops_frameerrors = {
 	.write = write_file_frameerrors,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -748,6 +753,7 @@ static const struct file_operations fops_ani = {
 	.write = write_file_ani,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -811,6 +817,7 @@ static const struct file_operations fops_queue = {
 	.write = write_file_queue,
 	.open = ath5k_debugfs_open,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 54aae93..2476570 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -71,7 +71,8 @@ static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #endif
@@ -116,7 +117,8 @@ static const struct file_operations fops_tx_chainmask = {
 	.read = read_file_tx_chainmask,
 	.write = write_file_tx_chainmask,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -158,7 +160,8 @@ static const struct file_operations fops_rx_chainmask = {
 	.read = read_file_rx_chainmask,
 	.write = write_file_rx_chainmask,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -259,7 +262,8 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 static const struct file_operations fops_dma = {
 	.read = read_file_dma,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -375,7 +379,8 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 static const struct file_operations fops_interrupt = {
 	.read = read_file_interrupt,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void ath_debug_stat_rc(struct ath_softc *sc, int final_rate)
@@ -464,7 +469,8 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 static const struct file_operations fops_rcstat = {
 	.read = read_file_rcstat,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
@@ -623,7 +629,8 @@ static const struct file_operations fops_wiphy = {
 	.read = read_file_wiphy,
 	.write = write_file_wiphy,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #define PR(str, elem)							\
@@ -702,7 +709,8 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
 static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
@@ -814,7 +822,8 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 static const struct file_operations fops_recv = {
 	.read = read_file_recv,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
@@ -852,7 +861,8 @@ static const struct file_operations fops_regidx = {
 	.read = read_file_regidx,
 	.write = write_file_regidx,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t read_file_regval(struct file *file, char __user *user_buf,
@@ -894,7 +904,8 @@ static const struct file_operations fops_regval = {
 	.read = read_file_regval,
 	.write = write_file_regval,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 int ath9k_init_debug(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7d09b4b..a4f4ec7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -536,7 +536,8 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 static const struct file_operations fops_tgt_stats = {
 	.read = read_file_tgt_stats,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
@@ -584,7 +585,8 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
@@ -613,7 +615,8 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 static const struct file_operations fops_recv = {
 	.read = read_file_recv,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 int ath9k_htc_init_debug(struct ath_hw *ah)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 8e84a08..5f59bf5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -873,6 +873,7 @@ static ssize_t iwl3945_sta_dbgfs_stats_table_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = iwl3945_sta_dbgfs_stats_table_read,
 	.open = iwl3945_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void iwl3945_add_debugfs(void *priv, void *priv_sta,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 23e5c42..0c47d1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2873,6 +2873,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = rs_sta_dbgfs_scale_table_write,
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
@@ -2915,6 +2916,7 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
@@ -2946,6 +2948,7 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = rs_sta_dbgfs_rate_scale_data_read,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void rs_add_debugfs(void *priv, void *priv_sta,
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index 53b0b77..85f650e 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -402,24 +402,28 @@ static const struct file_operations iwm_debugfs_txq_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_txq_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations iwm_debugfs_tx_credit_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_tx_credit_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations iwm_debugfs_rx_ticket_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_rx_ticket_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations iwm_debugfs_fw_err_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_fw_err_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void iwm_debugfs_init(struct iwm_priv *iwm)
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index edcb523..d2e3602 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -364,6 +364,7 @@ static const struct file_operations iwm_debugfs_sdio_fops = {
 	.owner =	THIS_MODULE,
 	.open =		iwm_debugfs_sdio_open,
 	.read =		iwm_debugfs_sdio_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void if_sdio_debugfs_init(struct iwm_priv *iwm, struct dentry *parent_dir)
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 74e94cc..9f7f805 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -962,6 +962,7 @@ static const struct file_operations lbs_debug_fops = {
 	.open = open_file_generic,
 	.write = lbs_debugfs_write,
 	.read = lbs_debugfs_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 88560d0..35346a1 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2802,6 +2802,7 @@ static ssize_t ray_cs_essid_proc_write(struct file *file,
 static const struct file_operations ray_cs_essid_proc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ray_cs_essid_proc_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static ssize_t int_proc_write(struct file *file, const char __user *buffer,
@@ -2835,6 +2836,7 @@ static ssize_t int_proc_write(struct file *file, const char __user *buffer,
 static const struct file_operations int_proc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= int_proc_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 #endif
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 7d6f19a..b3039a4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -315,6 +315,7 @@ static const struct file_operations rt2x00debug_fop_queue_dump = {
 	.poll		= rt2x00debug_poll_queue_dump,
 	.open		= rt2x00debug_open_queue_dump,
 	.release	= rt2x00debug_release_queue_dump,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t rt2x00debug_read_queue_stats(struct file *file,
@@ -371,6 +372,7 @@ static const struct file_operations rt2x00debug_fop_queue_stats = {
 	.read		= rt2x00debug_read_queue_stats,
 	.open		= rt2x00debug_file_open,
 	.release	= rt2x00debug_file_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
@@ -423,6 +425,7 @@ static const struct file_operations rt2x00debug_fop_crypto_stats = {
 	.read		= rt2x00debug_read_crypto_stats,
 	.open		= rt2x00debug_file_open,
 	.release	= rt2x00debug_file_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 #endif
 
@@ -543,6 +546,7 @@ static const struct file_operations rt2x00debug_fop_dev_flags = {
 	.read		= rt2x00debug_read_dev_flags,
 	.open		= rt2x00debug_file_open,
 	.release	= rt2x00debug_file_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
index a4ae7c4..c3efd47 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -238,6 +238,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
 	.open = wl1251_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t tx_queue_status_read(struct file *file, char __user *userbuf,
@@ -259,6 +260,7 @@ static ssize_t tx_queue_status_read(struct file *file, char __user *userbuf,
 static const struct file_operations tx_queue_status_ops = {
 	.read = tx_queue_status_read,
 	.open = wl1251_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void wl1251_debugfs_delete_files(struct wl1251 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
index 6e25303..ada84e5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -239,6 +239,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
 	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t gpio_power_read(struct file *file, char __user *user_buf,
@@ -293,7 +294,8 @@ out:
 static const struct file_operations gpio_power_ops = {
 	.read = gpio_power_read,
 	.write = gpio_power_write,
-	.open = wl1271_open_file_generic
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void wl1271_debugfs_delete_files(struct wl1271 *wl)
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index bbd7516..eabef6b 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -59,6 +59,7 @@ static ssize_t timeout_write(struct file *file, char const __user *buf,
 static const struct file_operations timeout_fops = {
 	.read		= timeout_read,
 	.write		= timeout_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #endif
@@ -93,7 +94,8 @@ static ssize_t depth_write(struct file *file, char const __user *buf, size_t cou
 
 static const struct file_operations depth_fops = {
 	.read		= depth_read,
-	.write		= depth_write
+	.write		= depth_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -105,6 +107,7 @@ static ssize_t pointer_size_read(struct file *file, char __user *buf, size_t cou
 
 static const struct file_operations pointer_size_fops = {
 	.read		= pointer_size_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -116,6 +119,7 @@ static ssize_t cpu_type_read(struct file *file, char __user *buf, size_t count,
 
 static const struct file_operations cpu_type_fops = {
 	.read		= cpu_type_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -151,6 +155,7 @@ static ssize_t enable_write(struct file *file, char const __user *buf, size_t co
 static const struct file_operations enable_fops = {
 	.read		= enable_read,
 	.write		= enable_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -163,6 +168,7 @@ static ssize_t dump_write(struct file *file, char const __user *buf, size_t coun
 
 static const struct file_operations dump_fops = {
 	.write		= dump_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 void oprofile_create_files(struct super_block *sb, struct dentry *root)
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 2766a6d..bfe7ec9 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -117,12 +117,14 @@ static const struct file_operations ulong_fops = {
 	.read		= ulong_read_file,
 	.write		= ulong_write_file,
 	.open		= default_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
 static const struct file_operations ulong_ro_fops = {
 	.read		= ulong_read_file,
 	.open		= default_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
@@ -183,6 +185,7 @@ static ssize_t atomic_read_file(struct file *file, char __user *buf, size_t coun
 static const struct file_operations atomic_ro_fops = {
 	.read		= atomic_read_file,
 	.open		= default_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 9099246..e371416 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -472,6 +472,7 @@ static ssize_t aer_inject_write(struct file *filp, const char __user *ubuf,
 static const struct file_operations aer_inject_fops = {
 	.write = aer_inject_write,
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static struct miscdevice aer_inject_device = {
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index e3154ff..a614974 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -2360,6 +2360,7 @@ static const struct file_operations sonypi_misc_fops = {
 	.release	= sonypi_misc_release,
 	.fasync		= sonypi_misc_fasync,
 	.unlocked_ioctl	= sonypi_misc_ioctl,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct miscdevice sonypi_misc_device = {
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 66377f3..292e4fd 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -748,6 +748,7 @@ static const struct file_operations wdt_fops = {
 	.write	= wdt_write,
 	.open	= wdt_open,
 	.release = wdt_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice wdt_dev = {
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 7158f95..cb02f05 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -670,6 +670,7 @@ static const struct file_operations dasd_eer_fops = {
 	.read		= &dasd_eer_read,
 	.poll		= &dasd_eer_poll,
 	.owner		= THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice *dasd_eer_dev = NULL;
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 857dfcb..2035906 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -520,6 +520,7 @@ static const struct file_operations fs3270_fops = {
 	.compat_ioctl	 = fs3270_ioctl,	/* ioctl */
 	.open		 = fs3270_open,		/* open */
 	.release	 = fs3270_close,	/* release */
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /*
diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
index e021ec6..155a805 100644
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -447,6 +447,7 @@ static const struct file_operations mon_fops = {
 	.release = &mon_close,
 	.read    = &mon_read,
 	.poll    = &mon_poll,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice mon_dev = {
diff --git a/drivers/s390/char/monwriter.c b/drivers/s390/char/monwriter.c
index 572a1e7..1af4801 100644
--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -274,6 +274,7 @@ static const struct file_operations monwrite_fops = {
 	.open	 = &monwrite_open,
 	.release = &monwrite_close,
 	.write	 = &monwrite_write,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice mon_dev = {
diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index 539045a..fa4a0a0 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -53,6 +53,7 @@ static const struct file_operations tape_fops =
 #endif
 	.open = tapechar_open,
 	.release = tapechar_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int tapechar_major = TAPECHAR_MAJOR;
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 04e532e..2e44c0b 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -177,6 +177,7 @@ static const struct file_operations vmcp_fops = {
 	.write		= vmcp_write,
 	.unlocked_ioctl	= vmcp_ioctl,
 	.compat_ioctl	= vmcp_ioctl,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice vmcp_dev = {
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index e40a1b8..25d63da 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -97,6 +97,7 @@ static const struct file_operations vmlogrdr_fops = {
 	.open    = vmlogrdr_open,
 	.release = vmlogrdr_release,
 	.read    = vmlogrdr_read,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 
diff --git a/drivers/s390/char/vmwatchdog.c b/drivers/s390/char/vmwatchdog.c
index e13508c..bbfdcf1 100644
--- a/drivers/s390/char/vmwatchdog.c
+++ b/drivers/s390/char/vmwatchdog.c
@@ -297,6 +297,7 @@ static const struct file_operations vmwdt_fops = {
 	.unlocked_ioctl = &vmwdt_ioctl,
 	.write   = &vmwdt_write,
 	.owner   = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice vmwdt_dev = {
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index f5ea338..e0e3cd7 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -459,6 +459,7 @@ static const struct file_operations zcore_memmap_fops = {
 	.read		= zcore_memmap_read,
 	.open		= zcore_memmap_open,
 	.release	= zcore_memmap_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static ssize_t zcore_reipl_write(struct file *filp, const char __user *buf,
@@ -486,6 +487,7 @@ static const struct file_operations zcore_reipl_fops = {
 	.write		= zcore_reipl_write,
 	.open		= zcore_reipl_open,
 	.release	= zcore_reipl_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 #ifdef CONFIG_32BIT
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index a83877c..d7ec8d7 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -806,6 +806,7 @@ static const struct file_operations chsc_fops = {
 	.open = nonseekable_open,
 	.unlocked_ioctl = chsc_ioctl,
 	.compat_ioctl = chsc_ioctl,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static struct miscdevice chsc_misc_device = {
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index ac94ac7..c5a92e1 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1067,6 +1067,7 @@ static ssize_t cio_settle_write(struct file *file, const char __user *buf,
 static const struct file_operations cio_settle_proc_fops = {
 	.open = nonseekable_open,
 	.write = cio_settle_write,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static int __init cio_settle_init(void)
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 41e0aae..7b2a64d 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -897,7 +897,8 @@ static const struct file_operations zcrypt_fops = {
 	.compat_ioctl	= zcrypt_compat_ioctl,
 #endif
 	.open		= zcrypt_open,
-	.release	= zcrypt_release
+	.release	= zcrypt_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /*
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index fcbd2b7..cf2d7b3 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -251,8 +251,9 @@ static const struct file_operations zfcp_cfdc_fops = {
 	.open = nonseekable_open,
 	.unlocked_ioctl = zfcp_cfdc_dev_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = zfcp_cfdc_dev_ioctl
+	.compat_ioctl = zfcp_cfdc_dev_ioctl,
 #endif
+	.llseek = no_llseek,/* nonseekable */
 };
 
 struct miscdevice zfcp_cfdc_misc = {
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 1690e53..deeffe1 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -162,6 +162,7 @@ static const struct file_operations d7s_fops = {
 	.compat_ioctl =		d7s_ioctl,
 	.open =			d7s_open,
 	.release =		d7s_release,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice d7s_miscdev = {
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 078e5f4..38a069c 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -720,6 +720,7 @@ static const struct file_operations envctrl_fops = {
 #endif
 	.open =			envctrl_open,
 	.release =		envctrl_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };	
 
 static struct miscdevice envctrl_dev = {
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e20b7bd..9d3b14f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -222,7 +222,8 @@ static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= twa_chrdev_ioctl,
 	.open		= twa_chrdev_open,
-	.release	= NULL
+	.release	= NULL,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* This function will complete an aen request from the isr */
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f481e73..25f9606 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -890,7 +890,8 @@ static const struct file_operations twl_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= twl_chrdev_ioctl,
 	.open		= twl_chrdev_open,
-	.release	= NULL
+	.release	= NULL,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* This function passes sense data from firmware to scsi layer */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 30d735a..c04db80 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1059,7 +1059,8 @@ static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= tw_chrdev_ioctl,
 	.open		= tw_chrdev_open,
-	.release	= NULL
+	.release	= NULL,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* This function will free up device extension resources */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index cad6f9a..3975d16 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1039,6 +1039,7 @@ static const struct file_operations aac_cfg_fops = {
 	.compat_ioctl   = aac_compat_cfg_ioctl,
 #endif
 	.open		= aac_cfg_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct scsi_host_template aac_driver_template = {
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index d653218..651afc3 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -981,6 +981,7 @@ static const struct file_operations changer_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ch_ioctl_compat,
 #endif
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __init init_ch_module(void)
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index ffc1edf..00caa83 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -126,6 +126,7 @@ static const struct file_operations adpt_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_adpt_ioctl,
 #endif
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* Structures and definitions for synchronous message posting.
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b860d65..f40b600 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -372,6 +372,7 @@ static const struct file_operations gdth_fops = {
     .unlocked_ioctl   = gdth_unlocked_ioctl,
     .open    = gdth_open,
     .release = gdth_close,
+    .llseek = noop_llseek,/* no read or write fn */
 };
 
 #include "gdth_proc.h"
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 0b6e322..5980adf 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -101,6 +101,7 @@ static const struct file_operations megadev_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= megadev_unlocked_ioctl,
 	.open		= megadev_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 41f82f7..fffd7e6 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -75,6 +75,7 @@ static const struct file_operations lsi_fops = {
 	.compat_ioctl = mraid_mm_compat_ioctl,
 #endif
 	.owner	= THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice megaraid_mm_dev = {
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 99e4478..357ee06 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3957,6 +3957,7 @@ static const struct file_operations megasas_mgmt_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = megasas_mgmt_compat_ioctl,
 #endif
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index b774973..b58a3f3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2952,6 +2952,7 @@ static const struct file_operations ctl_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = _ctl_ioctl_compat,
 #endif
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice ctl_dev = {
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index ffdd9fd..cefb2c0 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -182,6 +182,7 @@ static const struct file_operations osd_fops = {
 	.open           = osd_uld_open,
 	.release        = osd_uld_release,
 	.unlocked_ioctl = osd_uld_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 struct osd_dev *osduld_path_lookup(const char *name)
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ecc45c8..24c57e3 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4165,6 +4165,7 @@ static const struct file_operations pmcraid_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = pmcraid_chr_ioctl,
 #endif
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8c80b49..4eb061e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3926,6 +3926,7 @@ static struct pci_driver qla2xxx_pci_driver = {
 
 static struct file_operations apidev_fops = {
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /**
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index a87e21c..fb2b27e 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -333,6 +333,7 @@ static const struct file_operations tgt_fops = {
 	.poll		= tgt_poll,
 	.write		= tgt_write,
 	.mmap		= tgt_mmap,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static struct miscdevice tgt_miscdev = {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 78d6163..c4a10a7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1351,6 +1351,7 @@ static const struct file_operations sg_fops = {
 	.mmap = sg_mmap,
 	.release = sg_release,
 	.fasync = sg_fasync,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct class *sg_sysfs_class;
diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index bc9af50..5419d4f 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -227,12 +227,14 @@ static const struct file_operations port_regs_ops = {
 	.owner		= THIS_MODULE,
 	.open		= hsu_show_regs_open,
 	.read		= port_show_regs,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations dma_regs_ops = {
 	.owner		= THIS_MODULE,
 	.open		= hsu_show_regs_open,
 	.read		= dma_show_regs,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int hsu_debugfs_init(struct hsu_port *hsu)
diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
index d256cb0..030b485 100644
--- a/drivers/spi/dw_spi.c
+++ b/drivers/spi/dw_spi.c
@@ -131,6 +131,7 @@ static const struct file_operations mrst_spi_regs_ops = {
 	.owner		= THIS_MODULE,
 	.open		= spi_show_regs_open,
 	.read		= spi_show_regs,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int mrst_spi_debugfs_init(struct dw_spi *dws)
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index ea1bec3..7325a83 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -545,6 +545,7 @@ static const struct file_operations spidev_fops = {
 	.unlocked_ioctl = spidev_ioctl,
 	.open =		spidev_open,
 	.release =	spidev_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/staging/batman-adv/bat_debugfs.c b/drivers/staging/batman-adv/bat_debugfs.c
index 507da68..fb704e1 100644
--- a/drivers/staging/batman-adv/bat_debugfs.c
+++ b/drivers/staging/batman-adv/bat_debugfs.c
@@ -174,6 +174,7 @@ static const struct file_operations log_fops = {
 	.release        = log_release,
 	.read           = log_read,
 	.poll           = log_poll,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static int debug_log_setup(struct bat_priv *bat_priv)
diff --git a/drivers/staging/batman-adv/icmp_socket.c b/drivers/staging/batman-adv/icmp_socket.c
index 3ae7dd2..1a7b473 100644
--- a/drivers/staging/batman-adv/icmp_socket.c
+++ b/drivers/staging/batman-adv/icmp_socket.c
@@ -265,6 +265,7 @@ static const struct file_operations fops = {
 	.read = bat_socket_read,
 	.write = bat_socket_write,
 	.poll = bat_socket_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 int bat_socket_setup(struct bat_priv *bat_priv)
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 1409131..57fe2ff 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1922,6 +1922,7 @@ const struct file_operations comedi_fops = {
 	.mmap = comedi_mmap,
 	.poll = comedi_poll,
 	.fasync = comedi_fasync,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct class *comedi_class;
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index fbb80f0..d91a98d 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -351,6 +351,7 @@ static const struct file_operations chd_dec_fops = {
 	.unlocked_ioctl = chd_dec_ioctl,
 	.open    = chd_dec_open,
 	.release = chd_dec_close,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
index 81bd71f..8483a71 100644
--- a/drivers/staging/dream/camera/msm_camera.c
+++ b/drivers/staging/dream/camera/msm_camera.c
@@ -1941,6 +1941,7 @@ static const struct file_operations msm_fops_config = {
 	.open = msm_open,
 	.unlocked_ioctl = msm_ioctl_config,
 	.release = msm_release_config,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static const struct file_operations msm_fops_control = {
@@ -1948,6 +1949,7 @@ static const struct file_operations msm_fops_control = {
 	.open = msm_open_control,
 	.unlocked_ioctl = msm_ioctl_control,
 	.release = msm_release_control,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static const struct file_operations msm_fops_frame = {
@@ -1956,6 +1958,7 @@ static const struct file_operations msm_fops_frame = {
 	.unlocked_ioctl = msm_ioctl_frame,
 	.release = msm_release_frame,
 	.poll = msm_poll_frame,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int msm_setup_cdev(struct msm_device *msm,
diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index 7d6bbad..c171520 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -180,6 +180,7 @@ const struct file_operations pmem_fops = {
 	.mmap = pmem_mmap,
 	.open = pmem_open,
 	.unlocked_ioctl = pmem_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int get_id(struct file *file)
@@ -1204,6 +1205,7 @@ static ssize_t debug_read(struct file *file, char __user *buf, size_t count,
 static struct file_operations debug_fops = {
 	.read = debug_read,
 	.open = debug_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 #endif
 
diff --git a/drivers/staging/dream/qdsp5/adsp_driver.c b/drivers/staging/dream/qdsp5/adsp_driver.c
index 8197765..99a86b6 100644
--- a/drivers/staging/dream/qdsp5/adsp_driver.c
+++ b/drivers/staging/dream/qdsp5/adsp_driver.c
@@ -582,6 +582,7 @@ static struct file_operations adsp_fops = {
 	.open = adsp_open,
 	.unlocked_ioctl = adsp_ioctl,
 	.release = adsp_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static void adsp_create(struct adsp_device *adev, const char *name,
diff --git a/drivers/staging/dream/qdsp5/audio_aac.c b/drivers/staging/dream/qdsp5/audio_aac.c
index a373f35..9122888 100644
--- a/drivers/staging/dream/qdsp5/audio_aac.c
+++ b/drivers/staging/dream/qdsp5/audio_aac.c
@@ -1030,6 +1030,7 @@ static struct file_operations audio_aac_fops = {
 	.read = audio_read,
 	.write = audio_write,
 	.unlocked_ioctl = audio_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct miscdevice audio_aac_misc = {
diff --git a/drivers/staging/dream/qdsp5/audio_amrnb.c b/drivers/staging/dream/qdsp5/audio_amrnb.c
index 07b79d5..7c1c713 100644
--- a/drivers/staging/dream/qdsp5/audio_amrnb.c
+++ b/drivers/staging/dream/qdsp5/audio_amrnb.c
@@ -841,6 +841,7 @@ static struct file_operations audio_amrnb_fops = {
 	.read = audamrnb_read,
 	.write = audamrnb_write,
 	.unlocked_ioctl = audamrnb_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct miscdevice audio_amrnb_misc = {
diff --git a/drivers/staging/dream/qdsp5/audio_evrc.c b/drivers/staging/dream/qdsp5/audio_evrc.c
index ad989ee..687aec0 100644
--- a/drivers/staging/dream/qdsp5/audio_evrc.c
+++ b/drivers/staging/dream/qdsp5/audio_evrc.c
@@ -813,6 +813,7 @@ static struct file_operations audio_evrc_fops = {
 	.read = audevrc_read,
 	.write = audevrc_write,
 	.unlocked_ioctl = audevrc_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct miscdevice audio_evrc_misc = {
diff --git a/drivers/staging/dream/qdsp5/audio_in.c b/drivers/staging/dream/qdsp5/audio_in.c
index 6ae48e7..ad68c7d 100644
--- a/drivers/staging/dream/qdsp5/audio_in.c
+++ b/drivers/staging/dream/qdsp5/audio_in.c
@@ -921,12 +921,14 @@ static struct file_operations audio_fops = {
 	.read		= audio_in_read,
 	.write		= audio_in_write,
 	.unlocked_ioctl	= audio_in_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct file_operations audpre_fops = {
 	.owner          = THIS_MODULE,
 	.open           = audpre_open,
 	.unlocked_ioctl = audpre_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 struct miscdevice audio_in_misc = {
diff --git a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
index 530e1f3..633e6ae 100644
--- a/drivers/staging/dream/qdsp5/audio_mp3.c
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c
@@ -948,6 +948,7 @@ static struct file_operations audio_mp3_fops = {
 	.read		= audio_read,
 	.write		= audio_write,
 	.unlocked_ioctl	= audio_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct miscdevice audio_mp3_misc = {
diff --git a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
index 76d7fa5..9c2e11b 100644
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -807,12 +807,14 @@ static struct file_operations audio_fops = {
 	.read		= audio_read,
 	.write		= audio_write,
 	.unlocked_ioctl	= audio_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct file_operations audpp_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audpp_open,
 	.unlocked_ioctl	= audpp_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 struct miscdevice audio_misc = {
diff --git a/drivers/staging/dream/qdsp5/audio_qcelp.c b/drivers/staging/dream/qdsp5/audio_qcelp.c
index effa96f..fac03ca 100644
--- a/drivers/staging/dream/qdsp5/audio_qcelp.c
+++ b/drivers/staging/dream/qdsp5/audio_qcelp.c
@@ -824,6 +824,7 @@ static struct file_operations audio_qcelp_fops = {
 	.read = audqcelp_read,
 	.write = audqcelp_write,
 	.unlocked_ioctl = audqcelp_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct miscdevice audio_qcelp_misc = {
diff --git a/drivers/staging/dream/qdsp5/evlog.h b/drivers/staging/dream/qdsp5/evlog.h
index 922ce67..37cca40 100644
--- a/drivers/staging/dream/qdsp5/evlog.h
+++ b/drivers/staging/dream/qdsp5/evlog.h
@@ -123,6 +123,7 @@ static int ev_log_open(struct inode *inode, struct file *file)
 static const struct file_operations ev_log_ops = {
 	.read = ev_log_read,
 	.open = ev_log_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int ev_log_init(struct ev_log *log)
diff --git a/drivers/staging/dream/qdsp5/snd.c b/drivers/staging/dream/qdsp5/snd.c
index 037d7ff..4b0625b 100644
--- a/drivers/staging/dream/qdsp5/snd.c
+++ b/drivers/staging/dream/qdsp5/snd.c
@@ -247,6 +247,7 @@ static struct file_operations snd_fops = {
 	.open		= snd_open,
 	.release	= snd_release,
 	.unlocked_ioctl	= snd_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 struct miscdevice snd_misc = {
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 4e52105..02cd790 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -641,6 +641,7 @@ static const struct file_operations usb_alphatrack_fops = {
 	.open = usb_alphatrack_open,
 	.release = usb_alphatrack_release,
 	.poll = usb_alphatrack_poll,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /*
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index eed74f0..d4af6d9 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -767,6 +767,7 @@ static const struct file_operations usb_tranzport_fops = {
 	.open = usb_tranzport_open,
 	.release = usb_tranzport_release,
 	.poll = usb_tranzport_poll,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /*
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index dd4d87a..b1794e8 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -349,6 +349,7 @@ static const struct file_operations iio_event_chrdev_fileops = {
 	.release = iio_event_chrdev_release,
 	.open = iio_event_chrdev_open,
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static void iio_event_dev_release(struct device *dev)
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 6ab578e..ec6de45 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -133,6 +133,7 @@ static const struct file_operations iio_ring_fileops = {
 	.release = iio_ring_release,
 	.open = iio_ring_open,
 	.owner = THIS_MODULE,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 /**
diff --git a/drivers/staging/lirc/lirc_imon.c b/drivers/staging/lirc/lirc_imon.c
index 6649325..a286d88 100644
--- a/drivers/staging/lirc/lirc_imon.c
+++ b/drivers/staging/lirc/lirc_imon.c
@@ -115,7 +115,8 @@ static const struct file_operations display_fops = {
 	.owner		= THIS_MODULE,
 	.open		= &display_open,
 	.write		= &vfd_write,
-	.release	= &display_close
+	.release	= &display_close,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/drivers/staging/lirc/lirc_it87.c b/drivers/staging/lirc/lirc_it87.c
index ec11c0e..07d216d 100644
--- a/drivers/staging/lirc/lirc_it87.c
+++ b/drivers/staging/lirc/lirc_it87.c
@@ -342,6 +342,7 @@ static const struct file_operations lirc_fops = {
 	.unlocked_ioctl	= lirc_ioctl,
 	.open		= lirc_open,
 	.release	= lirc_close,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int set_use_inc(void *data)
diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/lirc/lirc_sasem.c
index 73166c3..59e1d21 100644
--- a/drivers/staging/lirc/lirc_sasem.c
+++ b/drivers/staging/lirc/lirc_sasem.c
@@ -125,6 +125,7 @@ static const struct file_operations vfd_fops = {
 	.write		= &vfd_write,
 	.unlocked_ioctl	= &vfd_ioctl,
 	.release	= &vfd_close,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* USB Device ID for Sasem USB Control Board */
diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index a98b3f1..3371b4c 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -890,6 +890,7 @@ static const struct file_operations memrar_fops = {
 	.mmap           = memrar_mmap,
 	.open           = memrar_open,
 	.release        = memrar_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice memrar_miscdev = {
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 3221814..cbe966e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1631,6 +1631,7 @@ static const struct file_operations keypad_fops = {
 	.read    = keypad_read,		/* read */
 	.open    = keypad_open,		/* open */
 	.release = keypad_release,	/* close */
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct miscdevice keypad_dev = {
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 7ee8949..81260ed 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -144,6 +144,7 @@ static const struct file_operations bridge_fops = {
 	.release = bridge_release,
 	.unlocked_ioctl = bridge_ioctl,
 	.mmap = bridge_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index b53deee..f4d742f 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -6676,7 +6676,8 @@ static const struct file_operations ixj_fops =
         .poll           = ixj_poll,
         .unlocked_ioctl = ixj_ioctl,
         .release        = ixj_release,
-        .fasync         = ixj_fasync
+        .fasync         = ixj_fasync,
+        .llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int ixj_linetest(IXJ *j)
diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index f3873f6..a62c1ba 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -130,6 +130,7 @@ static const struct file_operations phone_fops =
 {
 	.owner		= THIS_MODULE,
 	.open		= phone_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index bff1afb..3854b3e 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -740,6 +740,7 @@ static const struct file_operations uio_fops = {
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
 	.fasync		= uio_fasync,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int uio_major_init(void)
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 094c76b..8c63f49 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -584,7 +584,8 @@ static const struct file_operations wdm_fops = {
 	.open =		wdm_open,
 	.flush =	wdm_flush,
 	.release =	wdm_release,
-	.poll =		wdm_poll
+	.poll =		wdm_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct usb_class_driver wdm_class = {
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index e325162..173eacf 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1043,6 +1043,7 @@ static const struct file_operations usblp_fops = {
 	.compat_ioctl =		usblp_ioctl,
 	.open =		usblp_open,
 	.release =	usblp_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static char *usblp_devnode(struct device *dev, mode_t *mode)
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 3e7c1b8..1f4a091 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -987,6 +987,7 @@ static const struct file_operations fops = {
 	.open		= usbtmc_open,
 	.release	= usbtmc_release,
 	.unlocked_ioctl	= usbtmc_ioctl,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct usb_class_driver usbtmc_class = {
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index f06f5db..0724c5e 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -59,6 +59,7 @@ static int usb_open(struct inode * inode, struct file * file)
 static const struct file_operations usb_fops = {
 	.owner =	THIS_MODULE,
 	.open =		usb_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct usb_class {
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 53e1202..bc3d8ed 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -451,6 +451,7 @@ const struct file_operations f_hidg_fops = {
 	.write		= f_hidg_write,
 	.read		= f_hidg_read,
 	.poll		= f_hidg_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init hidg_bind(struct usb_configuration *c, struct usb_function *f)
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index cf241c3..ee02c4e 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -884,7 +884,8 @@ static const struct file_operations printer_io_operations = {
 	.fsync =	printer_fsync,
 	.poll =		printer_poll,
 	.unlocked_ioctl = printer_ioctl,
-	.release =	printer_close
+	.release =	printer_close,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 76b7fd2..e00547c 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -369,18 +369,21 @@ static const struct file_operations debug_async_fops = {
 	.open		= debug_async_open,
 	.read		= debug_output,
 	.release	= debug_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 static const struct file_operations debug_periodic_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_periodic_open,
 	.read		= debug_output,
 	.release	= debug_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 static const struct file_operations debug_registers_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_registers_open,
 	.read		= debug_output,
 	.release	= debug_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 static const struct file_operations debug_lpm_fops = {
 	.owner		= THIS_MODULE,
@@ -388,6 +391,7 @@ static const struct file_operations debug_lpm_fops = {
 	.read		= debug_lpm_read,
 	.write		= debug_lpm_write,
 	.release	= debug_lpm_close,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct dentry *ehci_debug_root;
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 36abd2b..04813fa 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -413,18 +413,21 @@ static const struct file_operations debug_async_fops = {
 	.open		= debug_async_open,
 	.read		= debug_output,
 	.release	= debug_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 static const struct file_operations debug_periodic_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_periodic_open,
 	.read		= debug_output,
 	.release	= debug_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 static const struct file_operations debug_registers_fops = {
 	.owner		= THIS_MODULE,
 	.open		= debug_registers_open,
 	.read		= debug_output,
 	.release	= debug_close,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct dentry *ohci_debug_root;
diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
index e192e8f..a80342b 100644
--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -963,6 +963,7 @@ static const struct file_operations mdc800_device_ops =
 	.write =	mdc800_device_write,
 	.open =		mdc800_device_open,
 	.release =	mdc800_device_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 801324a..9297e68 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -679,6 +679,7 @@ static const struct file_operations adu_fops = {
 	.write = adu_write,
 	.open = adu_open,
 	.release = adu_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /*
diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index a54c3cb..8e34d01 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -105,6 +105,7 @@ static const struct file_operations idmouse_fops = {
 	.read = idmouse_read,
 	.open = idmouse_open,
 	.release = idmouse_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /* class driver information */
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index bc88c79..8390786 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -730,6 +730,7 @@ static const struct file_operations iowarrior_fops = {
 	.open = iowarrior_open,
 	.release = iowarrior_release,
 	.poll = iowarrior_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static char *iowarrior_devnode(struct device *dev, mode_t *mode)
diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index dd41d87..2053eb9 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -613,6 +613,7 @@ static const struct file_operations ld_usb_fops = {
 	.open =		ld_usb_open,
 	.release =	ld_usb_release,
 	.poll =		ld_usb_poll,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 /*
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index cc13ae6..d8816f6 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -439,6 +439,7 @@ static const struct file_operations usb_rio_fops = {
 	.unlocked_ioctl = ioctl_rio,
 	.open =		open_rio,
 	.release =	close_rio,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct usb_class_driver usb_rio_class = {
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index d00dde1..0d45ede 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -282,6 +282,7 @@ static const struct file_operations lcd_fops = {
         .open =         lcd_open,
 	.unlocked_ioctl = lcd_ioctl,
         .release =      lcd_release,
+        .llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /*
diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 552679b..e793c02 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -507,6 +507,7 @@ static const struct file_operations skel_fops = {
 	.open =		skel_open,
 	.release =	skel_release,
 	.flush =	skel_flush,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /*
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 29e850a..34e0faa 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -869,6 +869,7 @@ static const struct file_operations vhost_net_fops = {
 	.compat_ioctl   = vhost_net_compat_ioctl,
 #endif
 	.open           = vhost_net_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice vhost_net_misc = {
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index b066475..80ba80d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1439,6 +1439,7 @@ static const struct file_operations fb_fops = {
 #ifdef CONFIG_FB_DEFERRED_IO
 	.fsync =	fb_deferred_io_fsync,
 #endif
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 struct class *fb_class;
diff --git a/drivers/video/mbx/mbxdebugfs.c b/drivers/video/mbx/mbxdebugfs.c
index ecad965..cfa6d8b 100644
--- a/drivers/video/mbx/mbxdebugfs.c
+++ b/drivers/video/mbx/mbxdebugfs.c
@@ -175,36 +175,42 @@ static const struct file_operations sysconf_fops = {
 	.read = sysconf_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations clock_fops = {
 	.read = clock_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations display_fops = {
 	.read = display_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations gsctl_fops = {
 	.read = gsctl_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations sdram_fops = {
 	.read = sdram_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations misc_fops = {
 	.read = misc_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void __devinit mbxfb_debugfs_init(struct fb_info *fbi)
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index c764c52..9d4d560 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -267,6 +267,7 @@ static const struct file_operations ar7_wdt_fops = {
 	.unlocked_ioctl	= ar7_wdt_ioctl,
 	.open		= ar7_wdt_open,
 	.release	= ar7_wdt_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice ar7_wdt_miscdev = {
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 566343b..4aa883d 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -524,6 +524,7 @@ static const struct file_operations cpwd_fops = {
 	.write =		cpwd_write,
 	.read =			cpwd_read,
 	.release =		cpwd_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int __devinit cpwd_probe(struct platform_device *op,
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 59359c9..6c9e0a7 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -188,6 +188,7 @@ static const struct file_operations ep93xx_wdt_fops = {
 	.unlocked_ioctl	= ep93xx_wdt_ioctl,
 	.open		= ep93xx_wdt_open,
 	.release	= ep93xx_wdt_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice ep93xx_wdt_miscdev = {
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 76b58ab..f60f4e3 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -258,6 +258,7 @@ static const struct file_operations omap_wdt_fops = {
 	.unlocked_ioctl = omap_wdt_ioctl,
 	.open = omap_wdt_open,
 	.release = omap_wdt_release,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static int __devinit omap_wdt_probe(struct platform_device *pdev)
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 66e185c..09149a8 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -467,6 +467,7 @@ static const struct file_operations evtchn_fops = {
 	.fasync  = evtchn_fasync,
 	.open    = evtchn_open,
 	.release = evtchn_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice evtchn_miscdev = {
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 78bfab0..85258ed 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -35,6 +35,7 @@ static ssize_t capabilities_read(struct file *file, char __user *buf,
 
 static const struct file_operations capabilities_file_ops = {
 	.read = capabilities_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
diff --git a/drivers/xen/xenfs/xenbus.c b/drivers/xen/xenfs/xenbus.c
index 3b39c37..559240c 100644
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenfs/xenbus.c
@@ -594,4 +594,5 @@ const struct file_operations xenbus_file_ops = {
 	.open = xenbus_file_open,
 	.release = xenbus_file_release,
 	.poll = xenbus_file_poll,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 6d55268..f682841 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -29,6 +29,7 @@ static void afs_mntpt_expiry_timed_out(struct work_struct *work);
 
 const struct file_operations afs_mntpt_file_operations = {
 	.open		= afs_mntpt_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 const struct inode_operations afs_mntpt_inode_operations = {
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index ba4a38b..a4f94f9 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -724,6 +724,7 @@ static const struct file_operations _dev_ioctl_fops = {
 	.unlocked_ioctl	 = autofs_dev_ioctl,
 	.compat_ioctl = autofs_dev_ioctl_compat,
 	.owner	 = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice _autofs_dev_ioctl_misc = {
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a7528b9..dc659f7 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -576,6 +576,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 static const struct file_operations bm_entry_operations = {
 	.read		= bm_entry_read,
 	.write		= bm_entry_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /* /register */
@@ -643,6 +644,7 @@ out:
 
 static const struct file_operations bm_register_operations = {
 	.write		= bm_register_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /* /status */
@@ -680,6 +682,7 @@ static ssize_t bm_status_write(struct file * file, const char __user * buffer,
 static const struct file_operations bm_status_operations = {
 	.read		= bm_status_read,
 	.write		= bm_status_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /* Superblock handling */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1776dbd..c5c235e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -815,6 +815,7 @@ static const struct file_operations btrfs_ctl_fops = {
 	.unlocked_ioctl	 = btrfs_control_ioctl,
 	.compat_ioctl = btrfs_control_ioctl,
 	.owner	 = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice btrfs_misc = {
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 727caed..ef86e08 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -55,6 +55,7 @@ const struct file_operations cachefiles_daemon_fops = {
 	.read		= cachefiles_daemon_read,
 	.write		= cachefiles_daemon_write,
 	.poll		= cachefiles_daemon_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 struct cachefiles_daemon_cmd {
diff --git a/fs/char_dev.c b/fs/char_dev.c
index f80a4f2..a8b5438 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -454,6 +454,7 @@ static void cdev_purge(struct cdev *cdev)
  */
 const struct file_operations def_chr_fops = {
 	.open = chrdev_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct kobject *exact_match(dev_t dev, int *part, void *data)
diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index ca25d96..419ded5 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -39,6 +39,7 @@ const struct inode_operations coda_ioctl_inode_operations = {
 const struct file_operations coda_ioctl_operations = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= coda_pioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* the coda pioctl inode ops */
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index de89645..e26f818 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -346,6 +346,7 @@ static const struct file_operations coda_psdev_fops = {
 	.unlocked_ioctl	= coda_psdev_ioctl,
 	.open		= coda_psdev_open,
 	.release	= coda_psdev_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int init_coda_psdev(void)
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 0210898..1b4db2c 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -43,6 +43,7 @@ const struct file_operations debugfs_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
 	.open =		default_open,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static void *debugfs_follow_link(struct dentry *dentry, struct nameidata *nd)
@@ -454,6 +455,7 @@ static const struct file_operations fops_bool = {
 	.read =		read_file_bool,
 	.write =	write_file_bool,
 	.open =		default_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
@@ -498,6 +500,7 @@ static ssize_t read_file_blob(struct file *file, char __user *user_buf,
 static const struct file_operations fops_blob = {
 	.read =		read_file_blob,
 	.open =		default_open,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index c6cf251..fee0212 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -643,7 +643,8 @@ static ssize_t waiters_read(struct file *file, char __user *userbuf,
 static const struct file_operations waiters_fops = {
 	.owner   = THIS_MODULE,
 	.open    = waiters_open,
-	.read    = waiters_read
+	.read    = waiters_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void dlm_delete_debug_file(struct dlm_ls *ls)
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index d45c02d..f8000dc 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -412,7 +412,8 @@ static const struct file_operations dev_fops = {
 	.read    = dev_read,
 	.write   = dev_write,
 	.poll    = dev_poll,
-	.owner   = THIS_MODULE
+	.owner   = THIS_MODULE,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice plock_dev_misc = {
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index b627285..f193a1a 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -1009,6 +1009,7 @@ static const struct file_operations device_fops = {
 	.write   = device_write,
 	.poll    = device_poll,
 	.owner   = THIS_MODULE,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static const struct file_operations ctl_device_fops = {
@@ -1017,6 +1018,7 @@ static const struct file_operations ctl_device_fops = {
 	.read    = device_read,
 	.write   = device_write,
 	.owner   = THIS_MODULE,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice ctl_device = {
@@ -1029,6 +1031,7 @@ static const struct file_operations monitor_device_fops = {
 	.open    = monitor_device_open,
 	.release = monitor_device_close,
 	.owner   = THIS_MODULE,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice monitor_device = {
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 622c951..98ad7c6 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -332,6 +332,7 @@ const struct file_operations ecryptfs_dir_fops = {
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 const struct file_operations ecryptfs_main_fops = {
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 00208c3..764901d 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -482,6 +482,7 @@ static const struct file_operations ecryptfs_miscdev_fops = {
 	.read    = ecryptfs_miscdev_read,
 	.write   = ecryptfs_miscdev_write,
 	.release = ecryptfs_miscdev_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct miscdevice ecryptfs_miscdev = {
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 6bd3f76..c0e0d9a 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -293,6 +293,7 @@ static const struct file_operations eventfd_fops = {
 	.poll		= eventfd_poll,
 	.read		= eventfd_read,
 	.write		= eventfd_write,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /**
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 3817149..01923e1 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -674,7 +674,8 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 	.release	= ep_eventpoll_release,
-	.poll		= ep_eventpoll_poll
+	.poll		= ep_eventpoll_poll,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /* Fast test to see if the file is an evenpoll file */
diff --git a/fs/fifo.c b/fs/fifo.c
index 5d6606f..d3bf774 100644
--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -151,4 +151,5 @@ err_nocleanup:
  */
 const struct file_operations def_fifo_fops = {
 	.open		= fifo_open,	/* will set read_ or write_pipefifo_fops */
+	.llseek = noop_llseek,/* no read or write fn */
 };
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 3773fd6..8beb760 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -179,23 +179,27 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 static const struct file_operations fuse_ctl_abort_ops = {
 	.open = nonseekable_open,
 	.write = fuse_conn_abort_write,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static const struct file_operations fuse_ctl_waiting_ops = {
 	.open = nonseekable_open,
 	.read = fuse_conn_waiting_read,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static const struct file_operations fuse_conn_max_background_ops = {
 	.open = nonseekable_open,
 	.read = fuse_conn_max_background_read,
 	.write = fuse_conn_max_background_write,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static const struct file_operations fuse_conn_congestion_threshold_ops = {
 	.open = nonseekable_open,
 	.read = fuse_conn_congestion_threshold_read,
 	.write = fuse_conn_congestion_threshold_write,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index e1f8171..cc06d67 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -182,6 +182,7 @@ static const struct file_operations cuse_frontend_fops = {
 	.unlocked_ioctl		= cuse_file_ioctl,
 	.compat_ioctl		= cuse_file_compat_ioctl,
 	.poll			= fuse_file_poll,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 4edd662..395b006 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -771,6 +771,7 @@ const struct file_operations gfs2_dir_fops = {
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
 	.flock		= gfs2_flock,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 #endif /* CONFIG_GFS2_FS_LOCKING_DLM */
@@ -797,5 +798,6 @@ const struct file_operations gfs2_dir_fops_nolock = {
 	.open		= gfs2_open,
 	.release	= gfs2_close,
 	.fsync		= gfs2_fsync,
+	.llseek = default_llseek,/* readdir is present */
 };
 
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 7b02772..bd00868 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -598,6 +598,7 @@ static const struct file_operations hppfs_dir_fops = {
 	.readdir	= hppfs_readdir,
 	.open		= hppfs_dir_open,
 	.fsync		= hppfs_fsync,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 static int hppfs_statfs(struct dentry *dentry, struct kstatfs *sf)
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6e5bd42..db73be8 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -674,6 +674,7 @@ const struct file_operations hugetlbfs_file_operations = {
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 9777eb5..a14286e 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -827,4 +827,5 @@ const struct file_operations logfs_dir_fops = {
 	.unlocked_ioctl	= logfs_ioctl,
 	.readdir	= logfs_readdir,
 	.read		= generic_read_dir,
+	.llseek = default_llseek,/* readdir is present */
 };
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index b53b1d0..6e2cd01 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -137,6 +137,7 @@ static const struct file_operations transaction_ops = {
 	.write		= nfsctl_transaction_write,
 	.read		= nfsctl_transaction_read,
 	.release	= simple_transaction_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int exports_open(struct inode *inode, struct file *file)
diff --git a/fs/no-block.c b/fs/no-block.c
index d269a93..9c59f87 100644
--- a/fs/no-block.c
+++ b/fs/no-block.c
@@ -19,4 +19,5 @@ static int no_blkdev_open(struct inode * inode, struct file * filp)
 
 const struct file_operations def_blk_fops = {
 	.open		= no_blkdev_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 5ed8e58..15145ac 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -433,6 +433,7 @@ static const struct file_operations fanotify_fops = {
 	.release	= fanotify_release,
 	.unlocked_ioctl	= fanotify_ioctl,
 	.compat_ioctl	= fanotify_ioctl,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static void fanotify_free_mark(struct fsnotify_mark *fsn_mark)
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bf7f6d7..ede009a 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -344,6 +344,7 @@ static const struct file_operations inotify_fops = {
 	.release	= inotify_release,
 	.unlocked_ioctl	= inotify_ioctl,
 	.compat_ioctl	= inotify_ioctl,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 113ebd9..3b72ae9 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2223,6 +2223,7 @@ const struct inode_operations ntfs_file_inode_ops = {
 #endif /* NTFS_RW */
 };
 
-const struct file_operations ntfs_empty_file_ops = {};
+const struct file_operations ntfs_empty_file_ops = {.llseek = noop_llseek,/* no read or write fn */
+};
 
 const struct inode_operations ntfs_empty_inode_ops = {};
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index c2903b8..bb3798a 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -612,6 +612,7 @@ static const struct file_operations dlmfs_file_operations = {
 	.poll		= dlmfs_file_poll,
 	.read		= dlmfs_file_read,
 	.write		= dlmfs_file_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct inode_operations dlmfs_dir_inode_operations = {
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 2dc57bc..c3a7457 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -628,6 +628,7 @@ static const struct file_operations ocfs2_control_fops = {
 	.read    = ocfs2_control_read,
 	.write   = ocfs2_control_write,
 	.owner   = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct miscdevice ocfs2_control_device = {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index a1c43e7..486e7fb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1151,6 +1151,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 static const struct file_operations proc_oom_score_adj_operations = {
 	.read		= oom_score_adj_read,
 	.write		= oom_score_adj_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -2039,11 +2040,13 @@ static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
 static const struct file_operations proc_fdinfo_file_operations = {
 	.open           = nonseekable_open,
 	.read		= proc_fdinfo_read,
+	.llseek = no_llseek,/* nonseekable */
 };
 
 static const struct file_operations proc_fd_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_readfd,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 /*
@@ -2112,6 +2115,7 @@ static int proc_readfdinfo(struct file *filp, void *dirent, filldir_t filldir)
 static const struct file_operations proc_fdinfo_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_readfdinfo,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 /*
@@ -2343,6 +2347,7 @@ static int proc_attr_dir_readdir(struct file * filp,
 static const struct file_operations proc_attr_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_attr_dir_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 static struct dentry *proc_attr_dir_lookup(struct inode *dir,
@@ -2751,6 +2756,7 @@ static int proc_tgid_base_readdir(struct file * filp,
 static const struct file_operations proc_tgid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tgid_base_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
@@ -3088,6 +3094,7 @@ static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *den
 static const struct file_operations proc_tid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tid_base_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 static const struct inode_operations proc_tid_base_inode_operations = {
@@ -3324,4 +3331,5 @@ static const struct inode_operations proc_task_inode_operations = {
 static const struct file_operations proc_task_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_task_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5be436e..cfb3e70 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -364,6 +364,7 @@ static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 static const struct file_operations proc_sys_file_operations = {
 	.read		= proc_sys_read,
 	.write		= proc_sys_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations proc_sys_dir_file_operations = {
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 4258384..9327eb7 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -179,6 +179,7 @@ static int proc_root_readdir(struct file * filp,
 static const struct file_operations proc_root_operations = {
 	.read		 = generic_read_dir,
 	.readdir	 = proc_root_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 /*
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 439fc1f..d2e31a0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -538,6 +538,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 
 const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 struct pagemapread {
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 42d2135..0a466ab 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -282,6 +282,7 @@ error:
 static const struct file_operations romfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= romfs_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
 
 static const struct inode_operations romfs_dir_inode_operations = {
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 1c5a6ad..e6de1f7 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -206,6 +206,7 @@ static const struct file_operations signalfd_fops = {
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 12b933a..c23bf78 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -230,5 +230,6 @@ failed_read:
 
 const struct file_operations squashfs_dir_ops = {
 	.read = generic_read_dir,
-	.readdir = squashfs_readdir
+	.readdir = squashfs_readdir,
+	.llseek = default_llseek,/* readdir is present */
 };
diff --git a/fs/timerfd.c b/fs/timerfd.c
index b86ab8e..503f6eb 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -144,6 +144,7 @@ static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static struct file *timerfd_fget(int fd)
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index c2a68ba..4406b2b 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2625,6 +2625,7 @@ static const struct file_operations dfs_fops = {
 	.open = open_debugfs_file,
 	.write = write_debugfs_file,
 	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* write accesses f_pos */
 };
 
 /**
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c60e519..7505590 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1219,6 +1219,7 @@ static const struct file_operations mqueue_file_operations = {
 	.flush = mqueue_flush_file,
 	.poll = mqueue_poll_file,
 	.read = mqueue_read_file,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct super_operations mqueue_super_ops = {
diff --git a/ipc/shm.c b/ipc/shm.c
index 52ed77e..c8201bc 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -298,6 +298,7 @@ static const struct file_operations shm_file_operations = {
 #ifndef CONFIG_MMU
 	.get_unmapped_area	= shm_get_unmapped_area,
 #endif
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static const struct file_operations shm_file_operations_huge = {
@@ -305,6 +306,7 @@ static const struct file_operations shm_file_operations_huge = {
 	.fsync		= shm_fsync,
 	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 int is_file_shm_hugepages(struct file *file)
diff --git a/kernel/configs.c b/kernel/configs.c
index abaee68..8fcc612 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -66,6 +66,7 @@ ikconfig_read_current(struct file *file, char __user *buf,
 static const struct file_operations ikconfig_file_ops = {
 	.owner = THIS_MODULE,
 	.read = ikconfig_read_current,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __init ikconfig_init(void)
diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index ef3c3f8..728d9d6 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -511,6 +511,7 @@ static ssize_t reset_read(struct file *file, char __user *addr, size_t len,
 static const struct file_operations gcov_reset_fops = {
 	.write	= reset_write,
 	.read	= reset_read,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 /*
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..544957f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1992,6 +1992,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 static const struct file_operations fops_kp = {
 	.read =         read_enabled_file_bool,
 	.write =        write_enabled_file_bool,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int __kprobes debugfs_kprobe_init(void)
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index b7e4c36..7aba85c 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -110,6 +110,7 @@ static const struct file_operations pm_qos_power_fops = {
 	.write = pm_qos_power_write,
 	.open = pm_qos_power_open,
 	.release = pm_qos_power_release,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /* unlocked internal variant */
diff --git a/kernel/profile.c b/kernel/profile.c
index b22a899..0875544 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -555,6 +555,7 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 static const struct file_operations proc_profile_operations = {
 	.read		= read_profile,
 	.write		= write_profile,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #ifdef CONFIG_SMP
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 959f8d6..364b9e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -326,6 +326,7 @@ static const struct file_operations blk_dropped_fops = {
 	.owner =	THIS_MODULE,
 	.open =		blk_dropped_open,
 	.read =		blk_dropped_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int blk_msg_open(struct inode *inode, struct file *filp)
@@ -365,6 +366,7 @@ static const struct file_operations blk_msg_fops = {
 	.owner =	THIS_MODULE,
 	.open =		blk_msg_open,
 	.write =	blk_msg_write,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0d88ce9..7da926e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -793,6 +793,7 @@ static const struct file_operations ftrace_profile_fops = {
 	.open		= tracing_open_generic,
 	.read		= ftrace_profile_read,
 	.write		= ftrace_profile_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /* used to initialize the real stat files */
@@ -2623,6 +2624,7 @@ static const struct file_operations ftrace_graph_fops = {
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
 	.release	= ftrace_graph_release,
+	.llseek = seq_lseek,/* we have seq_read */
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 19cccc3..48eceee 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3967,6 +3967,7 @@ static const struct file_operations rb_simple_fops = {
 	.open		= tracing_open_generic,
 	.read		= rb_simple_read,
 	.write		= rb_simple_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4c758f1..79aaa44 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -951,6 +951,7 @@ static const struct file_operations ftrace_enable_fops = {
 	.open = tracing_open_generic,
 	.read = event_enable_read,
 	.write = event_enable_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations ftrace_event_format_fops = {
@@ -963,29 +964,34 @@ static const struct file_operations ftrace_event_format_fops = {
 static const struct file_operations ftrace_event_id_fops = {
 	.open = tracing_open_generic,
 	.read = event_id_read,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations ftrace_event_filter_fops = {
 	.open = tracing_open_generic,
 	.read = event_filter_read,
 	.write = event_filter_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations ftrace_subsystem_filter_fops = {
 	.open = tracing_open_generic,
 	.read = subsystem_filter_read,
 	.write = subsystem_filter_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
 	.open = tracing_open_generic,
 	.read = system_enable_read,
 	.write = system_enable_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static const struct file_operations ftrace_show_header_fops = {
 	.open = tracing_open_generic,
 	.read = show_header,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static struct dentry *event_trace_events_dir(void)
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index a6b7e0e..ed9e8b7 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -195,6 +195,7 @@ static const struct file_operations stack_max_size_fops = {
 	.open		= tracing_open_generic,
 	.read		= stack_max_size_read,
 	.write		= stack_max_size_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void *
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 01e6427..e97d985 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -590,6 +590,7 @@ out_unlock:
 static const struct file_operations filter_fops = {
 	.read  = filter_read,
 	.write = filter_write,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static int dma_debug_fs_init(void)
diff --git a/net/atm/proc.c b/net/atm/proc.c
index 6262aea..6ff0bf1 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -38,6 +38,7 @@ static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
 static const struct file_operations proc_atm_dev_ops = {
 	.owner =	THIS_MODULE,
 	.read =		proc_dev_atm_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static void add_stats(struct seq_file *seq, const char *aal,
diff --git a/net/dccp/probe.c b/net/dccp/probe.c
index 078e48d..612c8ce 100644
--- a/net/dccp/probe.c
+++ b/net/dccp/probe.c
@@ -149,6 +149,7 @@ static const struct file_operations dccpprobe_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = dccpprobe_open,
 	.read    = dccpprobe_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static __init int dccpprobe_init(void)
diff --git a/net/ipv4/tcp_probe.c b/net/ipv4/tcp_probe.c
index f8efada..2faec7a 100644
--- a/net/ipv4/tcp_probe.c
+++ b/net/ipv4/tcp_probe.c
@@ -214,6 +214,7 @@ static const struct file_operations tcpprobe_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = tcpprobe_open,
 	.read    = tcpprobe_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 static __init int tcpprobe_init(void)
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 4a4d35c..131a18c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -102,7 +102,8 @@ static ssize_t tsf_write(struct file *file,
 static const struct file_operations tsf_ops = {
 	.read = tsf_read,
 	.write = tsf_write,
-	.open = mac80211_open_file_generic
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
@@ -121,6 +122,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 static const struct file_operations reset_ops = {
 	.write = reset_write,
 	.open = mac80211_open_file_generic,
+	.llseek = noop_llseek,/* write uses no f_pos */
 };
 
 static ssize_t noack_read(struct file *file, char __user *user_buf,
@@ -156,7 +158,8 @@ static ssize_t noack_write(struct file *file,
 static const struct file_operations noack_ops = {
 	.read = noack_read,
 	.write = noack_write,
-	.open = mac80211_open_file_generic
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
@@ -202,7 +205,8 @@ static ssize_t uapsd_queues_write(struct file *file,
 static const struct file_operations uapsd_queues_ops = {
 	.read = uapsd_queues_read,
 	.write = uapsd_queues_write,
-	.open = mac80211_open_file_generic
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t uapsd_max_sp_len_read(struct file *file, char __user *user_buf,
@@ -248,7 +252,8 @@ static ssize_t uapsd_max_sp_len_write(struct file *file,
 static const struct file_operations uapsd_max_sp_len_ops = {
 	.read = uapsd_max_sp_len_read,
 	.write = uapsd_max_sp_len_write,
-	.open = mac80211_open_file_generic
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t channel_type_read(struct file *file, char __user *user_buf,
@@ -280,7 +285,8 @@ static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations channel_type_ops = {
 	.read = channel_type_read,
-	.open = mac80211_open_file_generic
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static ssize_t queues_read(struct file *file, char __user *user_buf,
@@ -303,7 +309,8 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations queues_ops = {
 	.read = queues_read,
-	.open = mac80211_open_file_generic
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /* statistics stuff */
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index be04d46..0837665 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -145,6 +145,7 @@ static ssize_t rcname_read(struct file *file, char __user *userbuf,
 static const struct file_operations rcname_ops = {
 	.read = rcname_read,
 	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 #endif
 
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 241e76f..776a923 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -122,6 +122,7 @@ static const struct file_operations minstrel_stat_fops = {
 	.open = minstrel_stats_open,
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void
diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
index 47438b4..b05352f 100644
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ b/net/mac80211/rc80211_pid_debugfs.c
@@ -206,6 +206,7 @@ static const struct file_operations rc_pid_fop_events = {
 	.poll = rate_control_pid_events_poll,
 	.open = rate_control_pid_events_open,
 	.release = rate_control_pid_events_release,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 void rate_control_pid_add_sta_debugfs(void *priv, void *priv_sta,
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 76aec6a..999b2cf 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -567,6 +567,7 @@ static const struct file_operations recent_mt_fops = {
 	.write   = recent_mt_proc_write,
 	.release = seq_release_private,
 	.owner   = THIS_MODULE,
+	.llseek = seq_lseek,/* we have seq_read */
 };
 
 static int __net_init recent_proc_net_init(struct net *net)
diff --git a/net/nonet.c b/net/nonet.c
index 92e7664..5333982 100644
--- a/net/nonet.c
+++ b/net/nonet.c
@@ -22,4 +22,5 @@ static int sock_no_open(struct inode *irrelevant, struct file *dontcare)
 const struct file_operations bad_sock_fops = {
 	.owner = THIS_MODULE,
 	.open = sock_no_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 51875a0..61d4e45 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1241,6 +1241,7 @@ static const struct file_operations rfkill_fops = {
 	.unlocked_ioctl	= rfkill_fop_ioctl,
 	.compat_ioctl	= rfkill_fop_ioctl,
 #endif
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static struct miscdevice rfkill_miscdev = {
diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index db3a42b..c7076ac 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -117,6 +117,7 @@ static const struct file_operations sctpprobe_fops = {
 	.owner	= THIS_MODULE,
 	.open	= sctpprobe_open,
 	.read	= sctpprobe_read,
+	.llseek = noop_llseek,/* read uses no f_pos */
 };
 
 sctp_disposition_t jsctp_sf_eat_sack(const struct sctp_endpoint *ep,
diff --git a/net/socket.c b/net/socket.c
index 2270b94..2395cc7 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -502,6 +502,7 @@ static int sock_no_open(struct inode *irrelevant, struct file *dontcare)
 const struct file_operations bad_sock_fops = {
 	.owner = THIS_MODULE,
 	.open = sock_no_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /**
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 2b06410..4da07bc 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1441,6 +1441,7 @@ static const struct file_operations cache_flush_operations_procfs = {
 	.read		= read_flush_procfs,
 	.write		= write_flush_procfs,
 	.release	= release_flush_procfs,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 static void remove_cache_proc_entries(struct cache_detail *cd)
@@ -1646,6 +1647,7 @@ const struct file_operations cache_flush_operations_pipefs = {
 	.read		= read_flush_pipefs,
 	.write		= write_flush_pipefs,
 	.release	= release_flush_pipefs,
+	.llseek = no_llseek,/* open uses nonseekable */
 };
 
 int sunrpc_cache_register_pipefs(struct dentry *parent,
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 3f9a57e..fbf14f1 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -103,6 +103,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 static const struct file_operations ht40allow_map_ops = {
 	.read = ht40allow_map_read,
 	.open = cfg80211_open_file_generic,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 #define DEBUGFS_ADD(name)						\
diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 178061e..ca28d62 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -148,6 +148,7 @@ static const struct file_operations fifo_fops = {
 	.owner		= THIS_MODULE,
 	.read		= fifo_read,
 	.write		= fifo_write,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init example_init(void)
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index 71b2aab..19eed7f 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -141,6 +141,7 @@ static const struct file_operations fifo_fops = {
 	.owner		= THIS_MODULE,
 	.read		= fifo_read,
 	.write		= fifo_write,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init example_init(void)
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index e68bd16..6a60a49 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -155,6 +155,7 @@ static const struct file_operations fifo_fops = {
 	.owner		= THIS_MODULE,
 	.read		= fifo_read,
 	.write		= fifo_write,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init example_init(void)
diff --git a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
index 26fab33..c1b06c3 100644
--- a/samples/tracepoints/tracepoint-sample.c
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -30,6 +30,7 @@ static int my_open(struct inode *inode, struct file *file)
 
 static const struct file_operations mark_ops = {
 	.open = my_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int __init sample_init(void)
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 7320331..48602b7 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -86,7 +86,8 @@ static ssize_t profile_load(struct file *f, const char __user *buf, size_t size,
 }
 
 static const struct file_operations aa_fs_profile_load = {
-	.write = profile_load
+	.write = profile_load,
+	.llseek = default_llseek,/* write accesses f_pos */
 };
 
 /* .replace file hook fn to load and/or replace policy */
@@ -107,7 +108,8 @@ static ssize_t profile_replace(struct file *f, const char __user *buf,
 }
 
 static const struct file_operations aa_fs_profile_replace = {
-	.write = profile_replace
+	.write = profile_replace,
+	.llseek = default_llseek,/* write accesses f_pos */
 };
 
 /* .remove file hook fn to remove loaded policy */
@@ -134,7 +136,8 @@ static ssize_t profile_remove(struct file *f, const char __user *buf,
 }
 
 static const struct file_operations aa_fs_profile_remove = {
-	.write = profile_remove
+	.write = profile_remove,
+	.llseek = default_llseek,/* write accesses f_pos */
 };
 
 /** Base file system setup **/
diff --git a/security/inode.c b/security/inode.c
index 8c777f0..5623f0b 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -53,6 +53,7 @@ static const struct file_operations default_file_ops = {
 	.read =		default_read_file,
 	.write =	default_write_file,
 	.open =		default_open,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static struct inode *get_inode(struct super_block *sb, int mode, dev_t dev)
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a2b72d7..6ce351f 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -968,6 +968,7 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 static const struct file_operations smk_doi_ops = {
 	.read		= smk_read_doi,
 	.write		= smk_write_doi,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
@@ -1031,6 +1032,7 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 static const struct file_operations smk_direct_ops = {
 	.read		= smk_read_direct,
 	.write		= smk_write_direct,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
@@ -1112,6 +1114,7 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 static const struct file_operations smk_ambient_ops = {
 	.read		= smk_read_ambient,
 	.write		= smk_write_ambient,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
@@ -1191,6 +1194,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 static const struct file_operations smk_onlycap_ops = {
 	.read		= smk_read_onlycap,
 	.write		= smk_write_onlycap,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 /**
@@ -1255,6 +1259,7 @@ static ssize_t smk_write_logging(struct file *file, const char __user *buf,
 static const struct file_operations smk_logging_ops = {
 	.read		= smk_read_logging,
 	.write		= smk_write_logging,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 /**
  * smk_fill_super - fill the /smackfs superblock
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index f25e3cc..86d29d1 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -220,6 +220,7 @@ static const struct file_operations seq_oss_f_ops =
 	.poll =		odev_poll,
 	.unlocked_ioctl =	odev_ioctl,
 	.compat_ioctl =	odev_ioctl_compat,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int __init
diff --git a/sound/core/sound.c b/sound/core/sound.c
index ac42af4..ce6d476 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -184,7 +184,8 @@ static int snd_open(struct inode *inode, struct file *file)
 static const struct file_operations snd_fops =
 {
 	.owner =	THIS_MODULE,
-	.open =		snd_open
+	.open =		snd_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 #ifdef CONFIG_SND_DYNAMIC_MINORS
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index 2e48b17..9135cc2 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1117,6 +1117,7 @@ static const struct file_operations dev_fileops = {
 	.unlocked_ioctl	= dev_ioctl,
 	.open		= dev_open,
 	.release	= dev_release,
+	.llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static int reset_dsp(void)
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index 479e302..a6653a6 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -257,6 +257,7 @@ const struct file_operations dac_audio_fops = {
       .unlocked_ioctl =	dac_audio_unlocked_ioctl,
       .open =		dac_audio_open,
       .release =	dac_audio_release,
+      .llseek = noop_llseek,/* read and write both use no f_pos */
 };
 
 static enum hrtimer_restart sh_dac_audio_timer(struct hrtimer *handle)
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index acc91da..51222d8 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -223,6 +223,7 @@ static const struct file_operations codec_reg_fops = {
 	.open = codec_reg_open_file,
 	.read = codec_reg_read_file,
 	.write = codec_reg_write_file,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 static void soc_init_codec_debugfs(struct snd_soc_codec *codec)
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 03cb7c0..8583a8a 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1089,6 +1089,7 @@ static ssize_t dapm_widget_power_read_file(struct file *file,
 static const struct file_operations dapm_widget_power_fops = {
 	.open = dapm_widget_power_open_file,
 	.read = dapm_widget_power_read_file,
+	.llseek = default_llseek,/* read accesses f_pos */
 };
 
 void snd_soc_dapm_debugfs_init(struct snd_soc_codec *codec)
diff --git a/sound/sound_core.c b/sound/sound_core.c
index cb61317..8b406ce 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -165,6 +165,7 @@ static const struct file_operations soundcore_fops =
 	/* We must have an owner or the module locking fails */
 	.owner	= THIS_MODULE,
 	.open	= soundcore_open,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b78b794..f346738 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1305,6 +1305,7 @@ static struct file_operations kvm_vcpu_fops = {
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.compat_ioctl   = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 /*
@@ -1774,6 +1775,7 @@ static struct file_operations kvm_vm_fops = {
 	.compat_ioctl   = kvm_vm_compat_ioctl,
 #endif
 	.mmap           = kvm_vm_mmap,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static int kvm_dev_ioctl_create_vm(void)
@@ -1867,6 +1869,7 @@ out:
 static struct file_operations kvm_chardev_ops = {
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.compat_ioctl   = kvm_dev_ioctl,
+	.llseek = noop_llseek,/* no read or write fn */
 };
 
 static struct miscdevice kvm_dev = {
-- 
1.7.1

