Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1DETV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:21:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34049 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972Ab1DETVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:21:54 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [RFC][PATCH 0/5] Improve signal delivery scalability
Date: Tue,  5 Apr 2011 20:21:45 +0100
Message-Id: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

This series is most definitely RFC material. At this early stage I'm
just asking for feedback on whether the concepts/ideas are sound. For
example, I'm fairly sure that these patches break ia64 because it
accesses tsk->pending in asm and I haven't had time to look closely at
that yet.

This patch series was motivated by the signal1_threads testcase from
the Will It Scale benchmark suite. Currently, signal generation and
delivery in a thread group is serialised by the thread group's
siglock, tsk->sighand->siglock. This lock is a huge point of
contention in multithreaded applications, even when sending a signal
to one thread in a thread group.

In light of this, this patch series tries to improve scalability by,

	- introducing a per-thread siglock to protect the per-thread
	  pending signal queue

	- avoiding acquiring the shared siglock wherever possible

	- using a rwlock to protect signal handlers

This series is based on the assumption that it is OK to acquire and
release the shared siglock across function calls and do things like
execute PENDING() without holding any locks.

The improvement on the "signal delivery" testcase can be seen here,
http://userweb.kernel.org/~mfleming/will-it-scale/signals-per-thread-siglock/

Tejun, these patches are based on your ptrace branch as both you and
Oleg have touched alot of the same code paths lately.

All comments appreciated!

Matt Fleming (5):
  signals: Always place SIGCONT and SIGSTOP on 'shared_pending'
  signals: Introduce per-thread siglock and action rwlock
  ia64: Catch up with new sighand action spinlock
  signals: Introduce __dequeue_private_signal helper function
  signals: Don't hold shared siglock across signal delivery

 arch/ia64/kernel/signal.c |   13 +--
 fs/autofs4/waitq.c        |    2 +
 fs/exec.c                 |    2 +
 fs/signalfd.c             |    7 +-
 include/linux/init_task.h |    2 +
 include/linux/sched.h     |    4 +
 include/linux/signal.h    |    5 +
 include/linux/tracehook.h |    3 +-
 kernel/compat.c           |    7 +-
 kernel/exit.c             |   12 +-
 kernel/fork.c             |    2 +
 kernel/kmod.c             |    8 +-
 kernel/ptrace.c           |    4 +-
 kernel/signal.c           |  429 +++++++++++++++++++++++++++++++++------------
 security/selinux/hooks.c  |    6 +-
 15 files changed, 360 insertions(+), 146 deletions(-)

-- 
1.7.4

