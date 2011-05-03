Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1ECVEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:04:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1ECVEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:04:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=YueXyOqvn3TWonowiCyocMrJrwdk3iIXnAcn/DRrHj+Lxf+sawQbssHPVBZG1Pm90
	lUIP2cuGoHkKPDZW62ZvA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [RFC PATCH] tracing: Don't call wakeup() when committing the event
Date: Tue,  3 May 2011 14:03:36 -0700
Message-Id: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In using syscall tracing by concurrent processes, the wakeup() that is
called in the event commit function causes contention on the spin lock
of the waitqueue. I enabled sys_enter_getuid and sys_exit_getuid
tracepoints, and by running getuid_microbench from autotest in parallel
I found that the contention causes exponential latency increase in the
tracing path.

The autotest binary getuid_microbench calls getuid() in a tight loop for
the given number of iterations and measures the average time required to
complete a single invocation of syscall.

The patch here points to the problem and provides a naive solution to
start the discussion. It is not intended to be a definitive solution.

In the following example, the script enables the sys_enter_getuid and
sys_exit_getuid tracepoints and runs the getuid_microbench in parallel
with the given number of processes. The output clearly shows the latency
increase caused by contentions.

$ ~/getuid.sh 1
1000000 calls in 0.720974253 s (720.974253 ns/call)

$ ~/getuid.sh 2
1000000 calls in 1.166457554 s (1166.457554 ns/call)
1000000 calls in 1.168933765 s (1168.933765 ns/call)

$ ~/getuid.sh 3
1000000 calls in 1.783827516 s (1783.827516 ns/call)
1000000 calls in 1.795553270 s (1795.553270 ns/call)
1000000 calls in 1.796493376 s (1796.493376 ns/call)

$ ~/getuid.sh 4
1000000 calls in 4.483041796 s (4483.041796 ns/call)
1000000 calls in 4.484165388 s (4484.165388 ns/call)
1000000 calls in 4.484850762 s (4484.850762 ns/call)
1000000 calls in 4.485643576 s (4485.643576 ns/call)

$ ~/getuid.sh 5
1000000 calls in 6.497521653 s (6497.521653 ns/call)
1000000 calls in 6.502000236 s (6502.000236 ns/call)
1000000 calls in 6.501709115 s (6501.709115 ns/call)
1000000 calls in 6.502124100 s (6502.124100 ns/call)
1000000 calls in 6.502936358 s (6502.936358 ns/call)

After the patch, the latencies scale well and are exactly as expected.
$ ~/getuid.sh 1
1000000 calls in 0.626811320 s (626.811320 ns/call)

$ ~/getuid.sh 2
1000000 calls in 0.616566144 s (616.566144 ns/call)
1000000 calls in 0.622712754 s (622.712754 ns/call)

$ ~/getuid.sh 3
1000000 calls in 0.602886676 s (602.886676 ns/call)
1000000 calls in 0.612168691 s (612.168691 ns/call)
1000000 calls in 0.623516009 s (623.516009 ns/call)

$ ~/getuid.sh 4
1000000 calls in 0.614037455 s (614.037455 ns/call)
1000000 calls in 0.615070842 s (615.070842 ns/call)
1000000 calls in 0.615051941 s (615.051941 ns/call)
1000000 calls in 0.621556902 s (621.556902 ns/call)

$ ~/getuid.sh 5
1000000 calls in 0.605297117 s (605.297117 ns/call)
1000000 calls in 0.609545095 s (609.545095 ns/call)
1000000 calls in 0.610305369 s (610.305369 ns/call)
1000000 calls in 0.614056014 s (614.056014 ns/call)
1000000 calls in 0.622048279 s (622.048279 ns/call)

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ee7b5a0..3eeac29 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -328,7 +328,7 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_nowake_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
 void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
@@ -360,7 +360,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_nowake_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
 int reg_event_syscall_enter(struct ftrace_event_call *call)
-- 
1.7.3.1

