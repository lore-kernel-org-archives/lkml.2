Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0CaAQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:16:24 -0400
Received: from kroah.org ([198.145.64.141]:51811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab0C3XRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:37 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:11 2010
Message-Id: <20100330225610.518209974@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [020/116] tracing: Disable buffer switching when starting or stopping trace
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit a2f8071428ed9a0f06865f417c962421c9a6b488 upstream.

When the trace iterator is read, tracing_start() and tracing_stop()
is called to stop tracing while the iterator is processing the trace
output.

These functions disable both the standard buffer and the max latency
buffer. But if the wakeup tracer is running, it can switch these
buffers between the two disables:

  buffer = global_trace.buffer;
  if (buffer)
      ring_buffer_record_disable(buffer);

      <<<--------- swap happens here

  buffer = max_tr.buffer;
  if (buffer)
      ring_buffer_record_disable(buffer);

What happens is that we disabled the same buffer twice. On tracing_start()
we can enable the same buffer twice. All ring_buffer_record_disable()
must be matched with a ring_buffer_record_enable() or the buffer
can be disable permanently, or enable prematurely, and cause a bug
where a reset happens while a trace is commiting.

This patch protects these two by taking the ftrace_max_lock to prevent
a switch from occurring.

Found with Li Zefan's ftrace_stress_test.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -858,6 +858,8 @@ void tracing_start(void)
 		goto out;
 	}
 
+	/* Prevent the buffers from switching */
+	__raw_spin_lock(&ftrace_max_lock);
 
 	buffer = global_trace.buffer;
 	if (buffer)
@@ -867,6 +869,8 @@ void tracing_start(void)
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
+	__raw_spin_unlock(&ftrace_max_lock);
+
 	ftrace_start();
  out:
 	spin_unlock_irqrestore(&tracing_start_lock, flags);
@@ -888,6 +892,9 @@ void tracing_stop(void)
 	if (trace_stop_count++)
 		goto out;
 
+	/* Prevent the buffers from switching */
+	__raw_spin_lock(&ftrace_max_lock);
+
 	buffer = global_trace.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
@@ -896,6 +903,8 @@ void tracing_stop(void)
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
+	__raw_spin_unlock(&ftrace_max_lock);
+
  out:
 	spin_unlock_irqrestore(&tracing_start_lock, flags);
 }


