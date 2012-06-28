Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2F1Og6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:36:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34378 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2F1Og4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:36:56 -0400
Date: Thu, 28 Jun 2012 10:28:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: cyclonusj@gmail.com, marmarek@invisiblethingslab.com, hpa@zytor.com
Cc: xen-devel@lists.xensource.com, x86@kernel.org,
        Jason Garrett-Glaser <jason@x264.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86 fixes for 3.3 impacting distros (v1).
Message-ID: <20120628142836.GE8956@phenom.dumpdata.com>
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
 <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com>
 <20120510153457.GB6389@phenom.dumpdata.com>
 <20120627231755.GA1021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120627231755.GA1021@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 04:17:56PM -0700, Cyclonus J wrote:
> On Thu, May 10, 2012 at 11:34:57AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Feb 21, 2012 at 06:53:35PM -0800, Jason Garrett-Glaser wrote:
> > > On Fri, Feb 10, 2012 at 7:34 AM, Konrad Rzeszutek Wilk
> > > <konrad.wilk@oracle.com> wrote:
> > > > The attached patch fixes RH BZ #742032, #787403, and #745574
> > > > and touch x86 subsystem.
> > > >
> > > > The patch description gives a very good overview of the problem and
> > > > one solution. The one solution it chooses is not the most architecturally
> > > > sound but it does not cause performance degradation. If this your
> > > > first time reading this, please read the patch first and then come back to
> > > > this cover letter as I've some perf numbers and more detailed explanation here.
> > > >
> > > > A bit of overview of the __page_change_attr_set_clr:
> > > >
> > > > Its purpose is to change page attributes from one type to another.
> > > > It is important to understand that the entrance that code:
> > > > __page_change_attr_set_clr is guarded by cpa_lock spin-lock - which makes
> > > > that whole code be single threaded.
> > > >
> > > > Albeit it seems that if debug mode is turned on, it can run in parallel. The
> > > > effect of using the posted patch is that __page_change_attr_set_clr() will be
> > > > affected when we change caching attributes on 4KB pages and/or the NX flag.
> > > >
> > > > The execution of __page_change_attr_set_clr is concentrated in
> > > > (looked for ioremap_* and set_pages_*):
> > > >  - during bootup ("Write protecting the ..")
> > > >  - suspend/resume and graphic adapters evicting their buffers from the card
> > > >   to RAM (which is usually done during suspend but can be done via the
> > > >   'evict' attribute in debugfs)
> > > >  - when setting the memory for the cursor (AGP cards using i8xx chipset) -
> > > >   done during bootup and startup of Xserver.
> > > >  - setting up memory for Intel GTT scratch (i9xx) page (done during bootup)
> > > >  - payload (purgatory code) for kexec (done during kexec -l).
> > > >  - ioremap_* during PCI devices load - InfiniBand and video cards like to use
> > > >   ioremap_wc.
> > > >  - Intel, radeon, nouveau running into memory pressure and evicting pages from
> > > >   their GEM/TTM pool (once an hour or so if compiling a lot with only 4GB).
> > > >
> > > > These are the cases I found when running on baremetal (and Xen) using a normal
> > > > Fedora Core 16 distro.
> > > >
> > > > The alternate solution to the problem I am trying to solve, which is much
> > > > more architecturally sound (but has some perf disadvantages) is to wrap
> > > > the pte_flags with paravirt call everywhere. For that these patches two patches:
> > > > http://darnok.org/results/baseline_pte_flags_pte_attrs/0001-x86-paravirt-xen-Introduce-pte_flags.patch
> > > > http://darnok.org/results/baseline_pte_flags_pte_attrs/0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch
> > > >
> > > > make the pte_flags function (after bootup and patching with alternative asm)
> > > > look as so:
> > > >
> > > >   48 89 f8                     mov    %rdi,%rax
> > > >   66 66 66 90                  data32 data32 xchg %ax,%ax
> > > >
> > > > [the 66 66 .. is 'nop']. Looks good right? Well, it does work very well on Intel
> > > > (used an i3 2100), but on AMD A8-3850 it hits a performance wall - that I found out
> > > > is a result of CONFIG_FUNCTION_TRACER (too many nops??) being compiled in (but the tracer
> > > > is set to the default 'nop'). If I disable that specific config option the numbers
> > > > are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled) on the AMD box.
> > > > Interestingly enough I only see these on AMD machines - not on the Intel ones.
> > > 
> > > The AMD software optimization manual says that -- at least on some
> > > chips -- too many prefixes forces the instruction decoder into a slow
> > > mode (basically microcoded) where it takes literally dozens of cycles
> > > for a single instruction.  I believe more than 2 prefixes will do
> > > this; check the manual itself for specifics.
> > 
> > I've been digging in to this during my "free" time to figure out what
> > is going on. Sadly, haven't progressed much besides writting a set of patches
> > that would add the 'notrace' to the pvops calls and playing with
> > those patches.
> > 
> > In other words - still not sure what is happening.
> 
> I would like to spend some time looking into this issue as it blocks my
> project in some cases.

Ah, somebody else pinged me about this too. Let me CC them here.
> 
> I saw a temporary fix 8eaffa67b43e99ae581622c5133e20b0f48bcef1 went into 3.3 to disable
> PAT support on dom0. May I ask what would be the recommended fix to support PAT on dom0? 
> Will it be a possible solution to make Xen use the same PAT settings as Linux? Sorry, I don't 
> know the background why Xen is doing this differently.
> 
> Suggestions?

You could use those two patches I mentioned in the thread and revert the temporary fix.
That should get PAT support working - but .. that would be for your own tree
and wouldn't be in mainline.

The issues I had - with the CONFIG_FUNCTION_TRACER, I hadn't had a chance to dig
deeper in it. I would recommend for you to tree a simple test-case (I used kernelbench)
to see if the patches cause a regression or not on baremetal.

Make sure to start the kernel in high CPU frequency (meaning the performance governor)
otherwise your results could be skewed.

Peter mentioned to me had some ideas about software PAT table lookup. I am not
exactly sure what he meant by that.

Just to summarize, there were two ways proposed to fix this:

 1). Make __page_change_attr_set_clr use a new wrapper: pte_attr, that calls
     pte_val (pvops call) instead of pte_flag (native). Here is the patch:
     http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commitdiff;h=4f93aa02acd0e34806d4ac9c3a700bb5d040eab6
     (no perf regressions across all platforms)

 2). Introduce a new pvops call - pte_flags, which would make pte_flags
     (which currently is doing just a bit mask) be pvops-fied.
     http://darnok.org/results/baseline_pte_flags_pte_attrs/0001-x86-paravirt-xen-Introduce-pte_flags.patch
     http://darnok.org/results/baseline_pte_flags_pte_attrs/0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch
     (weird results on AMD, other platforms had no perf degradations)

  3). (not posted), was to do 2), but alter the alternative_asm and instead use asm_goto to
     make the compiler use less registers and hopefully reduce the code:
     http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/devel/mmu-perf
     But the results I got showed worst performance on baremetal.. which was weird?
     Perhaps it is compiler related - never got to follow up on it.


I also chatted with the core Xen hypervisor folks about adding in the context switch code
to alter the PAT layout - but they were not keen a about it - and I am not sure how much
CPU cycles one loses by doing a wrmsr to the PAT register on every guest context switch
(worst case when on has a pvops kernel and a old-style one - where the WC bit would differ)?


