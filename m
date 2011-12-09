Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1LIHYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:24:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55783 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1LIHYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:24:34 -0500
Date: Fri, 9 Dec 2011 08:22:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Steffen Persvold <sp@numascale.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
Message-ID: <20111209072244.GG24537@elte.hu>
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com>
 <tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org>
 <20111205203130.GA12364@elte.hu>
 <4EDD5D77.3030101@numascale.com>
 <20111206055023.GB1580@elte.hu>
 <CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
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

> On 6 December 2011 01:50, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Steffen Persvold <sp@numascale.com> wrote:
> >
> >> On 12/5/2011 21:31, Ingo Molnar wrote:
> >> []
> >> > There's a new build failure caused by this commit:
> >>
> >> It's this commit actually :
> >>
> >> Commit-ID:  64be4c1c2428e148de6081af235e2418e6a66dda
> >> Gitweb:     http://git.kernel.org/tip/64be4c1c2428e148de6081af235e2418e6a66dda
> >> Author:     Daniel J Blueman <daniel@numascale-asia.com>
> >> AuthorDate: Mon, 5 Dec 2011 16:20:37 +0800
> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Mon, 5 Dec 2011 17:17:21 +0100
> >>
> >> x86: Add x86_init platform override to fix up NUMA core numbering
> >>
> >> >
> >> >   arch/x86/kernel/cpu/common.c:1149:2: error: ‘struct cpuinfo_x86’ has no member named ‘phys_proc_id’
> >> >
> >> > Note that the config is a !SMP one - that's probably the key
> >> > detail.
> >>
> >> Yes, phys_proc_id in struct cpuinfo_x86 is covered within "ifdef CONFIG_SMP".
> >>
> >> >
> >> > Please send a delta fix that resolves this bug. You can find the
> >> > current lineup in:
> >> >
> >> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> >> >
> >>
> >> Will do, should be fairly simple. Something in the lines of the attached should work (tested).
> >>
> >> Note: I used "ifdef CONFIG_NUMA" simply because it doesn't make sense in a non-numa configuration even with SMP enabled. Besides, the only place where it is called right now is in kernel/cpu/amd.c:srat_detect_node() within the "CONFIG_NUMA" protected part.
> >>
> >> Cheers,
> >> --
> >> Steffen Persvold, Chief Architect NumaChip
> >> Numascale AS - www.numascale.com
> >> Tel: +47 92 49 25 54 Skype: spersvold
> >
> >> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> >> index ad4da45..a70bd5b 100644
> >> --- a/arch/x86/kernel/cpu/common.c
> >> +++ b/arch/x86/kernel/cpu/common.c
> >> @@ -1146,7 +1146,9 @@ static void dbg_restore_debug_regs(void)
> >>   */
> >>  void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
> >>  {
> >> +#ifdef CONFIG_NUMA
> >>       pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
> >> +#endif
> >>  }
> >
> > Yep, this should do the trick - i'll need a Signed-off-by line
> > to apply it.
> >
> > Ideally i think c->phys_proc_id should should be available
> > regardless of CONFIG_SMP or CONFIG_NUMA considerations - but
> > that would be a wider change. (feel free to have a shot at it
> > though, in addition to the fix above)
> >
> 
> If Steffen does not plan to do this additional cleanup, I 
> would give it a try.  You would likely prefer the changes 
> against -tip, correct?

On a second thought, the !SMP block in processor.h::cpuinfo_x86 
is pretty self-contained and making it unconditional would 
increase UP kernel size by 4x5==20 bytes.

I have not checked how many further simplifications this allows 
- if it's a really nice cleanup then i guess we could do it and 
keep the all-zeroes-and-ones default value on UP.

The fields *do* make sense on UP as well.

So it's a "try and see how it ends up" thing.

Thanks,

	Ingo
