Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0FHTKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:10:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0FHTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:10:14 -0400
X-Authority-Analysis: v=1.1 cv=qXMh5QPBcdVGPlSuovMI3YqffpUTMWPwMqUnXLzRgMM= c=1 sm=0 a=eX2VPhT_8KEA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=5U9U6Fdrr6--4nNm4oYA:9 a=8SbB8Gbm4F0VVqqTPlSCXdnFug4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20100608173559.GE2800@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
	 <1276012661.2046.120.camel@twins>
	 <20100608173559.GE2800@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 08 Jun 2010 15:10:11 -0400
Message-ID: <1276024211.15884.107.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 23:05 +0530, Srikar Dronamraju wrote:
> > On Tue, 2010-06-08 at 11:33 -0400, Steven Rostedt wrote:

> I tested the patch and it fixed the regression where
> perf record -e probe:do_fork -aR sleep 1 would fail. 
> 

Thanks! Unfortunately the patch does two things, one is to fix this
regression, the other is a clean up. Linus is currently only wanting
fixes now and may not accept the clean up part of this patch. Can you
test the patch below. It only addresses the regression.

Thanks,

-- Steve

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e6f6588..8a2b73f 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -96,7 +96,9 @@ int perf_trace_init(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tp_event, &ftrace_events, list) {
 		if (tp_event->event.type == event_id &&
-		    tp_event->class && tp_event->class->perf_probe &&
+		    tp_event->class &&
+		    (tp_event->class->perf_probe ||
+		     tp_event->class->reg) &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
 			break;


