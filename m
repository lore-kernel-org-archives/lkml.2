Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1I3PNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:13:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60211 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab1I3PND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:03 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [RFC][PATCH 0/5] Signal scalability series
Date: Fri, 30 Sep 2011 16:12:52 +0100
Message-Id: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Here's another attempt at improving signal scalability in the
kernel. It's not as drastic as my first attempt and consequently the
speedups aren't as impressive. However, it's a good first step and
hopefully by keeping it relatively simple it'll make it easier to
review.

Basically it's the same idea as last time - introduce more locks to
reduce contention on the per-process siglock, sighand->siglock. This
lock becomes highly contended in applications with multiple threads,
and I know the -rt guys have had scenarios where the per-process lock
has caused performance problems.

With this series I saw a ~%120 improvement in the number of
signals/per second that can be handled in the Will It Scale signal1
benchmark on a dual-socket machine.

There are two remaining scalability problems,

  1. lock_task_sighand() still grabs sighand->siglock
  2. signal->ctrl_lock must be taken in recalc_sigpending()

fixing these problems will be left to future patches.

And just like last time, these patches break ia64 because it
implements rt_sigprocmask() in assembly. I'll work on the ia64 stuff
while these patches are being reviewed.

Matt Fleming (5):
  signal: Document signal locking rules
  signal: Add rwlock to protect sighand->action
  signal: Reduce sighand->siglock hold time in get_signal_to_deliver()
  signal: Add signal->ctrl_lock for job control
  signal: Split siglock into shared_siglock and per-thread siglock

 arch/ia64/kernel/signal.c           |    4 +-
 drivers/block/nbd.c                 |    2 +-
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/file_storage.c   |    2 +-
 fs/autofs4/waitq.c                  |    5 +-
 fs/exec.c                           |   17 +-
 fs/jffs2/background.c               |    2 +-
 fs/ncpfs/sock.c                     |    2 +
 fs/proc/array.c                     |    2 +
 fs/signalfd.c                       |   11 +-
 include/linux/init_task.h           |    4 +
 include/linux/sched.h               |   23 +-
 kernel/exit.c                       |   29 +-
 kernel/fork.c                       |    4 +
 kernel/freezer.c                    |   10 +-
 kernel/kmod.c                       |    8 +-
 kernel/posix-timers.c               |    5 +-
 kernel/ptrace.c                     |   68 ++--
 kernel/signal.c                     |  737 +++++++++++++++++++++++++++--------
 net/9p/client.c                     |    6 +-
 net/sunrpc/svc.c                    |    3 -
 security/selinux/hooks.c            |   11 +-
 22 files changed, 677 insertions(+), 280 deletions(-)

-- 
1.7.4.4

