Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2HVQh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:37:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab2HVQhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:37:52 -0400
Date: Wed, 22 Aug 2012 18:37:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between
 secondary MMU and host
Message-ID: <20120822163746.GU29978@redhat.com>
References: <503358FF.3030009@linux.vnet.ibm.com>
 <20120821150618.GJ27696@redhat.com>
 <50345735.2000807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50345735.2000807@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:51:17AM +0800, Xiao Guangrong wrote:
> Hmm, in KSM code, i found this code in replace_page:
> 
> set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
> 
> It is possible to establish a writable pte, no?

Hugh already answered this thanks. Further details on the vm_page_prot
are in top of mmap.c, and KSM never scans MAP_SHARED vmas.

> Unfortunately, all these bugs are triggered by test cases.

Sure, I've seen the very Oops for the other one, and this one also can
trigger if unlucky.

This one can trigger with KVM but only if KSM is enabled or with live
migration or with device hotplug or some other event that triggers a
fork in qemu.

My curiosity about the other one in the exit/unregister/release paths
is if it really ever triggered with KVM. Because I can't easily see
how it could trigger. By the time kvm_destroy_vm or exit_mmap() runs,
no vcpu can be in guest mode anymore, so it cannot matter whatever the
status of any leftover spte at that time.

The process in the oops certainly wasn't qemu*. This is what I meant
in the previous email about this. Of course the fix was certainly good
and needed for other mmu notifier users, great fix.

Thanks,
Andrea
