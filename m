Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682Ab1JETMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:12:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:35616 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934227Ab1JETMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60262829"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 5 Oct 2011 12:12:04 -0700
Subject: RE: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for
 local apic timer
Thread-Topic: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for
 local apic timer
Thread-Index: AcyDj02PVzuOKSdqQqaApvvnXYluAgAAD8dA
Message-ID: <493994B35A117E4F832F97C4719C4C040136F7CBF3@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-2-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052045430.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110052045430.18778@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > irq0 won't generate any interrupt after local apic timers is enabled
> and ARAT
> > is enabled. Disable irq0 in this case. Thus irq0 won't block BSP
> offline.
> 
> Why would it do so ?
Irq0 is set as IRQF_NOBALANCING. And it's not used any more after boot time if CPU using local apic timer supports ARAT. Although irq0 is useless, it blocks CPU0 offline.

That's why we need to treat irq0 specially for CPU0 offline.

> > +
> > +	/* irq0 won't be used any more if CPU supports ARAT feature. */
> > +	if (cpu == 0 && this_cpu_has(X86_FEATURE_ARAT))
> > +		disable_irq(0);
> 
> This is completely wrong. If we want to shut that interrupt down, then
> we do it in the clockevents set mode functions of PIT or HPET and not
> at some random place in the apic timer code.

Agree with you.

Or my original irq0 handling is just ignoring irq0 when ARAT is enabled during CPU0 offline procedure. Is this way cleaner and limited to CPU0 offline path? I'm afraid shutting that interrupt down or disabling it may cause any other (legacy) issue?

Thanks.

-Fenghua
