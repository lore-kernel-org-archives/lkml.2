Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2BGJ6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:58:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab2BGJ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:58:04 -0500
Date: Tue, 7 Feb 2012 10:57:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, Nick Bowler <nbowler@elliptictech.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
Message-ID: <20120207095746.GH15359@elte.hu>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
 <20120202193702.GA9502@elliptictech.com>
 <20120202202427.GA2234@x1.osrc.amd.com>
 <20120203191801.GA2846@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203191801.GA2846@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Feb 02, 2012 at 09:24:28PM +0100, Borislav Petkov wrote:
> > > Is this feature truly irrelevant on UP systems?  I ask because I've
> > > always enabled this option on my UP AMD systems in the past...
> > 
> > No, you're right. Thanks for the suggestion. Scratch that version, I'll
> > think of a better fix.
> 
> Ok, I think I got it, pls take a look and scream if something's amiss.
> 
> @Randy: it builds fine with your randconfig and with mine default one;
> I'd appreciate if you could run it too, just in case.
> 
> Thanks.
> 
> --
> From: Borislav Petkov <bp@alien8.de>
> Date: Fri, 3 Feb 2012 18:07:54 +0100
> Subject: [PATCH] MCE, AMD: Hide smp-only code around CONFIG_SMP
> 
> 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs around code
> touching struct cpuinfo_x86 members but also caused the following build
> error with Randy's randconfigs:
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
> 
> Restore the #ifdef in threshold_create_bank() which creates symlinks on
> the non-BSP CPUs.
> 
> Cc: Kevin Winchester <kjwinchester@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Link: http://lkml.kernel.org/r/4F298A6C.6010101@xenotime.net
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 786e76a..e4eeaaf 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -528,6 +528,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
>  
>  	sprintf(name, "threshold_bank%i", bank);
>  
> +#ifdef CONFIG_SMP
>  	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
>  		i = cpumask_first(cpu_llc_shared_mask(cpu));

Could we please just define an obvious cpu_llc_shared_mask on UP 
(one bit long and set to 1) and not reintroduce the ugly
#ifdef CONFIG_SMP?

Thanks,

	Ingo
