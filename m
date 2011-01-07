Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1AGWsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:48:24 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:39163 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1AGWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=S3hjUgNNsRia5lA0VicqFxFKN47Pq2Wr4Q8Sb3x7NkjBOi23LecrggU/NhDr14OaJ3
         VokSEHcPDsguQfc9W6zvRfTpF4nFX/jMF76RgYO9ONBd6K91oLWXJ5MlSlqKe645t1lY
         yRvdOPrv4tpCZmzosq4x8SvjghvQazqU1pQrU=
Date: Fri, 7 Jan 2011 17:48:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for 2.6.38
Message-ID: <20110107224819.GB9884@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following git branch to receive
workqueue changes for 2.6.38.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-2.6.38

The branch contains 33 changes.

* Update the users of cancel_rearming_delayed_work[queue]() and
  schedule the two deprecate functions for removal.

* Allow chained queueing and properly drain them during destruction.
  This will be used to clean up SCSI workqueue usages.

* Other patches are to remove the use of flush_scheduled_work().
  After these conversions, there remain very few
  flush_scheduled_work() users and the goal is to convert all of them,
  mark it deprecated and trigger WARN_ON_ONCE() if flush_workqueue()
  is attempted on any of the system workqueues.

Pulling into the current mainline (01539ba2) causes one conflict in
drivers/media/video/bt8xx/bttv-input.c.

  <<<<<<< HEAD
		del_timer_sync(&btv->remote->timer_end);
  =======
		del_timer_sync(&btv->remote->timer);
		flush_scheduled_work();
  >>>>>>> 01539ba2a706ab7d35fc0667dff919ade7f87d63

which is caused by using ->timer instead of ->timer_end.  It can be
resolved as follows.

		del_timer_sync(&btv->remote->timer);


