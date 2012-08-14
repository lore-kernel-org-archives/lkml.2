Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2HNBtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:49:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44182 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2HNBtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:49:53 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org
Subject: [PATCHSET] workqueue: make all workqueues non-reentrant
Date: Mon, 13 Aug 2012 18:49:40 -0700
Message-Id: <1344908986-18152-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Unless explicitly specified, a workqueued is reentrant, which might
not even be the correct term.  If a work item is executing on a CPU
but not pending anywhere, the work item can be queued on a different
CPU, and that CPU might start executing the work item whether the
previous execution on the first CPU is finished or not.  In short,
while a work item can be queued on only one CPU, it may be executing
concurrently on any subset of the CPUs in the system.

This behavior in itself is already confusing and error-prone; however,
this causes much worse complication in flush operations.  Because a
given work item could be executing on any number of CPUs, even if no
further queueing happens after invocation, flush_work() can't
guarantee that the work item is idle on return without checking all
CPUs.  Being a relatively common operation, checking all CPUs on each
invocation was deemed too costly.  It only verifies the instance
queued last and there's a separate version which checks all CPUs -
flush_work_sync().

Also, due to the way last CPU is tracked, if there are parallel
queueing operations, the following sequence

	schedule_work(A);
	flush_work(A);

can't guarantee that the instance queued right above is finished.  If
someone else queues A on another CPU inbetween, flush_work() either
becomes noop or flushes that instance which may finish earlier than
the one from the above.

In the end, workqueue is a pain in the ass to get completely correct
and the breakages are very subtle.  Depending on queueing pattern,
assuming non-reentrancy might work fine most of the time.  The effect
of using flush_work() where flush_work_sync() should be used could be
a lot more subtle.  flush_work() becoming noop would happen extremely
rarely for most users but it definitely is there.

A tool which is used as widely as workqueue shouldn't be this
difficult and error-prone.  This is just silly.

Timer does the right thing.  It *always* checks whether a timer is
still executing on the previous CPU and queues it there if so much
like how WQ_NON_REENTRANT makes workqueue behave.  WQ_NON_REENTRANT
guarantees that any given work item is executing on only one CPU at
maximum and if both pending and executing, both are on the same CPU.
This makes the behaviors of work item execution and flush_work() much
more sane and flush_work_sync() unnecessary.

This patchset enforces WQ_NON_REENTRANT behavior on all workqueues and
simplifies workqueue API accordingly.

This adds an additional busy_hash lookup if the work item was
previously queued on a different CPU.  This shouldn't be noticeable
under any sane workload.  Work item queueing isn't a very
high-frequency operation and they don't jump across CPUs all the time.
In a micro benchmark to exaggerate this difference - measuring the
time it takes for two work items to repeatedly jump between two CPUs a
number (10M) of times with busy_hash table densely populated, the
difference was around 3%.

While the overhead is measureable, it is only visible in pathological
cases and the difference isn't huge.  This change brings much needed
sanity to workqueue and makes its behavior consistent with timer.  I
think this is the right tradeoff to make.

This patchset contains the following six patches.

 0001-workqueue-make-all-workqueues-non-reentrant.patch
 0002-workqueue-gut-flush-_delayed-_work_sync.patch
 0003-workqueue-gut-system_nrt-_freezable-_wq.patch
 0004-workqueue-deprecate-flush-_delayed-_work_sync.patch
 0005-workqueue-deprecate-system_nrt-_freezable-_wq.patch
 0006-workqueue-deprecate-WQ_NON_REENTRANT.patch

0001 makes all workqueues non-reentrant.

0002-0003 simplify workqueue API accordingly.

0004-0006 deprecate now unnecessary parts of workqueue API and convert
their users.  Most conversions are straight-forward but 0006 contains
some non-trivial ones.  If you work on NFC and drivers/staging/nvec,
please review them.

This patchset is on top of

  wq/for-3.7 1265057fa02c7bed3b6d9ddc8a2048065a370364
+ [1] "timer: clean up initializers and implement irqsafe" patchset
+ [2] "workqueue: use irqsafe timer in delayed_work" patchset

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-always-nrt

