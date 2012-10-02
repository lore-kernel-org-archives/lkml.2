Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2JBHAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:00:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47535 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2JBHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:00:19 -0400
Date: Tue, 2 Oct 2012 16:00:10 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        emilgoode@gmail.com
Subject: [GIT PULL] workqueue changes for v3.7-rc1
Message-ID: <20121002070010.GB6144@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This is workqueue updates for v3.7-rc1.  A lot of activities this
round including considerable API and behavior cleanups.

* delayed_work combines a timer and a work item.  The handling of the
  timer part has always been a bit clunky leading to confusing
  cancelation API with weird corner-case behaviors.  delayed_work is
  updated to use new IRQ safe timer and cancelation now works as
  expected.

* Another deficiency of delayed_work was lack of the counterpart of
  mod_timer() which led to cancel+queue combinations or open-coded
  timer+work usages.  mod_delayed_work[_on]() are added.

  These two delayed_work changes make delayed_work provide interface
  and behave like timer which is executed with process context.

* A work item could be executed concurrently on multiple CPUs, which
  is rather unintuitive and made flush_work() behavior confusing and
  half-broken under certain circumstances.  This problem doesn't exist
  for non-reentrant workqueues.  While non-reentrancy check isn't
  free, the overhead is incurred only when a work item bounces across
  different CPUs and even in simulated pathological scenario the
  overhead isn't too high.

  All workqueues are made non-reentrant.  This removes the distinction
  between flush_[delayed_]work() and flush_[delayed_]_work_sync().
  The former is now as strong as the latter and the specified work
  item is guaranteed to have finished execution of any previous
  queueing on return.

* In addition to the various bug fixes, Lai redid and simplified CPU
  hotplug handling significantly.

* Joonsoo introduced system_highpri_wq and used it during CPU hotplug.

There are two merge commits - one to pull in IRQ safe timer from
tip/timers/core and the other to pull in CPU hotplug fixes from
wq/for-3.6-fixes as Lai's hotplug restructuring depended on them.

This pull request will cause the following conflicts.

* drivers/tty/serial/omap-serial.c

  43829731dd ("workqueue: deprecate flush[_delayed]_work_sync()")
  ac57e7f38e ("serial: omap: Remove unnecessary checks from suspend/resume")

  The latter removes if() surrounding the block modified by the former
  - replacing flush_work_sync() with flush_work().  Can be resolved by
  replacing flush_work_sync() with flush_work() from the latter.

* drivers/isdn/mISDN/hwchannel.c

  43829731dd ("workqueue: deprecate flush[_delayed]_work_sync()")
  4b921eda53 ("mISDN: Fix wrong usage of flush_work_sync while holding locks")

  flush_work_sync() replaced by the former is removed by the latter
  which uses cancel_work_sync() instead.  Taking the code from the
  latter resolves the conflict.

* drivers/hid/hid-picolcd.c

  43829731dd ("workqueue: deprecate flush[_delayed]_work_sync()")
  fabdbf2fd2 ("HID: picoLCD: split driver code")
  9966c37c46 ("HID: picoLCD: Replace own refcounting with fbdev's")

  The code modified by the first is splitted into a different file by
  the second and removed by the third.  Nothing to do.

* drivers/extcon/extcon-adc-jack.c (silent conflict)

  203b42f731 ("workqueue: make deferrable delayed_work initializer names consistent")
  19939860dc ("extcon: adc_jack: adc-jack driver to support 3.5 pi or simliar devices")

  The latter adds a new use of INIT_DELAYED_WORK_DEFERRABLE() which
  was renamed to INIT_DEFERRABLE_WORK() by the former for consistency.

* drivers/hid/hid-picolcd.c (silent conflict)

  16048709b2 ("HID: picoLCD: rework hid-fbdev interaction")

  Adds a new use of flush_delayed_work_sync() which is deprecated and
  being replaced with flush_delayed_work().  Will post a separate
  patch as a reply to this message which can be applied on top.

