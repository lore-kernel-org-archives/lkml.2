Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1ERX3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:29:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1ERX3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rRZZKUZfoRXNLdcxutABmWmWZf9rJicskJv6ZYlbxCSYMurVJW00O3Pvh/xdO4QHWc
         VPVIketoWSioZpeY57bHTozvQ/SaNJlfuSzoUWmGjFAAWy2ZGib9jSPC4qPllwDsynlV
         toV+oRU4i5pLycEHXsR5os0aDSmrMwTx1mncg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] tracing: Register static events output early
Date: Thu, 19 May 2011 01:29:28 +0200
Message-Id: <1305761368-5488-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early uses of trace_printk() or trace_dump_stack() won't be
displayed correctly if they are printed before device initcalls
through explicit calls to ftrace_dump() or if there is an early
BUG() and ftrace_dump_on_oops is set. This is because we only
initialize these static events output callbacks at that initcall
level.

Initialize these events output at the earliest initcall state
to make boot debugging possible sooner.

Before:

[    1.936168] Dumping ftrace buffer:
[    1.936168] ---------------------------------
[    1.936168]   <idle>-0       3d.s. 2299861us : Unknown type 4
[    1.936168] ---------------------------------

After:

[    1.946182] Dumping ftrace buffer:
[    1.946182] ---------------------------------
[    1.946182]   <idle>-0       3d.s. 2309844us : <stack trace>
[    1.946182]  => tick_setup_sched_timer
[    1.946182]  => hrtimer_run_pending
[    1.946182]  => run_timer_softirq
[    1.946182]  => __do_softirq
[    1.946182]  => call_softirq
[    1.946182]  => do_softirq
[    1.946182]  => irq_exit
[    1.946182]  => smp_apic_timer_interrupt
[    1.946182] ---------------------------------

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cf535cc..ad92d9c 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1278,4 +1278,4 @@ __init static int init_events(void)
 
 	return 0;
 }
-device_initcall(init_events);
+early_initcall(init_events);
-- 
1.7.3.2

