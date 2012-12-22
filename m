Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2LVB52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:57:28 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63618 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LVB50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:57:26 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCHSET] workqueue: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:50 -0800
Message-Id: <1356141435-17340-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Given the current set of workqueue APIs, there are very few cases
where [delayed_]work_pending() are actually necessary; however, it's
seemingly somewhat popular for a few purposes including skipping
queue/flush/cancel depending on the current state for optimization.

work_pending() could be slightly cheaper than performing the actual
operation because it can skip atomic bitops assuming that the user is
synchronizing against other workqueue operations properly; however,
most paths with this type of optimization are siberia-cold for this
level of optimization to matter - e.g. driver detach path or parameter
update via sysfs - and it's easy to get it subtly wrong and introduce
difficult-to-trigger race conditions.  It just isn't worth it.

Other use cases include using work_pending() state to decide the state
of previously scheduled async action.  This too, unfortunately, seems
easy to get wrong.  Several users forgot that work_pending() becomes
false *before* the work item starts execution and fails to synchronize
with on-going execution.  Unless one is specifically looking for
those, they can be tricky to spot.

Overall, [delayed_]work_pending() seem to bring more troubles than
benefits and not using them usually results in better code.  This
patchset removes [delayed_]work_pending() usages from various
subsystems.  A lot are straight-forward removal of unnecessary
optimizations.  Some fix bugs around work item handling.  Others
restructure code so that [delayed_]work_pending() isn't necessary.

After this patchset, there remain a handful of
[delayed_]work_pending() users.  Some of them legit.  Some quite
broken.  Hopefully, they can be converted too and we can unexport
these easy-to-misuse interface.

This patchset contains the following 25 patches.

 0001-charger_manager-don-t-use-delayed_-work_pending.patch
 0002-ab8500_charger-don-t-use-delayed_-work_pending.patch
 0003-sja1000-don-t-use-delayed_-work_pending.patch
 0004-ipw2x00-simplify-scan_event-handling.patch
 0005-devfreq-don-t-use-delayed_-work_pending.patch
 0006-libertas-don-t-use-delayed_-work_pending.patch
 0007-mwifiex-don-t-use-delayed_-work_pending.patch
 0008-thinkpad_acpi-don-t-use-delayed_-work_pending.patch
 0009-wl1251-don-t-use-delayed_-work_pending.patch
 0010-kprobes-fix-wait_for_kprobe_optimizer.patch
 0011-pm-don-t-use-delayed_-work_pending.patch
 0012-bluetooth-l2cap-don-t-use-delayed_-work_pending.patch
 0013-sound-wm8350-don-t-use-delayed_-work_pending.patch
 0014-rfkill-don-t-use-delayed_-work_pending.patch
 0015-x86-mce-don-t-use-delayed_-work_pending.patch
 0016-PM-Domains-don-t-use-delayed_-work_pending.patch
 0017-wm97xx-don-t-use-delayed_-work_pending.patch
 0018-TMIO-MMC-don-t-use-delayed_-work_pending.patch
 0019-net-caif-don-t-use-delayed_-work_pending.patch
 0020-wimax-i2400m-fix-i2400m-wake_tx_skb-handling.patch
 0021-tty-max3100-don-t-use-delayed_-work_pending.patch
 0022-usb-at91_udc-don-t-use-delayed_-work_pending.patch
 0023-video-exynos-don-t-use-delayed_-work_pending.patch
 0024-debugobjects-don-t-use-delayed_-work_pending.patch
 0025-ipc-don-t-use-delayed_-work_pending.patch

And available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-work_pending-cleanup

diffstat follows.

 arch/x86/kernel/cpu/mcheck/mce.c        |   10 ++--------
 drivers/base/power/domain.c             |    3 +--
 drivers/devfreq/devfreq.c               |    3 +--
 drivers/input/touchscreen/wm97xx-core.c |    4 +---
 drivers/mmc/host/tmio_mmc_pio.c         |    3 +--
 drivers/net/caif/caif_shmcore.c         |   15 +++++----------
 drivers/net/can/sja1000/peak_pci.c      |    3 +--
 drivers/net/wimax/i2400m/netdev.c       |   31 +++++++++++++++++--------------
 drivers/net/wireless/ipw2x00/ipw2100.c  |   31 ++++++++-----------------------
 drivers/net/wireless/ipw2x00/ipw2100.h  |    3 +--
 drivers/net/wireless/ipw2x00/ipw2200.c  |   13 +++----------
 drivers/net/wireless/libertas/cfg.c     |    2 +-
 drivers/net/wireless/libertas/if_sdio.c |    9 ++++-----
 drivers/net/wireless/mwifiex/sdio.c     |    9 ++++-----
 drivers/net/wireless/ti/wl1251/ps.c     |    3 +--
 drivers/platform/x86/thinkpad_acpi.c    |    3 +--
 drivers/power/ab8500_charger.c          |   13 ++++---------
 drivers/power/charger-manager.c         |   31 ++++++++++++++++---------------
 drivers/tty/serial/max3100.c            |    3 +--
 drivers/usb/gadget/at91_udc.c           |    3 +--
 drivers/video/exynos/exynos_dp_core.c   |    6 ++----
 include/net/bluetooth/l2cap.h           |   24 ++++++++++++++++--------
 ipc/util.c                              |    3 +--
 kernel/kprobes.c                        |   23 +++++++++++++++--------
 kernel/power/autosleep.c                |    2 +-
 kernel/power/qos.c                      |    9 +++------
 lib/debugobjects.c                      |    7 +++----
 net/bluetooth/l2cap_core.c              |    7 +++----
 net/rfkill/input.c                      |    8 +++-----
 sound/soc/codecs/wm8350.c               |   10 ++++------
 30 files changed, 125 insertions(+), 169 deletions(-)

Thanks.

--
tejun
