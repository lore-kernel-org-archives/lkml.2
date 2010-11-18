Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0KRM3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab0KRM3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:29:19 -0500
Message-ID: <4CE51C17.4000108@redhat.com>
Date: Thu, 18 Nov 2010 14:29:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
References: <20101117221254.GA8296@redhat.com> <20101118105741.GA31261@redhat.com> <4CE50810.3090502@redhat.com> <20101118111037.GB31261@redhat.com>
In-Reply-To: <20101118111037.GB31261@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 01:10 PM, Michael S. Tsirkin wrote:
> >  I guess I should create an empty Documentation/kvm/locking.txt and
> >  force everyone else to update it.
>
> Comments near the relevant fields not better?
>

Not an either/or.  You can't understand the system from random source 
comments.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a055742..d13ced3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -16,6 +16,7 @@
>   #include<linux/mm.h>
>   #include<linux/preempt.h>
>   #include<linux/msi.h>
> +#include<linux/rcupdate.h>
>   #include<asm/signal.h>
>
>   #include<linux/kvm.h>
> @@ -206,6 +207,8 @@ struct kvm {
>
>   	struct mutex irq_lock;
>   #ifdef CONFIG_HAVE_KVM_IRQCHIP
> +	/* Update side is protected by irq_lock and,
> +	 * if configured, irqfds.lock. */

/*
  * kernel style comment
  * here and elsewhere
  */



>   	struct kvm_irq_routing_table __rcu *irq_routing;
>   	struct hlist_head mask_notifier_list;
>   	struct hlist_head irq_ack_notifier_list;
> @@ -462,6 +465,8 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
>   				   unsigned long *deliver_bitmask);
>   #endif
>   int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> +		int irq_source_id, int level);

No point in the level argument for an msi specific function.

>
>   #else
> @@ -614,6 +620,12 @@ static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>   }
>
>   static inline void kvm_irqfd_release(struct kvm *kvm) {}

blank line

> +static inline void kvm_irq_routing_update(struct kvm *kvm,
> +					  struct kvm_irq_routing_table *irq_rt)
> +{
> +	rcu_assign_pointer(kvm->irq_routing, irq_rt);
> +}
> +
>   static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>   {
>   	return -ENOSYS;

Apart from these minor issues, looks good.

-- 
error compiling committee.c: too many arguments to function

