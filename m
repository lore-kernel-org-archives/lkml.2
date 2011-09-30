Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1I3PNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:13:07 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60221 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab1I3PNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:04 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Subject: [RFC][PATCH 1/5] signal: Document signal locking rules
Date: Fri, 30 Sep 2011 16:12:53 +0100
Message-Id: <1317395577-14091-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The current locking rules for signal handling and job control are
complex and pretty much undocumented. Fix that by explaining which
data structures are involved. At the moment, all the necessary locking
is covered by the per-process sighand->siglock but patches later in
the series will change that.

Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirudh Badam <abadam@cs.princeton.edu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 kernel/signal.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 3868e66..54fc552 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -38,6 +38,33 @@
 #include "audit.h"	/* audit_signal_info() */
 
 /*
+ * signal locking rules:
+ *
+ *   - sighand->siglock (spinlock) protects,
+ *
+ *        * the tsk->sighand pointer from being modified, see de_thread() and
+ *          __exit_signal(). If you need to dereference tsk->sighand (for
+ *          example when locking ->siglock) and tsk is not current, you must
+ *          call lock_task_sighand().
+ *
+ *        * most things under tsk->signal
+ *
+ *        * tsk->sighand->action[]
+ *
+ *        * tsk->last_siginfo
+ *        * tsk->group_stop
+ *        * tsk->pending
+ *        * tsk->jobctl
+ *
+ *        * the atomic operation of checking tsk->jobctl, tsk->pending and
+ *          tsk->signal->shared_pending and setting/clearing TIF_SIGPENDING,
+ *          see recalc_sigpending().
+ *
+ *        * tsk->cpu_timers
+ *
+ */
+
+/*
  * SLAB caches for signal bits.
  */
 
-- 
1.7.4.4

