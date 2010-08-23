Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0HWP1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0HWP1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:27:52 -0400
Message-ID: <4C729342.6070205@redhat.com>
Date: Mon, 23 Aug 2010 18:26:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 03/12] Add async PF initialization to PV guest.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-4-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-4-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/19/2010 06:30 PM, Gleb Natapov wrote:
> Enable async PF in a guest if async PF capability is discovered.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> ---
>   arch/x86/include/asm/kvm_para.h |    5 +++
>   arch/x86/kernel/kvm.c           |   68 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 73 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 5b05e9f..f1662d7 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -65,6 +65,11 @@ struct kvm_mmu_op_release_pt {
>   	__u64 pt_phys;
>   };
>
> +struct kvm_vcpu_pv_apf_data {
> +	__u32 reason;
> +	__u32 enabled;
> +};
> +

The guest will have to align this on a 64 byte boundary, should this be 
marked __aligned(64) here?

> @@ -231,12 +235,72 @@ static void __init paravirt_ops_setup(void)
>   #endif
>   }
>
> +void __cpuinit kvm_guest_cpu_init(void)
> +{
> +	if (!kvm_para_available())
> +		return;
> +
> +	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF)) {
> +		u64 pa = __pa(&__get_cpu_var(apf_reason));
> +
> +		if (native_write_msr_safe(MSR_KVM_ASYNC_PF_EN,
> +					  pa | KVM_ASYNC_PF_ENABLED, pa>>  32))
> +			return;
> +		__get_cpu_var(apf_reason).enabled = 1;
> +		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
> +		       smp_processor_id());
> +	}
> +}

Need a way to disable apf from the guest kernel command line.

> +
> +static int __cpuinit kvm_cpu_notify(struct notifier_block *self,
> +				    unsigned long action, void *hcpu)
> +{
> +	switch (action) {
> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +		kvm_guest_cpu_init();
> +		break;
> +	default:
> +		break;

Should we disable apf if the cpu is dying here?

> +	}
> +	return NOTIFY_OK;
> +}
> +

-- 
error compiling committee.c: too many arguments to function

