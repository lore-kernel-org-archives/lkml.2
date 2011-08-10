Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1HJQqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:46:33 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:48779 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1HJQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:46:32 -0400
X-Greylist: delayed 1608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 12:46:31 EDT
Date: Wed, 10 Aug 2011 09:19:24 -0700
From: Brad Boyer <flar@cynthia.pants.nu>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
Message-ID: <20110810161924.GA26257@cynthia.pants.nu>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
 <alpine.OSX.2.00.1106011300550.199@ibook.intranet>
 <20110605062702.GA2034@cynthia.pants.nu>
 <CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com>
 <alpine.OSX.2.00.1108102007430.203@ibook.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1108102007430.203@ibook.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 08:53:16PM +1000, Finn Thain wrote:
> On Wed, 10 Aug 2011, Geert Uytterhoeven wrote:
> > While looking into optimizing interrupts using chain handlers (which 
> > cannot be shared), I noticed several of these cascades are hung on the 
> > same interrupt. Hence we cannot use the optimization of chain handlers 
> > for them.
> > 
> > Knowing which are mutually exclusive helps a lot, but my Mac knowledge 
> > is very limited.

The only simple rules are that OSS only exists on one model, the Mac IIfx,
the PSC only exists on two (three, sort of) models: the Quadra 660AV
(which is also the Centris 660AV) and the Quadra 840AV, and the Baboon
only exists on one m68k model, the Powerbook 190 (it also exists on the
PowerBook 5300, but that is ppc).

What's messy is VIA2/RBV, which gets very complicated. The only simple
thing there is that the Mac IIfx doesn't have any of that because it
has OSS instead.

> > I derived from the code this list of cascade handlers and the interrupts 
> > they use:
> > 
> > baboon_irq
> >     IRQ_NUBUS_C
> > 
> > oss_irq
> >     OSS_IRQLEV_SCSI = IRQ_AUTO_2                conflict: via2_irq
> >     OSS_IRQLEV_SOUND = IRQ_AUTO_5               conflict: psc_irq
> 
> PSC and OSS are mutually exclusive.
> 
> VIA2 and OSS are also mutually exlusive.
> 
> > 
> > oss_nubus_irq
> >     OSS_IRQLEV_NUBUS = IRQ_AUTO_3               conflict: psc_irq
> > 
> > psc_irq
> >     IRQ_AUTO_3                                  conflict: oss_nubus_irq
> >     IRQ_AUTO_4
> >     IRQ_AUTO_5                                  conflict: oss_irq
> >     IRQ_AUTO_6                                  conflict: via1_irq
> > 
> > via1_irq
> >     OSS_IRQLEV_VIA1 = IRQ_AUTO_6 (on oss)       conflict: psc_irq
> > 
> >     IRQ_AUTO_1                                  conflict: iop_ism_irq
> 
> iop_ism_irq is only used with OSS.

Not strictly true, but it's mapped onto IRQ_VIA2_0 in the other case.

> 
> >     IRQ_AUTO_6 (if via_alt_mapping)             conflict: psc_irq
> 
> via_alt_mapping is not used with PSC.
> 
> > 
> > via2_irq
> >     IRQ_AUTO_2                                  conflict: oss_irq
> > 
> > via_nubus_irq
> >     IRQ_MAC_NUBUS = IRQ_VIA2_1
> > 
> > These are other interrupts using in the Mac core code, which may use the same
> > interrupts as some of the cascades above:
> > 
> > iop_ism_irq
> >     OSS_IRQLEV_IOPISM = 1 = IRQ_AUTO_1 (on oss) conflict: via1_irq
> 
> via1_irq is remapped to IRQ_AUTO_6 on OSS.
> 
> >     IRQ_VIA2_0 (on !oss)
> > 
> > mac_nmi_handler
> >     IRQ_AUTO_7
> > 
> > timer handler
> >     IRQ_MAC_TIMER_1 = IRQ_VIA1_6
> > 
> > So baboon and PSC are mutually exclusive? But they don't conflict w.r.t. to
> > interrupt lines anyway, so they're not an issue.
> > 
> > From the code, OSS and VIA are also mutually exclusive (except for via1_irq)?
> > 
> > But PSC can coexist with OSS? That's where most of the conflicts are.
> 
> Hope this helps...

More help is always good. Hope I've been helpful as well.

	Brad Boyer
	flar@allandria.com

