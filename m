Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2JBLTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab2JBLTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:19:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
Date: Tue,  2 Oct 2012 13:18:43 +0200
Message-Id: <1349176723-5537-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I'm getting following warning when running basic cgroup perf stuff:
(perf stat -a -e faults -G krava -- sleep 10)

 WARNING: at kernel/events/core.c:397 perf_cgroup_switch+0x1c6/0x1e0()
 Hardware name: Montevina platform
 Modules linked in:
 Pid: 1173, comm: bash Not tainted 3.6.0+ #129
 Call Trace:
  [<ffffffff8103736f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff810dc025>] ? perf_ctx_lock+0x15/0x30
  [<ffffffff810373ca>] warn_slowpath_null+0x1a/0x20
  [<ffffffff810e0b96>] perf_cgroup_switch+0x1c6/0x1e0
  [<ffffffff810e09d0>] ? perf_event_context_sched_in+0xc0/0xc0
  [<ffffffff810e0fa9>] __perf_event_task_sched_in+0xa9/0x200
  [<ffffffff81089c67>] ? lock_release_holdtime.part.3+0xc7/0x160
  [<ffffffff810689f8>] finish_task_switch+0xb8/0xf0
  [<ffffffff814fab2b>] __schedule+0x2eb/0x930
  [<ffffffff814fca10>] ? _raw_spin_unlock_irq+0x30/0x60
  [<ffffffff8108fd75>] ? trace_hardirqs_on_caller+0x105/0x190
  [<ffffffff8108fe0d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff814fca1b>] ? _raw_spin_unlock_irq+0x3b/0x60
  [<ffffffff81055238>] ? start_flush_work+0x108/0x180
  [<ffffffff814fb289>] schedule+0x29/0x70
  [<ffffffff814f8725>] schedule_timeout+0x1c5/0x210
  [<ffffffff8105cecd>] ? add_wait_queue+0x4d/0x60
  [<ffffffff814fc9c5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
  [<ffffffff8108fd75>] ? trace_hardirqs_on_caller+0x105/0x190
  [<ffffffff8108fe0d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff814fc9a2>] ? _raw_spin_unlock_irqrestore+0x42/0x80
  [<ffffffff812b5151>] n_tty_read+0x461/0x8b0
  [<ffffffff8106d040>] ? try_to_wake_up+0x310/0x310
  [<ffffffff812af2b9>] tty_read+0x99/0xf0
  [<ffffffff81128fff>] vfs_read+0xaf/0x180
  [<ffffffff8112911d>] sys_read+0x4d/0x90
  [<ffffffff81504412>] system_call_fastpath+0x16/0x1b


Looking at the code the cpuctx->cgrp condition seems legal,
and need just some adjustment.

However, I don't fully understand that code and could be
wrong.. just want to get rid of probably wrong warning.. ;)

thanks,
jirka


---
Changing WARN_ON_ONCE condition for PERF_CGROUP_SWIN leg.

It's legal to have cpuctx->cgrp already defined, but it's
not legal not to have events active at the same time.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/events/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b9df35..733f794 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -394,7 +394,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 			}
 
 			if (mode & PERF_CGROUP_SWIN) {
-				WARN_ON_ONCE(cpuctx->cgrp);
+				WARN_ON_ONCE(cpuctx->cgrp && !cpuctx->ctx.is_active);
+
 				/* set cgrp before ctxsw in to
 				 * allow event_filter_match() to not
 				 * have to pass task around
-- 
1.7.7.6

