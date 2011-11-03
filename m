Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1KCOTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:19:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1KCOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:19:39 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=CMzmyBkqurIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6rqHouBjAAAA:8 a=8i2gTpztnxHGoKo4l_kA:9 a=PUjeQqilurYA:10 a=TAmEwCHjoHMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320329977.27370.16.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 03 Nov 2011 10:19:37 -0400
In-Reply-To: <1320275277.4793.54.camel@gandalf.stny.rr.com>
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
	 <1320275277.4793.54.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 19:07 -0400, Steven Rostedt wrote:
> On Thu, 2011-11-03 at 01:40 +0300, Andrew Vagin wrote:
> > process_arg(...) can't parse "__entry->prev_state & (TASK_STATE_MAX-1)",
> > because a complicated argument should be within brackets.
> 
> No it is fine, the userspace tool is broken.
> 
> > 
> > Without this patch "perf report" prints following errors:
> > $ ./perf record -ag -e sched:sched_switch
> > ...
> > $ ./perf report
> >   Warning: Error: expected type 5 but read 4
> >   Warning: Error: expected type 4 but read 0
> >   Fatal: bad op token {
> > 
> > Signed-off-by: Andrew Vagin <avagin@openvz.org>
> 
> NACK!
> 
> This is a perf userspace bug, not a kernel one. Please fix the userspace
> tool instead.
> 
> Note, the new version of libparsevent handles this case without issue.
> Perf just needs to be updated.
> 

Can you try this patch on perf. It's untested (not even compiled tested)

-- Steve

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..6c164dc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1537,6 +1537,8 @@ process_flags(struct event *event, struct print_arg *arg, char **tok)
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
+	while (type == EVENT_OP)
+		type = process_op(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 


