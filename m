Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2LRHxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:53:40 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41749 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2LRHxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:53:34 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 02:53:30 EST
Date: Tue, 18 Dec 2012 16:30:45 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] KVM: Conditionally reschedule when
 kvm_mmu_slot_remove_write_access() takes a long time
Message-Id: <20121218163045.3f1c169e.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the userspace starts dirty logging for a large slot, say 64GB of
memory, kvm_mmu_slot_remove_write_access() needs to hold mmu_lock for
a long time such as tens of milliseconds.  This patch controls the lock
hold time by asking the scheduler if we need to reschedule for others.

One penalty for this is that we need to flush TLBs before releasing
mmu_lock.  But since holding mmu_lock for a long time does affect not
only the guest, vCPU threads in other words, but also the host as a
whole, we should pay for that.

In practice, the cost will not be so high because we can protect a fair
amount of memory before being rescheduled: on my test environment,
cond_resched_lock() was called only once for protecting 12GB of memory
even without THP.  We can also revisit Avi's "unlocked TLB flush" work
later for completely suppressing extra TLB flushes if needed.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b7a1235..a32e8cf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4212,6 +4212,11 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		for (index = 0; index <= last_index; ++index, ++rmapp) {
 			if (*rmapp)
 				__rmap_write_protect(kvm, rmapp, false);
+
+			if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+				kvm_flush_remote_tlbs(kvm);
+				cond_resched_lock(&kvm->mmu_lock);
+			}
 		}
 	}
 
-- 
1.7.5.4

