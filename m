Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab1AMM75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:59:57 -0500
Received: from david.siemens.de ([192.35.17.14]:21288 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1AMM7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:59:55 -0500
Message-ID: <4D2EF717.8080604@siemens.com>
Date: Thu, 13 Jan 2011 13:59:03 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Christoph Lameter <cl@linux.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: sleeping function called from invalid context at mm/slub.c:793
References: <20110110105433.GA17881@shutemov.name> <alpine.DEB.2.00.1101101051260.12243@router.home> <20110110193117.GA20027@shutemov.name> <4D2C279D.5050309@redhat.com> <4D2C3115.9030301@redhat.com>
In-Reply-To: <4D2C3115.9030301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.01.2011 11:29, Avi Kivity wrote:
> Please try out the attached patch.
> 
> From f3a6041b5bb3bf7c88f9694a66d7f34be2f78845 Mon Sep 17 00:00:00 2001
> From: Avi Kivity <avi@redhat.com>
> Date: Tue, 11 Jan 2011 12:15:54 +0200
> Subject: [PATCH] KVM: Initialize fpu state in preemptible context
> 
> init_fpu() (which is indirectly called by the fpu switching code) assumes
> it is in process context.  Rather than makeing init_fpu() use an atomic
> allocation, which can cause a task to be killed, make sure the fpu is
> already initialized when we enter the run loop.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/kernel/i387.c |    1 +
>  arch/x86/kvm/x86.c     |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 58bb239..e60c38c 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -169,6 +169,7 @@ int init_fpu(struct task_struct *tsk)
>  	set_stopped_child_used_math(tsk);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(init_fpu);
>  
>  /*
>   * The xstateregs_active() routine is the same as the fpregs_active() routine,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8652643..fd93cda 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5351,6 +5351,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  	int r;
>  	sigset_t sigsaved;
>  
> +	if (!tsk_used_math(current) && init_fpu(current))
> +		return -ENOMEM;
> +

Could become a rainy day for the kvm-kmod maintainer:

For compat support on kernels without init_fpu exported yet, can I
trigger the same result by simply issuing an FPU instruction here so
that do_device_not_available will perform the allocation? Not really
nice, but it doesn't appear to me like there is any code path that would
complain about in-kernel FPU usage (provided we don't need math
emulation - which is quite likely).

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
