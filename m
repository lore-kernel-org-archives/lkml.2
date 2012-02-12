Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2BLLTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 06:19:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab2BLLTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 06:19:33 -0500
Date: Sun, 12 Feb 2012 12:19:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
Message-ID: <20120212111914.GC21493@elte.hu>
References: <20120211140737.GA26637@elte.hu>
 <1329006252-1684-1-git-send-email-kjwinchester@gmail.com>
 <CAELBVzD8eZuxO0KLvZp8VuucoPxBNVsojO1NhC-pvr78Mg1v+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAELBVzD8eZuxO0KLvZp8VuucoPxBNVsojO1NhC-pvr78Mg1v+w@mail.gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> On 11 February 2012 20:24, Kevin Winchester <kjwinchester@gmail.com> wrote:
> > Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> > 'struct cpuinfo_x86'") caused the compilation error:
> >
> > mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
> >
> > by removing an #ifdef CONFIG_SMP around a block containing a reference
> > to cpu_llc_shared_map.  Rather than replace the #ifdef, move
> > cpu_llc_shared_map to be a new field llc_shared_map in struct
> > cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
> >
> > Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> > ---
> >  arch/x86/include/asm/processor.h      |    1 +
> >  arch/x86/include/asm/smp.h            |    6 ------
> >  arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
> >  arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 ++++---
> >  arch/x86/kernel/smpboot.c             |   15 ++++++---------
> >  arch/x86/xen/smp.c                    |    1 -
> >  6 files changed, 13 insertions(+), 21 deletions(-)
> >
> >
> >  static void impress_friends(void)
> > @@ -1053,7 +1051,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
> >        for_each_possible_cpu(i) {
> >                zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> >                zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> > -               zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
> >        }
> >        set_cpu_sibling_map(0);
> >
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 041d4fe..a898ed5 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -225,7 +225,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
> >        for_each_possible_cpu(i) {
> >                zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> >                zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> > -               zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
> >        }
> >        set_cpu_sibling_map(0);
> >
> 
> I just realized that I took out a couple of allocations here 
> for cpu_llc_shared_map, without replacing them.  Am I leaving 
> cpuinfo_x86.llc_shared_map unallocated then, and just writing 
> to whatever address that field happened to get?

That will probably crash CONFIG_CPUMASK_OFFSTACK=y kernels.

The simplest approach would be to use a cpumask_t (i.e. not a 
variable cpumask_var_t one), on the [valid looking] assumption 
that cpuinfo_x86 gets allocated in sane ways - i.e. never on the 
kernel stack and such.

The before/after vmlinux 'size' result should be inspected, with 
NR_CPUs set to 4096 and OFFSTACK activated in the .config, to 
see how bad the size effect is - but I think it should not be 
too bad.

Thanks,

	Ingo
