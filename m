Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2ITJuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab2ITJuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:50:19 -0400
Message-ID: <505AE6C8.90905@redhat.com>
Date: Thu, 20 Sep 2012 12:50:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>  <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>  <50599AE2.80601@redhat.com> <1348099839.26695.327.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1348099839.26695.327.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 03:10 AM, Suresh Siddha wrote:
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index b06737d..8ff328b 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1493,7 +1493,8 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
>  #ifdef CONFIG_X86_64
>  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
>  #endif
> -	if (user_has_fpu())
> +	/* Did the host task or the guest vcpu has FPU restored lazily? */
> +	if (!use_eager_fpu() && (user_has_fpu() || vmx->vcpu.guest_fpu_loaded))
>  		clts();

Why do the clts() if guest_fpu_loaded()?

An interrupt might arrive after this, look at TS
(interrupted_kernel_fpu_idle()), and stomp on the the guest's fpu.

-- 
error compiling committee.c: too many arguments to function