Judging from linux-next, there can be a few more conflicts with
further pulls from other subsystems but they're all either from
flush_[delayed_]work_sync() -> flush_[delayed_]work() which also can
be left alone during merge and fixed up later or
INIT_DELAYED_WORK_DEFERRABLE() -> INIT_DEFERRABLE_WORK().  Both should
be trivial to resolve.

Please pull from the following git branch to receive the above
changes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7

Just in case, the merge result can be compared to the following.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7-test-merge

Thanks.

Joonsoo Kim (6):
      workqueue: use enum value to set array size of pools in gcwq
      workqueue: correct req_cpu in trace_workqueue_queue_work()
      workqueue: change value of lcpu in __queue_delayed_work_on()
      workqueue: introduce system_highpri_wq
      workqueue: use system_highpri_wq for highpri workers in rebind_workers()
      workqueue: use system_highpri_wq for unbind_work

Lai Jiangshan (14):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be atomic
      workqueue: restore POOL_MANAGING_WORKERS
      workqueue: fix possible idle worker depletion across CPU hotplug
      workqueue: always clear WORKER_REBIND in busy_worker_rebind_fn()
      workqueue: reimplement idle worker rebinding
      workqueue: WORKER_REBIND is no longer necessary for busy rebinding
      workqueue: WORKER_REBIND is no longer necessary for idle rebinding
      workqueue: rename manager_mutex to assoc_mutex
      workqueue: use __cpuinit instead of __devinit for cpu callbacks
      workqueue: use hotcpu_notifier() for workqueue_cpu_down_callback()
      workqueue: fix possible stall on try_to_grab_pending() of a delayed work item
      workqueue: remove @delayed from cwq_dec_nr_in_flight()
      workqueue: introduce cwq_set_max_active() helper for thaw_workqueues()
      workqueue: use cwq_set_max_active() helper for workqueue_set_max_active()

Tejun Heo (37):
      workqueue: reorder queueing functions so that _on() variants are on top
      workqueue: make queueing functions return bool
      workqueue: add missing smp_wmb() in process_one_work()
      workqueue: disable irq while manipulating PENDING
      workqueue: set delayed_work->timer function on initialization
      workqueue: unify local CPU queueing handling
      workqueue: fix zero @delay handling of queue_delayed_work_on()
      workqueue: move try_to_grab_pending() upwards
      workqueue: introduce WORK_OFFQ_FLAG_*
      workqueue: factor out __queue_delayed_work() from queue_delayed_work_on()
      workqueue: reorganize try_to_grab_pending() and __cancel_timer_work()
      workqueue: mark a work item being canceled as such
      workqueue: implement mod_delayed_work[_on]()
      workqueue: use mod_delayed_work() instead of cancel + queue
      workqueue: fix CPU binding of flush_delayed_work[_sync]()
      workqueue: add missing wmb() in clear_work_data()
      workqueue: make all workqueues non-reentrant
      workqueue: gut flush[_delayed]_work_sync()
      workqueue: gut system_nrt[_freezable]_wq()
      workqueue: deprecate flush[_delayed]_work_sync()
      workqueue: deprecate system_nrt[_freezable]_wq
      timer: Generalize timer->base flags handling
      timer: Relocate declarations of init_timer_on_stack_key()
      timer: Clean up timer initializers
      timer: Implement TIMER_IRQSAFE
      Merge branch 'timers/core' of git://git.kernel.org/.../tip/tip into for-3.7
      workqueue: cosmetic whitespace updates for macro definitions
      workqueue: make deferrable delayed_work initializer names consistent
      workqueue: clean up delayed_work initializers and add missing one
      workqueue: use irqsafe timer for delayed_work
      workqueue: use mod_delayed_work() instead of __cancel + queue
      workqueue: reimplement cancel_delayed_work() using try_to_grab_pending()
      workqueue: deprecate __cancel_delayed_work()
      workqueue: move WORKER_REBIND clearing in rebind_workers() to the end of the function
      workqueue: fix possible deadlock in idle worker rebinding
      Merge branch 'for-3.6-fixes' of git://git.kernel.org/.../tj/wq into for-3.7
      workqueue: remove spurious WARN_ON_ONCE(in_irq()) from try_to_grab_pending()

