Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2F0XSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 19:18:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33064 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2F0XR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 19:17:59 -0400
Date: Wed, 27 Jun 2012 16:17:56 -0700
From: Cyclonus J <cyclonusj@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jason Garrett-Glaser <jason@x264.com>, xen-devel@lists.xensource.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86 fixes for 3.3 impacting distros (v1).
Message-ID: <20120627231755.GA1021@gmail.com>
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
 <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com>
 <20120510153457.GB6389@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120510153457.GB6389@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:34:57AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Feb 21, 2012 at 06:53:35PM -0800, Jason Garrett-Glaser wrote:
> > On Fri, Feb 10, 2012 at 7:34 AM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > > The attached patch fixes RH BZ #742032, #787403, and #745574
> > > and touch x86 subsystem.
> > >
> > > The patch description gives a very good overview of the problem and
> > > one solution. The one solution it chooses is not the most architecturally
> > > sound but it does not cause performance degradation. If this your
> > > first time reading this, please read the patch first and then come back to
> > > this cover letter as I've some perf numbers and more detailed explanation here.
> > >
> > > A bit of overview of the __page_change_attr_set_clr:
> > >
> > > Its purpose is to change page attributes from one type to another.
> > > It is important to understand that the entrance that code:
> > > __page_change_attr_set_clr is guarded by cpa_lock spin-lock - which makes
> > > that whole code be single threaded.
> > >
> > > Albeit it seems that if debug mode is turned on, it can run in parallel. The
> > > effect of using the posted patch is that __page_change_attr_set_clr() will be
> > > affected when we change caching attributes on 4KB pages and/or the NX flag.
> > >
> > > The execution of __page_change_attr_set_clr is concentrated in
> > > (looked for ioremap_* and set_pages_*):
> > >  - during bootup ("Write protecting the ..")
> > >  - suspend/resume and graphic adapters evicting their buffers from the card
> > >   to RAM (which is usually done during suspend but can be done via the
> > >   'evict' attribute in debugfs)
> > >  - when setting the memory for the cursor (AGP cards using i8xx chipset) -
> > >   done during bootup and startup of Xserver.
> > >  - setting up memory for Intel GTT scratch (i9xx) page (done during bootup)
> > >  - payload (purgatory code) for kexec (done during kexec -l).
> > >  - ioremap_* during PCI devices load - InfiniBand and video cards like to use
> > >   ioremap_wc.
> > >  - Intel, radeon, nouveau running into memory pressure and evicting pages from
> > >   their GEM/TTM pool (once an hour or so if compiling a lot with only 4GB).
> > >
> > > These are the cases I found when running on baremetal (and Xen) using a normal
> > > Fedora Core 16 distro.
> > >
> > > The alternate solution to the problem I am trying to solve, which is much
> > > more architecturally sound (but has some perf disadvantages) is to wrap
> > > the pte_flags with paravirt call everywhere. For that these patches two patches:
> > > http://darnok.org/results/baseline_pte_flags_pte_attrs/0001-x86-paravirt-xen-Introduce-pte_flags.patch
> > > http://darnok.org/results/baseline_pte_flags_pte_attrs/0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch
> > >
> > > make the pte_flags function (after bootup and patching with alternative asm)
> > > look as so:
> > >
> > >   48 89 f8                     mov    %rdi,%rax
> > >   66 66 66 90                  data32 data32 xchg %ax,%ax
> > >
> > > [the 66 66 .. is 'nop']. Looks good right? Well, it does work very well on Intel
> > > (used an i3 2100), but on AMD A8-3850 it hits a performance wall - that I found out
> > > is a result of CONFIG_FUNCTION_TRACER (too many nops??) being compiled in (but the tracer
> > > is set to the default 'nop'). If I disable that specific config option the numbers
> > > are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled) on the AMD box.
> > > Interestingly enough I only see these on AMD machines - not on the Intel ones.
> > 
> > The AMD software optimization manual says that -- at least on some
> > chips -- too many prefixes forces the instruction decoder into a slow
> > mode (basically microcoded) where it takes literally dozens of cycles
> > for a single instruction.  I believe more than 2 prefixes will do
> > this; check the manual itself for specifics.
> 
> I've been digging in to this during my "free" time to figure out what
> is going on. Sadly, haven't progressed much besides writting a set of patches
> that would add the 'notrace' to the pvops calls and playing with
> those patches.
> 
> In other words - still not sure what is happening.

I would like to spend some time looking into this issue as it blocks my
project in some cases.

I saw a temporary fix 8eaffa67b43e99ae581622c5133e20b0f48bcef1 went into 3.3 to disable
PAT support on dom0. May I ask what would be the recommended fix to support PAT on dom0? 
Will it be a possible solution to make Xen use the same PAT settings as Linux? Sorry, I don't 
know the background why Xen is doing this differently.

Suggestions?

Thanks,
CJ

> > 
> > Jason
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
