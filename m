Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0KYSV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:21:58 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:39265
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751545Ab0KYSV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:21:56 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i691h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCGDOA-02-937-02
X-M-MSG: 
Date: Thu, 25 Nov 2010 19:21:52 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
Message-ID: <20101125182152.GB9411@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
 <4CED63DC.20608@redhat.com>
 <20101125114640.GC6031@amd.com>
 <4CEE7D9F.7070105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CEE7D9F.7070105@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:15:43AM -0500, Avi Kivity wrote:
> On 11/25/2010 01:46 PM, Roedel, Joerg wrote:

> Eventually the emulator will be used outside kvm.  We don't want to tie 
> the two together.

Does any user outside of KVM care about nested virtualization?

> All that's needed is to read the svm chapter in the AMD manual; you 
> don't need to understand kvm or out nested svm implementation.  On the 
> other hand, some information needs to be encoded in the emulator (the 
> order of the intercept check vs exception check) or we need to duplicate 
> checks.  We also do a split decode.

Is that person also required to read through the 500 pages of VMX
documentation when nested VMX gets merged?

> So they get special treatment.  Decode bits are for the general case.
> 
> Let's see:
> 
>    CRx/DRx checks - need group mechanism extension, can use decode bits

The CRx writes are mostly special because exceptions for validity of the
values written take precedence over the intercept. Implementing these
checks also requires to put the intercept check into the kvm_set_crX
functions, which, by themselves, needs to be reworked in an SVM specific
way for this.

>    Selective CR0 - special

Needs to be handled in the write-cr0 path

>    LIDT/SIDT/LGDT/SGDT/LLDT/SLDT/LTR/STR - decode bits

Check for a valid address before the intercept check. Thus special too.

>    RDTSC/RDPMC/CPUID - decode bits

RDTSC and RDPMC check all exceptions before the intercept too.

>    PUSHF/POPF/RSM/IRET/INTn - decode bits, + flag to check before exceptions

Should work with decode-bits.

>    INVD /HLT/INVLPG/INVLPGA - decode bits

Exceptions are only caused on cpl > 0 and take precedence over the
intercept. Should work with decode bits.


>    VMRUN/VMLOAD/VMSAVE/VMMCALL/STGI/CLGI/SKINIT - decode bits (VMMCALL 
> preempts exceptions)

VMRUN/VMLOAD/VMSAVE need to check rax for a valid physical address
before the intercept is taken. All SVM instructions are not allowed in
real-mode which needs to be checkd too. The realmode-check may be
generic but with the address check this is harder. So at least
VMRUN/VMLOAD/VMSAVE are special too.

Further the SVM instructions are not implemented in the emulator at all
(like some other instructions which can be intercepted). Proper
emulation of these instructions would require new callbacks.

>    RDTSCP/ICEBP/WBINVD/MONITOR/MWAIT - decode bits

RDTSCP needs special handling like RDTSC. MONITOR is special too because
it checks all exceptions before the intercept.

All this can be done, but I doubt the result will look better or is
better maintainable than the current the solution in this patch-set.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