Tejun Heo (33):
      workqueue: convert cancel_rearming_delayed_work[queue]() users to cancel_delayed_work_sync()
      workqueue: deprecate cancel_rearming_delayed_work[queue]()
      workqueue: allow chained queueing during destruction
      isdn/capi: unregister capictr notifier after init failure
      isdn/capi: make kcapi use a separate workqueue
      net/dsa: don't use flush_scheduled_work()
      ocfs2: don't use flush_scheduled_work()
      pcmcia/ipwireless: don't use flush_scheduled_work()
      drm/ttm: use cancel_delayed_work_sync() in ttm_bo
      ncpfs: don't use flush_scheduled_work()
      arm/sharpsl: don't use flush_scheduled_work()
      sh: don't use flush_scheduled_work()
      floppy: don't use flush_scheduled_work()
      gdrom: don't use flush_scheduled_work()
      xen: don't use flush_scheduled_work()
      hvsi: don't use flush_scheduled_work()
      sonypi: don't use flush_scheduled_work()
      tpm: don't use flush_scheduled_work()
      vmwgfx: don't use flush_scheduled_work()
      macintosh/ams: don't use flush_scheduled_work()
      mISDN: don't use flush_scheduled_work()
      leds-wm8350: don't use flush_scheduled_work()
      dvb: don't use flush_scheduled_work()
      mfd: update workqueue usages
      mmc: update workqueue usages
      rtc: don't use flush_scheduled_work()
      s390: don't use flush_scheduled_work()
      init: don't call flush_scheduled_work() from do_initcalls()
      ioc4: use static work_struct for ioc4_load_modules()
      media/video: explicitly flush request_module work
      media/video: don't use flush_scheduled_work()
      speedtch: don't abuse struct delayed_work
      usb: don't use flush_scheduled_work()

 Documentation/feature-removal-schedule.txt    |   10 ++++
 arch/arm/mach-pxa/sharpsl_pm.c                |    3 +-
 arch/sh/drivers/push-switch.c                 |    2 +-
 drivers/ata/libata-core.c                     |    2 +-
 drivers/ata/libata-sff.c                      |    2 +-
 drivers/block/floppy.c                        |    4 +-
 drivers/block/xen-blkfront.c                  |    4 +-
 drivers/cdrom/gdrom.c                         |    2 +-
 drivers/char/hvsi.c                           |    4 +-
 drivers/char/pcmcia/ipwireless/hardware.c     |    2 +-
 drivers/char/pcmcia/ipwireless/network.c      |    3 +-
 drivers/char/pcmcia/ipwireless/tty.c          |    2 +-
 drivers/char/sonypi.c                         |    2 +-
 drivers/char/tpm/tpm.c                        |    4 +-
 drivers/gpu/drm/ttm/ttm_bo.c                  |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c            |    2 +-
 drivers/isdn/capi/capidrv.c                   |    1 +
 drivers/isdn/capi/kcapi.c                     |   26 +++++++---
 drivers/isdn/mISDN/hwchannel.c                |    4 +-
 drivers/isdn/mISDN/l1oip_core.c               |    2 +
 drivers/leds/leds-wm8350.c                    |    2 +-
 drivers/macintosh/ams/ams-core.c              |    2 +-
 drivers/macintosh/rack-meter.c                |    4 +-
 drivers/media/dvb/dvb-core/dvb_net.c          |    3 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c    |    3 +-
 drivers/media/dvb/mantis/mantis_evm.c         |    2 +-
 drivers/media/dvb/mantis/mantis_uart.c        |    1 +
 drivers/media/video/bt8xx/bttv-driver.c       |    9 ++++
 drivers/media/video/bt8xx/bttv-input.c        |    5 +--
 drivers/media/video/cx18/cx18-driver.c        |    8 +++
 drivers/media/video/cx231xx/cx231xx-cards.c   |    8 +++
 drivers/media/video/cx23885/cx23885-input.c   |    2 -
 drivers/media/video/cx88/cx88-mpeg.c          |    8 +++
 drivers/media/video/em28xx/em28xx-cards.c     |    8 +++
 drivers/media/video/em28xx/em28xx-input.c     |    2 +-
 drivers/media/video/omap24xxcam.c             |    6 +-
 drivers/media/video/saa7134/saa7134-core.c    |   11 ++++-
 drivers/media/video/saa7134/saa7134-empress.c |    2 +-
 drivers/mfd/menelaus.c                        |    3 +-
 drivers/mfd/tps65010.c                        |   13 +++---
 drivers/misc/ioc4.c                           |   29 ++++--------
 drivers/mmc/core/core.c                       |    2 +-
 drivers/mmc/host/omap.c                       |   24 +++++++---
 drivers/mmc/host/omap_hsmmc.c                 |    2 +-
 drivers/net/chelsio/my3126.c                  |    2 +-
 drivers/net/ibm_newemac/core.c                |    4 +-
 drivers/net/wireless/zd1211rw/zd_mac.c        |    3 +-
 drivers/power/ds2760_battery.c                |    6 +--
 drivers/power/intel_mid_battery.c             |    6 +--
 drivers/rtc/rtc-dev.c                         |    2 +-
 drivers/rtc/rtc-ds1305.c                      |    2 +-
 drivers/rtc/rtc-ds1374.c                      |    2 +-
 drivers/rtc/rtc-ds3232.c                      |    2 +-
 drivers/rtc/rtc-rx8025.c                      |    2 +-
 drivers/s390/char/tape_3590.c                 |   18 +++++--
 drivers/s390/char/tape_block.c                |    2 +-
 drivers/staging/pohmelfs/inode.c              |    4 +-
 drivers/usb/atm/cxacru.c                      |    2 +-
 drivers/usb/atm/speedtch.c                    |   28 ++++++-----
 drivers/usb/gadget/u_ether.c                  |    4 +-
 drivers/usb/host/ohci-hcd.c                   |    3 +-
 drivers/usb/otg/isp1301_omap.c                |    2 +-
 drivers/usb/serial/oti6858.c                  |    5 +-
 drivers/video/fb_defio.c                      |    2 +-
 drivers/video/omap/lcd_mipid.c                |    2 +-
 fs/ncpfs/inode.c                              |    7 +++-
 fs/nfsd/nfs4state.c                           |    2 +-
 fs/ocfs2/cluster/heartbeat.c                  |    3 +-
 fs/ocfs2/cluster/quorum.c                     |    4 +-
 fs/xfs/xfs_mru_cache.c                        |    2 +-
 include/linux/workqueue.h                     |    4 +-
 init/main.c                                   |    3 -
 kernel/workqueue.c                            |   60 ++++++++++++++++++++++++-
 mm/slab.c                                     |    2 +-
 mm/vmstat.c                                   |    2 +-
 net/atm/lec.c                                 |    2 +-
 net/core/netpoll.c                            |    2 +-
 net/dsa/dsa.c                                 |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                |    2 +-
 net/sunrpc/xprtsock.c                         |    2 +-
 80 files changed, 289 insertions(+), 156 deletions(-)

Thanks.

--
tejun
