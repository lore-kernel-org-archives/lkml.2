Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3AGUho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:37:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3AGUh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:37:27 -0500
Date: Mon, 7 Jan 2013 18:36:42 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-ID: <20130107203642.GA23155@amt.cnet>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:25:58PM +0900, Takuya Yoshikawa wrote:
> This patch set makes kvm_mmu_slot_remove_write_access() rmap based and
> adds conditional rescheduling to it.
> 
> The motivation for this change is of course to reduce the mmu_lock hold
> time when we start dirty logging for a large memory slot.  You may not
> see the problem if you just give 8GB or less of the memory to the guest
> with THP enabled on the host -- this is for the worst case.

Neat.

Looks good, except patch 1 - 

a) don't understand why it is necessary and 
b) not confident its safe - isnt clearing necessary for KVM_SET_MEMORY
instances other than

!(old.flags & LOG_DIRTY) && (new.flags & LOG_DIRTY)

> 
> 
> IMPORTANT NOTE (not about this patch set):
> 
> I have hit the following bug many times with the current next branch,
> even WITHOUT my patches.  Although I do not know a way to reproduce this
> yet, it seems that something was broken around slot->dirty_bitmap.  I am
> now investigating the new code in __kvm_set_memory_region().
> 
> The bug:
> [  575.238063] BUG: unable to handle kernel paging request at 00000002efe83a77
> [  575.238185] IP: [<ffffffffa05f9619>] mark_page_dirty_in_slot+0x19/0x20 [kvm]
> [  575.238308] PGD 0 
> [  575.238343] Oops: 0002 [#1] SMP 
> 
> The call trace:
> [  575.241207] Call Trace:
> [  575.241257]  [<ffffffffa05f96b1>] kvm_write_guest_cached+0x91/0xb0 [kvm]
> [  575.241370]  [<ffffffffa0610db9>] kvm_arch_vcpu_ioctl_run+0x1109/0x12c0 [kvm]
> [  575.241488]  [<ffffffffa060fd55>] ? kvm_arch_vcpu_ioctl_run+0xa5/0x12c0 [kvm]
> [  575.241595]  [<ffffffff81679194>] ? mutex_lock_killable_nested+0x274/0x340
> [  575.241706]  [<ffffffffa05faf80>] ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
> [  575.241813]  [<ffffffffa05f71c9>] kvm_vcpu_ioctl+0x559/0x670 [kvm]
> [  575.241913]  [<ffffffffa05f8a58>] ? kvm_vm_ioctl+0x1b8/0x570 [kvm]
> [  575.242007]  [<ffffffff8101b9d3>] ? native_sched_clock+0x13/0x80
> [  575.242125]  [<ffffffff8101ba49>] ? sched_clock+0x9/0x10
> [  575.242208]  [<ffffffff8109015d>] ? sched_clock_cpu+0xbd/0x110
> [  575.242298]  [<ffffffff811a914c>] ? fget_light+0x3c/0x140
> [  575.242381]  [<ffffffff8119dfa8>] do_vfs_ioctl+0x98/0x570
> [  575.242463]  [<ffffffff811a91b1>] ? fget_light+0xa1/0x140
> [  575.246393]  [<ffffffff811a914c>] ? fget_light+0x3c/0x140
> [  575.250363]  [<ffffffff8119e511>] sys_ioctl+0x91/0xb0
> [  575.254327]  [<ffffffff81684c19>] system_call_fastpath+0x16/0x1b
> 
> 
> Takuya Yoshikawa (7):
>   KVM: Write protect the updated slot only when we start dirty logging
>   KVM: MMU: Remove unused parameter level from __rmap_write_protect()
>   KVM: MMU: Make kvm_mmu_slot_remove_write_access() rmap based
>   KVM: x86: Remove unused slot_bitmap from kvm_mmu_page
>   KVM: Make kvm_mmu_change_mmu_pages() take mmu_lock by itself
>   KVM: Make kvm_mmu_slot_remove_write_access() take mmu_lock by itself
>   KVM: Conditionally reschedule when kvm_mmu_slot_remove_write_access() takes a long time
> 
>  Documentation/virtual/kvm/mmu.txt |    7 ----
>  arch/x86/include/asm/kvm_host.h   |    5 ---
>  arch/x86/kvm/mmu.c                |   56 +++++++++++++++++++-----------------
>  arch/x86/kvm/x86.c                |   13 +++++---
>  virt/kvm/kvm_main.c               |    1 -
>  5 files changed, 38 insertions(+), 44 deletions(-)
> 
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
