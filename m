Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1AMT1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:27:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1AMT1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:27:08 -0500
Message-ID: <4D2F5204.7020100@redhat.com>
Date: Thu, 13 Jan 2011 21:27:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest
 mode
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com> <1294932178-26866-2-git-send-email-joerg.roedel@amd.com> <4D2F1D49.8070807@redhat.com> <20110113155129.GA23914@amd.com>
In-Reply-To: <20110113155129.GA23914@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 05:51 PM, Roedel, Joerg wrote:
> On Thu, Jan 13, 2011 at 10:42:01AM -0500, Avi Kivity wrote:
> >  On 01/13/2011 05:22 PM, Joerg Roedel wrote:
> >  >  The vmexit path on SVM needs to restore the KERNEL_GS_BASE
> >  >  MSR in order to savely execute the NMI handler. Otherwise a
> >  >  pending NMI can occur after the STGI instruction and crash
> >  >  the machine.
> >  >  This makes it impossible to run perf and kvm in parallel on
> >  >  an AMD machine in a stable way.
> >  >
> >  >  Cc: stable@kernel.org
> >  >  Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >  >  ---
> >  >    arch/x86/kvm/svm.c |    1 +
> >  >    1 files changed, 1 insertions(+), 0 deletions(-)
> >  >
> >  >  diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >  >  index 25bd1bc..8b9bc72 100644
> >  >  --- a/arch/x86/kvm/svm.c
> >  >  +++ b/arch/x86/kvm/svm.c
> >  >  @@ -3637,6 +3637,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >  >
> >  >    #ifdef CONFIG_X86_64
> >  >    	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> >  >  +	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
> >  >    #else
> >  >    	loadsegment(fs, svm->host.fs);
> >  >    #endif
> >
> >  Why would an NMI crash if MSR_KERNEL_GS_BASE is bad?
> >
> >  I see save_paranoid depends on MSR_GS_BASE (specifically its sign, which
> >  is bad for the new instructions that allow userspace to write gsbase),
> >  but not on MSR_KERNEL_GS_BASE.
>
> Thats a good question. I have not idea. I spent some time trying to
> figure this out (after I found out that wrong KERNEL_GS_BASE was the
> cause of the crashes) but had no luck.
>
> This also doesn't happen every time an NMI is delivered in svm_vcpu_run.
> Sometimes it runs perfectly in parallel for a few minutues before the
> machine triple-faults.
>
> I also had a look at entry_64.S. The save_paranoid could not be the
> cause because MSR_GS_BASE is already negative at this point. But the
> re-schedule condition check at the end of the NMI handler code could
> also not be the cause because the NMI happens while preemption (and
> interrupts) are disabled (a re-schedule should also trigger
> preempt-notifiers and restore KERNEL_GS_BASE).
>

I have it:

ENTRY(native_load_gs_index)
     CFI_STARTPROC
     pushfq_cfi
     DISABLE_INTERRUPTS(CLBR_ANY & ~CLBR_RDI)
     SWAPGS
gs_change:
     movl %edi,%gs
2:    mfence        /* workaround */
     SWAPGS
     popfq_cfi
     ret

If an nmi hits between the two SWAPGSs, it sees the guest's 
MSR_KERNEL_GS_BASE as the host's MSR_GS_BASE.

An alternative to your fix would be to disable GIF around 
load_gs_index() in kvm.  I imagine it would be slower than your fix (not 
a trivial tradeoff - wrmsr every lightweight exit, vs. clgi/stgi every 
heavyweight exit).

Please update the changelog, and add a comment.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

