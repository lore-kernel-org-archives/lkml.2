Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab0HaPVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:21:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51535 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab0HaPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HeFeGPgvH9cCceEJscmEFnz+j5GWIW3kZh4BWRKZ/2Avqmkb9P+QoUxidhtVVk/J6e
         LOb9PHTMW6io9ixzB3cW3p3/VxHXpRgOyyFCJK5FUNKCBh4Wh1hfceMtLVBbPtdZYSJS
         igUehQhDA55tQuNyJ70L6jEITHkvWKzya2EtU=
Date: Tue, 31 Aug 2010 17:21:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 1/5] perf: Check if we should exclude idle thread
	in perf_exclude_event()
Message-ID: <20100831152132.GD5259@nowhere>
References: <cover.1283123521.git.matt@console-pimps.org> <72c0ed93ff0b24365cc4d0a40e24efa3be3fe3df.1283123521.git.matt@console-pimps.org> <20100831145405.GB5259@nowhere> <20100831152012.GC27532@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831152012.GC27532@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 04:20:12PM +0100, Matt Fleming wrote:
> On Tue, Aug 31, 2010 at 04:54:07PM +0200, Frederic Weisbecker wrote:
> > On Mon, Aug 30, 2010 at 01:13:43PM +0100, Matt Fleming wrote:
> > > Don't open code the event check for excluding the idle thread. Instead
> > > include the check in perf_exclude_event().
> > > 
> > > Signed-off-by: Matt Fleming <matt@console-pimps.org>
> > > ---
> > >  kernel/perf_event.c |    8 +++++---
> > >  1 files changed, 5 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > > index 0d38f27..16b0476 100644
> > > --- a/kernel/perf_event.c
> > > +++ b/kernel/perf_event.c
> > > @@ -4310,6 +4310,9 @@ static int perf_exclude_event(struct perf_event *event,
> > >  
> > >  		if (event->attr.exclude_kernel && !user_mode(regs))
> > >  			return 1;
> > > +
> > > +		if (event->attr.exclude_idle && current->pid == 0)
> > > +			return 1;
> > 
> > 
> > 
> > Right.
> > 
> > But one of the problems people have reported is that they can miss
> > interrupts samples if they happen in idle. Hence we have decided
> > that exclude_idle should exclude events that happen in idle process
> > context but not in interrupts interrupting idle.
> > 
> > So adding an in_interrupt() check would perhaps be better.
> > 
> > I plan to do this exclusion using the per context exclusion, which is
> > a patchset I have in queue. But until then, having this patch is better.
> > 
> > 
> > 
> > >  	}
> > >  
> > >  	return 0;
> > > @@ -4512,9 +4515,8 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
> > >  	regs = get_irq_regs();
> > >  
> > >  	if (regs && !perf_exclude_event(event, regs)) {
> > > -		if (!(event->attr.exclude_idle && current->pid == 0))
> > > -			if (perf_event_overflow(event, 0, &data, regs))
> > > -				ret = HRTIMER_NORESTART;
> > > +		if (perf_event_overflow(event, 0, &data, regs))
> > > +			ret = HRTIMER_NORESTART;
> > 
> > 
> > 
> > But yeah if we add an in_interrupt() check in perf_exclude_event(), it
> > won't work here. This one needs to check if irqs are nesting :)
> > 
> > Bah, checking we interrupted softirqs is probably enough. I guess we
> > don't care about nesting hardirqs.
> 
> This patch isn't really worth it on its own, I only grouped the idle
> check into perf_exclude_event() because patch 3/5 introduced a new
> caller. As you've said, the semantics at the various callsites are
> quite complex. It's probably best to wait for your patchset :)


Ok :)

