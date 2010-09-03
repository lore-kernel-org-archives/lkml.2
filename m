Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0ICV3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:29:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:46758 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0ICV3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:29:15 -0400
Subject: Re: [PATCH 3/3] KVM: SVM: Clean up rip handling in vmrun emulation
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100903122140.GG1964@amd.com>
Date: Fri, 3 Sep 2010 23:29:11 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1E478B32-8E9D-4041-B841-F64016FA5AB1@suse.de>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com> <1283441387-7378-4-git-send-email-joerg.roedel@amd.com> <20100903122140.GG1964@amd.com>
To: "Roedel, Joerg" <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03.09.2010, at 14:21, Roedel, Joerg wrote:

> On Thu, Sep 02, 2010 at 11:29:47AM -0400, Joerg Roedel wrote:
>> This patch changes the rip handling in the vmrun emulation
>> path from using next_rip to the generic kvm register access
>> functions.
>> 
>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>> ---
>> arch/x86/kvm/svm.c |    6 +++---
>> 1 files changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index ecd4e58..1643f30 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -2069,7 +2069,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>> 		return false;
>> 	}
>> 
>> -	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
>> +	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
>> 			       nested_vmcb->save.rip,
>> 			       nested_vmcb->control.int_ctl,
>> 			       nested_vmcb->control.event_inj,
>> @@ -2270,8 +2270,8 @@ static int vmrun_interception(struct vcpu_svm *svm)
>> 	if (nested_svm_check_permissions(svm))
>> 		return 1;
>> 
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>> -	skip_emulated_instruction(&svm->vcpu);
>> +	/* Save rip after vmrun instruction */
>> +	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
>> 
>> 	if (!nested_svm_vmrun(svm))
>> 		return 1;
> 
> Argh, in my interactive commit I forgot one part of this patch. Please
> apply the attached one instead.
> 
> 
> From 42450df2b72c23538d61616834dbdf1b53deafd7 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 2 Sep 2010 17:12:18 +0200
> Subject: [PATCH 3/3] KVM: SVM: Clean up rip handling in vmrun emulation
> 
> This patch changes the rip handling in the vmrun emulation
> path from using next_rip to the generic kvm register access
> functions.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
> arch/x86/kvm/svm.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ecd4e58..6808f64 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2069,7 +2069,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
> 		return false;
> 	}
> 
> -	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
> +	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
> 			       nested_vmcb->save.rip,
> 			       nested_vmcb->control.int_ctl,
> 			       nested_vmcb->control.event_inj,
> @@ -2098,7 +2098,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
> 	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
> 	hsave->save.cr4    = svm->vcpu.arch.cr4;
> 	hsave->save.rflags = vmcb->save.rflags;
> -	hsave->save.rip    = svm->next_rip;
> +	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
> 	hsave->save.rsp    = vmcb->save.rsp;
> 	hsave->save.rax    = vmcb->save.rax;
> 	if (npt_enabled)
> @@ -2270,8 +2270,8 @@ static int vmrun_interception(struct vcpu_svm *svm)
> 	if (nested_svm_check_permissions(svm))
> 		return 1;
> 
> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
> -	skip_emulated_instruction(&svm->vcpu);
> +	/* Save rip after vmrun instruction */
> +	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);


Any reason we can't use the next_rip information here? A hypervisor could potentially do badness and put a prefix here, thus break all the logic, right?

(yes, I know, I wrote that code, but still ...)


Alex

