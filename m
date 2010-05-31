Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0EaQqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:46:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab0EaQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZXQ5PxHEVHAjJf/z6Em9N2V7eyrHad24bjmvDadMj9oBylInUl3D1qLx9lAA/TQUp5
         SgW8TEu9uCLnYgk4HTg6bBdzfbnkHKQx3TnbbAw4W4pQRwX+umnKqavKmSUTCDWx0G6E
         nBpDwcI+Vi6WHyjTeF8t5WoHGsXftcquo1DMQ=
Date: Mon, 31 May 2010 20:45:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Robert Richter <robert.richter@amd.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [RFC] perf, x86: Segregate PMU workaraunds into
	x86_pmu_quirk_ops structure
Message-ID: <20100531164553.GD5489@lenovo>
References: <20100529182409.GJ5322@lenovo> <1275157990.1645.519.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275157990.1645.519.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 08:33:10PM +0200, Peter Zijlstra wrote:
> 
> On Sat, 2010-05-29 at 22:24 +0400, Cyrill Gorcunov wrote:
> > @@ -924,7 +930,11 @@ x86_perf_event_set_period(struct perf_ev
> >          */
> >         atomic64_set(&hwc->prev_count, (u64)-left);
> >  
> > -       wrmsrl(hwc->event_base + idx,
> > +       if (x86_pmu.quirks.perfctr_write)
> > +               x86_pmu.quirks.perfctr_write(hwc->event_base + idx,
> > +                               (u64)(-left) & x86_pmu.cntval_mask);
> > +       else
> > +               wrmsrl(hwc->event_base + idx,
> >                         (u64)(-left) & x86_pmu.cntval_mask);
> 
> This bit is rather ugly,.. not quite sure how to clean it up though.
> Anybody got a bright idea?
> 

Yes, I know, only a bit lighter solution could be like in patch
below, alternative instructions bring mess (and considering we
may have paravirt turned on -- even more mess), jump labels...
I didn't find them in tree, in which file(s) they are? I mean,
are they under review now or merged in some place?

So I guess plain test may be more-less fine here, hmm?

	-- Cyrill
---
perf, x86: Make a second write to performance counter when needed

On Netburst cpu we need a second write to performance counter to
be sure it's updated properly.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c    |   10 ++++++++++
 arch/x86/kernel/cpu/perf_event_p4.c |    9 +++++++++
 2 files changed, 19 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -220,6 +220,7 @@ struct x86_pmu {
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
 	void		(*quirks)(void);
+	int		perfctr_second_write;
 
 	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
@@ -926,6 +927,15 @@ x86_perf_event_set_period(struct perf_ev
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
 	wrmsrl(hwc->event_base + idx,
+		(u64)(-left) & x86_pmu.cntval_mask);
+
+	/*
+	 * Due to erratum on certan cpu we need
+	 * a second write to be sure the register
+	 * is updated properly
+	 */
+	if (x86_pmu.perfctr_second_write)
+		wrmsrl(hwc->event_base + idx,
 			(u64)(-left) & x86_pmu.cntval_mask);
 
 	perf_event_update_userpage(event);
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -829,6 +829,15 @@ static __initconst const struct x86_pmu 
 	.max_period		= (1ULL << 39) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
+	/*
+	 * This handles erratum N15 in intel doc 249199-029,
+	 * the counter may not be updated correctly on write
+	 * so we need a second write operation to do the trick
+	 * (the official workaround didn't work)
+	 *
+	 * the former idea is taken from OProfile code
+	 */
+	.perfctr_second_write	= 1,
 };
 
 static __init int p4_pmu_init(void)
