Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2GRT5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 15:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2GRT5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 15:57:15 -0400
Date: Wed, 18 Jul 2012 16:56:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 0/8] KVM: Optimize MMU notifier's THP page invalidation
 -v4
Message-ID: <20120718195628.GA18071@amt.cnet>
References: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 05:52:39PM +0900, Takuya Yoshikawa wrote:
> v3->v4: Resolved trace_kvm_age_page() issue -- patch 6,7
> v2->v3: Fixed intersection calculations. -- patch 3, 8
> 
> 	Takuya
> 
> Takuya Yoshikawa (8):
>   KVM: MMU: Use __gfn_to_rmap() to clean up kvm_handle_hva()
>   KVM: Introduce hva_to_gfn_memslot() for kvm_handle_hva()
>   KVM: MMU: Make kvm_handle_hva() handle range of addresses
>   KVM: Introduce kvm_unmap_hva_range() for kvm_mmu_notifier_invalidate_range_start()
>   KVM: Separate rmap_pde from kvm_lpage_info->write_count
>   KVM: MMU: Add memslot parameter to hva handlers
>   KVM: MMU: Push trace_kvm_age_page() into kvm_age_rmapp()
>   KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()
> 
>  arch/powerpc/include/asm/kvm_host.h |    2 +
>  arch/powerpc/kvm/book3s_64_mmu_hv.c |   47 ++++++++++++---
>  arch/x86/include/asm/kvm_host.h     |    3 +-
>  arch/x86/kvm/mmu.c                  |  107 +++++++++++++++++++++++------------
>  arch/x86/kvm/x86.c                  |   11 ++++
>  include/linux/kvm_host.h            |    8 +++
>  virt/kvm/kvm_main.c                 |    3 +-
>  7 files changed, 131 insertions(+), 50 deletions(-)
> 
> 
> >From v2:
> 
> The new test result was impressively good, see below, and THP page
> invalidation was more than 5 times faster on my x86 machine.
> 
> Before:
>   ...
>   19.852 us  |  __mmu_notifier_invalidate_range_start();
>   28.033 us  |  __mmu_notifier_invalidate_range_start();
>   19.066 us  |  __mmu_notifier_invalidate_range_start();
>   44.715 us  |  __mmu_notifier_invalidate_range_start();
>   31.613 us  |  __mmu_notifier_invalidate_range_start();
>   20.659 us  |  __mmu_notifier_invalidate_range_start();
>   19.979 us  |  __mmu_notifier_invalidate_range_start();
>   20.416 us  |  __mmu_notifier_invalidate_range_start();
>   20.632 us  |  __mmu_notifier_invalidate_range_start();
>   22.316 us  |  __mmu_notifier_invalidate_range_start();
>   ...
> 
> After:
>   ...
>   4.089 us   |  __mmu_notifier_invalidate_range_start();
>   4.096 us   |  __mmu_notifier_invalidate_range_start();
>   3.560 us   |  __mmu_notifier_invalidate_range_start();
>   3.376 us   |  __mmu_notifier_invalidate_range_start();
>   3.772 us   |  __mmu_notifier_invalidate_range_start();
>   3.353 us   |  __mmu_notifier_invalidate_range_start();
>   3.332 us   |  __mmu_notifier_invalidate_range_start();
>   3.332 us   |  __mmu_notifier_invalidate_range_start();
>   3.332 us   |  __mmu_notifier_invalidate_range_start();
>   3.337 us   |  __mmu_notifier_invalidate_range_start();
>   ...

Applied, thanks.

