Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658Ab2D0QXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:23:40 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:60265 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229Ab2D0QXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:23:38 -0400
Subject: [RFC PATCH v1 0/5] KVM paravirt remote flush tlb
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, avi@redhat.com,
        hpa@zytor.com
Date: Fri, 27 Apr 2012 21:53:02 +0530
Message-ID: <20120427161727.27082.43096.stgit@abhimanyu>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12042716-3864-0000-0000-000002765D26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remote flushing api's does a busy wait which is fine in bare-metal
scenario. But with-in the guest, the vcpus might have been pre-empted
or blocked. In this scenario, the initator vcpu would end up
busy-waiting for a long amount of time.

This was discovered in our gang scheduling test and other way to solve
this is by para-virtualizing the flush_tlb_others_ipi.

This patch set implements para-virt flush tlbs making sure that it
does not wait for vcpus that are sleeping. And all the sleeping vcpus
flush the tlb on guest enter. Idea was discussed here:
https://lkml.org/lkml/2012/2/20/157

This patch depends on ticketlocks[1] and KVM Paravirt Spinlock patches[2]
Based to 3.4.0-rc4 (commit: af3a3ab2)

Here are the results from non-PLE hardware. Running ebizzy workload
inside the VMs. The table shows the normalized ebizzy score wrt to the
baseline.

Machine:
8CPU Intel Xeon, HT disabled, 64 bit VM(8vcpu, 1G RAM)

	Gang    pv_spin     pv_flush    pv_spin_flush    
1VM     1.01      0.30        1.01         0.49
2VMs    7.07      0.53        0.91         4.04
4VMs    9.07      0.59        0.31         5.27
8VMs    9.99      1.58        0.48         7.65

Perf report from the guest VM:
Base:
    41.25%       [k] flush_tlb_others_ipi
    41.21%       [k] __bitmap_empty
     7.66%       [k] _raw_spin_unlock_irqrestore
     3.07%       [.] __memcpy_ssse3_back
     1.20%       [k] clear_page

gang:
    22.92%       [.] __memcpy_ssse3_back
    15.46%       [k] _raw_spin_unlock_irqrestore
     9.82%       [k] clear_page
     6.35%       [k] do_page_fault
     4.57%       [k] down_read_trylock
     3.36%       [k] __mem_cgroup_commit_charge
     3.26%       [k] __x2apic_send_IPI_mask
     3.23%       [k] up_read
     2.87%       [k] __bitmap_empty
     2.78%       [k] flush_tlb_others_ipi

pv_spin:
    34.82%       [k] __bitmap_empty
    34.75%       [k] flush_tlb_others_ipi
    25.10%       [k] _raw_spin_unlock_irqrestore
     1.52%       [.] __memcpy_ssse3_back

pv_flush:
    37.34%       [k] _raw_spin_unlock_irqrestore
    18.26%       [k] native_halt
    11.58%       [.] __memcpy_ssse3_back
     4.83%       [k] clear_page
     3.68%       [k] do_page_fault

pv_spin_flush:
    71.13%       [k] _raw_spin_unlock_irqrestore
     8.89%       [.] __memcpy_ssse3_back
     4.68%       [k] native_halt
     3.92%       [k] clear_page
     2.31%       [k] do_page_fault

So looking at the perf output for pv_flush and pv_spin_flush, in both
the cases all the flush_tlb_others_ipi is no more contending for the
cpu and relinquishing the cpu for progress. 

Comments?

Regards
Nikunj

1. https://lkml.org/lkml/2012/4/19/335
2. https://lkml.org/lkml/2012/4/23/123

---

Nikunj A. Dadhania (5):
      KVM Guest: Add VCPU running/pre-empted state for guest
      KVM-HV: Add VCPU running/pre-empted state for guest
      KVM: Add paravirt kvm_flush_tlb_others
      KVM: export kvm_kick_vcpu for pv_flush
      KVM: Introduce PV kick in flush tlb


 arch/x86/include/asm/kvm_host.h |    7 ++++
 arch/x86/include/asm/kvm_para.h |   11 ++++++
 arch/x86/include/asm/tlbflush.h |    9 +++++
 arch/x86/kernel/kvm.c           |   52 +++++++++++++++++++++++++-----
 arch/x86/kvm/cpuid.c            |    1 +
 arch/x86/kvm/x86.c              |   50 ++++++++++++++++++++++++++++-
 arch/x86/mm/tlb.c               |   68 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 188 insertions(+), 10 deletions(-)

