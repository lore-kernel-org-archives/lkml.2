Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab1JETiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:38:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:34435 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233Ab1JETiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:38:09 -0400
Date: Wed, 5 Oct 2011 21:38:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for
 local apic timer
In-Reply-To: <493994B35A117E4F832F97C4719C4C040136F7CBF3@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1110052129270.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-2-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1110052045430.18778@ionos> <493994B35A117E4F832F97C4719C4C040136F7CBF3@orsmsx505.amr.corp.intel.com>
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

Please remove Zwane Mwaikambo <zwane@arm.linux.org.uk> from the cc
list, that address does not exist anymore.

> > 
> > > From: Fenghua Yu <fenghua.yu@intel.com>
> > >
> > > irq0 won't generate any interrupt after local apic timers is enabled
> > and ARAT
> > > is enabled. Disable irq0 in this case. Thus irq0 won't block BSP
> > offline.
> > 
> > Why would it do so ?

> Irq0 is set as IRQF_NOBALANCING. And it's not used any more after
> boot time if CPU using local apic timer supports ARAT. Although irq0
> is useless, it blocks CPU0 offline.

Please use proper line breaks around 78

> That's why we need to treat irq0 specially for CPU0 offline.

That's utter nonsense. Your whole approach is broken. irq0 is not
special at all and any other interrupt could be marked
IRQF_NOBALANCING as well.

Special casing stuff is always a sign of bandaids and your whole patch
set is just a big cobbled together duct tape thing.
 
> > > +
> > > +	/* irq0 won't be used any more if CPU supports ARAT feature. */
> > > +	if (cpu == 0 && this_cpu_has(X86_FEATURE_ARAT))
> > > +		disable_irq(0);
> > 
> > This is completely wrong. If we want to shut that interrupt down, then
> > we do it in the clockevents set mode functions of PIT or HPET and not
> > at some random place in the apic timer code.
> 
> Agree with you.
> 
> Or my original irq0 handling is just ignoring irq0 when ARAT is
> enabled during CPU0 offline procedure. Is this way cleaner and
> limited to CPU0 offline path? I'm afraid shutting that interrupt
> down or disabling it may cause any other (legacy) issue?

That's still wrong and your offline check code is broken beyond repair
anyway.

Thanks,

	tglx
