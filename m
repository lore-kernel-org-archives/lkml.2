Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab1BKWNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:13:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab1BKWNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:13:30 -0500
Message-ID: <4D55B44D.6080208@redhat.com>
Date: Fri, 11 Feb 2011 17:12:29 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] KVM: X86: Delegate tsc-offset calculation to architecture
 code
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com> <1297272584-22689-6-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1297272584-22689-6-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 12:29 PM, Joerg Roedel wrote:
> With TSC scaling in SVM the tsc-offset needs to be
> calculated differently. This patch propagates this
> calculation into the architecture specific modules so that
> this complexity can be handled there.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/svm.c              |   11 ++++++++++-
>   arch/x86/kvm/vmx.c              |    6 ++++++
>   arch/x86/kvm/x86.c              |   10 +++++-----
>   4 files changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9686950..8c40425 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -593,6 +593,7 @@ struct kvm_x86_ops {
>   	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
>
>   	bool (*use_virtual_tsc_khz)(struct kvm_vcpu *vcpu);
> +	u64 (*compute_tsc_offset)(struct kvm_vcpu *vcpu, u64 target_tsc);
>    

So I've gone over this series and the only issue I see so far is with 
this patch, and it doesn't have to do with upstream code, rather with 
code I was about to send.

Logically, the compensation done by adjust_tsc_offset should also be 
scaled; currently, this happens only for reasons, both of which are 
meant to deal with unstable TSCs; since TSC scaling won't happen on 
those processors with unstable TSCs, we don't need to worry about it there.

I have an upcoming patch which does complicate things a bit, which deals 
with host suspend.  In that case, the host TSC goes backwards and the 
offsets needs to be recomputed.  However, there is no convenient time to 
set the offset again; on VMX, the hardware will not yet be set up and so 
can't easily write the offset field in the VMCS.  We also can't put a 
synchronization barrier on all the VCPUs to write the offset before they 
start running without getting into a difficult situation with locking.

So instead, the approach I took was to re-use the adjust_tsc_offset 
function and accumulate offsets to apply.

For SVM with TSC scaling, the offset to apply as an adjustment in this 
case needs to be scaled.  Setting guest TSC (gtsc) equal to the new 
guest TSC (gstc'), we have:

gtsc = htsc * mult + offset
gstc' = htsc' * mult + offset'
gtsc' = gtsc
offset' = htsc * mult + offset - htsc' * mult
offset' = (htsc - htsc') * mult + offset

so, delta offset needs to = (htsc - htsc') * mult

We will instead be passing (htsc - htsc') as the adjustment value; the 
solution seems simple, we have to scale it up as well in the 
adjust_tsc_offset function.

However, the problem is that we need a new architecture specific 
function or API change because not all call sites for adjust_tsc want to 
have adjustments scaled - the call site dealing with tsc_catchup is 
actually working in guest cycles already, so should not be scaled again.

We could have separate functions to adjust TSC cycles by either guest or 
host cycle amounts, or pass a flag to adjust_tsc_offset indicating 
whether the adjustment is to be applied in guest cycles or host cycles.

The resulting API will be slightly asymmetric, as compute_tsc_offset 
lets the generic code compute in terms of hardware offsets, but in the 
adjustment case, there isn't an easy way to expose the ability to 
compute in hardware offset terms.

One slight pity is that we won't be able to resue 
svm_compute_tsc_offset, as the applied delta won't be based off a read 
of the tsc.  I can't really find a better API though, in case offsets 
are computed differently on different hardware (such as multiplying 
after the offset), then we need a function to convert guest cycles back 
to hardware cycles.

As usual, with the TSC code, it is going to require a lot of commenting 
to explain this.

Your code in general looks good.

Cheers,

Zach
