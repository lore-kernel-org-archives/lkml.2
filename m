Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab0FJQ0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:26:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38126 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0FJQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TbJutcllQBRGy6NPdTQ+2Jqp5NSj5u7nN/YKATJ9FGyOX9CSUnLFErD0c0bx71Atyf
         SeBBI6Znvgd55mPbDBq1ytSvBE6EjTjGnY6Db4jUEdRQk0wzgf7Ye1RHeUTkrA6yuvGV
         mvdzlXj7HT4cZEQQ+TqrTTC7R2n/Mvjy1Cbkc=
Date: Thu, 10 Jun 2010 18:26:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] perf: New PERF_EVENT_STATE_PAUSED event state
Message-ID: <20100610162602.GC5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <1276141760-11590-4-git-send-regression-fweisbec@gmail.com> <1276167317.2077.109.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276167317.2077.109.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:55:17PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 05:49 +0200, Frederic Weisbecker wrote:
> > This brings a new PERF_EVENT_STATE_PAUSED state. It means the events
> > is enabled but we don't want it to run, it must be in the same state
> > than after a pmu->stop() call. So the event has been reserved and
> > allocated and it is ready to start after a pmu->start() call.
> > 
> > It is deemed for hardware events when we want them to be reserved on
> > the cpu and ready to be started anytime. This is going to be useful
> > for the new context exclusion that will follow.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> > Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  arch/x86/kernel/cpu/perf_event.c |    6 ++++--
> >  include/linux/perf_event.h       |    3 ++-
> >  kernel/perf_event.c              |    7 ++++---
> >  3 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index f2da20f..9b0e52f 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -839,7 +839,8 @@ void hw_perf_enable(void)
> >  			    match_prev_assignment(hwc, cpuc, i))
> >  				continue;
> >  
> > -			x86_pmu_stop(event);
> > +			if (event->state != PERF_EVENT_STATE_PAUSED)
> > +				x86_pmu_stop(event);
> >  		}
> >  
> >  		for (i = 0; i < cpuc->n_events; i++) {
> > @@ -851,7 +852,8 @@ void hw_perf_enable(void)
> >  			else if (i < n_running)
> >  				continue;
> >  
> > -			x86_pmu_start(event);
> > +			if (event->state != PERF_EVENT_STATE_PAUSED)
> > +				x86_pmu_start(event);
> >  		}
> >  		cpuc->n_added = 0;
> >  		perf_events_lapic_init();
> 
> Also, I'd rather keep the whole event->state knowledge in the generic
> code.



Yeah, but if we do this, we need to maintain the exact same state in the
arch level. We need this for every pmus.

