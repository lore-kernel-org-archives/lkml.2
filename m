Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0KZI2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:28:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab0KZI2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:28:47 -0500
Message-ID: <4CEF6FB6.7090004@redhat.com>
Date: Fri, 26 Nov 2010 10:28:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com> <4CED63DC.20608@redhat.com> <20101125114640.GC6031@amd.com> <4CEE7D9F.7070105@redhat.com> <20101125182152.GB9411@amd.com>
In-Reply-To: <20101125182152.GB9411@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 08:21 PM, Roedel, Joerg wrote:
> On Thu, Nov 25, 2010 at 10:15:43AM -0500, Avi Kivity wrote:
> >  On 11/25/2010 01:46 PM, Roedel, Joerg wrote:
>
> >  Eventually the emulator will be used outside kvm.  We don't want to tie
> >  the two together.
>
> Does any user outside of KVM care about nested virtualization?

No.

> >  All that's needed is to read the svm chapter in the AMD manual; you
> >  don't need to understand kvm or out nested svm implementation.  On the
> >  other hand, some information needs to be encoded in the emulator (the
> >  order of the intercept check vs exception check) or we need to duplicate
> >  checks.  We also do a split decode.
>
> Is that person also required to read through the 500 pages of VMX
> documentation when nested VMX gets merged?

Yes.

> >  So they get special treatment.  Decode bits are for the general case.
> >
> >  Let's see:
> >
> >     CRx/DRx checks - need group mechanism extension, can use decode bits
>
> The CRx writes are mostly special because exceptions for validity of the
> values written take precedence over the intercept.

We can have three checks, controlled by the decode bits:

     // decode instruction

     if ((c->d & SvmMask) == SvmInterceptBefore)
           ... do intercept check

     // do privivilge level checks

     if ((c->d & SvmMask) == SvmInterceptAfterPriv)
           ... do intercept check

     // fetch operands

     if ((c->d & SvmMask) == SvmInterceptAfterMemory)
           ... do intercept check


>   Implementing these
> checks also requires to put the intercept check into the kvm_set_crX
> functions, which, by themselves, needs to be reworked in an SVM specific
> way for this.

Add a kvm_x86_ops callback for this (vmx as usual is pretty complicated 
here)

> >     Selective CR0 - special
>
> Needs to be handled in the write-cr0 path

In the appropriate callback

> >     LIDT/SIDT/LGDT/SGDT/LLDT/SLDT/LTR/STR - decode bits
>
> Check for a valid address before the intercept check. Thus special too.

See above - we can regularize it by encoding where the check takes place.

> >     RDTSC/RDPMC/CPUID - decode bits
>
> RDTSC and RDPMC check all exceptions before the intercept too.
>
> >     PUSHF/POPF/RSM/IRET/INTn - decode bits, + flag to check before exceptions
>
> Should work with decode-bits.
>
> >     INVD /HLT/INVLPG/INVLPGA - decode bits
>
> Exceptions are only caused on cpl>  0 and take precedence over the
> intercept. Should work with decode bits.
>
>
> >     VMRUN/VMLOAD/VMSAVE/VMMCALL/STGI/CLGI/SKINIT - decode bits (VMMCALL
> >  preempts exceptions)
>
> VMRUN/VMLOAD/VMSAVE need to check rax for a valid physical address
> before the intercept is taken.

Add an SrcPhys/DstPhys decode, it becomes regular.

> All SVM instructions are not allowed in
> real-mode which needs to be checkd too. The realmode-check may be
> generic but with the address check this is harder. So at least
> VMRUN/VMLOAD/VMSAVE are special too.
>
> Further the SVM instructions are not implemented in the emulator at all
> (like some other instructions which can be intercepted). Proper
> emulation of these instructions would require new callbacks.

Sure.

> >     RDTSCP/ICEBP/WBINVD/MONITOR/MWAIT - decode bits
>
> RDTSCP needs special handling like RDTSC.

Why?

> MONITOR is special too because
> it checks all exceptions before the intercept.
>
> All this can be done, but I doubt the result will look better or is
> better maintainable than the current the solution in this patch-set.

With proper infrastructure I think all the modifications needed will be 
the three checks above and the decode bits (assuming the current 
crx/drx/pio callbacks are in the right place).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

