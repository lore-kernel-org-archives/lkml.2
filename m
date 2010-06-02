Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0FBM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:27:24 -0400
Received: from www.tglx.de ([62.245.132.106]:41346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713Ab0FBM1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:27:22 -0400
Date: Wed, 2 Jun 2010 14:26:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8]
 Suspend block api (version 8)
In-Reply-To: <AANLkTik3zu5s8PjuZ6NdtVMKRuGIB-9CUyvA48JG8ybh@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006021355130.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org> <201006010005.19554.rjw@sisk.pl> <20100601090023.788cabf4@notabene.brown> <201006010232.20263.rjw@sisk.pl> <20100601113309.609349fd@notabene.brown> <alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
 <20100601122012.1edeaf48@notabene.brown> <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain> <20100602153235.340a7852@notabene.brown> <AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com> <20100602180614.729246ea@notabene.brown>
 <AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com> <alpine.LFD.2.00.1006021117480.2933@localhost.localdomain> <AANLkTik3zu5s8PjuZ6NdtVMKRuGIB-9CUyvA48JG8ybh@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1357201380-1275481585=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1357201380-1275481585=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 2 Jun 2010, Arve Hjønnevåg wrote:

> 2010/6/2 Thomas Gleixner <tglx@linutronix.de>:
> > On Wed, 2 Jun 2010, Arve Hjønnevåg wrote:
> >> 2010/6/2 Neil Brown <neilb@suse.de>:
> >> > There would still need to be some sort of communication between the the
> >> > suspend daemon on any event daemon to ensure that the events had been
> >> > processed.  This could be very light weight interaction.  The point though is
> >> > that with this patch it becomes possible to avoid races.  Possible is better
> >> > than impossible.
> >> >
> >>
> >> We already have a solution. I don't think rejecting our solution but
> >> merging a worse solution should be the goal.
> >
> > That's not the goal at all. We want a solution which is acceptable for
> > android and OTOH does not get into the way of other approaches.
> >
> 
> I don't actually think the suspend blocker patchset get in the way of
> anything else.
> 
> > The main problem I have is that suspend blockers are only addressing
> > one particular problem space of power management.
> >
> > We have more requirements than that, e.g. an active device transfer
> > requires to prevent the idle code to select a deep power state due to
> > latency requirements.
> >
> > So we then have to implement two mechanisms in the relevant drivers:
> >
> >   1) telling the idle code to limit latency
> >   2) telling the suspend code not to suspend
> 
> And 3) telling the idle code to not enter low power modes that disrupt
> active interrupts or clocks.
>
> Our wakelock code handles 2 and 3, but I removed support for 3 on
> request since you can hack it by specifying a latency value that you
> know the low power mode cannot support.

You are mixing concepts. 

clock domains and power domains are a separate issue which are already
handled by the run time power management code and the clock framework.

The interrupt latency is a QoS requirement and has nothing to do with
power domains and clock domains simply because I can go deeper w/o
violating the clock and power domain constraints when the latency
allows it.

> > My main interest is to limit it to one mechanism, which is QoS based
> > and let idle and suspend make the appropriate decisions based on that
> > information.
> >
> 
> We can use one mechanism for this, but we still have to specify both.
> To me this is just another naming argument and not a good reason to
> not merge the suspend blocker code. You have to modify the same

The main objection against suspend blocker is the user space interface
/ ABI issue, not the driver code which we can fix in no time. But we
cannot fix it once it is glued into a user space interface.

I don't care about adding two empty static inlines into a header file,
which allows to merge the android drivers, but I care much about
giving a guaranteed behaviour to user space.

Thanks,

	tglx
--8323328-1357201380-1275481585=:2933--
