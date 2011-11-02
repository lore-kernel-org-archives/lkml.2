Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1KBUpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:45:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1KBUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:45:43 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=DJOu6W8zkUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VrwLg1RDDlTrUvbtMcMA:9 a=9eQMlsPDHhmqyXIoE8YA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320266741.4793.50.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Restore system filter behavior
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 Nov 2011 16:45:41 -0400
In-Reply-To: <1320259868.4793.46.camel@gandalf.stny.rr.com>
References: <4EAF46CF.8040408@cn.fujitsu.com>
	 <1320258167.4793.45.camel@gandalf.stny.rr.com>
	 <1320259868.4793.46.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 14:51 -0400, Steven Rostedt wrote:
> On Wed, 2011-11-02 at 14:22 -0400, Steven Rostedt wrote:
> 
> > The above shows how things are just ambiguous. I have no problem in
> > using the top filter to set multiple events. But the top filter should
> > not keep the state of what was set. Perhaps just have system event
> > filters always show default text. Like:
> > 
> > # cat /debug/tracing/events/sched/filter
> > ### global filter ###
> > # Use this to set multiple event filters
> > # Only affects events that have the event fields specified in the filter
> > 
> > 
> > I'll add your patch, but are you OK with the above always printing for
> > system event filters?  Just to remove the ambiguous state.
> 
> 
> As the filter is also used to show errors, I'll only have it print the
> "message" if the filter worked. If there's an error, then the error
> message will display instead.
> 

What's your thought on the below patch?

-- Steve

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 86040d9..6dee2b5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -27,6 +27,12 @@
 #include "trace.h"
 #include "trace_output.h"
 
+#define DEFAULT_SYS_FILTER_MESSAGE					\
+	"### global filter ###\n"					\
+	"# Use this to set filters for multiple events.\n"		\
+	"# Only events with the given fields will be affected.\n"	\
+	"# If no events are modified, an error message will be displayed here"
+
 enum filter_op_ids
 {
 	OP_OR,
@@ -646,7 +652,7 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
-		trace_seq_printf(s, "none\n");
+		trace_seq_printf(s, DEFAULT_SYS_FILTER_MESSAGE "\n");
 	mutex_unlock(&event_mutex);
 }
 
@@ -1838,7 +1844,8 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 	if (!filter)
 		goto out;
 
-	replace_filter_string(filter, filter_string);
+	/* System filters just show a default message */
+	replace_filter_string(filter, DEFAULT_SYS_FILTER_MESSAGE);
 	/*
 	 * No event actually uses the system filter
 	 * we can free it without synchronize_sched().
@@ -1848,14 +1855,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	parse_init(ps, filter_ops, filter_string);
 	err = filter_parse(ps);
-	if (err) {
-		append_filter_err(ps, system->filter);
-		goto out;
-	}
+	if (err)
+		goto err_filter;
 
 	err = replace_system_preds(system, ps, filter_string);
 	if (err)
-		append_filter_err(ps, system->filter);
+		goto err_filter;
 
 out:
 	filter_opstack_clear(ps);
@@ -1865,6 +1870,11 @@ out_unlock:
 	mutex_unlock(&event_mutex);
 
 	return err;
+
+err_filter:
+	replace_filter_string(filter, filter_string);
+	append_filter_err(ps, system->filter);
+	goto out;
 }
 
 #ifdef CONFIG_PERF_EVENTS


