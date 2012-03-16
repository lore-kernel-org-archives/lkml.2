Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2CPFEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:04:06 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54691 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2CPFED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:04:03 -0400
Message-ID: <4F62C9B4.7060804@linux.vnet.ibm.com>
Date: Fri, 16 Mar 2012 13:03:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp> <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12031518-0260-0000-0000-000000B3D789
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 06:33 PM, Takuya Yoshikawa wrote:


> +	spin_lock(&kvm->mmu_lock);
> 
> -		r = -ENOMEM;
> -		slots = kmemdup(kvm->memslots, sizeof(*kvm->memslots), GFP_KERNEL);
> -		if (!slots)
> -			goto out;
> +	for (i = 0; i < n / sizeof(long); i++) {
> +		unsigned long mask;
> +		gfn_t offset;
> 
> -		memslot = id_to_memslot(slots, log->slot);
> -		memslot->nr_dirty_pages = 0;
> -		memslot->dirty_bitmap = dirty_bitmap_head;
> -		update_memslots(slots, NULL);
> +		if (!dirty_bitmap[i])
> +			continue;
> 
> -		old_slots = kvm->memslots;
> -		rcu_assign_pointer(kvm->memslots, slots);
> -		synchronize_srcu_expedited(&kvm->srcu);
> -		kfree(old_slots);


For my quickly review, mmu_lock can not protect everything, if the guest page
is written out of the shadow page/ept table, dirty page will be lost.

There is a example:

             CPU A                                   CPU  B
guest page is written by write-emulation

                                                  hold mmu-lock and see dirty-bitmap
                                                  is not be changed, then migration is
                                                  completed.

call mark_page_dirty() to set dirty_bit map


Right?

