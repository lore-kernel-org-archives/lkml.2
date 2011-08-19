Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1HSOQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:16:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63671 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1HSOQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:32 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com
Subject: [PATCHSET] freezer: fix various bugs and simplify implementation
Date: Fri, 19 Aug 2011 16:16:06 +0200
Message-Id: <1313763382-12341-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The freezer code has developed a number of convolutions and bugs.
It's now using five per-task flags - TIF_FREEZE, PF_FREEZING,
PF_NOFREEZE, PF_FROZEN, PF_FREEZER_SKIP and PF_FREEZER_NOSIG, and at
the same time has quite a few race conditions.  PF_NOFREEZE
modifications can race against PM freezer, cgroup_freezer can race
against PM freezer, and so on.

This patchset tries to simplify the freezer implementation and fix the
various bugs.  It makes the synchronization more straight forward and
replaces TIF_FREEZE with directly checking freeze conditions which are
in effect, which makes the whole thing much saner.

This patchset removes TIF_FREEZE and PF_FREEZING.  Also,
PF_FREEZER_SKIP users are planned to move away from the flag and will
be removed.  It contains the following 16 patches.

 0001-freezer-fix-current-state-restoration-race-in-refrig.patch
 0002-freezer-don-t-unnecessarily-set-PF_NOFREEZE-explicit.patch
 0003-freezer-unexport-refrigerator-and-update-try_to_free.patch
 0004-freezer-implement-and-use-kthread_freezable_should_s.patch
 0005-freezer-rename-thaw_process-to-__thaw_task-and-simpl.patch
 0006-freezer-make-exiting-tasks-properly-unfreezable.patch
 0007-freezer-don-t-distinguish-nosig-tasks-on-thaw.patch
 0008-freezer-use-dedicated-lock-instead-of-task_lock-memo.patch
 0009-freezer-make-freezing-indicate-freeze-condition-in-e.patch
 0010-freezer-fix-set_freezable-_with_signal-race.patch
 0011-freezer-kill-PF_FREEZING.patch
 0012-freezer-clean-up-freeze_processes-failure-path.patch
 0013-cgroup_freezer-prepare-for-removal-of-TIF_FREEZE.patch
 0014-freezer-make-freezing-test-freeze-conditions-in-effe.patch
 0015-freezer-remove-now-unused-TIF_FREEZE.patch
 0016-freezer-remove-should_send_signal-and-update-frozen.patch

This patchset is on top of the current linus#master (01b883358b "Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc") and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer

diffstat follows.

 Documentation/power/freezing-of-tasks.txt |   14 +-
 arch/alpha/include/asm/thread_info.h      |    2
 arch/arm/include/asm/thread_info.h        |    2
 arch/avr32/include/asm/thread_info.h      |    2
 arch/blackfin/include/asm/thread_info.h   |    2
 arch/cris/include/asm/thread_info.h       |    2
 arch/frv/include/asm/thread_info.h        |    2
 arch/h8300/include/asm/thread_info.h      |    2
 arch/ia64/include/asm/thread_info.h       |    2
 arch/m32r/include/asm/thread_info.h       |    2
 arch/m68k/include/asm/thread_info.h       |    1
 arch/microblaze/include/asm/thread_info.h |    2
 arch/mips/include/asm/thread_info.h       |    2
 arch/mn10300/include/asm/thread_info.h    |    2
 arch/parisc/include/asm/thread_info.h     |    2
 arch/powerpc/include/asm/thread_info.h    |    2
 arch/s390/include/asm/thread_info.h       |    2
 arch/sh/include/asm/thread_info.h         |    2
 arch/sparc/include/asm/thread_info_32.h   |    2
 arch/sparc/include/asm/thread_info_64.h   |    2
 arch/um/include/asm/thread_info.h         |    2
 arch/unicore32/include/asm/thread_info.h  |    2
 arch/x86/include/asm/thread_info.h        |    2
 arch/xtensa/include/asm/thread_info.h     |    2
 drivers/bluetooth/btmrvl_main.c           |    2
 drivers/mfd/twl4030-irq.c                 |    3
 drivers/mfd/twl6030-irq.c                 |    2
 drivers/net/irda/stir4200.c               |    2
 drivers/platform/x86/thinkpad_acpi.c      |   15 +-
 drivers/staging/rts_pstor/rtsx.c          |    2
 fs/btrfs/async-thread.c                   |    2
 fs/btrfs/disk-io.c                        |    8 -
 fs/ext4/super.c                           |    3
 fs/fs-writeback.c                         |    4
 fs/gfs2/log.c                             |    4
 fs/gfs2/quota.c                           |    4
 fs/jbd/journal.c                          |    2
 fs/jbd2/journal.c                         |    2
 fs/jfs/jfs_logmgr.c                       |    2
 fs/jfs/jfs_txnmgr.c                       |    4
 fs/nilfs2/segment.c                       |    2
 fs/xfs/linux-2.6/xfs_buf.c                |    2
 include/linux/freezer.h                   |   78 +++++--------
 include/linux/kthread.h                   |    1
 include/linux/sched.h                     |    3
 kernel/cgroup_freezer.c                   |   51 +++-----
 kernel/exit.c                             |    8 +
 kernel/fork.c                             |    1
 kernel/freezer.c                          |  179 +++++++++++++++++-------------
 kernel/kthread.c                          |   25 ++++
 kernel/power/hibernate.c                  |   15 --
 kernel/power/process.c                    |   65 +++-------
 kernel/power/user.c                       |    4
 mm/backing-dev.c                          |    8 -
 54 files changed, 247 insertions(+), 315 deletions(-)

Thanks.

--
tejun
