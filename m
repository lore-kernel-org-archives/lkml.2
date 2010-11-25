Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0KYPPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:15:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0KYPPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:15:48 -0500
Message-ID: <4CEE7D9F.7070105@redhat.com>
Date: Thu, 25 Nov 2010 17:15:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com> <4CED63DC.20608@redhat.com> <20101125114640.GC6031@amd.com>
In-Reply-To: <20101125114640.GC6031@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 01:46 PM, Roedel, Joerg wrote:
> On Wed, Nov 24, 2010 at 02:13:32PM -0500, Avi Kivity wrote:
> >  On 11/24/2010 08:18 PM, Joerg Roedel wrote:
> >  >  Hi Avi, Hi Marcelo,
> >  >
> >  >  here is a patch-set to make the instruction emulator aware of nested
> >  >  virtualization. It basically works by introducing a new callback into
> >  >  the x86_ops to check if a decoded instruction must be intercepted. If it
> >  >  is intercepted the instruction emulator returns straight into the guest.
> >  >
> >  >  I am not entirely happy with this solution because it partially
> >  >  duplicates the code in the x86_emulate_insn function.
> >
> >  My big worry is that it makes svm.c aware of internal emulator variable,
> >  so it makes it harder to hack on the emulator.
>
> I don't think so, the structure of the code in svm.c follows the same
> structures (even in a simpler way) as in the x86_emulate_insn()
> function. Someone who changes the internal data structures of the
> emulator can easily change svm.c too. This person will even recognize
> the need for this automatically because svm.c will not compile anymore
> when the data structure is changed.

Eventually the emulator will be used outside kvm.  We don't want to tie 
the two together.

> On the other side, implementing this in the emulator itself would
> require a person to learn about very low-level svm internals to get
> everything right (or the changes easily break the code which is more
> likely).

All that's needed is to read the svm chapter in the AMD manual; you 
don't need to understand kvm or out nested svm implementation.  On the 
other hand, some information needs to be encoded in the emulator (the 
order of the intercept check vs exception check) or we need to duplicate 
checks.  We also do a split decode.

> >  So I don't think there's a problem with coding the svm intercepts in
> >  emulate.c.  This is no different than emulating any AMD-specific
> >  instruction in the emulator - we're emulating an instruction in exactly
> >  the way it is specified in the manual.
>
> That would make sense if the Nested-SVM code is implemented in the
> generic code so that it is usable from VMX too. But that is not the case
> and also not really doable.

Nested VMX could do the same thing.  Sometimes the checks would be 
shared and sometimes not.

> >  Something you could do is allocate bits for the intercept bit number and
> >  exit code in opcode->flags.  This way most unconditional intercepts
> >  happen outside the instruction switch: generic code reads the intercept
> >  bit, the intercept word (via a callback), if the bit is set, returns the
> >  exit code.  That should completely kill the diffstat.  We only need to
> >  be careful wrt the order of the intercept check and the other permission
> >  checks.
>
> We have a lot of intercepts where this does not work. There is no 1-1
> mapping between an opcode and an intercept. Some opcodes can result in
> multiple different intercepts (mov cr, mov dr),

We can extend the group mechanism to make these separate opcodes.

>   sometimes multiple
> intructions result in one intercept (rdmsr/wrmsr, in/out). The later
> ones even need special handling because the differences between the
> different instructions are encoded in the exit_info fields.

So they get special treatment.  Decode bits are for the general case.

Let's see:

   CRx/DRx checks - need group mechanism extension, can use decode bits
   Selective CR0 - special
   LIDT/SIDT/LGDT/SGDT/LLDT/SLDT/LTR/STR - decode bits
   RDTSC/RDPMC/CPUID - decode bits
   PUSHF/POPF/RSM/IRET/INTn - decode bits, + flag to check before exceptions
   INVD /HLT/INVLPG/INVLPGA - decode bits
   PAUSE - special
   VMRUN/VMLOAD/VMSAVE/VMMCALL/STGI/CLGI/SKINIT - decode bits (VMMCALL 
preempts exceptions)
   RDTSCP/ICEBP/WBINVD/MONITOR/MWAIT - decode bits
   IOIO/MSR - very special
   Exception intercepts - outside emulator

So the majority (by far) can be handled by decode bits.  Selective CR0, 
IOIO, MSR, and PAUSE need special handling, can be done via callbacks 
into kvm (and into vendor specific code).  These will be useful for 
nested vmx as well.

Come to think of it, CR0, IOIO, and MSR already have callbacks into 
kvm.  So all we need to do is add X86EMUL_INTERCEPTED to the callback 
(provided it's at the right place in terms of intercept/exception 
priority - haven't checked).

>   All this
> would expose svm-internals like the vmcb structure into the generic
> code.
> I think hacking all this in the emulator itself also makes it more
> complex than it is today and the changes will likely break at some point
> when somone hacks on the emulator. And the situation will not get better
> when Nested-VMX gets merged and needs to do the same.
>
> We basically have two choices here:
>
> 	a) We expose svm internals into the emulator
> 	b) We expose emulator internals into svm
>
> Both choices are not really good from a software-design point-of-view.
> But I think option b) is the better one because it is easier to cope with
> and thus less likely to break when changing the emulator code.

svm specific infomation will have to be exposed anyway, because the 
checks need to be made in different places.  That's especially true when 
the emulation itself can generate exceptions, you may have to redo the 
exception check in svm.c.

-- 

error compiling committee.c: too many arguments to function

