Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1KTL05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 06:26:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab1KTL0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 06:26:55 -0500
Message-ID: <4EC8E3FB.7020108@redhat.com>
Date: Sun, 20 Nov 2011 13:26:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] KVM: sort memslots by its size and use line search
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC62336.7040505@linux.vnet.ibm.com>
In-Reply-To: <4EC62336.7040505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 11:19 AM, Xiao Guangrong wrote:
> Sort memslots base on its size and use line search to find it, so the larger
> memslots have better fit
>
> The idea is from Avi
>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/linux/kvm_host.h |   22 +++++++++---
>  virt/kvm/kvm_main.c      |   82 ++++++++++++++++++++++++++++++++-------------
>  2 files changed, 75 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a0e4d63..83b396a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -230,8 +230,12 @@ struct kvm_irq_routing_table {};
>  #define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
>  #endif
>
> +/*
> + * Note:
> + * memslots are not sorted by id anymore, please use id_to_memslot()
> + * to get the memslot by its id.
> + */
>  struct kvm_memslots {
> -	int nmemslots;
>  	u64 generation;
>  	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
>  };
> @@ -307,9 +311,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>  	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>  	     idx++)
>
> -#define kvm_for_each_memslot(slots, memslot, i)	\
> -	for (i = 0; i < (slots)->nmemslots &&	\
> -	      ({ memslot = &(slots)->memslots[i]; 1; }); i++)
> +#define kvm_for_each_memslot(slots, memslot, i)			\
> +	for (i = 0; i < KVM_MEM_SLOTS_NUM &&			\
> +	      ({ memslot = &(slots)->memslots[i]; 1; }) &&	\
> +	      memslot->npages != 0; i++)

You might allocate an always-empty memslot at the end and simplify the
termination condition.

>
>  int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
>  void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
> @@ -335,7 +340,14 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
>  static inline struct kvm_memory_slot *
>  id_to_memslot(struct kvm_memslots *slots, int id)
>  {
> -	return &slots->memslots[id];
> +	int i;
> +
> +	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> +		if (slots->memslots[i].id == id)
> +			return &slots->memslots[i];
> +

Is that in any hot path?  we could make an array for doing this translation.

Alex wants to increase the memslot count, so this could be a long loop.


-- 
error compiling committee.c: too many arguments to function

