Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1DSU3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:29:31 -0400
Received: from kroah.org ([198.145.64.141]:47619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab1DSURB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201044.974549470@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [17/70] perf: Fix task context scheduling
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit ab711fe08297de1485fff0a366e6db8828cafd6a upstream.

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
LKML-Reference: <1301520405.4859.213.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/perf_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1052,7 +1052,7 @@ void perf_event_task_sched_out(struct ta
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+	__perf_event_task_sched_out(task, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);


