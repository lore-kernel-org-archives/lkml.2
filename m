Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2LSMhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:37:43 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63815 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2LSMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:37:34 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 07:37:34 EST
Date: Wed, 19 Dec 2012 21:30:37 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Cc: mtosatti@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-Id: <20121219213037.b234f9d4f187df2132e65576@gmail.com>
In-Reply-To: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Alex,

I tested kvm.git next branch before Alex's patch set was applied, and
did not see the bug.  Although I'm not 100% sure but it is possible
that something got broken by a patch in the following series:

[01/10] KVM: Restrict non-existing slot state transitions
[02/10] KVM: Check userspace_addr when modifying a memory slot
[03/10] KVM: Fix iommu map/unmap to handle memory slot moves
[04/10] KVM: Minor memory slot optimization
[05/10] KVM: Rename KVM_MEMORY_SLOTS -> KVM_USER_MEM_SLOTS
[06/10] KVM: Make KVM_PRIVATE_MEM_SLOTS optional
[07/10] KVM: struct kvm_memory_slot.user_alloc -> bool
[08/10] KVM: struct kvm_memory_slot.flags -> u32
[09/10] KVM: struct kvm_memory_slot.id -> short
[10/10] KVM: Increase user memory slots on x86 to 125

If I can get time, I will check which one caused the problem tomorrow.

Thanks,
	Takuya


On Tue, 18 Dec 2012 16:25:58 +0900
Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp> wrote:

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
