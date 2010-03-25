Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0CYK2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:28:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0CYK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:27:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Thu, 25 Mar 2010 11:26:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <20100324170704.7ef8b9c1.akpm@linux-foundation.org>
In-Reply-To: <20100324170704.7ef8b9c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003251126.56640.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FMOtn7oWlKktIsfxdgYdlBPDUQlMK+ltCxvN
 Lg1RYXSm4HWvQqKAGI5ixGLFXLQPYIR6PnPXU/EvutbFat6KF+
 9Pv3AmzVS8/QHBSHv/gBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Andrew Morton wrote:
> On Wed, 24 Mar 2010 22:40:54 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I've spent some time continuing the work of the people on Cc and many others
> > to remove the big kernel lock from Linux
> 
> <looks inside ptrace.c>
> 
> Seems that there might be a few tricksy bits in here.  Please do push
> at least the non-obvious parts out to the relevant people.

Sure, that is certainly the plan.

Regarding the ptrace bits, this is one of a handful of places where the BKL
was put in by someone a really long time ago but with the rest of the
series applied, it becomes evident that there is nothing whatsoever that
it serializes with, so removing the BKL here does not make the situation
worse. It could still be a bug that needs to be fixed by adding a new
serialization method no matter if the BKL is there or not.

> It'd be interesting to see the overall diffstat?

Let me give you three separate diffstats. One is for the trivial pushdown of
the BKL into all the ioctl and llseek functions as well as marking all
remaining users as 'depends on BKL' in Kconfig, the second one is for the
TTY layer conversion to the Big TTY Mutex and the third one is all the rest.

	Arnd

---
Big TTY Mutex conversion:
 drivers/char/Makefile           |    2 +
 drivers/char/amiserial.c        |   16 ++--
 drivers/char/cyclades.c         |   20 ++--
 drivers/char/epca.c             |    4 +-
 drivers/char/isicom.c           |   10 +-
 drivers/char/istallion.c        |   20 ++--
 drivers/char/mxser.c            |   10 +-
 drivers/char/n_hdlc.c           |   16 ++--
 drivers/char/n_r3964.c          |   10 +-
 drivers/char/pty.c              |    8 +-
 drivers/char/riscom8.c          |    8 +-
 drivers/char/rocket.c           |    8 +-
 drivers/char/serial167.c        |    4 +-
 drivers/char/specialix.c        |   10 +-
 drivers/char/stallion.c         |   12 ++--
 drivers/char/sx.c               |   12 ++--
 drivers/char/synclink.c         |   10 ++-
 drivers/char/synclink_gt.c      |    8 +-
 drivers/char/synclinkmp.c       |   12 ++--
 drivers/char/tty_buffer.c       |    2 +-
 drivers/char/tty_io.c           |  123 +++++++++++++++------------
 drivers/char/tty_ioctl.c        |   36 ++++----
 drivers/char/tty_ldisc.c        |   53 +++++++-----
 drivers/char/tty_lock.c         |  100 ++++++++++++++++++++++
 drivers/char/tty_port.c         |    6 +-
 drivers/char/vc_screen.c        |    4 +-
 drivers/char/vt.c               |    4 +-
 drivers/char/vt_ioctl.c         |   12 ++--
 drivers/isdn/i4l/isdn_common.c  |   20 ++--
 drivers/isdn/i4l/isdn_tty.c     |    8 +-
 drivers/net/irda/irtty-sir.c    |    5 +-
 drivers/net/ppp_generic.c       |   29 +++---
 drivers/serial/68360serial.c    |    4 +-
 drivers/serial/crisv10.c        |    8 +-
 drivers/serial/serial_core.c    |   42 +++++-----
 drivers/staging/strip/strip.c   |    2 +-
 drivers/usb/class/cdc-acm.c     |    2 +-
 drivers/usb/serial/usb-serial.c |   18 ++--
 drivers/video/console/vgacon.c  |    4 +-
 include/linux/init_task.h       |    1 +
 include/linux/sched.h           |    1 +
 include/linux/tty.h             |  180 +++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                   |    1 +


