Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1KXKOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:14:48 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50010 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1KXKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:14:47 -0500
Message-ID: <4ECE1948.2060907@oss.ntt.co.jp>
Date: Thu, 24 Nov 2011 19:15:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] KVM: introduce id_to_memslot function
References: <4ECE1037.4060300@gmail.com> <4ECE10F8.9070707@gmail.com>
In-Reply-To: <4ECE10F8.9070707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/24 18:40), Xiao Guangrong wrote:

...

> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3521,7 +3521,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>   	if (log->slot>= KVM_MEMORY_SLOTS)
>   		goto out;
>
> -	memslot =&kvm->memslots->memslots[log->slot];
> +	memslot = id_to_memslot(kvm->memslots, log->slot);
>   	r = -ENOENT;
>   	if (!memslot->dirty_bitmap)
>   		goto out;
> @@ -3544,15 +3544,16 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>   		if (!slots)
>   			goto out;
>   		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
> -		memslot =&slots->memslots[log->slot];
> -		memslot->dirty_bitmap = dirty_bitmap;
> +		memslot = id_to_memslot(slots, log->slot);
>   		memslot->nr_dirty_pages = 0;
> +		memslot->dirty_bitmap = dirty_bitmap;
>   		update_memslots(slots, NULL);
>
>   		old_slots = kvm->memslots;
>   		rcu_assign_pointer(kvm->memslots, slots);
>   		synchronize_srcu_expedited(&kvm->srcu);
> -		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
> +		dirty_bitmap = id_to_memslot(old_slots,
> +					      log->slot)->dirty_bitmap;

You can eliminate this if you use old_slot and new_slot for the two memory slots.

	Takuya

>   		kfree(old_slots);
>
>   		write_protect_slot(kvm, memslot, dirty_bitmap, nr_dirty_pages);