Valentin Ilie (1):
      workqueue: fix checkpatch issues

 arch/arm/mach-pxa/sharpsl_pm.c                  |    4 +-
 arch/arm/plat-omap/mailbox.c                    |    2 +-
 arch/powerpc/platforms/cell/cpufreq_spudemand.c |    2 +-
 arch/sh/drivers/push-switch.c                   |    2 +-
 block/blk-core.c                                |    8 +-
 block/blk-throttle.c                            |   14 +-
 block/genhd.c                                   |   14 +-
 drivers/block/floppy.c                          |    5 +-
 drivers/block/xen-blkfront.c                    |    4 +-
 drivers/cdrom/gdrom.c                           |    2 +-
 drivers/char/sonypi.c                           |    2 +-
 drivers/char/tpm/tpm.c                          |    4 +-
 drivers/cpufreq/cpufreq_conservative.c          |    2 +-
 drivers/cpufreq/cpufreq_ondemand.c              |    2 +-
 drivers/devfreq/devfreq.c                       |    2 +-
 drivers/edac/edac_mc.c                          |   17 +-
 drivers/gpu/drm/drm_crtc_helper.c               |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c         |    2 +-
 drivers/gpu/drm/nouveau/nouveau_gpio.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c              |    2 +-
 drivers/hid/hid-picolcd.c                       |    2 +-
 drivers/hid/hid-wiimote-ext.c                   |    2 +-
 drivers/infiniband/core/addr.c                  |    4 +-
 drivers/infiniband/core/mad.c                   |   16 +-
 drivers/infiniband/hw/nes/nes_hw.c              |    6 +-
 drivers/infiniband/hw/nes/nes_nic.c             |    5 +-
 drivers/input/keyboard/qt2160.c                 |    3 +-
 drivers/input/mouse/synaptics_i2c.c             |    7 +-
 drivers/input/touchscreen/wm831x-ts.c           |    2 +-
 drivers/isdn/mISDN/hwchannel.c                  |    4 +-
 drivers/leds/leds-lm3533.c                      |    6 +-
 drivers/leds/leds-lp8788.c                      |    2 +-
 drivers/leds/leds-wm8350.c                      |    2 +-
 drivers/macintosh/ams/ams-core.c                |    2 +-
 drivers/md/dm-mpath.c                           |    2 +-
 drivers/md/dm-raid1.c                           |    2 +-
 drivers/md/dm-stripe.c                          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c            |    4 +-
 drivers/media/dvb/mantis/mantis_evm.c           |    2 +-
 drivers/media/dvb/mantis/mantis_uart.c          |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c         |    2 +-
 drivers/media/video/cx18/cx18-driver.c          |    2 +-
 drivers/media/video/cx231xx/cx231xx-cards.c     |    2 +-
 drivers/media/video/cx23885/cx23885-input.c     |    6 +-
 drivers/media/video/cx88/cx88-mpeg.c            |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c       |    2 +-
 drivers/media/video/omap24xxcam.c               |    6 +-
 drivers/media/video/saa7134/saa7134-core.c      |    2 +-
 drivers/media/video/saa7134/saa7134-empress.c   |    2 +-
 drivers/media/video/tm6000/tm6000-cards.c       |    2 +-
 drivers/mfd/menelaus.c                          |    4 +-
 drivers/misc/ioc4.c                             |    2 +-
 drivers/mmc/core/host.c                         |    4 +-
 drivers/mtd/mtdoops.c                           |    4 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |    2 +-
 drivers/net/ethernet/mellanox/mlx4/sense.c      |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c  |    2 +-
 drivers/net/ethernet/sun/cassini.c              |    2 +-
 drivers/net/ethernet/sun/niu.c                  |    2 +-
 drivers/net/virtio_net.c                        |   12 +-
 drivers/net/wireless/hostap/hostap_ap.c         |    4 +-
 drivers/net/wireless/hostap/hostap_hw.c         |   10 +-
 drivers/net/wireless/ipw2x00/ipw2100.c          |    8 +-
 drivers/net/wireless/zd1211rw/zd_usb.c          |    3 +-
 drivers/platform/x86/thinkpad_acpi.c            |   20 +-
 drivers/power/ab8500_btemp.c                    |    2 +-
 drivers/power/ab8500_charger.c                  |    8 +-
 drivers/power/ab8500_fg.c                       |    8 +-
 drivers/power/abx500_chargalg.c                 |    4 +-
 drivers/power/charger-manager.c                 |    9 +-
 drivers/power/collie_battery.c                  |    2 +-
 drivers/power/ds2760_battery.c                  |    9 +-
 drivers/power/jz4740-battery.c                  |    6 +-
 drivers/power/max17040_battery.c                |    2 +-
 drivers/power/tosa_battery.c                    |    2 +-
 drivers/power/wm97xx_battery.c                  |    2 +-
 drivers/power/z2_battery.c                      |    2 +-
 drivers/regulator/core.c                        |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                |    4 +-
 drivers/scsi/ipr.c                              |    2 +-
 drivers/scsi/pmcraid.c                          |    2 +-
 drivers/scsi/qla2xxx/qla_target.c               |    2 +-
 drivers/thermal/thermal_sys.c                   |   15 +-
 drivers/tty/hvc/hvsi.c                          |    2 +-
 drivers/tty/ipwireless/hardware.c               |    2 +-
 drivers/tty/ipwireless/network.c                |    4 +-
 drivers/tty/serial/kgdboc.c                     |    2 +-
 drivers/tty/serial/omap-serial.c                |    2 +-
 drivers/tty/tty_ldisc.c                         |    6 +-
 drivers/usb/atm/speedtch.c                      |    2 +-
 drivers/usb/atm/ueagle-atm.c                    |    2 +-
 drivers/usb/gadget/u_ether.c                    |    2 +-
 drivers/usb/host/ohci-hcd.c                     |    2 +-
 drivers/usb/otg/isp1301_omap.c                  |    2 +-
 drivers/video/omap2/displays/panel-taal.c       |    6 +-
 drivers/video/omap2/dss/dsi.c                   |    6 +-
 fs/affs/super.c                                 |    2 +-
 fs/afs/callback.c                               |    4 +-
 fs/afs/server.c                                 |   10 +-
 fs/afs/vlocation.c                              |   14 +-
 fs/gfs2/lock_dlm.c                              |    2 +-
 fs/gfs2/super.c                                 |    2 +-
 fs/hfs/inode.c                                  |    2 +-
 fs/ncpfs/inode.c                                |    6 +-
 fs/nfs/nfs4renewd.c                             |    3 +-
 fs/ocfs2/cluster/quorum.c                       |    2 +-
 fs/xfs/xfs_super.c                              |    2 +-
 fs/xfs/xfs_sync.c                               |    2 +-
 include/linux/timer.h                           |  165 ++--
 include/linux/workqueue.h                       |  220 +++--
 kernel/srcu.c                                   |    4 +-
 kernel/timer.c                                  |  108 +-
 kernel/workqueue.c                              | 1285 +++++++++++++----------
 mm/slab.c                                       |    2 +-
 mm/vmstat.c                                     |    2 +-
 net/9p/trans_fd.c                               |    2 +-
 net/core/dst.c                                  |    4 +-
 net/core/link_watch.c                           |   21 +-
 net/core/neighbour.c                            |    2 +-
 net/dsa/dsa.c                                   |    2 +-
 net/ipv4/inetpeer.c                             |    2 +-
 net/rfkill/input.c                              |    3 +-
 net/sunrpc/cache.c                              |    2 +-
 security/keys/gc.c                              |    8 +-
 security/keys/key.c                             |    2 +-
 sound/i2c/other/ak4113.c                        |    2 +-
 sound/i2c/other/ak4114.c                        |    2 +-
 sound/pci/oxygen/oxygen_lib.c                   |    8 +-
 sound/soc/codecs/wm8350.c                       |    2 +-
 sound/soc/codecs/wm8753.c                       |    2 +-
 sound/soc/soc-core.c                            |    6 +-
 virt/kvm/eventfd.c                              |    2 +-
 133 files changed, 1171 insertions(+), 1147 deletions(-)
