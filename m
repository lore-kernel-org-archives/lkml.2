Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2FLGnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:43:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2FLGnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:43:05 -0400
X-IronPort-AV: E=Sophos;i="4.77,394,1336320000"; 
   d="scan'208";a="5166608"
Message-ID: <4FD6E5EC.3090802@cn.fujitsu.com>
Date: Tue, 12 Jun 2012 14:47:08 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>
CC: qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH] kvm: notify host when guest panicked
References: <4FB9E4CE.8060709@cn.fujitsu.com>
In-Reply-To: <4FB9E4CE.8060709@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 14:43:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 14:43:39,
	Serialize complete at 2012/06/12 14:43:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Avi

Do you have any comment to this patch?

Thanks
Wen Congyang

At 05/21/2012 02:46 PM, Wen Congyang Wrote:
> We can know the guest is panicked when the guest runs on xen.
> But we do not have such feature on kvm.
> 
> Another purpose of this feature is: management app(for example:
> libvirt) can do auto dump when the guest is panicked. If management
> app does not do auto dump, the guest's user can do dump by hand if
> he sees the guest is panicked.
> 
> We have three solutions to implement this feature:
> 1. use vmcall
> 2. use I/O port
> 3. use virtio-serial.
> 
> We have decided to avoid touching hypervisor. The reason why I choose
> choose the I/O port is:
> 1. it is easier to implememt
> 2. it does not depend any virtual device
> 3. it can work when startint the kernel
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/kvm_para.h     |    7 +++++++
>  arch/x86/kernel/kvm.c               |   14 ++++++++++++++
>  include/linux/kvm_para.h            |   15 +++++++++++++++
>  6 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
> index 1588aee..a890096 100644
> --- a/arch/ia64/include/asm/kvm_para.h
> +++ b/arch/ia64/include/asm/kvm_para.h
> @@ -26,6 +26,11 @@ static inline unsigned int kvm_arch_para_features(void)
>  	return 0;
>  }
>  
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  #endif
> diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
> index 7b754e7..b5f7c35 100644
> --- a/arch/powerpc/include/asm/kvm_para.h
> +++ b/arch/powerpc/include/asm/kvm_para.h
> @@ -206,6 +206,11 @@ static inline unsigned int kvm_arch_para_features(void)
>  	return r;
>  }
>  
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return 0;
> +}
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* __POWERPC_KVM_PARA_H__ */
> diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
> index 6964db2..21a8d18 100644
> --- a/arch/s390/include/asm/kvm_para.h
> +++ b/arch/s390/include/asm/kvm_para.h
> @@ -149,6 +149,11 @@ static inline unsigned int kvm_arch_para_features(void)
>  	return 0;
>  }
>  
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  #endif /* __S390_KVM_PARA_H */
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 734c376..f66b16e 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -208,6 +208,13 @@ static inline void kvm_disable_steal_time(void)
>  }
>  #endif
>  
> +#ifdef KVM_PV_PORT
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return inl(KVM_PV_PORT);
> +}
> +#endif
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* _ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b8ba6e4..adfde45 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -335,6 +335,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
>  	.notifier_call = kvm_pv_reboot_notify,
>  };
>  
> +static int
> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
> +{
> +	outl(KVM_PV_PANICKED, KVM_PV_PORT);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block kvm_pv_panic_nb = {
> +	.notifier_call = kvm_pv_panic_notify,
> +};
> +
>  static u64 kvm_steal_clock(int cpu)
>  {
>  	u64 steal;
> @@ -421,6 +432,9 @@ void __init kvm_guest_init(void)
>  
>  	paravirt_ops_setup();
>  	register_reboot_notifier(&kvm_pv_reboot_nb);
> +	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +			&kvm_pv_panic_nb);
>  	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
>  		spin_lock_init(&async_pf_sleepers[i].lock);
>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> index ff476dd..849b0d5 100644
> --- a/include/linux/kvm_para.h
> +++ b/include/linux/kvm_para.h
> @@ -20,6 +20,14 @@
>  #define KVM_HC_FEATURES			3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
>  
> +#define KVM_PV_PORT	(0x505UL)
> +
> +/* The bit of the value read from KVM_PV_PORT */
> +#define KVM_PV_FEATURE_PANICKED	0
> +
> +/* The value writen to KVM_PV_PORT */
> +#define KVM_PV_PANICKED		1
> +
>  /*
>   * hypercalls use architecture specific
>   */
> @@ -33,5 +41,12 @@ static inline int kvm_para_has_feature(unsigned int feature)
>  		return 1;
>  	return 0;
>  }
> +
> +static inline int kvm_pv_has_feature(unsigned int feature)
> +{
> +	if (kvm_arch_pv_features() & (1UL << feature))
> +		return 1;
> +	return 0;
> +}
>  #endif /* __KERNEL__ */
>  #endif /* __LINUX_KVM_PARA_H */

