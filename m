Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab0CaAQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:16:39 -0400
Received: from kroah.org ([198.145.64.141]:51783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab0C3XRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:33 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:07 2010
Message-Id: <20100330225606.919621872@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [016/116] ring-buffer: Move disabled check into preempt disable section
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 52fbe9cde7fdb5c6fac196d7ebd2d92d05ef3cd4 upstream.

The ring buffer resizing and resetting relies on a schedule RCU
action. The buffers are disabled, a synchronize_sched() is called
and then the resize or reset takes place.

But this only works if the disabling of the buffers are within the
preempt disabled section, otherwise a window exists that the buffers
can be written to while a reset or resize takes place.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B949E43.2010906@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ring_buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2237,12 +2237,12 @@ ring_buffer_lock_reserve(struct ring_buf
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return NULL;
 
-	if (atomic_read(&buffer->record_disabled))
-		return NULL;
-
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out_nocheck;
+
 	if (trace_recursive_lock())
 		goto out_nocheck;
 
@@ -2474,11 +2474,11 @@ int ring_buffer_write(struct ring_buffer
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return -EBUSY;
 
-	if (atomic_read(&buffer->record_disabled))
-		return -EBUSY;
-
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out;
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))


