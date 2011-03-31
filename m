Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1CaMmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:42:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:56825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1CaMmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:42:16 -0400
Date: Thu, 31 Mar 2011 12:41:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <1301520405.4859.213.camel@twins>
References: <1301520405.4859.213.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix task context scheduling
Message-ID: <tip-ab711fe08297de1485fff0a366e6db8828cafd6a@git.kernel.org>
Git-Commit-ID: ab711fe08297de1485fff0a366e6db8828cafd6a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 12:41:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab711fe08297de1485fff0a366e6db8828cafd6a
Gitweb:     http://git.kernel.org/tip/ab711fe08297de1485fff0a366e6db8828cafd6a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 31 Mar 2011 10:29:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 13:02:55 +0200

perf: Fix task context scheduling

Jiri reported:

 |
 | - once an event is created by sys_perf_event_open, task context
 |   is created and it stays even if the event is closed, until the
 |   task is finished ... thats what I see in code and I assume it's
 |   correct
 |
 | - when the task opens event, perf_sched_events jump label is
 |   incremented and following callbacks are started from scheduler
 |
 |         __perf_event_task_sched_in
 |         __perf_event_task_sched_out
 |
 |   These callback *in/out set/unset cpuctx->task_ctx value to the
 |   task context.
 |
 | - close is called on event on CPU 0:
 |         - the task is scheduled on CPU 0
 |         - __perf_event_task_sched_in is called
 |         - cpuctx->task_ctx is set
 |         - perf_sched_events jump label is decremented and == 0
 |         - __perf_event_task_sched_out is not called
 |         - cpuctx->task_ctx on CPU 0 stays set
 |
 | - exit is called on CPU 1:
 |         - the task is scheduled on CPU 1
 |         - perf_event_exit_task is called
 |         - task_ctx_sched_out unsets cpuctx->task_ctx on CPU 1
 |         - put_ctx destroys the context
 |
 | - another call of perf_rotate_context on CPU 0 will use invalid
 |   task_ctx pointer, and eventualy panic.
 |

Cure this the simplest possibly way by partially reverting the
jump_label optimization for the sched_out case.

Reported-and-tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org> # .37+
LKML-Reference: <1301520405.4859.213.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 311b4dc..04d75a8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1086,7 +1086,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
+	__perf_event_task_sched_out(task, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
