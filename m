Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0C2Wnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:43:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34795 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0C2Wnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bFqZuga5gd5WIvNXzhy0vIeSuOo7WBZYx9El9Gjqk8DiRweKpZRMvepHIyMcr+bq7r
         eECP/qC6V/V3Cj61+h8BEgMfA3Jf+8n2mF7p/uqsvxL2u+H9LXhzwimww1+mDVA9TgYU
         AflBsyK2H5ofm4fBjI4zcSoBLQNL7YO4jfA4s=
Date: Tue, 30 Mar 2010 00:43:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
	switch/migrate events
Message-ID: <20100329224352.GC12254@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com> <1269753066-17246-3-git-send-regression-fweisbec@gmail.com> <1269852599.12097.159.camel@laptop> <20100329174723.GB5101@nowhere> <1269885938.12097.367.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269885938.12097.367.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 08:05:38PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 19:47 +0200, Frederic Weisbecker wrote:
> > 
> > 
> > I'm going to make a quick fix for perf_fetch_caller_regs() that
> > passes task_pt_regs if exclude_kernel for perf/urgent,
> > and I'll do the above cleanups/invasive fixes on perf/core.
> > 
> > 
> ok, sounds sensible, thanks!


Actually I have doubts about what should be the strict sense
of exclude_kernel.

Does that mean we exclude any event that happened in the kernel?
Or does that mean we exclude the part that happened in the kernel?

Depending on the case, we do either.

In perf_swevent_hrtimer(), we simply go back to task_pt_regs()
if exclude_kernel.

But in other software events, we don't such fix, we actually
filter out the event if it is not user_mode().

So, I'm a bit confused on what to do.
I'm tempted to adopt the meaning from perf_swevent_hrtimer()
for software events too, I'm not sure...

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b0feb47..3cb5de8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3986,14 +3986,17 @@ static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data);
 
 static int perf_exclude_event(struct perf_event *event,
-			      struct pt_regs *regs)
+			      struct pt_regs **regs)
 {
-	if (regs) {
-		if (event->attr.exclude_user && user_mode(regs))
+	if (*regs) {
+		if (event->attr.exclude_user && user_mode(*regs))
 			return 1;
 
-		if (event->attr.exclude_kernel && !user_mode(regs))
-			return 1;
+		if (event->attr.exclude_kernel && !user_mode(*regs))
+			if (current->mm)
+				*regs = task_pt_regs();
+			else
+				return 1;
 	}
 
 	return 0;
@@ -4017,7 +4020,7 @@ static int perf_swevent_match(struct perf_event *event,
 	if (event->attr.config != event_id)
 		return 0;
 
-	if (perf_exclude_event(event, regs))
+	if (perf_exclude_event(event, &regs))
 		return 0;
 
 	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
@@ -4442,7 +4445,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 
 	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
-	if (!perf_exclude_event(bp, regs))
+	if (!perf_exclude_event(bp, &regs))
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else


