Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0EaOJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:09:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40906 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0EaOJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l0A2kE0aWYN25VJhq1g4sU8nW4kHFXj9rP8qD4mIIUwDCUxzUi34C7WG0Z/FsxNw+x
         nQUrGwhhhzkj5QmO4XtG+U/DYKQBcnIJaoNBFqPr65CH8Ius56IB3ChrbcDLJszzzJOW
         C49bYzc6ETZKcML/ZuU10TGfnb39c+G6W5FrY=
Date: Mon, 31 May 2010 18:09:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf, x86: Segregate PMU workaraunds into
	x86_pmu_quirk_ops structure
Message-ID: <20100531140910.GA5489@lenovo>
References: <20100529182409.GJ5322@lenovo> <20100531130058.GR21799@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531130058.GR21799@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 03:00:58PM +0200, Robert Richter wrote:
> On 29.05.10 14:24:09, Cyrill Gorcunov wrote:
> > Hi,
> > 
> > I would appreciate comments/complains on the following patch. The idea is to implement
> > PMU quirks with minimal impact. At the moment two quirks are addressed -
> > PEBS disabling on Clovertown and P4 performance counter double write.
> > PEBS disabling already was there only moved to x86_pmu_quirk_ops. Note
> > that I didn't use pointer to the structure intensionally but embed it into
> > x86_pmu, if the structure grow we will need to use a pointer to the structure.
> 
> The quirk functions add additional code and ops structures to the
> already existing model specific code. This quirks would be fine if we
> would could merge model specific code and get unified code. But these
> model specific code cannot be replaced. So I rather prefer to
> implement cpu errata in model specific code.
> 

agreed, but this quirks ops looked as more clear solution for me,
at least in a sake of initiating the 'find something better' dialogue
you know :)

> > @@ -185,6 +185,11 @@ union perf_capabilities {
> >  	u64	capabilities;
> >  };
> >  
> > +struct x86_pmu_quirk_ops {
> > +	void		(*pmu_init)(void);
> 
> This init quirk could be much better handled in the model specific
> init code (intel_pmu_init()/amd_pmu_init()). I don't see a reason for
> adding the quirk first and then immediately calling it. The quirk
> function could be called directly instead.
> 

well, at moment we have only the one caller but if the number of
callers increase _better_ to have it called via function pointer
since it's easier to find out the callers in further and we're allowed
to use such approach since this is a not fast path code. On the other
hands I rather agree with you -- it's overzealous at the moment.
/me: dropping idea on *pmu_init

> > +	void		(*perfctr_write)(unsigned long addr, u64 value);
> 
> This one is difficult to avoid ...
> 

unfortunately

> > @@ -924,7 +930,11 @@ x86_perf_event_set_period(struct perf_ev
> >  	 */
> >  	atomic64_set(&hwc->prev_count, (u64)-left);
> >  
> > -	wrmsrl(hwc->event_base + idx,
> > +	if (x86_pmu.quirks.perfctr_write)
> > +		x86_pmu.quirks.perfctr_write(hwc->event_base + idx,
> > +				(u64)(-left) & x86_pmu.cntval_mask);
> > +	else
> > +		wrmsrl(hwc->event_base + idx,
> 
> ... but it introduces another check in the fast path. There are some
> options to avoid this. First we could see if we rather implement this
> in model specific interrupt handlers (there is p4_pmu_handle_irq()).

no, we can't, I thought about that, this code is called from several
places.

> Or, we implement an optimized check for perf quirks, maybe using
> ALTERNATIVE or jump labels.
> 

yes! Robert, I completely forgot about alternatives. I guess that
is exactly what we need! I'll try to implement.

> I think we can handle both quirks, but if we start using and extending
> it more, it will have a performance impact and code will also more
> complicated. So, I think it is rather inappropriate as a general
> approach.
> 
> -Robert
> 

Thanks a huge for comments, Robert!

> >  			(u64)(-left) & x86_pmu.cntval_mask);
> >  
> >  	perf_event_update_userpage(event);
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
> 
	-- Cyrill
