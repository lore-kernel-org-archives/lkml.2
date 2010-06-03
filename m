Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0FCANa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:13:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab0FCAN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:13:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: [RFC 0/5] BKL removal leftovers
Date: Thu,  3 Jun 2010 02:13:14 +0200
Message-Id: <1275523999-27462-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V01U2FsdGVkX1+9amZ1yhkvhQ/TyepmTA8NT/EZZpSlkEwaiX6
 O2H3hCnCNypXfGPtrpKbjkZh7UAIvx0h9GiO8DjZ5UhaVfhFO2
 RlpoNuzTTtKuItGfwfMxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we can complete the ioctl-pushdown, tty, block, vfs,
usb, and v4l patch series for the next merge window,
this is essentially what remains.

As Ingo suggested, I've found a way to script the
conversion from BKL to a per-file mutex that works
for most of the remaining users, but I still manually
needed to create a list of these, because there are
some that are at best non-obvious.

The question is how to merge that first patch
without patch-bombing lkml with 100 trivial
patches. For now, I've kept it as a single patch.

The other patches are fairly straightforward.
Among the code that still depends on CONFIG_BKL
after this are a lot of file systems, DRM, fs/locks.c,
USB-HID, i4l, v4l, dvb, oss and some old networking
protocols. It's mostly code that I can live without
on all of my machines, but not to the point that
I'd expect distro kernels to ship without all of
that.

Arnd Bergmann (5):
  BKL: autoconvert trivial users to private mutex
  BKL: remove the BKL from kernel init code
  BKL: do not take BKL in do_coredump
  BKL: use no BKL in llseek
  BKL: introduce CONFIG_BKL.

 arch/cris/arch-v10/drivers/eeprom.c        |    2 -
 arch/cris/arch-v10/drivers/i2c.c           |    2 -
 arch/cris/arch-v32/drivers/cryptocop.c     |    2 -
 arch/cris/arch-v32/drivers/i2c.c           |    2 -
 drivers/block/paride/pg.c                  |    7 ++--
 drivers/block/paride/pt.c                  |   19 ++++++------
 drivers/char/Kconfig                       |    2 +-
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
 drivers/gpu/drm/Kconfig                    |    5 ++-
 drivers/hid/usbhid/Kconfig                 |    2 +-
 drivers/hwmon/fschmd.c                     |    6 ++--
 drivers/hwmon/w83793.c                     |    6 ++--
 drivers/input/misc/hp_sdc_rtc.c            |    7 ++--
 drivers/isdn/Kconfig                       |    1 +
 drivers/isdn/capi/Kconfig                  |    2 +-
 drivers/isdn/capi/capi.c                   |    6 ++--
 drivers/isdn/divert/divert_procfs.c        |    7 ++--
 drivers/isdn/hardware/eicon/divamnt.c      |    7 ++--
 drivers/isdn/hardware/eicon/divasi.c       |    2 -
 drivers/isdn/hardware/eicon/divasmain.c    |    2 -
 drivers/isdn/hysdn/hysdn_procconf.c        |   21 +++++++------
 drivers/isdn/hysdn/hysdn_proclog.c         |   15 +++++----
 drivers/isdn/i4l/isdn_common.c             |   27 +++++++++--------
 drivers/isdn/mISDN/Kconfig                 |    1 +
 drivers/isdn/mISDN/timerdev.c              |    7 ++--
 drivers/macintosh/adb.c                    |   10 +++---
 drivers/macintosh/smu.c                    |    6 ++--
 drivers/macintosh/via-pmu.c                |   11 ++++---
 drivers/media/Kconfig                      |    3 +-
 drivers/media/dvb/bt8xx/dst_ca.c           |    7 ++--
 drivers/media/video/cx88/cx88-blackbird.c  |   13 ++++----
 drivers/media/video/dabusb.c               |   18 ++++++------
 drivers/media/video/se401.c                |    9 +++--
 drivers/media/video/stradis.c              |    9 +++--
 drivers/media/video/stv680.c               |    6 ++--
 drivers/media/video/usbvideo/vicam.c       |   14 ++++----
 drivers/message/fusion/mptctl.c            |   15 +++++----
 drivers/message/i2o/i2o_config.c           |   23 +++++++-------
 drivers/misc/Kconfig                       |    2 +-
 drivers/misc/phantom.c                     |   11 ++++---
 drivers/mtd/mtdchar.c                      |   15 +++++----
 drivers/net/appletalk/Kconfig              |    1 +
 drivers/net/ppp_generic.c                  |   19 ++++++------
 drivers/net/wan/cosa.c                     |   10 +++---
 drivers/pci/hotplug/cpqphp_sysfs.c         |   13 ++++----
 drivers/pnp/isapnp/proc.c                  |    6 ++--
 drivers/rtc/rtc-m41t80.c                   |   13 ++++----
 drivers/sbus/char/Kconfig                  |    2 +-
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
 drivers/staging/sep/Kconfig                |    2 +-
 drivers/staging/usbip/Kconfig              |    2 +-
 drivers/staging/vme/devices/vme_user.c     |    7 ++--
 drivers/telephony/ixj.c                    |    7 ++--
 drivers/usb/core/inode.c                   |    1 -
 drivers/usb/gadget/Kconfig                 |    2 +-
 drivers/usb/gadget/printer.c               |    7 ++--
 drivers/usb/misc/iowarrior.c               |   15 +++++----
 drivers/usb/misc/rio500.c                  |   15 +++++----
 drivers/usb/misc/usblcd.c                  |   16 +++++-----
 drivers/watchdog/cpwd.c                    |   15 +++++----
 drivers/zorro/proc.c                       |    6 ++--
 fs/adfs/Kconfig                            |    1 +
 fs/afs/Kconfig                             |    1 +
 fs/autofs/Kconfig                          |    1 +
 fs/autofs4/Kconfig                         |    1 +
 fs/coda/Kconfig                            |    1 +
 fs/ecryptfs/Kconfig                        |    1 +
 fs/exec.c                                  |    6 ----
 fs/fat/Kconfig                             |    2 +
 fs/freevxfs/Kconfig                        |    1 +
 fs/hfsplus/ioctl.c                         |   11 ++++---
 fs/hpfs/Kconfig                            |    1 +
 fs/isofs/Kconfig                           |    1 +
 fs/jffs2/Kconfig                           |    1 +
 fs/ncpfs/Kconfig                           |    1 +
 fs/nfs/Kconfig                             |    2 +-
 fs/nfsd/Kconfig                            |    1 +
 fs/ocfs2/Kconfig                           |    1 +
 fs/qnx4/Kconfig                            |    1 +
 fs/read_write.c                            |    4 +-
 fs/reiserfs/Kconfig                        |    1 +
 fs/smbfs/Kconfig                           |    1 +
 fs/squashfs/Kconfig                        |    2 +-
 fs/udf/Kconfig                             |    1 +
 fs/ufs/Kconfig                             |    2 +-
 init/Kconfig                               |    2 +-
 init/main.c                                |    5 ---
 kernel/trace/trace.c                       |    8 -----
 lib/Kconfig.debug                          |   11 ++++++-
 net/ipx/Kconfig                            |    1 +
 net/irda/Kconfig                           |    2 +-
 net/irda/irnet/Kconfig                     |    2 +-
 net/wanrouter/wanmain.c                    |    7 ++--
 net/wanrouter/wanproc.c                    |    7 ++--
 net/x25/Kconfig                            |    2 +-
 sound/oss/Kconfig                          |    2 +-
 140 files changed, 558 insertions(+), 512 deletions(-)