ioctl/llseek pushdown, Kconfig: 
 43 files changed, 590 insertions(+), 275 deletions(-)
 Documentation/DocBook/kernel-hacking.tmpl   |    2 +-
 Documentation/filesystems/vfs.txt           |    3 +-
 arch/arm/kernel/etm.c                       |    1 -
 arch/cris/arch-v10/drivers/ds1302.c         |    3 -
 arch/cris/arch-v10/drivers/gpio.c           |    2 -
 arch/cris/arch-v10/drivers/i2c.c            |    2 -
 arch/cris/arch-v10/drivers/pcf8563.c        |    3 -
 arch/cris/arch-v10/drivers/sync_serial.c    |    4 +-
 arch/cris/arch-v32/drivers/cryptocop.c      |    4 +-
 arch/cris/arch-v32/drivers/i2c.c            |    2 -
 arch/cris/arch-v32/drivers/mach-a3/gpio.c   |    2 -
 arch/cris/arch-v32/drivers/mach-fs/gpio.c   |    2 -
 arch/cris/arch-v32/drivers/pcf8563.c        |    5 +-
 arch/cris/arch-v32/drivers/sync_serial.c    |    4 +-
 arch/ia64/kernel/perfmon.c                  |    2 -
 arch/ia64/sn/kernel/sn2/sn_hwperf.c         |    2 -
 arch/m68k/bvme6000/rtc.c                    |    2 -
 arch/m68k/mvme16x/rtc.c                     |    2 -
 arch/powerpc/platforms/iseries/Kconfig      |    1 -
 arch/s390/Kconfig                           |    1 -
 arch/um/drivers/harddog_kern.c              |    2 -
 arch/um/drivers/hostaudio_kern.c            |    3 -
 arch/um/drivers/mmapper_kern.c              |    3 -
 arch/x86/Kconfig                            |    3 +-
 arch/x86/kvm/Kconfig                        |    1 -
 drivers/block/DAC960.c                      |    3 +-
 drivers/block/Kconfig                       |    6 +-
 drivers/block/paride/pg.c                   |    2 -
 drivers/block/paride/pt.c                   |    2 -
 drivers/block/pktcdvd.c                     |    3 -
 drivers/char/Kconfig                        |   25 +-
 drivers/char/apm-emulation.c                |    2 -
 drivers/char/applicom.c                     |    2 -
 drivers/char/ds1302.c                       |    1 -
 drivers/char/ds1620.c                       |    2 -
 drivers/char/dtlk.c                         |    2 -
 drivers/char/generic_nvram.c                |    2 -
 drivers/char/genrtc.c                       |    2 -
 drivers/char/i8k.c                          |    2 -
 drivers/char/ip2/ip2main.c                  |    1 -
 drivers/char/ipmi/Kconfig                   |    2 -
 drivers/char/ipmi/ipmi_devintf.c            |    2 -
 drivers/char/ipmi/ipmi_watchdog.c           |    2 -
 drivers/char/istallion.c                    |    1 -
 drivers/char/lp.c                           |    1 -
 drivers/char/mmtimer.c                      |    1 -
 drivers/char/nwflash.c                      |    1 -
 drivers/char/pcmcia/Kconfig                 |    4 +-
 drivers/char/raw.c                          |    4 -
 drivers/char/rio/rio_linux.c                |    1 -
 drivers/char/stallion.c                     |    1 -
 drivers/char/sx.c                           |    1 -
 drivers/char/uv_mmtimer.c                   |    1 -
 drivers/char/viotape.c                      |    1 -
 drivers/crypto/Kconfig                      |    2 +-
 drivers/firewire/Kconfig                    |    1 -
 drivers/firewire/core-cdev.c                |    2 -
 drivers/gpu/drm/Kconfig                     |    5 +-
 drivers/gpu/drm/i810/i810_dma.c             |    2 -
 drivers/gpu/drm/i830/i830_dma.c             |    2 -
 drivers/hid/Kconfig                         |    2 +-
 drivers/hid/usbhid/Kconfig                  |    2 +-
 drivers/hid/usbhid/hiddev.c                 |    3 +-
 drivers/hwmon/Kconfig                       |    2 +-
 drivers/hwmon/fschmd.c                      |    2 -
 drivers/ide/Kconfig                         |    1 -
 drivers/ide/ide-tape.c                      |    1 -
 drivers/ieee1394/Kconfig                    |    6 +-
 drivers/ieee1394/dv1394.c                   |    2 -
 drivers/ieee1394/raw1394.c                  |    2 -
 drivers/ieee1394/video1394.c                |    4 +-
 drivers/infiniband/Kconfig                  |    6 +-
 drivers/infiniband/core/ucm.c               |    2 -
 drivers/infiniband/core/ucma.c              |    2 -
 drivers/infiniband/core/user_mad.c          |    3 -
 drivers/infiniband/core/uverbs_main.c       |   11 +-
 drivers/input/joystick/Kconfig              |    2 +-
 drivers/input/misc/Kconfig                  |   13 +-
 drivers/input/misc/hp_sdc_rtc.c             |    2 -
 drivers/input/misc/uinput.c                 |    1 -
 drivers/input/mouse/Kconfig                 |    4 +-
 drivers/input/serio/Kconfig                 |    1 -
 drivers/input/tablet/Kconfig                |    8 +-
 drivers/input/touchscreen/Kconfig           |    2 +-
 drivers/isdn/Kconfig                        |    2 -
 drivers/isdn/capi/Kconfig                   |    2 +-
 drivers/isdn/capi/capi.c                    |    1 -
 drivers/isdn/divert/divert_procfs.c         |    2 -
 drivers/isdn/hardware/eicon/Kconfig         |    2 +-
 drivers/isdn/hysdn/Kconfig                  |    2 +-
 drivers/isdn/i4l/Kconfig                    |    1 -
 drivers/isdn/i4l/isdn_common.c              |    1 -
 drivers/isdn/mISDN/Kconfig                  |    1 -
 drivers/isdn/mISDN/timerdev.c               |    3 -
 drivers/macintosh/Kconfig                   |    7 +-
 drivers/macintosh/ans-lcd.c                 |    2 -
 drivers/macintosh/nvram.c                   |    2 -
 drivers/macintosh/via-pmu.c                 |    2 -
 drivers/media/Kconfig                       |    5 +-
 drivers/media/dvb/bt8xx/Kconfig             |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c            |    1 -
 drivers/media/dvb/dvb-core/dmxdev.c         |    3 -
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    3 -
 drivers/media/dvb/dvb-core/dvb_frontend.c   |    5 +-
 drivers/media/dvb/dvb-core/dvb_net.c        |    3 -
 drivers/media/dvb/firewire/Kconfig          |    2 +-
 drivers/media/dvb/firewire/firedtv-ci.c     |    3 -
 drivers/media/dvb/ttpci/Kconfig             |    2 +-
 drivers/media/dvb/ttpci/av7110.c            |    3 -
 drivers/media/dvb/ttpci/av7110_av.c         |    5 -
 drivers/media/dvb/ttpci/av7110_ca.c         |    3 -
 drivers/media/video/Kconfig                 |   13 +-
 drivers/media/video/cpia.c                  |    2 -
 drivers/media/video/v4l2-dev.c              |    2 -
 drivers/message/fusion/Kconfig              |    2 +-
 drivers/message/i2o/Kconfig                 |    2 +-
 drivers/misc/Kconfig                        |    2 +-
 drivers/mtd/Kconfig                         |    1 -
 drivers/mtd/mtdchar.c                       |    1 -
 drivers/mtd/ubi/Kconfig                     |    2 +-
 drivers/mtd/ubi/cdev.c                      |    2 -
 drivers/net/Kconfig                         |    1 -
 drivers/net/appletalk/Kconfig               |    1 -
 drivers/net/ppp_generic.c                   |    4 +-
 drivers/net/wan/Kconfig                     |    2 +-
 drivers/net/wireless/Kconfig                |    4 +-
 drivers/net/wireless/airo.c                 |    9 -
 drivers/net/wireless/ray_cs.c               |    3 -
 drivers/pci/hotplug/Kconfig                 |    2 +-
 drivers/pcmcia/Kconfig                      |    3 +-
 drivers/platform/x86/Kconfig                |    1 -
 drivers/pnp/isapnp/Kconfig                  |    2 +-
 drivers/rtc/Kconfig                         |    1 -
 drivers/rtc/rtc-m41t80.c                    |    1 -
 drivers/s390/block/Kconfig                  |    2 +-
 drivers/s390/char/Kconfig                   |    2 +-
 drivers/s390/char/fs3270.c                  |    1 -
 drivers/s390/char/tape_char.c               |    2 +-
 drivers/s390/cio/chsc_sch.c                 |    2 -
 drivers/s390/crypto/zcrypt_api.c            |    1 -
 drivers/s390/scsi/zfcp_cfdc.c               |    2 -
 drivers/sbus/char/envctrl.c                 |    1 -
 drivers/sbus/char/openprom.c                |    1 -
 drivers/scsi/3w-9xxx.c                      |    2 -
 drivers/scsi/3w-sas.c                       |    2 -
 drivers/scsi/3w-xxxx.c                      |    2 -
 drivers/scsi/Kconfig                        |   28 +-
 drivers/scsi/aacraid/linit.c                |    1 -
 drivers/scsi/dpt_i2o.c                      |    2 -
 drivers/scsi/gdth.c                         |    2 -
 drivers/scsi/megaraid.c                     |    2 -
 drivers/scsi/megaraid/Kconfig.megaraid      |    6 +-
 drivers/scsi/megaraid/megaraid_mm.c         |    2 -
 drivers/scsi/megaraid/megaraid_sas.c        |    1 -
 drivers/scsi/mpt2sas/Kconfig                |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |    1 -
 drivers/scsi/osd/Kconfig                    |    2 +-
 drivers/scsi/osd/osd_uld.c                  |    2 -
 drivers/scsi/osst.c                         |    2 -
 drivers/scsi/pmcraid.c                      |    2 -
 drivers/scsi/st.c                           |    1 -
 drivers/spi/spidev.c                        |    2 -
 drivers/staging/comedi/comedi_fops.c        |    2 -
 drivers/staging/dream/pmem.c                |    3 -
 drivers/staging/dream/qdsp5/audio_aac.c     |    2 -
 drivers/staging/dream/qdsp5/audio_mp3.c     |    2 -
 drivers/staging/poch/poch.c                 |    3 -
 drivers/staging/sep/sep_driver.c            |    2 -
 drivers/staging/vme/devices/vme_user.c      |    2 -
 drivers/telephony/Kconfig                   |    2 +-
 drivers/telephony/ixj.c                     |    1 -
 drivers/usb/Kconfig                         |    2 +-
 drivers/usb/class/Kconfig                   |    1 -
 drivers/usb/class/usblp.c                   |    2 -
 drivers/usb/gadget/Kconfig                  |    2 -
 drivers/usb/gadget/printer.c                |    1 -
 drivers/usb/host/Kconfig                    |    2 +-
 drivers/usb/misc/Kconfig                    |    8 +-
 drivers/usb/misc/idmouse.c                  |    2 -
 drivers/usb/misc/iowarrior.c                |    1 -
 drivers/usb/misc/rio500.c                   |    1 -
 drivers/usb/misc/sisusbvga/Kconfig          |    2 +-
 fs/adfs/Kconfig                             |    1 -
 fs/afs/Kconfig                              |    1 -
 fs/autofs/Kconfig                           |    1 -
 fs/autofs/root.c                            |    1 -
 fs/autofs4/Kconfig                          |    1 -
 fs/autofs4/dev-ioctl.c                      |    2 -
 fs/btrfs/super.c                            |    1 -
 fs/coda/Kconfig                             |    1 -
 fs/coda/pioctl.c                            |    3 -
 fs/coda/psdev.c                             |    2 -
 fs/ecryptfs/Kconfig                         |    1 -
 fs/ecryptfs/file.c                          |    2 -
 fs/ecryptfs/miscdev.c                       |    2 -
 fs/fat/Kconfig                              |    3 -
 fs/freevxfs/Kconfig                         |    1 -
 fs/hfsplus/Kconfig                          |    1 -
 fs/hfsplus/dir.c                            |    2 -
 fs/hfsplus/inode.c                          |    2 -
 fs/hpfs/Kconfig                             |    1 -
 fs/ioctl.c                                  |   11 +-
 fs/isofs/Kconfig                            |    1 -
 fs/jffs2/Kconfig                            |    1 -
 fs/ncpfs/Kconfig                            |    1 -
 fs/ncpfs/dir.c                              |    2 -
 fs/ncpfs/file.c                             |    1 -
 fs/nfs/Kconfig                              |    2 +-
 fs/nfsd/Kconfig                             |    1 -
 fs/ocfs2/Kconfig                            |    1 -
 fs/qnx4/Kconfig                             |    1 -
 fs/read_write.c                             |   34 +
 fs/reiserfs/Kconfig                         |    1 -
 fs/smbfs/Kconfig                            |    1 -
 fs/smbfs/dir.c                              |    2 -
 fs/smbfs/file.c                             |    1 -
 fs/squashfs/Kconfig                         |    1 -
 fs/udf/Kconfig                              |    1 -
 fs/udf/dir.c                                |    2 -
 fs/udf/file.c                               |    1 -
 fs/ufs/Kconfig                              |    2 +-
 include/linux/fs.h                          |    5 +
 kernel/power/Kconfig                        |    2 +-
 lib/Kconfig.debug                           |    2 +-
 lib/kernel_lock.c                           |   37 +-
 net/bluetooth/hidp/Kconfig                  |    1 -
 net/ipx/Kconfig                             |    1 -
 net/irda/Kconfig                            |    2 +-
 net/irda/irnet/Kconfig                      |    2 +-
 net/socket.c                                |    1 -
 net/sunrpc/Kconfig                          |    4 +-
 net/wanrouter/Kconfig                       |    2 +-
 net/x25/Kconfig                             |    2 +-
 sound/Kconfig                               |    2 +-
 sound/core/control.c                        |    2 -
 sound/core/oss/pcm_oss.c                    |    2 -
 sound/core/pcm_native.c                     |    2 -
 sound/core/seq/seq_clientmgr.c              |    2 -
 sound/oss/au1550_ac97.c                     |   30 +-
 sound/oss/dmasound/dmasound_core.c          |    2 -
 sound/oss/msnd_pinnacle.c                   |    2 -
 sound/oss/sh_dac_audio.c                    |    3 -
 sound/oss/swarm_cs4297a.c                   |    3 -
 sound/oss/vwsnd.c                           |    2 -
 sound/soc/soc-core.c                        |    2 -
 virt/kvm/kvm_main.c                         |    1 -
 248 files changed, 190 insertions(+), 516 deletions(-)

