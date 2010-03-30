Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0C3XRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:17:45 -0400
Received: from kroah.org ([198.145.64.141]:51805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab0C3XRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:36 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:10 2010
Message-Id: <20100330225609.778211759@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [019/116] tracing: Use same local variable when resetting the ring buffer
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 283740c619d211e34572cc93c8cdba92ccbdb9cc upstream.

In the ftrace code that resets the ring buffer it references the
buffer with a local variable, but then uses the tr->buffer as the
parameter to reset. If the wakeup tracer is running, which can
switch the tr->buffer with the max saved buffer, this can break
the requirement of disabling the buffer before the reset.

   buffer = tr->buffer;
   ring_buffer_record_disable(buffer);
   synchronize_sched();
   __tracing_reset(tr->buffer, cpu);

If the tr->buffer is swapped, then the reset is not happening to the
buffer that was disabled. This will cause the ring buffer to fail.

Found with Li Zefan's ftrace_stress_test.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -748,10 +748,10 @@ out:
 	mutex_unlock(&trace_types_lock);
 }
 
-static void __tracing_reset(struct trace_array *tr, int cpu)
+static void __tracing_reset(struct ring_buffer *buffer, int cpu)
 {
 	ftrace_disable_cpu();
-	ring_buffer_reset_cpu(tr->buffer, cpu);
+	ring_buffer_reset_cpu(buffer, cpu);
 	ftrace_enable_cpu();
 }
 
@@ -763,7 +763,7 @@ void tracing_reset(struct trace_array *t
 
 	/* Make sure all commits have finished */
 	synchronize_sched();
-	__tracing_reset(tr, cpu);
+	__tracing_reset(buffer, cpu);
 
 	ring_buffer_record_enable(buffer);
 }
@@ -781,7 +781,7 @@ void tracing_reset_online_cpus(struct tr
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		__tracing_reset(tr, cpu);
+		__tracing_reset(buffer, cpu);
 
 	ring_buffer_record_enable(buffer);
 }


