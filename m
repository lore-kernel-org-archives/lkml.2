Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2IKNVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:21:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:55942 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2IKNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:21:00 -0400
Date: Tue, 11 Sep 2012 15:20:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: NeilBrown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: Seeking clarity on IRQCHIP_MASK_ON_SUSPEND
In-Reply-To: <20120911094252.0e78a8f9@notabene.brown>
Message-ID: <alpine.LFD.2.02.1209111512130.7093@ionos>
References: <20120910165127.37dd07f3@notabene.brown> <alpine.LFD.2.02.1209101215300.2724@ionos> <20120911094252.0e78a8f9@notabene.brown>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, NeilBrown wrote:
> On Mon, 10 Sep 2012 12:28:35 +0200 (CEST) Thomas Gleixner
> <tglx@linutronix.de> wrote:
> > You might be looking for a different functionality. Can you explain
> > what you need?
> 
> I want as particular GPIO interrupt to be masked before entering suspend.
> I produced code to get the ->suspend() callback to perform this masking.
> Another developer (Santosh) felt that IRQCHIP_MASK_ON_SUSPEND was the
> preferred way to do this and on the surface this looks like it should be
> correct.  However it doesn't work as explained previously.
> I want a resolution to this difference of opinion that doesn't just sweep the
> issue under that carpet but provides a clear answer to this sort of issue.
> 
> My current opinion is that IRQCHIP_MASK_ON_SUSPEND should be discarded.  The
> patch which introduced it says:
> 
>     Rather than working around this in the affected interrupt chip
>     implementations we can solve this elegant in the core code itself.
>     
> It appears that the solution in core code, while elegant, is wrong.  It
> happens too late to be generally usable.  It is easy enough to handle this

Sigh. The flag was invented with the semantics to keep the current
"check for any interrupt" pending functionality alive and then mask it
right before going down, so only the designated wakeup interrupts can
wake the device. That was the result of the discussion back then and
that was what the developer wanted to achieve with his driver suspend
hackery.

> issue in the interrupt chip drivers so maybe that is the best place
> to handle it.

And have the same "keep track of wakeup interrupts" code over and over
in the drivers.
 
> The the very least I think we need a big comment saying the
> IRQCHIP_MASK_ON_SUSPEND can only be used for irqchips which can always be
> programmed, even when they are suspended from an runtime-PM perspective,
> and that those chips must handle masking in their 'suspend' callback.

Sigh, no. Either we make IRQCHIP_MASK_ON_SUSPEND into an
implementation which masks the interrupts early, if the existing users
find this acceptable or have a separate IRQCHIP_MASK_BEFORE_SUSPEND
flag.

This GPIO driver at hand is probably not the last one which requires
this and we really want to do stuff in the core code instead of having
random implementations of the same stuff all over the place.

Thanks,

	tglx
