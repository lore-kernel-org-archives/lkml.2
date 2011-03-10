Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1CJQAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:00:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1CJP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:14 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=VZ_X-eb2-ZgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=lAknz7vJnf5IPZ4WgJ0A:9 a=TiZ2sP6LQNCcOeuN2RZ38FHusXMA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155912.913153141@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 15/15] tracing: Fix irqoff selftest expanding max buffer
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0015-tracing-Fix-irqoff-selftest-expanding-max-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the kernel command line declares a tracer "ftrace=sometracer" and
that tracer is either not defined or is enabled after irqsoff,
then the irqs off selftest will fail with the following error:

Testing tracer irqsoff:
------------[ cut here ]------------
WARNING: at /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/tra
ce.c:713 update_max_tr_single+0xfa/0x11b()
Hardware name:
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.38-rc8-test #1
Call Trace:
 [<c0441d9d>] ? warn_slowpath_common+0x65/0x7a
 [<c049adb2>] ? update_max_tr_single+0xfa/0x11b
 [<c0441dc1>] ? warn_slowpath_null+0xf/0x13
 [<c049adb2>] ? update_max_tr_single+0xfa/0x11b
 [<c049e454>] ? stop_critical_timing+0x154/0x204
 [<c049b54b>] ? trace_selftest_startup_irqsoff+0x5b/0xc1
 [<c049b54b>] ? trace_selftest_startup_irqsoff+0x5b/0xc1
 [<c049b54b>] ? trace_selftest_startup_irqsoff+0x5b/0xc1
 [<c049e529>] ? time_hardirqs_on+0x25/0x28
 [<c0468bca>] ? trace_hardirqs_on_caller+0x18/0x12f
 [<c0468cec>] ? trace_hardirqs_on+0xb/0xd
 [<c049b54b>] ? trace_selftest_startup_irqsoff+0x5b/0xc1
 [<c049b6b8>] ? register_tracer+0xf8/0x1a3
 [<c14e93fe>] ? init_irqsoff_tracer+0xd/0x11
 [<c040115e>] ? do_one_initcall+0x71/0x121
 [<c14e93f1>] ? init_irqsoff_tracer+0x0/0x11
 [<c14ce3a9>] ? kernel_init+0x13a/0x1b6
 [<c14ce26f>] ? kernel_init+0x0/0x1b6
 [<c0403842>] ? kernel_thread_helper+0x6/0x10
---[ end trace e93713a9d40cd06c ]---
.. no entries found ..FAILED!

What happens is the "ftrace=..." will expand the ring buffer to its
default size (from its minimum size) but it will not expand the
max ring buffer (the ring buffer to store maximum latencies).
When the irqsoff test runs, it will call the ring buffer swap routine
that checks if the max ring buffer is the same size as the normal
ring buffer, and will fail if it is not. This causes the test to fail.

The solution is to expand the max ring buffer before running the self
test if the max ring buffer is used by that tracer and the normal ring
buffer is expanded. The max ring buffer should be shrunk again after
the test is done to save space.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fd6e1b9..9541c27 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -779,6 +779,11 @@ __acquires(kernel_lock)
 		tracing_reset_online_cpus(tr);
 
 		current_trace = type;
+
+		/* If we expanded the buffers, make sure the max is expanded too */
+		if (ring_buffer_expanded && type->use_max_tr)
+			ring_buffer_resize(max_tr.buffer, trace_buf_size);
+
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
 		ret = type->selftest(type, tr);
@@ -791,6 +796,10 @@ __acquires(kernel_lock)
 		/* Only reset on passing, to avoid touching corrupted buffers */
 		tracing_reset_online_cpus(tr);
 
+		/* Shrink the max buffer again */
+		if (ring_buffer_expanded && type->use_max_tr)
+			ring_buffer_resize(max_tr.buffer, 1);
+
 		printk(KERN_CONT "PASSED\n");
 	}
 #endif
-- 
1.7.2.3


