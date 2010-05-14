Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab0ENT3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:29:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380Ab0ENT3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:20 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=o-RD-GAIFbMA:10 a=VZGMvYHv9TIA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=g0cBHdXBoa7iz6UwXl4A:9 a=MgbeDtK9sUKH5dx4CdIA:7 a=NqdjBy8hXeqb-fXQcWvd2pnondsA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100514192917.222882793@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 May 2010 15:22:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 13/13 v3] tracing: Comment the use of event_mutex with trace event flags
References: <20100514192246.079025623@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Comment-the-use-of-event_mutex-with-trace-ev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The flags variable is protected by the event_mutex when modifying,
but the event_mutex is not held when reading the variable.

This is due to the fact that the reads occur in critical sections where
taking a mutex (or even a spinlock) is not wanted.

But the two flags that exist (enable and filter_active) have the code
written as such to handle the reads to not need a lock.

The enable flag is used just to know if the event is enabled or not
and its use is always under the event_mutex. Whether or not the event
is actually enabled is really determined by the tracepoint being
registered. The flag is just a way to let the code know if the tracepoint
is registered.

The filter_active is different. It is read without the lock. If it
is set, then the event probes jump to the filter code. There can be a
slight mismatch between filters available and filter_active. If the flag is
set but no filters are available, the code safely jumps to a filter nop.
If the flag is not set and the filters are available, then the filters
are skipped. This is acceptable since filters are usually set before
tracing or they are set by humans, which would not notice the slight
delay that this causes.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5ac97a4..3578e90 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -169,7 +169,14 @@ struct ftrace_event_call {
 	 *   bit 1:		enabled
 	 *   bit 2:		filter_active
 	 *
-	 *  Must hold event_mutex to change.
+	 * Changes to flags must hold the event_mutex.
+	 *
+	 * Note: Reads of flags do not hold the event_mutex since
+	 * they occur in critical sections. But the way flags
+	 * is currently used, these changes do no affect the code
+	 * except that when a change is made, it may have a slight
+	 * delay in propagating the changes to other CPUs due to
+	 * cacheing and such.
 	 */
 	unsigned int		flags;
 
-- 
1.7.0