The rest:
 arch/arm/lib/uaccess_with_memcpy.c         |    1 +
 arch/x86/configs/x86_64_defconfig          |   29 +-
 arch/x86/kernel/microcode_core.c           |    6 +-
 block/bsg.c                                |    2 -
 block/compat_ioctl.c                       |    8 +-
 block/ioctl.c                              |   24 +-
 drivers/block/DAC960.c                     |    4 +-
 drivers/block/aoe/aoechr.c                 |    6 +-
 drivers/block/cciss.c                      |    4 +-
 drivers/block/paride/pg.c                  |    4 +-
 drivers/block/paride/pt.c                  |   16 +-
 drivers/char/briq_panel.c                  |    1 +
 drivers/char/dsp56k.c                      |    1 +
 drivers/char/hpet.c                        |   96 +++--
 drivers/char/mwave/mwavedd.c               |    1 +
 drivers/char/nvram.c                       |    7 +-
 drivers/char/pcmcia/cm4000_cs.c            |    1 +
 drivers/char/pcmcia/cm4040_cs.c            |    1 +
 drivers/char/random.c                      |    2 +
 drivers/char/snsc.c                        |    1 +
 drivers/char/tlclk.c                       |    1 +
 drivers/char/toshiba.c                     |    1 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    1 +
 drivers/gpu/vga/vgaarb.c                   |    4 +-
 drivers/hid/hidraw.c                       |    1 +
 drivers/input/serio/serio_raw.c            |    1 +
 drivers/isdn/capi/capifs.c                 |   10 +-
 drivers/md/dm-ioctl.c                      |    2 +
 drivers/media/dvb/dvb-core/dvbdev.c        |    1 +
 drivers/misc/phantom.c                     |    1 +
 drivers/pci/proc.c                         |    4 +-
 drivers/pcmcia/pcmcia_ioctl.c              |   23 +-
 drivers/sbus/char/display7seg.c            |    1 +
 drivers/sbus/char/jsflash.c                |   20 +-
 drivers/scsi/aacraid/linit.c               |    1 +
 drivers/scsi/ch.c                          |    1 +
 drivers/scsi/sg.c                          |   22 +-
 drivers/usb/core/file.c                    |    1 +
 drivers/usb/core/inode.c                   |    5 +
 drivers/usb/gadget/inode.c                 |   12 +-
 drivers/usb/misc/usblcd.c                  |    1 +
 drivers/usb/mon/mon_bin.c                  |   14 +-
 drivers/watchdog/cpwd.c                    |    1 +
 fs/adfs/super.c                            |    8 +-
 fs/affs/super.c                            |   14 +-
 fs/afs/super.c                             |    5 +
 fs/autofs/root.c                           |   67 +++-
 fs/autofs4/root.c                          |   69 +++-
 fs/bad_inode.c                             |    4 +
 fs/bfs/inode.c                             |    7 +-
 fs/block_dev.c                             |   20 +-
 fs/cifs/cifsfs.c                           |    9 +-
 fs/coda/inode.c                            |    8 +-
 fs/compat_ioctl.c                          |   43 +--
 fs/ecryptfs/main.c                         |    4 +
 fs/exec.c                                  |    6 -
 fs/exofs/super.c                           |    1 -
 fs/ext2/inode.c                            |    5 +-
 fs/ext2/super.c                            |   58 ++-
 fs/ext3/super.c                            |   12 -
 fs/ext4/super.c                            |   11 -
 fs/fat/dir.c                               |   11 +-
 fs/fat/fat.h                               |    2 +-
 fs/fat/file.c                              |   33 ++-
 fs/fat/namei_msdos.c                       |    7 +-
 fs/fat/namei_vfat.c                        |    7 +-
 fs/freevxfs/vxfs_lookup.c                  |    1 +
 fs/freevxfs/vxfs_super.c                   |    7 +-
 fs/hfs/super.c                             |    6 +-
 fs/hfsplus/super.c                         |    5 -
 fs/hpfs/super.c                            |    8 +-
 fs/hppfs/hppfs.c                           |    2 +-
 fs/ioctl.c                                 |    2 +
 fs/isofs/dir.c                             |    1 +
 fs/isofs/inode.c                           |    8 +-
 fs/jffs2/super.c                           |   11 +-
 fs/jfs/super.c                             |   22 +-
 fs/locks.c                                 |  110 +++--
 fs/namespace.c                             |    2 -
 fs/ncpfs/inode.c                           |    8 +-
 fs/nfs/super.c                             |   24 +
 fs/nilfs2/ioctl.c                          |    1 -
 fs/nilfs2/super.c                          |   10 -
 fs/ntfs/super.c                            |   24 +-
 fs/ocfs2/stack_user.c                      |    1 +
 fs/ocfs2/super.c                           |    5 +
 fs/proc/base.c                             |   10 +-
 fs/proc/inode.c                            |    8 +-
 fs/qnx4/dir.c                              |    1 +
 fs/qnx4/inode.c                            |    8 +-
 fs/read_write.c                            |    8 +
 fs/reiserfs/super.c                        |    4 +
 fs/smbfs/inode.c                           |    5 +
 fs/squashfs/super.c                        |    6 +
 fs/super.c                                 |    3 -
 fs/udf/super.c                             |    8 +-
 fs/ufs/super.c                             |    5 +
 include/linux/auto_fs.h                    |    1 +
 include/linux/blkdev.h                     |    6 +
 include/linux/ext2_fs_sb.h                 |    6 +
 include/linux/fs.h                         |    2 +
 include/linux/sched.h                      |    2 +
 include/linux/smp_lock.h                   |   57 ++-
 init/main.c                                |    5 -
 kernel/cgroup.c                            |    4 -
 kernel/perf_event.c                        |    2 +
 kernel/ptrace.c                            |   10 -
 kernel/sched.c                             |   17 +
 kernel/trace/blktrace.c                    |   14 +-
 kernel/trace/trace.c                       |    8 -
 lib/Kconfig.debug                          |   17 +
 lib/Makefile                               |    4 +
 lib/kernel_lock.c                          |  104 +-----
 lib/kernel_lock_core.c                     |  307 +++++++++++++
 net/sunrpc/cache.c                         |   30 +-
 net/sunrpc/rpc_pipe.c                      |    9 +-
 sound/core/timer.c                         |    5 +-
 sound/sound_core.c                         |    1 +
 virt/kvm/kvm_main.c                        |    6 +
 120 files changed, 1156 insertions(+), 540 deletions(-)

