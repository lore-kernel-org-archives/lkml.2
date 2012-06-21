Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2FUItI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:49:08 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58532 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886Ab2FUItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:49:05 -0400
Date: Thu, 21 Jun 2012 17:48:42 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 0/6] KVM: Optimize MMU notifier's THP page invalidation -v2
Message-Id: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added further optimization based on Avi's advice and my rmap_pde work.
 - patch [5-6]

The new test result was impressively good, see below, and THP page
invalidation was more than 5 times faster on my x86 machine.

I also noticed that GUI's responsiveness on the host during swapping the
guest's memory improved a lot.

Before:
  ...
  19.852 us  |  __mmu_notifier_invalidate_range_start();
  28.033 us  |  __mmu_notifier_invalidate_range_start();
  19.066 us  |  __mmu_notifier_invalidate_range_start();
  44.715 us  |  __mmu_notifier_invalidate_range_start();
  31.613 us  |  __mmu_notifier_invalidate_range_start();
  20.659 us  |  __mmu_notifier_invalidate_range_start();
  19.979 us  |  __mmu_notifier_invalidate_range_start();
  20.416 us  |  __mmu_notifier_invalidate_range_start();
  20.632 us  |  __mmu_notifier_invalidate_range_start();
  22.316 us  |  __mmu_notifier_invalidate_range_start();
  ...

After:
  ...
  4.089 us   |  __mmu_notifier_invalidate_range_start();
  4.096 us   |  __mmu_notifier_invalidate_range_start();
  3.560 us   |  __mmu_notifier_invalidate_range_start();
  3.376 us   |  __mmu_notifier_invalidate_range_start();
  3.772 us   |  __mmu_notifier_invalidate_range_start();
  3.353 us   |  __mmu_notifier_invalidate_range_start();
  3.332 us   |  __mmu_notifier_invalidate_range_start();
  3.332 us   |  __mmu_notifier_invalidate_range_start();
  3.332 us   |  __mmu_notifier_invalidate_range_start();
  3.337 us   |  __mmu_notifier_invalidate_range_start();
  ...

Takuya Yoshikawa (6):
  KVM: MMU: Use __gfn_to_rmap() to clean up kvm_handle_hva()
  KVM: Introduce hva_to_gfn_memslot() for kvm_handle_hva()
  KVM: MMU: Make kvm_handle_hva() handle range of addresses
  KVM: Introduce kvm_unmap_hva_range() for kvm_mmu_notifier_invalidate_range_start()
  KVM: Separate rmap_pde from kvm_lpage_info->write_count
  KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()

 arch/powerpc/include/asm/kvm_host.h |    2 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   42 +++++++++++++++-----
 arch/x86/include/asm/kvm_host.h     |    3 +-
 arch/x86/kvm/mmu.c                  |   72 +++++++++++++++++++++++------------
 arch/x86/kvm/x86.c                  |   13 ++++++-
 include/linux/kvm_host.h            |    8 ++++
 virt/kvm/kvm_main.c                 |    3 +-
 7 files changed, 104 insertions(+), 39 deletions(-)

-- 
1.7.5.4

