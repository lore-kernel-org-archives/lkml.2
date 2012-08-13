Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2HMSV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:21:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2HMSV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:21:57 -0400
Date: Mon, 13 Aug 2012 14:39:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
Message-ID: <20120813173900.GA25268@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <20120810181422.GA14892@amt.cnet>
 <5025D334.9070503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5025D334.9070503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 11:36:20AM +0800, Xiao Guangrong wrote:
> On 08/11/2012 02:14 AM, Marcelo Tosatti wrote:
> > On Tue, Aug 07, 2012 at 05:47:15PM +0800, Xiao Guangrong wrote:
> >> Changelog:
> >> - introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
> >> - introduce KVM_HVA_ERR_BAD and optimize error hva indicators
> >>
> >> The test case can be found at:
> >> http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2
> >>
> >> In current code, if we map a readonly memory space from host to guest
> >> and the page is not currently mapped in the host, we will get a fault-pfn
> >> and async is not allowed, then the vm will crash.
> >>
> >> As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
> >> to the guest, read access is happy for readonly memslot, write access on
> >> readonly memslot will cause KVM_EXIT_MMIO exit.
> > 
> > Memory slots whose QEMU mapping is write protected is supported
> > today, as long as there are no write faults.
> > 
> > What prevents the use of mmap(!MAP_WRITE) to handle read-only memslots
> > again?
> > 
> 
> It is happy to map !write host memory space to the readonly memslot,
> and they can coexist as well.
> 
> readonly memslot checks the write-permission by seeing slot->flags and
> !write memory checks the write-permission in hva_to_pfn() function
> which checks vma->flags. It is no conflict.

Yes, there is no conflict. The point is, if you can use the
mmap(PROT_READ) interface (supporting read faults on read-only slots)
for this behavior, what is the advantage of a new memslot flag?

I'm not saying mmap(PROT_READ) is the best interface, i am just asking
why it is not.

> > The initial objective was to fix a vm crash, can you explain that
> > initial problem?
> >
> 
> The issue was trigged by this code:
> 
>                 } else {
>                         if (async && (vma->vm_flags & VM_WRITE))
>                                 *async = true;
>                         pfn = KVM_PFN_ERR_FAULT;
>                 }
> 
> If the host memory region is readonly (!vma->vm_flags & VM_WRITE) and
> its physical page is swapped out (or the file data does not be read in),
> get_user_page_nowait will fail, above code reject to set async,
> then we will get a fault pfn and async=false.
> 
> I guess this issue also exists in "QEMU write protected mapping" as
> you mentioned above.

Yes, it does. As far as i understand, what that check does from a high
level pov is:

- Did get_user_pages_nowait() fail due to a swapped out page (in which 
case we should try to swappin the page asynchronously), or due to 
another reason (for which case an error should be returned).

Using vma->vm_flags VM_WRITE for that is trying to guess why
get_user_pages_nowait() failed, because it (gup_nowait return values) 
does not provide sufficient information by itself.

Can't that be fixed separately? 

Another issue which is also present with the mmap(PROT_READ) scheme is
interaction with reexecute_instruction. That is, unless i am mistaken,
reexecute_instruction can succeed (return true) on a region that is
write protected. This breaks the "write faults on read-only slots exit
to userspace via EXIT_MMIO" behaviour.

