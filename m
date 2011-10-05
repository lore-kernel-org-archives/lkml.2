Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab1JEVTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:19:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:34666 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1JEVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:19:44 -0400
Date: Wed, 5 Oct 2011 23:19:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
In-Reply-To: <493994B35A117E4F832F97C4719C4C040136F7CCB1@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1110052247520.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-9-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1110052122240.18778@ionos> <493994B35A117E4F832F97C4719C4C040136F7CCB1@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Yu, Fenghua wrote:

> > -----Original Message-----
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Sent: Wednesday, October 05, 2011 12:25 PM
> > To: Yu, Fenghua
> > Cc: Ingo Molnar; H Peter Anvin; Zwane Mwaikambo; Luck, Tony; Mallick,
> > Asit K; Siddha, Suresh B; Len Brown; linux-kernel
> > Subject: Re: [PATCH 8/8] kernel/cpu.c: Define bsp_hotpluggable variable
> > 
> > On Wed, 5 Oct 2011, Fenghua Yu wrote:
> > 
> > > From: Fenghua Yu <fenghua.yu@intel.com>
> > >
> > > This gloable variable controls BSP (aka CPU0) hotplug. If set, BSP is
> > > hotpluggable. By default, it's 0. On X86, kernel option
> > bsp_hotpluggable sets
> > > the variable as 1.
> > 
> > .... and on !x86 its just pointless.
> 
> I'll change the variable to an inline function which returns bsp_hotpluggable on x86 and is empty function on !x86.
> 

Can you finally fix your mail client, please ? It want's to look like
this:

> I'll change the variable to an inline function which returns
> bsp_hotpluggable on x86 and is empty function on !x86.

No, that's wrong again. This needs to be in the arch function not in
some random sysfs file op. Someone else pointed it out to you already,
that it's racy as well.

> > 
> > I have yet to see a justification for that whole cpu0 unplugging
> > business.
> > 
> > If there is a real reason that this is desireable, then ALL cpu0
> > assumptions in arch/x86 need to be cleaned up and fixed.
> 
> I can think of two reasons for bsp offline/online:
> 
> 1. RAS needs the feature. If socket0 needs to be hotplugged for any
>    reason (any thread on socket0 is bad, shared cache issue, uncore
>    issue, etc), CPU0 is required to be offlined.

That sounds like a reasonable requirement, which should have been
mentioned in the 0/N mail to a patch series to avoid such questions.

> 2. CPU0 is symmetrical to other CPU's. There is no specific reason
>    why it shouldn't be offlined except BIOS requirements.

That's not a reason at all. And "except BIOS requirements" might be
actually a reason NOT to do that.
 
Though as this needs to be runtime enabled, I have no general
objections against doing it, but it has to be done right.

To do that proper, it needs

   - to fixup _ALL_ cpu 0 assumptions in arch/x86 and not just hacking
     around some of them

   - a proper mechanism to deal with hardware which cannot handle it
     (i.e. no IOAPIC .....)

   - proper fixups for set up but unused irqs like irq0

   - ....

Thanks,

	tglx