Thanks.  diffstat follows.

 Documentation/workqueue.txt                     |   14 --
 arch/arm/mach-pxa/sharpsl_pm.c                  |    4 
 arch/arm/plat-omap/mailbox.c                    |    2 
 arch/sh/drivers/push-switch.c                   |    2 
 block/blk-throttle.c                            |    7 -
 block/genhd.c                                   |   10 -
 drivers/block/xen-blkfront.c                    |    4 
 drivers/cdrom/gdrom.c                           |    2 
 drivers/char/sonypi.c                           |    2 
 drivers/char/tpm/tpm.c                          |    4 
 drivers/firewire/core-transaction.c             |    3 
 drivers/gpu/drm/drm_crtc_helper.c               |    6 
 drivers/gpu/drm/exynos/exynos_drm_g2d.c         |    2 
 drivers/gpu/drm/i915/i915_dma.c                 |    6 
 drivers/gpu/drm/nouveau/nouveau_gpio.c          |    2 
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c              |    2 
 drivers/hid/hid-picolcd.c                       |    2 
 drivers/hid/hid-wiimote-ext.c                   |    2 
 drivers/input/touchscreen/wm831x-ts.c           |    2 
 drivers/isdn/mISDN/hwchannel.c                  |    4 
 drivers/leds/leds-lm3533.c                      |    6 
 drivers/leds/leds-lp8788.c                      |    2 
 drivers/leds/leds-wm8350.c                      |    2 
 drivers/macintosh/ams/ams-core.c                |    2 
 drivers/md/dm-crypt.c                           |   10 -
 drivers/md/dm-kcopyd.c                          |    3 
 drivers/md/dm-mpath.c                           |    2 
 drivers/md/dm-raid1.c                           |    5 
 drivers/md/dm-stripe.c                          |    2 
 drivers/md/dm.c                                 |    3 
 drivers/media/dvb/dvb-core/dvb_net.c            |    4 
 drivers/media/dvb/mantis/mantis_evm.c           |    2 
 drivers/media/dvb/mantis/mantis_uart.c          |    2 
 drivers/media/video/bt8xx/bttv-driver.c         |    2 
 drivers/media/video/cx18/cx18-driver.c          |    2 
 drivers/media/video/cx231xx/cx231xx-cards.c     |    2 
 drivers/media/video/cx23885/cx23885-input.c     |    6 
 drivers/media/video/cx88/cx88-mpeg.c            |    2 
 drivers/media/video/em28xx/em28xx-cards.c       |    2 
 drivers/media/video/omap24xxcam.c               |    6 
 drivers/media/video/saa7134/saa7134-core.c      |    2 
 drivers/media/video/saa7134/saa7134-empress.c   |    2 
 drivers/media/video/tm6000/tm6000-cards.c       |    2 
 drivers/mfd/menelaus.c                          |    4 
 drivers/misc/ioc4.c                             |    2 
 drivers/mmc/core/host.c                         |    4 
 drivers/mmc/host/dw_mmc.c                       |    3 
 drivers/mtd/mtdoops.c                           |    4 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |    2 
 drivers/net/ethernet/neterion/vxge/vxge-main.c  |    2 
 drivers/net/ethernet/sun/cassini.c              |    2 
 drivers/net/ethernet/sun/niu.c                  |    2 
 drivers/net/virtio_net.c                        |   12 -
 drivers/net/wireless/hostap/hostap_ap.c         |    4 
 drivers/net/wireless/hostap/hostap_hw.c         |   10 -
 drivers/nfc/pn533.c                             |    5 
 drivers/power/collie_battery.c                  |    2 
 drivers/power/tosa_battery.c                    |    2 
 drivers/power/wm97xx_battery.c                  |    2 
 drivers/power/z2_battery.c                      |    2 
 drivers/regulator/core.c                        |    2 
 drivers/scsi/arcmsr/arcmsr_hba.c                |    4 
 drivers/scsi/ipr.c                              |    2 
 drivers/scsi/pmcraid.c                          |    2 
 drivers/scsi/qla2xxx/qla_target.c               |    2 
 drivers/staging/nvec/nvec.c                     |   10 -
 drivers/staging/nvec/nvec.h                     |    2 
 drivers/staging/omapdrm/omap_drv.c              |    3 
 drivers/tty/hvc/hvsi.c                          |    2 
 drivers/tty/ipwireless/hardware.c               |    2 
 drivers/tty/ipwireless/network.c                |    4 
 drivers/tty/serial/kgdboc.c                     |    2 
 drivers/tty/serial/omap-serial.c                |    2 
 drivers/tty/tty_ldisc.c                         |    6 
 drivers/usb/atm/speedtch.c                      |    2 
 drivers/usb/atm/ueagle-atm.c                    |    2 
 drivers/usb/gadget/u_ether.c                    |    2 
 drivers/usb/host/ohci-hcd.c                     |    2 
 drivers/usb/otg/isp1301_omap.c                  |    2 
 fs/affs/super.c                                 |    2 
 fs/dlm/ast.c                                    |    5 
 fs/gfs2/lock_dlm.c                              |    2 
 fs/gfs2/main.c                                  |    2 
 fs/gfs2/super.c                                 |    2 
 fs/hfs/inode.c                                  |    2 
 fs/ncpfs/inode.c                                |    6 
 fs/ocfs2/cluster/quorum.c                       |    2 
 fs/xfs/xfs_super.c                              |    4 
 fs/xfs/xfs_sync.c                               |    2 
 include/linux/workqueue.h                       |   37 ++++-
 kernel/srcu.c                                   |    4 
 kernel/workqueue.c                              |  150 +++---------------------
 net/9p/trans_fd.c                               |    2 
 net/ceph/messenger.c                            |    2 
 net/dsa/dsa.c                                   |    2 
 net/nfc/core.c                                  |    6 
 net/nfc/hci/core.c                              |    8 -
 net/nfc/hci/shdlc.c                             |    4 
 net/nfc/llcp/llcp.c                             |   18 --
 security/keys/gc.c                              |    8 -
 security/keys/key.c                             |    2 
 sound/i2c/other/ak4113.c                        |    2 
 sound/i2c/other/ak4114.c                        |    2 
 sound/pci/oxygen/oxygen_lib.c                   |    8 -
 sound/soc/codecs/wm8350.c                       |    2 
 sound/soc/codecs/wm8753.c                       |    2 
 sound/soc/soc-core.c                            |    6 
 virt/kvm/eventfd.c                              |    2 
 109 files changed, 221 insertions(+), 351 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1340224 
[2] http://thread.gmane.org/gmane.linux.kernel/1340333
