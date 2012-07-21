Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2GUIgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:36:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab2GUIgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:36:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,629,1336320000"; 
   d="scan'208";a="5450481"
Message-ID: <500A6B41.3030901@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 16:41:37 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v7] kvm: notify host when the guest is panicked
References: <500A565A.8080403@cn.fujitsu.com> <500A580D.1010301@web.de>
In-Reply-To: <500A580D.1010301@web.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 16:37:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 16:37:24,
	Serialize complete at 2012/07/21 16:37:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/21/2012 03:19 PM, Jan Kiszka Wrote:
> On 2012-07-21 09:12, Wen Congyang wrote:
>> We can know the guest is panicked when the guest runs on xen.
>> But we do not have such feature on kvm.
>>
>> Another purpose of this feature is: management app(for example:
>> libvirt) can do auto dump when the guest is panicked. If management
>> app does not do auto dump, the guest's user can do dump by hand if
>> he sees the guest is panicked.
>>
>> We have three solutions to implement this feature:
>> 1. use vmcall
>> 2. use I/O port
>> 3. use virtio-serial.
>>
>> We have decided to avoid touching hypervisor. The reason why I choose
>> choose the I/O port is:
>> 1. it is easier to implememt
>> 2. it does not depend any virtual device
>> 3. it can work when startint the kernel
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>>  arch/x86/include/asm/kvm_para.h     |    7 +++++++
>>  arch/x86/kernel/kvm.c               |   14 ++++++++++++++
>>  include/linux/kvm_para.h            |   13 +++++++++++++
>>  6 files changed, 49 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
>> index 2019cb9..187c0e2 100644
>> --- a/arch/ia64/include/asm/kvm_para.h
>> +++ b/arch/ia64/include/asm/kvm_para.h
>> @@ -31,6 +31,11 @@ static inline bool kvm_check_and_clear_guest_paused(void)
>>  	return false;
>>  }
>>  
>> +static inline unsigned int kvm_arch_pv_features(void)
>> +{
>> +	return 0;
>> +}
>> +
>>  #endif
>>  
>>  #endif
>> diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
>> index c18916b..be81aac 100644
>> --- a/arch/powerpc/include/asm/kvm_para.h
>> +++ b/arch/powerpc/include/asm/kvm_para.h
>> @@ -211,6 +211,11 @@ static inline bool kvm_check_and_clear_guest_paused(void)
>>  	return false;
>>  }
>>  
>> +static inline unsigned int kvm_arch_pv_features(void)
>> +{
>> +	return 0;
>> +}
>> +
>>  #endif /* __KERNEL__ */
>>  
>>  #endif /* __POWERPC_KVM_PARA_H__ */
>> diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
>> index a988329..3d993b7 100644
>> --- a/arch/s390/include/asm/kvm_para.h
>> +++ b/arch/s390/include/asm/kvm_para.h
>> @@ -154,6 +154,11 @@ static inline bool kvm_check_and_clear_guest_paused(void)
>>  	return false;
>>  }
>>  
>> +static inline unsigned int kvm_arch_pv_features(void)
>> +{
>> +	return 0;
>> +}
>> +
>>  #endif
>>  
>>  #endif /* __S390_KVM_PARA_H */
>> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
>> index 63ab166..c8ad86e 100644
>> --- a/arch/x86/include/asm/kvm_para.h
>> +++ b/arch/x86/include/asm/kvm_para.h
>> @@ -89,6 +89,8 @@ struct kvm_vcpu_pv_apf_data {
>>  	__u32 enabled;
>>  };
>>  
>> +#define KVM_PV_PORT	(0x505UL)
>> +
>>  #ifdef __KERNEL__
>>  #include <asm/processor.h>
>>  
>> @@ -221,6 +223,11 @@ static inline void kvm_disable_steal_time(void)
>>  }
>>  #endif
>>  
>> +static inline unsigned int kvm_arch_pv_features(void)
>> +{
>> +	return inl(KVM_PV_PORT);
>> +}
>> +
>>  #endif /* __KERNEL__ */
>>  
>>  #endif /* _ASM_X86_KVM_PARA_H */
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index e554e5a..9a97f7e 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -328,6 +328,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
>>  	.notifier_call = kvm_pv_reboot_notify,
>>  };
>>  
>> +static int
>> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
>> +{
>> +	outl(KVM_PV_PANICKED, KVM_PV_PORT);
>> +	return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block kvm_pv_panic_nb = {
>> +	.notifier_call = kvm_pv_panic_notify,
>> +};
>> +
>>  static u64 kvm_steal_clock(int cpu)
>>  {
>>  	u64 steal;
>> @@ -414,6 +425,9 @@ void __init kvm_guest_init(void)
>>  
>>  	paravirt_ops_setup();
>>  	register_reboot_notifier(&kvm_pv_reboot_nb);
>> +	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
>> +		atomic_notifier_chain_register(&panic_notifier_list,
>> +			&kvm_pv_panic_nb);
>>  	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
>>  		spin_lock_init(&async_pf_sleepers[i].lock);
>>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
>> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
>> index ff476dd..e73efcf 100644
>> --- a/include/linux/kvm_para.h
>> +++ b/include/linux/kvm_para.h
>> @@ -20,6 +20,12 @@
>>  #define KVM_HC_FEATURES			3
>>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
>>  
>> +/* The bit of the value read from KVM_PV_PORT */
>> +#define KVM_PV_FEATURE_PANICKED	0
>> +
>> +/* The value writen to KVM_PV_PORT */
>> +#define KVM_PV_PANICKED		1
>> +
>>  /*
>>   * hypercalls use architecture specific
>>   */
>> @@ -33,5 +39,12 @@ static inline int kvm_para_has_feature(unsigned int feature)
>>  		return 1;
>>  	return 0;
>>  }
>> +
>> +static inline int kvm_pv_has_feature(unsigned int feature)
>> +{
>> +	if (kvm_arch_pv_features() & (1UL << feature))
> 
> Reading from an invalid I/O port will return -1. So your test will
> deliver a wrong result on a platform that doesn't support this PV channel.

Yes, you are right. I will update it.

Thanks
Wen Congyang

> 
> Jan
> 
>> +		return 1;
>> +	return 0;
>> +}
>>  #endif /* __KERNEL__ */
>>  #endif /* __LINUX_KVM_PARA_H */
>>
> 
> 
> 
> 

