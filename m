Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab1KRJpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:45:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab1KRJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:45:40 -0500
Subject: Re: [PATCH v2 6/6] KVM: introduce a table to map slot id to index
 in memslots arry
From: Sasha Levin <levinsasha928@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
In-Reply-To: <4EC6235A.90705@linux.vnet.ibm.com>
References: <4EC6226B.3080408@linux.vnet.ibm.com>
	 <4EC6235A.90705@linux.vnet.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 18 Nov 2011 11:45:36 +0200
Message-ID: <1321609536.8010.30.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:20 +0800, Xiao Guangrong wrote:
> The operation of getting dirty log is frequency When framebuffer-based
> displays are used(for example, Xwindow), so, we introduce a mapping table
> to speed up id_to_memslot()
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/linux/kvm_host.h |   13 +++++++------
>  virt/kvm/kvm_main.c      |    7 ++++++-
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 83b396a..fbf66eb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -238,6 +238,8 @@ struct kvm_irq_routing_table {};
>  struct kvm_memslots {
>  	u64 generation;
>  	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
> +	/* The mapping table from slot id to the index in memslots[]. */
> +	int id_to_index[KVM_MEM_SLOTS_NUM];
>  };
> 
>  struct kvm {
> @@ -340,14 +342,13 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
>  static inline struct kvm_memory_slot *
>  id_to_memslot(struct kvm_memslots *slots, int id)
>  {
> -	int i;
> +	int index = slots->id_to_index[id];
> +	struct kvm_memory_slot *slot;
> 
> -	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> -		if (slots->memslots[i].id == id)
> -			return &slots->memslots[i];
> +	slot = &slots->memslots[index];
> 
> -	WARN_ON(1);
> -	return NULL;
> +	WARN_ON(slot->id != id);
> +	return slot;
>  }

If we didn't find the right memslot we shouldn't be returning a wrong
one, we should be failing.

-- 

Sasha.

