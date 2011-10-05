Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935261Ab1JETyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:54:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:21832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934819Ab1JETyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:54:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="59378281"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 5 Oct 2011 12:53:17 -0700
Subject: RE: [PATCH 3/8] x86, i387.c: thread xstate is initialized only on
 BSP once
Thread-Topic: [PATCH 3/8] x86, i387.c: thread xstate is initialized only on
 BSP once
Thread-Index: AcyDj6SpfOcWmSK6QnSBfBjtSsEOYwABic1Q
Message-ID: <493994B35A117E4F832F97C4719C4C040136F7CC59@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-4-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052048290.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110052048290.18778@ionos>
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

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Wednesday, October 05, 2011 11:50 AM
> To: Yu, Fenghua
> Cc: Ingo Molnar; H Peter Anvin; Zwane Mwaikambo; Luck, Tony; Mallick,
> Asit K; Siddha, Suresh B; Len Brown; linux-kernel
> Subject: Re: [PATCH 3/8] x86, i387.c: thread xstate is initialized only
> on BSP once
> 
> On Wed, 5 Oct 2011, Fenghua Yu wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > init_thread_xstate() is only called on BSP once to avoid to override
> > xstate_size.
> >
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/kernel/i387.c |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> > index 739d859..de2b48a 100644
> > --- a/arch/x86/kernel/i387.c
> > +++ b/arch/x86/kernel/i387.c
> > @@ -93,6 +93,7 @@ void __cpuinit fpu_init(void)
> >  {
> >  	unsigned long cr0;
> >  	unsigned long cr4_mask = 0;
> > +	static int once;
> >
> >  	if (cpu_has_fxsr)
> >  		cr4_mask |= X86_CR4_OSFXSR;
> > @@ -107,8 +108,14 @@ void __cpuinit fpu_init(void)
> >  		cr0 |= X86_CR0_EM;
> >  	write_cr0(cr0);
> >
> > -	if (!smp_processor_id())
> > +	/*
> > +	 * init_thread_xstate is only called on BSP once to avoid to
> override
> > +	 * xstate_size.
> > +	 */
> > +	if (!smp_processor_id() && once) {
> 
> Brilliant change. Makes sure that init_thread_xstate() is NEVER
> called. Was this crap tested at all?

Ooh, "once" should be initialized as 1.

The code passes stress test with CPU0 online/offline, though...xstate_size will be re-initialized/overriden in xstate_enable_boot_cpu() later. So not calling init_thread_xstate() doesn't cause problem in my situation (where HAVE_HWFP=1).

Anyway, this patch is wrong. I'll fix it in next version.

Thanks.

-Fenghua
