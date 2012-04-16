Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2DPSRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:17:55 -0400
Received: from ocelot.phlegethon.org ([81.29.64.94]:62578 "EHLO
	mail.phlegethon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2DPSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:17:54 -0400
Date: Mon, 16 Apr 2012 19:17:44 +0100
From: Tim Deegan <tim@xen.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xen.org>, Sheng Yang <sheng@yasker.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
Message-ID: <20120416181744.GF13111@ocelot.phlegethon.org>
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com> <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com> <049b7b93-fb37-4962-b272-d786e1dcfacb@default> <20120416170827.GE13111@ocelot.phlegethon.org> <3e05ae0e-afe4-4ed7-b839-39a343cc0d06@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <3e05ae0e-afe4-4ed7-b839-39a343cc0d06@default>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10:52 -0700 on 16 Apr (1334573568), Dan Magenheimer wrote:
> > From: Tim Deegan [mailto:tim@xen.org]
> > Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> > 
> > At 09:05 -0700 on 16 Apr (1334567132), Dan Magenheimer wrote:
> > > Hmmm... I spent a great deal of time on TSC support in the hypervisor
> > > 2-3 years ago.  I worked primarily on PV, but Intel supposedly was tracking
> > > everything on HVM as well.  There's most likely a bug or two still lurking
> > > but, for all guests, with the default tsc_mode, TSC is provided by Xen
> > > as an absolutely stable clock source.  If Xen determines that the underlying
> > > hardware declares that TSC is stable, guest rdtsc instructions are not trapped.
> > > If it is not, Xen emulates all guest rdtsc instructions.  After a migration or
> > > save/restore, TSC is always emulated.  The result is (ignoring possible
> > > bugs) that TSC as provided by Xen is a) monotonic; b) synchronized across
> > > CPUs; and c) constant rate.  Even across migration/save/restore.
> > 
> > AIUI, this thread is about the PV-time clock source, not about the TSC
> > itself.  Even if the TSC is emulated (or in some other way made
> > "stable") the PV wallclock is not necessarily stable across migration.
> > But since migration is controlled by the kernel, presumably the kernel
> > can DTRT about it.
> 
> Under what circumstances is PV wallclock not stable across migration?

The wallclock is host-local, so I don't think it can be guaranteed to be
strictly monotonic across migration.  But as I said that's OK because
the Xen code in the kernel is in control during migration.

> > > In fact, it might be wise for a Xen-savvy kernel to check to see
> > > if it is running on Xen-4.0+ and, if so, force clocksource=tsc
> > > and tsc=reliable.
> > 
> > That seems like overdoing it.  Certainly it's not OK unless it can also
> > check that Xen is providing a stable TSC (i.e. that tscmode==1).
> 
> Xen guarantees a stable TSC for the default (tsc_mode==0) also.
> 
> If the vm.cfg file explicitly sets a guest tsc_mode==2, you are correct
> that pvclock is still necessary.  But as the documentation says:
> tsc_mode==2 should be set if "it is certain that all apps running in this
> VM are TSC-resilient and highest performance is required".  In
> the case we are talking about, the PV guest kernel itself isn't TSC-
> resilient!

Only if we deliberately break it! :) 

> In any case, IIRC, there is a pvcpuid instruction to determine the
> tsc_mode, so when the upstream kernel checks for Xen 4.0+, it could
> also check to ensure the tsc_mode wasn't overridden and set to 2.

Yes, that's what I was suggesting.

> > In the case where the PV clock has been selected, can it not be marked
> > unstable without also marking the TSC unstable?
> 
> I'm not sure I understand...
> 
> Are you talking about the HVM case of an upstream kernel, maybe
> when the clocksource is manually overridden on the kernel command
> line or after boot with sysfs?

I'm talking about any case where the clocksource == xen.  

> If pvclock is necessary (e.g. old Xen), how would it be
> marked unstable? (I didn't know there was code to do that.)

I think I'm confused by terminology.  Maybe David can correct me.  My
understanding was that there is some concept inside linux of a time
source being 'stable', which requires it to be synchronized, monotonic
and constant-rate.  The PV clock is two of those things (within a
reasonable tolerance) but may not be monotonic over migration.  I was
suggesting that, however linux deals with that, it can probably do it
without changing its opinion of whether the TSC is stable.

If the PV clocksource works, and works in more configurations than TSC,
I don't see much advantage of deprecating it in favour of TSC.  But I
don't have any huge objection to it either, I guess, as long as it only
happens when it's safe.

And on older Xens, or for tsc_mode==2, the kernel probably ought to mark
the TSC as unstable, because it is.

Cheers,

Tim.
