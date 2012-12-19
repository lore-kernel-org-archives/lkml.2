Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab2LSKUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:20:32 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41319 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2LSKUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:20:25 -0500
Date: Wed, 19 Dec 2012 10:19:34 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clockevents: Add generic timer broadcast
 receiver
Message-ID: <20121219101934.GD32484@e106331-lin.cambridge.arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
 <1355832418-31692-3-git-send-email-mark.rutland@arm.com>
 <50D0EB67.2060802@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <50D0EB67.2060802@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Dec 2012 10:19:34.0817 (UTC) FILETIME=[57B82910:01CDDDD2]
X-MC-Unique: 112121910193704501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:17:11PM +0000, Stephen Boyd wrote:
> On 12/18/12 04:06, Mark Rutland wrote:
> > diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> > index f113755..c2dd022 100644
> > --- a/kernel/time/tick-broadcast.c
> > +++ b/kernel/time/tick-broadcast.c
> > @@ -125,6 +125,21 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
> >  	return ret;
> >  }
> >  
> > +int tick_receive_broadcast(void)
> > +{
> > +	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
> > +	struct clock_event_device *evt = td->evtdev;
> > +
> > +	if (!evt)
> > +		return -ENODEV;
> > +
> > +	if (!evt->event_handler)
> > +		return -EINVAL;
> > +
> 
> Does this actually happen? It's not obvious to me how it does.

Taking a look at it, I don't think it does. Any tick_device's
clock_event_device should have an event_handler. I'll drop this check.

A tick device might not have a clock_event_device registered in some cases --
the x86 lapic timer has to deal with interrupts pending across a kexec, where
interrupts are enabled before local timers are registered. I'm not sure how
common this problem might be though, and whether it should be dealt with here
or elsewhere.

> > +	evt->event_handler(evt);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Broadcast the event to the cpus, which are set in the mask (mangled).
> >   */
> 
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 

Thanks,
Mark.

