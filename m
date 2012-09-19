Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2ISKOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:14:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab2ISKOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:14:12 -0400
Message-ID: <50599AE2.80601@redhat.com>
Date: Wed, 19 Sep 2012 13:13:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com> <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
In-Reply-To: <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2012 12:12 AM, Suresh Siddha wrote:
> kvm's guest fpu save/restore should be wrapped around
> kernel_fpu_begin/end(). This will avoid for example taking a DNA
> in kvm_load_guest_fpu() when it tries to load the fpu immediately
> after doing unlazy_fpu() on the host side.
> 
> More importantly this will prevent the host process fpu from being
> corrupted.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/kvm/x86.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 42bce48..67e773c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5969,7 +5969,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>  	 */
>  	kvm_put_guest_xcr0(vcpu);
>  	vcpu->guest_fpu_loaded = 1;
> -	unlazy_fpu(current);
> +	kernel_fpu_begin();
>  	fpu_restore_checking(&vcpu->arch.guest_fpu);
>  	trace_kvm_fpu(1);

This breaks kvm, since it disables preemption.  What we want here is to
save the user fpu state if it was loaded, and do nothing if wasn't.
Don't know what's the new API for that.

>  }
> @@ -5983,6 +5983,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>  
>  	vcpu->guest_fpu_loaded = 0;
>  	fpu_save_init(&vcpu->arch.guest_fpu);
> +	kernel_fpu_end();
>  	++vcpu->stat.fpu_reload;
>  	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
>  	trace_kvm_fpu(0);
> 


-- 
error compiling committee.c: too many arguments to function
