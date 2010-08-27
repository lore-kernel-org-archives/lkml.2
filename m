Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0H0MvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:51:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:58414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0H0Mu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:50:59 -0400
Subject: Re: [PATCH] perf: fix possible divide-by-zero in
 perf_swevent_overflow()
From: Peter Zijlstra <peterz@infradead.org>
To: DDD <dongdong.deng@windriver.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C77ADC1.5030502@windriver.com>
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>
	 <1282824727.1975.747.camel@laptop>  <4C765FD3.9060904@windriver.com>
	 <1282827486.1975.845.camel@laptop>  <4C77ADC1.5030502@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 14:50:45 +0200
Message-ID: <1282913445.1975.2414.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 20:21 +0800, DDD wrote:

> >> Maybe the root cause was from kgdb/hw_breakpoint_layer,
> > 
> > Yeah, I think there's a bug in the hw_breakpoint stuff, does something
> > like the below fix it?

> Thanks for your patch, but I still could reproduce the problem with your 
> patch.

Frederic, any clue as to what makes hw breakpoints go funny and have
last_period == 0?

> > ---
> >  kernel/hw_breakpoint.c |   13 ++++++++++++-
> >  1 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> > index d71a987..f57ebee 100644
> > --- a/kernel/hw_breakpoint.c
> > +++ b/kernel/hw_breakpoint.c
> > @@ -600,9 +600,20 @@ static int __init init_hw_breakpoint(void)
> >  }
> >  core_initcall(init_hw_breakpoint);
> >  
> > +static int hw_breakpoint_enable(struct perf_event *event)
> > +{
> > +     struct hw_perf_event *hwc = &event->hw;
> > +
> > +     if (hwc->sample_period) {
> > +             hwc->last_period = hwc->sample_period;
> > +             perf_swevent_set_period(event);
> > +     }
> > +
> > +     return arch_install_hw_breakpoint(event);
> > +}
> >  
> >  struct pmu perf_ops_bp = {
> > -     .enable         = arch_install_hw_breakpoint,
> > +     .enable         = hw_breakpoint_enable,
> >       .disable        = arch_uninstall_hw_breakpoint,
> >       .read           = hw_breakpoint_pmu_read,
> >  };
> > 
> > 
