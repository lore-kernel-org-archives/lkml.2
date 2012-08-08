Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2HHViS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:38:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39611 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2HHViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:16 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com
Subject: [PATCHSET] workqueue: use irqsafe timer in delayed_work
Date: Wed,  8 Aug 2012 14:37:55 -0700
Message-Id: <1344461882-10149-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Because IRQs can happen between delayed_work->timer being dispatched
and delayed_work_timer_fn() actually queueing delayed_work->work,
try_to_grab_pending() couldn't be used from IRQ handlers.  If it hits
the window, it will return -EAGAIN perpetually.  This makes it
impossible to steal PENDING from IRQ handlers using
try_to_grab_pending() leading to the following issues.

* mod_delayed_work() can't be used from IRQ handlers.

* __cancel_delayed_work() can't use the usual try_to_grab_pending()
  which handles all three states but instead only deals with the first
  state using a separate implementation.  There's no way to make a
  delayed_work not pending from IRQ handlers.

* The context / behavior differences among cancel_delayed_work(),
  __cancel_delayed_work(), cancel_delayed_work_sync() are subtle and
  confusing (the first two are mostly historical tho).

This patchset makes delayed_work use the irqsafe timer added by the
pending "timer: clean up initializers and implement irqsafe timers"
patchset[1].  This enables try_to_grab_pending() to be used from any
context which in turn makes mod_delayed_work() usable from IRQ
handlers.  cancel_delayed_work() is reimplemented using
try_to_grab_pending() so that it also can be used from IRQ handlers
and its behavior is consitent with other canceling operations.
__cancel_delayed_work() is no longer necessary and deprecated.

 0001-workqueue-cosmetic-whitespace-updates-for-macro-defi.patch
 0002-workqueue-make-deferrable-delayed_work-initializer-n.patch
 0003-workqueue-clean-up-delayed_work-initializers-and-add.patch
 0004-workqueue-use-irqsafe-timer-for-delayed_work.patch
 0005-workqueue-use-mod_delayed_work-instead-of-__cancel-q.patch
 0006-workqueue-reimplement-cancel_delayed_work-using-try_.patch
 0007-workqueue-deprecate-__cancel_delayed_work.patch

0001-0003 are prep patches.

0004 makes delayed_work use irqsafe timers.  This makes
try_to_grab_pending() and mod_delayed_work() safe to use from any
context.

0005 converts all __cancel_delayed_work() + queue_delayed_work()
sequences to mod_delayed_work().  The link_watch conversion needs
David's ack.

0006 reimplements cancel_delayed_work() using try_to_grab_pending().

0007 replaces __cancel_delayed_work() calls with cancel_delayed_work()
and deprecates the underscored one.

This patchset is on top of

  [2] wq/for-3.7 (8fcd63664f "workqueue: fix CPU binding of flush_delayed...")
+ [1] timer: clean up initializers and implement irqsafe timers

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-delayed_work-irqsafe

diffstat follows.

 arch/powerpc/platforms/cell/cpufreq_spudemand.c |    2 
 block/blk-core.c                                |    8 -
 block/blk-throttle.c                            |    7 -
 drivers/block/floppy.c                          |    5 
 drivers/cpufreq/cpufreq_conservative.c          |    2 
 drivers/cpufreq/cpufreq_ondemand.c              |    2 
 drivers/devfreq/devfreq.c                       |    2 
 drivers/infiniband/core/mad.c                   |   16 --
 drivers/input/keyboard/qt2160.c                 |    3 
 drivers/input/mouse/synaptics_i2c.c             |    7 -
 drivers/net/ethernet/mellanox/mlx4/sense.c      |    2 
 drivers/power/ab8500_btemp.c                    |    2 
 drivers/power/ab8500_charger.c                  |    8 -
 drivers/power/ab8500_fg.c                       |    8 -
 drivers/power/abx500_chargalg.c                 |    4 
 drivers/power/max17040_battery.c                |    2 
 drivers/video/omap2/displays/panel-taal.c       |    6 
 drivers/video/omap2/dss/dsi.c                   |    6 
 include/linux/workqueue.h                       |  155 ++++++++++--------------
 kernel/workqueue.c                              |   50 ++++++-
 mm/slab.c                                       |    2 
 mm/vmstat.c                                     |    2 
 net/core/link_watch.c                           |   21 ---
 net/core/neighbour.c                            |    2 
 net/ipv4/inetpeer.c                             |    2 
 net/sunrpc/cache.c                              |    2 
 26 files changed, 159 insertions(+), 169 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1340224
[2] git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7
