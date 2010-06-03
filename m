Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0FCMfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:35:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49352 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0FCMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UchEIf3TtGC0MYEzaP5+rbQy/4qFGEEwDuBjQtmpFpbpkEm9bJuGiR1+aR5IMAnWca
         xK2Lfz53pP6ZBVNZABlQsb8iKt8ZLBDYIdm37HIH4tg0AOrL/U7JruhZ0O2XJhNwjGyT
         It8pm1SEiCKP8VLMgZqcOJyKWKq4w6/m9lkpg=
Date: Thu, 3 Jun 2010 14:35:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf crash fix
Message-ID: <20100603123543.GA5234@nowhere>
References: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com> <1275552159.27810.34944.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275552159.27810.34944.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:02:39AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-03 at 05:13 +0200, Frederic Weisbecker wrote:
> 
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index 858f56f..b666d7d 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -1510,20 +1510,16 @@ do {					\
> >  	return div64_u64(dividend, divisor);
> >  }
> >  
> > -static void perf_event_stop(struct perf_event *event)
> > +static void perf_event_stop_hwevent(struct perf_event *event)
> >  {
> > -	if (!event->pmu->stop)
> > -		return event->pmu->disable(event);
> > -
> > -	return event->pmu->stop(event);
> > +	if (event->pmu->stop && !is_software_event(event))
> > +		return event->pmu->stop(event);
> >  }
> >  
> > -static int perf_event_start(struct perf_event *event)
> > +static int perf_event_start_hwevent(struct perf_event *event)
> >  {
> > -	if (!event->pmu->start)
> > -		return event->pmu->enable(event);
> > -
> > -	return event->pmu->start(event);
> > +	if (event->pmu->start && !is_software_event(event))
> > +		return event->pmu->start(event);
> >  }
> >  
> >  static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
> > @@ -1546,9 +1542,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
> >  
> >  	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
> >  		perf_disable();
> > -		perf_event_stop(event);
> > +		perf_event_stop_hwevent(event);
> >  		atomic64_set(&hwc->period_left, 0);
> > -		perf_event_start(event);
> > +		perf_event_start_hwevent(event);
> >  		perf_enable();
> >  	}
> >  }
> 
> Urhm,. isn't is much easier to simply give the software events a NOP
> stop/start callback?


I wanted to, but I thought we could avoid two indirect calls on each
ticks and I was also afraid of breaking start/stop original semantics,
more especially the role of perf_event_stop/start


But that's about quite small details. I'm ok with your patch (the version
that also handles trace events ;)

Thanks.

