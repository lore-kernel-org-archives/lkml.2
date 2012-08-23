Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab2HWHZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:25:48 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53617 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2HWHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:25:44 -0400
Message-ID: <5035DAE0.7050901@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2012 15:25:20 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between secondary
 MMU and host
References: <503358FF.3030009@linux.vnet.ibm.com> <20120821150618.GJ27696@redhat.com> <50345735.2000807@linux.vnet.ibm.com> <20120822163746.GU29978@redhat.com>
In-Reply-To: <20120822163746.GU29978@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082307-0260-0000-0000-000001B8F696
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 12:37 AM, Andrea Arcangeli wrote:
> On Wed, Aug 22, 2012 at 11:51:17AM +0800, Xiao Guangrong wrote:
>> Hmm, in KSM code, i found this code in replace_page:
>>
>> set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
>>
>> It is possible to establish a writable pte, no?
> 
> Hugh already answered this thanks. Further details on the vm_page_prot
> are in top of mmap.c, and KSM never scans MAP_SHARED vmas.
> 

Yes, i see that, thank you, Andrea!

>> Unfortunately, all these bugs are triggered by test cases.
> 
> Sure, I've seen the very Oops for the other one, and this one also can
> trigger if unlucky.
> 
> This one can trigger with KVM but only if KSM is enabled or with live
> migration or with device hotplug or some other event that triggers a
> fork in qemu.
> 
> My curiosity about the other one in the exit/unregister/release paths
> is if it really ever triggered with KVM. Because I can't easily see
> how it could trigger. By the time kvm_destroy_vm or exit_mmap() runs,
> no vcpu can be in guest mode anymore, so it cannot matter whatever the
> status of any leftover spte at that time.
> 

vcpu is not in guest mode, but the memory can be still hold in KVM MMU.

Consider this case:

   CPU 0                      CPU 1

   create kvm
   create vcpu thread

   [ Guest is happily running ]

                          send kill signal to the process

   call do_exit
      mmput mm
      exit_mmap, then
         delete mmu_notify

                         reclaim the memory of these threads
                            !!!!!!
                         Now, the page has been reclaimed but
                         it is still hold in KVM MMU

        mmu_notify->release
             !!!!!!
           delete spte, and call
           mark_page_accessed/mark_page_dirty for
           the page which has already been freed on CPU 1


     exit_files
        release kvm/vcpu file, then
        kvm and vcpu are destroyed.


