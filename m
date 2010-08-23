Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0HWPx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:53:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab0HWPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:53:54 -0400
Message-ID: <4C729961.7070308@redhat.com>
Date: Mon, 23 Aug 2010 18:53:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 07/12] Maintain memslot version number
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-8-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/19/2010 06:30 PM, Gleb Natapov wrote:
> Code that depends on particular memslot layout can track changes and
> adjust to new layout.
>
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c13cc48..c74ffc0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -177,6 +177,7 @@ struct kvm {
>   	raw_spinlock_t requests_lock;
>   	struct mutex slots_lock;
>   	struct mm_struct *mm; /* userspace tied to this vm */
> +	u32 memslot_version;
>   	struct kvm_memslots *memslots;
>   	struct srcu_struct srcu;
>   #ifdef CONFIG_KVM_APIC_ARCHITECTURE
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b78b794..292514c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -733,6 +733,7 @@ skip_lpage:
>   	slots->memslots[mem->slot] = new;
>   	old_memslots = kvm->memslots;
>   	rcu_assign_pointer(kvm->memslots, slots);
> +	kvm->memslot_version++;
>   	synchronize_srcu_expedited(&kvm->srcu);
>
>   	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);

How does this interact with rcu?  Nothing enforces consistency between 
rcu_dereference(kvm->memslots) and kvm->memslot_version.

Should probably be rcu_dereference(kvm->memslots)->version.

-- 
error compiling committee.c: too many arguments to function

