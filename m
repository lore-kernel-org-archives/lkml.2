Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1CXSPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:15:47 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:48017 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756392Ab1CXSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:15:46 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hxB_aesVM1knKzfP45wyNz.EO_x7PpvLTjOZLad1YngEprx
 23SOuo5LSIHN3KRP36W1wCM8wmKf.ugB3FVZzZErslONuIORQVzxqqqfqUtw
 IUZEMMA.UIIzYcX.onWsFTxsJEXLwStPP3EVgzRBKclCuQzTWFcyhEb.rLAw
 Qw7jTuQIxkGlieyE2GQCIK_3OgBXYUevvHUgmr.0eVMc4TmJvMFsgcKVJlwr
 QHyAsYj79uZalsz7iiBFnXRHj9ojvHbh22zij3cX0h1FzzwO2Wo5mpGAjbic
 VoW9qdWtpH51CkwDkshmT3IakzqSWuYUzBnRTuHoP6HbPAUCI
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 13:15:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103241312280.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger> <20110324142146.GA11682@elte.hu> <alpine.DEB.2.00.1103240940570.32226@router.home> <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com> <20110324172653.GA28507@elte.hu>
 <alpine.DEB.2.00.1103241242450.32226@router.home> <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com> <alpine.DEB.2.00.1103241300420.32226@router.home> <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Pekka Enberg wrote:

> > I forced the fallback to the _emu function to occur but could not trigger
> > the bug in kvm.
>
> That's not the problem. I'm sure the fallback is just fine. What I'm
> saying is that the fallback is *not patched* to kernel text on Ingo's
> machines because alternative_instructions() happens late in the boot!
> So the problem is that on Ingo's boxes (that presumably have old AMD
> CPUs) we execute cmpxchg16b, not the fallback code.

But then we would get the bug in kmem_cache_alloc() and not in the
*_emu() function. So the _emu is executing but failing on Ingo's system
but not on mine. Question is why.

For some reason the first reference to %gs:(%rsi) wont work right on his
system:

>From arch/x86/lib/cmpxchg16b_emu

#
# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in %al not
# via the ZF.  Caller will access %al to get result.
#
# Note that this is only useful for a cpuops operation.  Meaning that we
# do *not* have a fully atomic operation but just an operation that is
# *atomic* on a single cpu (as provided by the this_cpu_xx class of
# macros).
#
this_cpu_cmpxchg16b_emu:
        pushf
        cli

        cmpq %gs:(%rsi), %rax
        jne not_same
        cmpq %gs:8(%rsi), %rdx
        jne not_same

        movq %rbx, %gs:(%rsi)
        movq %rcx, %gs:8(%rsi)

        popf
        mov $1, %al
        ret

 not_same:
        popf
        xor %al,%al
        ret

CFI_ENDPROC




