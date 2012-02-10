Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2BJPiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:38:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18684 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2BJPiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:38:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rostedt@goodmis.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] x86 fixes for 3.3 impacting distros (v1).
Date: Fri, 10 Feb 2012 10:34:50 -0500
Message-Id: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F3539CC.00B6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch fixes RH BZ #742032, #787403, and #745574
and touch x86 subsystem.

The patch description gives a very good overview of the problem and
one solution. The one solution it chooses is not the most architecturally
sound but it does not cause performance degradation. If this your
first time reading this, please read the patch first and then come back to
this cover letter as I've some perf numbers and more detailed explanation here.

A bit of overview of the __page_change_attr_set_clr:

Its purpose is to change page attributes from one type to another.
It is important to understand that the entrance that code:
__page_change_attr_set_clr is guarded by cpa_lock spin-lock - which makes
that whole code be single threaded.

Albeit it seems that if debug mode is turned on, it can run in parallel. The
effect of using the posted patch is that __page_change_attr_set_clr() will be
affected when we change caching attributes on 4KB pages and/or the NX flag.

The execution of __page_change_attr_set_clr is concentrated in
(looked for ioremap_* and set_pages_*):
 - during bootup ("Write protecting the ..")
 - suspend/resume and graphic adapters evicting their buffers from the card
   to RAM (which is usually done during suspend but can be done via the
   'evict' attribute in debugfs)
 - when setting the memory for the cursor (AGP cards using i8xx chipset) -
   done during bootup and startup of Xserver.
 - setting up memory for Intel GTT scratch (i9xx) page (done during bootup)
 - payload (purgatory code) for kexec (done during kexec -l).
 - ioremap_* during PCI devices load - InfiniBand and video cards like to use
   ioremap_wc.
 - Intel, radeon, nouveau running into memory pressure and evicting pages from
   their GEM/TTM pool (once an hour or so if compiling a lot with only 4GB).

These are the cases I found when running on baremetal (and Xen) using a normal
Fedora Core 16 distro.

The alternate solution to the problem I am trying to solve, which is much
more architecturally sound (but has some perf disadvantages) is to wrap
the pte_flags with paravirt call everywhere. For that these patches two patches:
http://darnok.org/results/baseline_pte_flags_pte_attrs/0001-x86-paravirt-xen-Introduce-pte_flags.patch
http://darnok.org/results/baseline_pte_flags_pte_attrs/0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch

make the pte_flags function (after bootup and patching with alternative asm)
look as so:

   48 89 f8             	mov    %rdi,%rax
   66 66 66 90          	data32 data32 xchg %ax,%ax

[the 66 66 .. is 'nop']. Looks good right? Well, it does work very well on Intel
(used an i3 2100), but on AMD A8-3850 it hits a performance wall - that I found out
is a result of CONFIG_FUNCTION_TRACER (too many nops??) being compiled in (but the tracer
is set to the default 'nop'). If I disable that specific config option the numbers
are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled) on the AMD box.
Interestingly enough I only see these on AMD machines - not on the Intel ones.

The benchmarks (kernbench 5 times) were carried out using a Fedora Core 16 .config in
single-mode bootup with the swap disk enabled.

I ran some benchmarks (kernbench) under an i3 2100 and AMD A8-3850 and
the results are in:

https://docs.google.com/spreadsheet/ccc?key=0Aj5ukWh4htwMdHBOaUJzckRrNTdtN0FZcm5pLXNCbWc
and
https://docs.google.com/spreadsheet/ccc?key=0Aj5ukWh4htwMdDJLRTZGbDB0S0Eta0FHd0lkZThOM0E

respectively (all aggregated with raw data and pictures is in
http://darnok.org/results/baseline_pte_flags_pte_attrs/)

The interesting thing is that on Intel i3 2100 it does not matter which solution
is chosen - just to make sure I also ran it on 32 logical CPU SandyBridge beast and it just
breezed through this with no trouble. On AMD A8-3850 it stumbles when using the non-posted
version - wrapping the pte_flags with paravirt everywhere. Even if the code is optimized so
that it ends up looking as so:

        pushq   %rax,%rdi	[the pte]
        mov     %rdi,%rax       [the paravirt ident patching - used to be callq]
        nop
        nop
        nop
        nop
	[and here the check for !pgprot_val(cpa->mask_clr) happens]
        movq    16(%rbx), %rdi          [cpa->mask_clr -> rdi]
        notq    %rdi
        andq    %rax, %rdi

vs where there was none of this (that is a virgin 3.2-rc4):

        ...
	[and here the check for !pgprot_val(cpa->mask_clr) happens]
        movq    16(%rbx), %rdi          [cpa->mask_clr -> rdi]
        notq    %rdi
        andq    %rax, %rdi

[The full .S annotate outputs, are at http://darnok.org/results/baseline_pte_flags_pte_attrs/]

So on AMD if I use the posted patch  - where I wrap the pte_flags in just one specific place
(__page_change_attr_set_clr) - the degradation disappears.

I called that case the pte_attrs in the benchmarks numbers. It could be that the
AMD degradation is due to insertion of improper nops in the 'callq *pv_mmu_ops+104' space
but not sure. [edit: That was my original thinking but after some more runs it looks
to be due to whatever CONFIG_FUNCTION_TRACER introduces]

The posted patch (pte_attrs), introduces three extra operations
(http://darnok.org/results/baseline_pte_flags_pte_attrs/baseline-vs-pte_attrs.diff)

        call    pte_val         [this calls mcount and does the pvops call (which gets patched over)]
        movq    %r14, %rdi      [used for pte_pfn call right after the next movq]
        movq    %rax, -144(%rbp)[save our new pte flag value on stack]

        [.. call pte_pfn - which the original code did as well]

Performance wise it was on par (on in one case faster?) than baseline (v3.2-rc4 virgin).
This is on Intel and AMD.

Naturally if the "# CONFIG_PARAVIRT is not set", the assembler code is _exactly_ the same
as before this patch (no surprise since it ends up becoming native_pte_flags)
and the performance is on par.


