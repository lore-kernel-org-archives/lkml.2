Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab2BKOHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 09:07:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab2BKOHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 09:07:48 -0500
Date: Sat, 11 Feb 2012 15:07:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Nick Bowler <nbowler@elliptictech.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
Message-ID: <20120211140737.GA26637@elte.hu>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
 <20120202193702.GA9502@elliptictech.com>
 <20120202202427.GA2234@x1.osrc.amd.com>
 <20120203191801.GA2846@x1.osrc.amd.com>
 <20120207095746.GH15359@elte.hu>
 <20120208101956.GA1772@x1.osrc.amd.com>
 <20120209080648.GI18387@elte.hu>
 <CAELBVzBAYRYWsO=PpwQhi0=_hejdLaq5Yci8uC_NT12KiFLb4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAELBVzBAYRYWsO=PpwQhi0=_hejdLaq5Yci8uC_NT12KiFLb4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> On 9 February 2012 04:06, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Borislav Petkov <bp@alien8.de> wrote:
> >
> >> +++ b/arch/x86/include/asm/smp.h
> >> @@ -33,8 +33,15 @@ static inline bool cpu_has_ht_siblings(void)
> >>
> >>  DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
> >>  DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
> >> -/* cpus sharing the last level cache: */
> >> +
> >> +#ifdef CONFIG_SMP
> >> +/* CPUs sharing the last level cache: */
> >>  DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
> >> +#else
> >> +static DECLARE_BITMAP(cpu_llc_shared_bits, NR_CPUS) __read_mostly = { [0] = 1UL };
> >> +static struct cpumask *const cpu_llc_shared_map = to_cpumask(cpu_llc_shared_bits);
> >> +#endif
> >
> > Why not just expose it like on SMP?
> >
> > We want to *reduce* the specialness of UP, not increase it - one
> > more word of .data and .text does not matter much - UP is
> > becoming more and more an oddball, rarely tested config. By the
> > time these changes hit any real boxes it will be even more
> > oddball.
> >
> 
> It seems that cpu_llc_shared_map is actually defined in 
> arch/x86/kernel/smpboot.c, which is not compiled/linked for UP 
> builds.
>  Is there an equivalent file for UP that could be used 
> instead, or could the:
> 
> DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
> 
> be moved to some other file?

Yes, it should be moved into struct cpuinfo_x86, and thus we'd 
remove cpu_llc_shared_map altogether, it would be named 
cpu->llc_shared_map or so - taking up a single bit (or maybe 
zero bits) on UP.

> Generally, it sounds like you might approve of an eventual 
> merging of the boot paths for SMP and UP.  Is that true?  I 
> wonder how much work that would be.  That would really reduce 
> the specialness of UP.

I generally approve just about any patch that works and reduces 
complexity! :-) The boot path is rather ambitious, but if you 
want to try, feel free ...

Thanks,

	Ingo
