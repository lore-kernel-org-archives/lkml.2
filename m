Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2EJPlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:41:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24808 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2EJPlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:41:22 -0400
Date: Thu, 10 May 2012 11:34:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Garrett-Glaser <jason@x264.com>
Cc: xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86 fixes for 3.3 impacting distros (v1).
Message-ID: <20120510153457.GB6389@phenom.dumpdata.com>
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
 <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 06:53:35PM -0800, Jason Garrett-Glaser wrote:
> On Fri, Feb 10, 2012 at 7:34 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > The attached patch fixes RH BZ #742032, #787403, and #745574
> > and touch x86 subsystem.
> >
> > The patch description gives a very good overview of the problem and
> > one solution. The one solution it chooses is not the most architecturally
> > sound but it does not cause performance degradation. If this your
> > first time reading this, please read the patch first and then come back to
> > this cover letter as I've some perf numbers and more detailed explanation here.
> >
> > A bit of overview of the __page_change_attr_set_clr:
> >
> > Its purpose is to change page attributes from one type to another.
> > It is important to understand that the entrance that code:
> > __page_change_attr_set_clr is guarded by cpa_lock spin-lock - which makes
> > that whole code be single threaded.
> >
> > Albeit it seems that if debug mode is turned on, it can run in parallel. The
> > effect of using the posted patch is that __page_change_attr_set_clr() will be
> > affected when we change caching attributes on 4KB pages and/or the NX flag.
> >
> > The execution of __page_change_attr_set_clr is concentrated in
> > (looked for ioremap_* and set_pages_*):
> >  - during bootup ("Write protecting the ..")
> >  - suspend/resume and graphic adapters evicting their buffers from the card
> >   to RAM (which is usually done during suspend but can be done via the
> >   'evict' attribute in debugfs)
> >  - when setting the memory for the cursor (AGP cards using i8xx chipset) -
> >   done during bootup and startup of Xserver.
> >  - setting up memory for Intel GTT scratch (i9xx) page (done during bootup)
> >  - payload (purgatory code) for kexec (done during kexec -l).
> >  - ioremap_* during PCI devices load - InfiniBand and video cards like to use
> >   ioremap_wc.
> >  - Intel, radeon, nouveau running into memory pressure and evicting pages from
> >   their GEM/TTM pool (once an hour or so if compiling a lot with only 4GB).
> >
> > These are the cases I found when running on baremetal (and Xen) using a normal
> > Fedora Core 16 distro.
> >
> > The alternate solution to the problem I am trying to solve, which is much
> > more architecturally sound (but has some perf disadvantages) is to wrap
> > the pte_flags with paravirt call everywhere. For that these patches two patches:
> > http://darnok.org/results/baseline_pte_flags_pte_attrs/0001-x86-paravirt-xen-Introduce-pte_flags.patch
> > http://darnok.org/results/baseline_pte_flags_pte_attrs/0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch
> >
> > make the pte_flags function (after bootup and patching with alternative asm)
> > look as so:
> >
> >   48 89 f8                     mov    %rdi,%rax
> >   66 66 66 90                  data32 data32 xchg %ax,%ax
> >
> > [the 66 66 .. is 'nop']. Looks good right? Well, it does work very well on Intel
> > (used an i3 2100), but on AMD A8-3850 it hits a performance wall - that I found out
> > is a result of CONFIG_FUNCTION_TRACER (too many nops??) being compiled in (but the tracer
> > is set to the default 'nop'). If I disable that specific config option the numbers
> > are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled) on the AMD box.
> > Interestingly enough I only see these on AMD machines - not on the Intel ones.
> 
> The AMD software optimization manual says that -- at least on some
> chips -- too many prefixes forces the instruction decoder into a slow
> mode (basically microcoded) where it takes literally dozens of cycles
> for a single instruction.  I believe more than 2 prefixes will do
> this; check the manual itself for specifics.

I've been digging in to this during my "free" time to figure out what
is going on. Sadly, haven't progressed much besides writting a set of patches
that would add the 'notrace' to the pvops calls and playing with
those patches.

In other words - still not sure what is happening.
> 
> Jason
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
