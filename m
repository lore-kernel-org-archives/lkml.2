Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1F2JRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:17:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1F2JRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:17:00 -0400
Message-ID: <4E0AED86.2060908@redhat.com>
Date: Wed, 29 Jun 2011 12:16:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 19/22] KVM: MMU: lockless walking shadow page table
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDB4.60306@cn.fujitsu.com>
In-Reply-To: <4E01FDB4.60306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:35 PM, Xiao Guangrong wrote:
> Use rcu to protect shadow pages table to be freed, so we can safely walk it,
> it should run fastly and is needed by mmio page fault
>

>   static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>   				    struct list_head *invalid_list)
>   {
> @@ -1767,6 +1874,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>
>   	kvm_flush_remote_tlbs(kvm);
>
> +	if (atomic_read(&kvm->arch.reader_counter)) {
> +		kvm_mmu_isolate_pages(invalid_list);
> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> +		list_del_init(invalid_list);
> +		call_rcu(&sp->rcu, free_pages_rcu);
> +		return;
> +	}
> +

I think we should do this unconditionally.  The cost of ping-ponging the 
shared cache line containing reader_counter will increase with large smp 
counts.  On the other hand, zap_page is very rare, so it can be a little 
slower.  Also, less code paths = easier to understand.

-- 
error compiling committee.c: too many arguments to function

