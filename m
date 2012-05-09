Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2EIGV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:21:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38948 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249Ab2EIFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:20 -0400
Message-Id: <20120509055043.841582599@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 102/167] [PATCH] tracing: Fix stacktrace of latency tracers (irqsoff and
 friends)
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit db4c75cbebd7e5910cd3bcb6790272fcc3042857 upstream.

While debugging a latency with someone on IRC (mirage335) on #linux-rt (OFTC),
we discovered that the stacktrace output of the latency tracers
(preemptirqsoff) was empty.

This bug was caused by the creation of the dynamic length stack trace
again (like commit 12b5da3 "tracing: Fix ent_size in trace output" was).

This bug is caused by the latency tracers requiring the next event
to determine the time between the current event and the next. But by
grabbing the next event, the iter->ent_size is set to the next event
instead of the current one. As the stacktrace event is the last event,
this makes the ent_size zero and causes nothing to be printed for
the stack trace. The dynamic stacktrace uses the ent_size to determine
how much of the stack can be printed. The ent_size of zero means
no stack.

The simple fix is to save the iter->ent_size before finding the next event.

Note, mirage335 asked to remain anonymous from LKML and git, so I will
not add the Reported-by and Tested-by tags, even though he did report
the issue and tested the fix.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_output.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 859fae6..df611a0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -652,6 +652,8 @@ int trace_print_lat_context(struct trace_iterator *iter)
 {
 	u64 next_ts;
 	int ret;
+	/* trace_find_next_entry will reset ent_size */
+	int ent_size = iter->ent_size;
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent,
 			   *next_entry = trace_find_next_entry(iter, NULL,
@@ -660,6 +662,9 @@ int trace_print_lat_context(struct trace_iterator *iter)
 	unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
 	unsigned long rel_usecs;
 
+	/* Restore the original ent_size */
+	iter->ent_size = ent_size;
+
 	if (!next_entry)
 		next_ts = iter->ts;
 	rel_usecs = ns2usecs(next_ts - iter->ts);
-- 
1.7.10



