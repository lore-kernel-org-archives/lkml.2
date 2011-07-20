Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1GTKyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:54:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1GTKyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:54:08 -0400
Message-ID: <4E26B721.9020103@steinhoff.de>
Date: Wed, 20 Jul 2011 13:08:17 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Carsten Emde <ce@ceag.ch>, Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [ANNOUNCE] 3.0-rc7-rt0
References: <alpine.LFD.2.02.1107200153070.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107200153070.2702@ionos>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:OS8+GVna/2loMdZLfTXVDtoM+R6WWV4nWO4gLEeH2Az
 BduBp4mNBIjO9bBlYZ5LvOGRO7jDJ6Zw6yzHnG99xo367TzwQd
 kPm9MOrG0Ar3wdTl1HOkoAwWhF9FGLB38SyEouJJpJEMqFBxU9
 qzKHAHwE+wr7jYvZOhyRV4qirbvlQkCn4dzu3YiUQ+uNMrR4os
 c7kwSYgnIAJdTtGcLAihw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas,

congratulations !

The results are really amazing !!

https://www.osadl.org/Latency-plot-of-system-in-rack-4-slot.qa-latencyplot-r4s6.0.html?latencies=&showno=&slider=57

--Armin



Thomas Gleixner wrote:
> Dear RT Folks,
>
> I'm pleased to announce the first drop of the 3.0-rc7 based RT
> patch.
>
> It's been quite a while since 2.6.33-rt, but I went through a very
> painful experience while trying to get a 2.6.38-rt stabilized. The
> beast insisted on destroying filesystems with reproduction times
> measured in days and the total refusal to reveal at least a
> minimalistic hint to debug the root cause. Staring into completely
> useless traces for months is not a very pleasant pastime.
>
> That's the very first problem in the RT history which I gave up on.
>
> [The truth: Linus avoiding the final 2.6.42 release made all my
>   ultimate plans go down the drain ... ]
>
> Though while trying to analyse the problem I had plenty of time to
> twist my brain around the existing RT approach and its shortcomings.
>
> The main issue which RT is fighting with is the ever growing per cpu
> variable usage and the assumptions which are built around it. The
> existing RT approach to work around this with PER_CPU_LOCKED
> constructs and hand the CPU number around simply does not work anymore
> because the number of sites which need to be patched is way too large
> and the resulting mess in the code is neither acceptable nor
> maintainable.
>
> After lenghty and fruitful discussions with Peter Zijlstra - thanks a
> lot Peter! - we finally agreed on trying a totally different approach
> to tackle these issues: disabling migration over spinlock and get_cpu
> sections. This had been discussed before, but nobody ever considered
> to sit down and make it work.
>
> This keeps the semantics which are expected by the per cpu users,
> while keeping the regions preemptible. As a side effect, it allows us
> to run softirq handlers directly from irq threads on local_bh_enable
> which was a long desired feature to lower the performance impact of
> RT.
>
> Changing this required a major refactoring of the RT patch queue,
> which took some time as I had to go through every single patch, fold
> fixes back into the right places and sort them into various categories:
>
>   - Mainline ready (raw lock annotations, infrastructure patches, code
>     restructuring...)
>
>   - Preparatory (_rt()/_nort() variants of preempt_*(), local_irq_*(),
>     BUG*(), WARN*() and the annotations in various places)
>
>   - Base patches (Reworking the slab/page_alloc code, bit_spinlock
>     replacements, migrate disable infrastructure ...)
>
>   - Full RT patches (sleeping spinlocks and the resulting fixups here
>     and there)
>
> In course of that exercise I weeded out a lot of historically grown
> hackery and dropped stuff which was not essential for getting it up
> and running. Thanks to Carsten for reintegrating the tracer addons
> which he's using for the OSADL test farm:
>
>    https://www.osadl.org/?id=1042
>
> I probably have missed a few bits and pieces, but the overall outcome
> is stable and survived testing on various systems. The latency
> behaviour with cyclictest is on par with 33-rt at least on x86_64/32.
>
> The overall patch size has shrunk significantly and the readability
> (except for the missing changelogs in various patches) is at an
> acceptable level.
>
> If you download the quilt tarball, you'll find various sections:
>
> - upstream fixes: Stuff broken upstream which we managed to trip
>    over. This section contains real weird stuff from simple fixes, over
>    mainline code which claims to contain (complete bogus) RT support up
>    to an archaeologic bug in the floppy driver code.
>
>    8 patches (size 8892)
>    7 files changed, 59 insertions(+), 51 deletions(-)
>
> - upstream submitted: Stuff which is on LKML already and needs some
>    follow up.
>
>    4 patches (size 9741)
>    4 files changed, 81 insertions(+), 119 deletions(-)
>
> - upstream ready: Stuff which needs a bit polishing and upstream
>    submission
>
>    79 patches (size 232566)
>    192 files changed, 1204 insertions(+), 1097 deletions(-)
>
> - upstream needs work: Stuff which should go upstream, but needs some
>    or lots of care.
>
>    7 patches (size 164120)
>    49 files changed, 3292 insertions(+), 253 deletions(-)
>
> - the real rt stuff:
>
>    125 patches (size 280665)
>    162 files changed, 4327 insertions(+), 592 deletions(-)
>
> The overall patch is now:
>    223 patches (size 680054)
>    374 files changed, 8950 insertions(+), 2099 deletions(-)
>
> Compared that to 2.6.33-rt:
>    462 patches (size 1396505)
>    690 files changed, 15994 insertions(+), 5123 deletions(-)
>
> That's a significant reduction in size and impact. Some of it is due
> to the new approach, but we also got quite a lot of the infrastructure
> patches upstream in the last few kernel releases. Thanks to all folks
> who have helped to get that done, especially to Peter Zijlstra for
> getting the preemptible mmu gather problem and lots of the scheduler
> issues which we discovered in RT over time sorted out!!!
>
> What's new in 3.0-rt ?
>
>   - No more split soft interrupt threads. We need to analyze whether
>     this is a good decision.
>
>   - softirq handling from the end of interrupt threads and on all
>     thread sites where a nested local_bh disabled section ends
>
>   - SPARSE interrupts and IOMMU interrupt remapping work now
>
>   - Split config option CONFIG_PREEMPT_RT into CONFIG_PREEMPT_RT_BASE
>     and CONFIG_PREEMPT_RT_FULL. RT_BASE covers some of the more complex
>     changes (e.g. mm/* where we substitute interrupt disabled sections
>     with per cpu locks and the bit_spinlock to spinlock conversion).
>     RT_BASE allows us to test and verify these changes independently of
>     the big RT_FULL modifications. That's mainly a debugability and
>     maintainability issue.
>
> What's the state:
>
>     We've done quite some testing on x86 32/64 bit and basic tests on
>     some ARM/MIPS/POWERPC platforms. Thank God, no file system eating so
>     far :)
>
>     Given the fact that it is a major rewrite it's amazinlgy stable and
>     I consider it to be the best -rt1 release we ever had. That doesn't
>     mean that there are no bugs, since it has not had the proper test
>     coverage yet.
>
>     Thanks to Carsten, Clark and Peter for all the help to get this far!
>
> Want to help?
>
>     Many people offered help in the past and I had to turn them down so
>     far as refactoring that stuff really is not a task which can be
>     shared easily. Though now is the point where I can use all the help
>     you promised to provide.
>
>     What's needed?
>
>     - Testing, testing, testing ... you know the drill (good bug
>       reports are 98% of the solution)
>
>     - Compare and analyze the performance/troughput impact of the new
>       approach with 33-rt
>
>     - Help mainlining the "upstream ready section"
>
>       That means reviewing the patches, cleaning them up, fixing the
>       changelogs, submitting them through the proper channels ...
>
>       Please do not blindly pick any of these patches and submit them
>       to mailing lists w/o doing the above. Also please coordinate on
>       the #linux-rt IRC channel on oftc.net so redundant and
>       conflicting work can be avoided
>
>     - Help getting the "upstream needs work" section into shape
>
>       All of these patches need a close look and (especially the
>       hwlatency detector) major cleanups. Please coordinate with the
>       patch authors and lookout for previous discussions of some of
>       those on LKML.
>
>     - Tend to the FIXME annotations in the RT stuff section
>
>       I have annotated some places with /* FIXME ... comments. These
>       sections are not for the faint hearted and need some serious
>       review and thought.
>
>     - Help with the RCU modifications
>
>       That's an easy one. We have a volunteer signed up for this
>       involuntarily already. Thanks Paul!
>
>     - Twist your brain around the schedulability impact of the
>       migrate_disable() approach.
>
>       A really interesting research topic for our friends from the
>       academic universe. Relevant and conclusive (even short notice)
>       papers and/or talks on that topic have a reserved slot in the
>       Kernel developers track at the Realtime Linux Workshop in Prague
>       in October this year.
>
> Enough marketing, here comes the real stuff.
>
>    Patch against 3.0-rc7 can be found here:
>
>      http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rc7-rt0.patch.bz2
>
>    The split quilt queue is available at:
>
>      http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rc7-rt0.tar.gz
>
> There is no git tree for now.
>
> I'm not yet convinced that moving RT to git was a good idea as quilt
> allows me to move stuff around in a way more flexible manner. So for
> now no git version until someone comes up with a brilliant idea which
> allows me to keep my workflow sane (do not even try to suggest stgit&
> co!).
>
> That said, have fun and make sure that you have the fire extinguisher
> ready when you start using this!
>
> Thanks,
>
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

