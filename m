Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0DTG3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:29:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49548 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab0DTG3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:29:12 -0400
Message-ID: <4BCD49C9.8090604@cn.fujitsu.com>
Date: Tue, 20 Apr 2010 14:29:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [BUG] kvm: dereference srcu-protected pointer without srcu_read_lock()
 held
References: <4BCC2543.7050104@cn.fujitsu.com> <4BCC295D.1040807@cn.fujitsu.com> <4BCC2B9D.8050008@redhat.com> <20100420014504.GB17981@amt.cnet>
In-Reply-To: <20100420014504.GB17981@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Mon, Apr 19, 2010 at 01:08:29PM +0300, Avi Kivity wrote:
>> On 04/19/2010 12:58 PM, Lai Jiangshan wrote:
>>> Applied the patch I just sent and let CONFIG_PROVE_RCU=y,
>>> we can got the following dmesg. And we found that it is
>>> because some codes in KVM dereferences srcu-protected pointer without
>>> srcu_read_lock() held or update-side lock held.
>>>
>>> It is not hard to fix, the problem is that:
>>> Where is the most proper place to put a srcu_read_lock()?
>>>
>>> I can not determine the answer, so I report this bug
>>> instead of fixing it.
>>>
>> I think the else branch in complete_pio() should work.  Marcelo?
>>
>> Longer term I'd like to see the lock taken at the high levels
>> (ioctls, in virt/kvm) and dropped only for guest entry and when we
>> explicitly sleep (hlt emulation).
>>
>> Note: complete_pio() is gone in the current code.
> 
> Yes, this was fixed by 7fb2ea1e6.
> 
> 

Applied the patch I sent yesterday and let CONFIG_PROVE_RCU=y
I can get the following dmesg.

Under very simple test, these is no complaint from PROVE_RCU
after this patch applied.

More test or reviewing of code are need in future.

----------
Subject: [PATCH] kvm: add missing srcu_read_lock()

I got this dmesg due to srcu_read_lock() is missing in
kvm_mmu_notifier_release().

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
arch/x86/kvm/x86.h:72 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by qemu-system-x86/3100:
 #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff810d73dc>] __mmu_notifier_release+0x38/0xdf
 #1:  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<ffffffffa0130a6a>] kvm_mmu_zap_all+0x21/0x5e [kvm]

stack backtrace:
Pid: 3100, comm: qemu-system-x86 Not tainted 2.6.34-rc3-22949-gbc8a97a-dirty #2
Call Trace:
 [<ffffffff8106afd9>] lockdep_rcu_dereference+0xaa/0xb3
 [<ffffffffa0123a89>] unalias_gfn+0x56/0xab [kvm]
 [<ffffffffa0119600>] gfn_to_memslot+0x16/0x25 [kvm]
 [<ffffffffa012ffca>] gfn_to_rmap+0x17/0x6e [kvm]
 [<ffffffffa01300c1>] rmap_remove+0xa0/0x19d [kvm]
 [<ffffffffa0130649>] kvm_mmu_zap_page+0x109/0x34d [kvm]
 [<ffffffffa0130a7e>] kvm_mmu_zap_all+0x35/0x5e [kvm]
 [<ffffffffa0122870>] kvm_arch_flush_shadow+0x16/0x22 [kvm]
 [<ffffffffa01189e0>] kvm_mmu_notifier_release+0x15/0x17 [kvm]
 [<ffffffff810d742c>] __mmu_notifier_release+0x88/0xdf
 [<ffffffff810d73dc>] ? __mmu_notifier_release+0x38/0xdf
 [<ffffffff81040848>] ? exit_mm+0xe0/0x115
 [<ffffffff810c2cb0>] exit_mmap+0x2c/0x17e
 [<ffffffff8103c472>] mmput+0x2d/0xd4
 [<ffffffff81040870>] exit_mm+0x108/0x115
[...]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a5dfea1..a6d639d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -341,7 +341,11 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
 	kvm_arch_flush_shadow(kvm);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
