Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159Ab2DKXrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:47:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab2DKXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:25 -0400
Message-Id: <20120411231038.977243939@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 21/59] tracing: Fix ent_size in trace output
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 12b5da349a8b94c9dbc3430a6bc42eabd9eaf50b upstream.

When reading the trace file, the records of each of the per_cpu buffers
are examined to find the next event to print out. At the point of looking
at the event, the size of the event is recorded. But if the first event is
chosen, the other events in the other CPU buffers will reset the event size
that is stored in the iterator descriptor, causing the event size passed to
the output functions to be incorrect.

In most cases this is not a problem, but for the case of stack traces, it
is. With the change to the stack tracing to record a dynamic number of
back traces, the output depends on the size of the entry instead of the
fixed 8 back traces. When the entry size is not correct, the back traces
would not be fully printed.

Note, reading from the per-cpu trace files were not affected.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1642,6 +1642,7 @@ __find_next_entry(struct trace_iterator
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
+	int next_size = 0;
 	int cpu;
 
 	/*
@@ -1673,9 +1674,12 @@ __find_next_entry(struct trace_iterator
 			next_cpu = cpu;
 			next_ts = ts;
 			next_lost = lost_events;
+			next_size = iter->ent_size;
 		}
 	}
 
+	iter->ent_size = next_size;
+
 	if (ent_cpu)
 		*ent_cpu = next_cpu;
 


