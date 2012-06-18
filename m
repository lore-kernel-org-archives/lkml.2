Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2FRKLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab2FRKLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:11:08 -0400
Message-ID: <4FDEFEB8.9000001@redhat.com>
Date: Mon, 18 Jun 2012 13:11:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: introduce readonly memslot
References: <4FD6ADA6.40008@linux.vnet.ibm.com> <4FD6AE3B.9020508@linux.vnet.ibm.com>
In-Reply-To: <4FD6AE3B.9020508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 05:49 AM, Xiao Guangrong wrote:
> In current code, if we map a readonly memory space from host to guest
> and the page is not currently mapped in the host, we will get a fault-pfn
> and async is not allowed, then the vm will crash
> 
> Address Avi's idea, we introduce readonly memory region to map ROM/ROMD
> to the guest
> 
> index 4b96bc2..b551db1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -688,7 +688,7 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
> 
>  static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
>  {
> -	if (mem->flags & ~KVM_MEM_LOG_DIRTY_PAGES)
> +	if (mem->flags & ~(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY))
>  		return -EINVAL;

Only x86 supports readonly so far.

> 
> -static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
> -				     gfn_t *nr_pages)
> +static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
> +				     gfn_t *nr_pages, bool write)
>  {
> -	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
> +	      ((slot->flags & KVM_MEM_READONLY) && write))
>  		return bad_hva();
> 
>  	if (nr_pages)
> @@ -1045,6 +1046,12 @@ static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
>  	return gfn_to_hva_memslot(slot, gfn);
>  }
> 
> +static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
> +				     gfn_t *nr_pages)
> +{
> +	return __gfn_to_hva_many(slot, gfn, nr_pages, true);
> +}

We have dozens of translation functions: read/write guest virtual, guest
physical (nested and non nested), host virtual, host physical,
atomic/nonatomic, sync/async, with/without slot lookup, and probably a
few more I forgot.

I think we should refactor this into a series of on-step translations:

   /*
    * Translate gva/len write access to a number of tlb entries
    * (due to cross-page splits) or a fault
    */
   gva_to_tlb(gva, len, ACCESS_WRITE, &translation);
   /*
    * Translate tlb entries to callbacks that do I/O (either directly
    * or through KVM_EXIT_MMIO, provided there is no exception pending
    */
   tlb_to_io(&translation, &iolist, IO_ATOMIC);
   /*
    * Initiate I/O (if no exception)
    */
   run_iolist(&iolist, data);

   struct gpa_scatterlist {
       unsigned nr_entries;
       struct {
           gpa_t gpa;
           unsigned len;
       } entry[2];
       struct x86_exception exception;
   };

   struct kvm_iolist {
       unsigned nr_entries;
       struct kvm_ioentry {
           struct kvm_memslot *slot;  /* NULL for mmio */
           struct something *kernel_iodevice;
           gfn_t page_in_slot;
           unsigned offset_in_page;
           unsigned len;
           void (*iofunc)(struct kvm_ioentry *entry, void *data);
       } entry[2];
       struct x86_exception execption;
   };

This is of course outside the scope of this patchset, just something to
think about (and write opinions on).



-- 
error compiling committee.c: too many arguments to function


