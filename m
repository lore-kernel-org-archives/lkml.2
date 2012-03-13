Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab2CMXHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063Ab2CMXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:07:06 -0400
Date: Tue, 13 Mar 2012 20:04:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-ID: <20120313230412.GA12153@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
 <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 07:32:16PM +0900, Takuya Yoshikawa wrote:
> Dropped such mappings when we enabled dirty logging and we will never
> create new ones until we stop the logging.
> 
> For this we introduce a new function which can be used to write protect
> a range of PT level pages: although we do not need to care about a range
> of pages at this point, the following patch will need this feature to
> optimize the write protection of many pages.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> ---
>  arch/x86/include/asm/kvm_host.h |    5 ++-
>  arch/x86/kvm/mmu.c              |   40 +++++++++++++++++++++++++++++---------
>  arch/x86/kvm/x86.c              |    8 ++----
>  3 files changed, 36 insertions(+), 17 deletions(-)

This is a race with hugetlbfs which is not an issue ATM (it is 
hidden by the removal of huge sptes in get_dirty).


guest fault                                     enable dirty logging

tdp_page_fault (all _page_fault functions)      kvm_set_memory_region


level = mapping_level(vcpu, gfn)
(finds level == 2 or 3)


                                                rcu_assign_pointer(slot
								   with 
                                                                   ->dirty_bitmap)
                                                synchronize_srcu_expedited()
schedule()
                                                kvm_arch_commit_memory_region()
                                                spin_lock(mmu_lock)
                                                kvm_mmu_slot_remove_write_access()
						removes large sptes
                                                spin_unlock(mmu_lock)
spin_lock(mmu_lock)
create large spte accordingly
to level above
spin_unlock(mmu_lock)

Not removing large sptes in get_dirty means this racy sptes could
live from the start of migration to the end of it.

It can be fixed with a preceding patch that checks whether
slot->dirty_bitmap value changes between mapping_level and after
mmu_lock acquision, similarly to mmu_seq. Also please add a 
WARN_ON in mmu_set_spte if(slot->dirty_bitmap && level > 1).
And document it clearly.


