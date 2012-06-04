Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2FDFGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:06:22 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54501 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2FDFGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:06:20 -0400
Subject: [PATCH v2 0/7] KVM paravirt remote flush tlb
To: peterz@infradead.org, mingo@elte.hu, mtosatti@redhat.com, avi@redhat.com
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Date: Mon, 04 Jun 2012 10:35:41 +0530
Message-ID: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
x-cbid: 12060405-5564-0000-0000-0000030EDD1B
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

This also brings one more dependency for lock-less page walk that is
performed by get_user_pages_fast(gup_fast). gup_fast disables the
interrupt and assumes that the pages will not be freed during that
period. And this was fine as the flush_tlb_others_ipi would wait for
the all the IPI to be processed and return back. With the new approach
of not waiting for the sleeping vcpus, this assumption is not valid
anymore. So now HAVE_RCU_TABLE_FREE is used to free the pages. This
will make sure that all the cpus would atleast process smp_callback
before the pages are freed.

The patchset depends on ticketlocks[1] and KVM Paravirt Spinlock
patches[2]

Changelog from v1:
• Race fixes reported by Vatsa
• Address gup_fast dependency using PeterZ's rcu table free patch
• Fix rcu_table_free for hw pagetable walkers
• Increased SPIN_THRESHOLD 8k - to address the baseline numbers
  regression in ebizzy(non-ple). Raghu is working on tuning the
  threshold value along with the ple_window and ple_gap.

Here are the results from PLE hardware. Here is the setup details:
• 8 CPUs (HT disabled)
• 64-bit VM
   • 8vcpus
   • 1GB RAM

Numbers are % improvement/degradation wrt base kernel 3.4.0-rc4
(commit: af3a3ab2) 

Note: SPINLOCK_THRESHOLD is set to 8192

gang - Base kernel + gang scheduling patches
pvspin - Base kernel + ticketlocks patches + paravirt spinlock patches
pvflush - Base kernel + paravirt tlb flush patches
pvall - pvspin + paravirt tlb flush patches
pvallnople - pvall and PLE is disabled(ple_gap = 0) 

+-------------+-----------+-----------+-----------+-----------+-----------+
|             |   gang    |  pvspin   |  pvflush  |   pvall   | pvallnople|
+-------------+-----------+-----------+-----------+-----------+-----------+
|  ebizzy-1vm |        2  |        2  |        3  |      -11  |         4 |
|  ebizzy-2vm |      156  |       15  |      -58  |      343  |       110 | 
|  ebizzy-4vm |      238  |       14  |      -42  |       17  |        47 |
+-------------+-----------+-----------+-----------+-----------+-----------+
| specjbb-1vm |        3  |        5  |        3  |        3  |         2 |
| specjbb-2vm |      -10  |        3  |        2  |        2  |         3 |
| specjbb-4vm |        1  |        4  |        3  |        4  |         4 |
+-------------+-----------+-----------+-----------+-----------+-----------+
|  hbench-1vm |      -14  |      -58  |       -1  |        2  |         7 |
|  hbench-2vm |      -35  |       -5  |        7  |       11  |        12 |
|  hbench-4vm |       19  |        8  |       -1  |       14  |        35 |
+-------------+-----------+-----------+-----------+-----------+-----------+
|  dbench-1vm |       -1  |      -17  |      -25  |       -7  |       -18 |
|  dbench-2vm |        3  |       -4  |        1  |        5  |         3 |
|  dbench-4vm |        8  |        6  |       22  |        6  |        -6 |
+-------------+-----------+-----------+-----------+-----------+-----------+
|  kbench-1vm |     -100  |        8  |        4  |        5  |         7 |
|  kbench-2vm |        7  |        9  |        0  |       -2  |        -2 |
|  kbench-4vm |       12  |       -1  |        0  |       -6  |       -15 |
+-------------+-----------+-----------+-----------+-----------+-----------+
| sysbnch-1vm |        4  |        1  |        3  |        4  |         5 |
| sysbnch-2vm |       73  |       15  |       29  |       34  |        49 |
| sysbnch-4vm |       22  |        2  |        9  |       17  |        31 |
+-------------+-----------+-----------+-----------+-----------+-----------+

Observations from the above table:
* pvall does well in most of the benchmarks.
* pvall does no do quite well for kernbench 2vm(-2%) and 4vm(-6%)

Other experiment that Vatsa suggested was to disable PLE. As the
paravirt patches provide similar functionality. So in those
experiments we did see notable improvements in hackbench and
sysbench. Kernbench degraded further, PLE does help kernbench. This
will be addressed by Raghu's directed yield approach.

Comments/suggestions welcome.

Regards
Nikunj

---

Nikunj A. Dadhania (6):
      KVM Guest: Add VCPU running/pre-empted state for guest
      KVM-HV: Add VCPU running/pre-empted state for guest
      KVM: Add paravirt kvm_flush_tlb_others
      KVM: export kvm_kick_vcpu for pv_flush
      KVM: Introduce PV kick in flush tlb
      Flush page-table pages before freeing them

Peter Zijlstra (1):
      kvm,x86: RCU based table free


 arch/Kconfig                        |    3 ++
 arch/powerpc/include/asm/pgalloc.h  |    1 +
 arch/s390/mm/pgtable.c              |    1 +
 arch/sparc/include/asm/pgalloc_64.h |    1 +
 arch/x86/Kconfig                    |   12 ++++++
 arch/x86/include/asm/kvm_host.h     |    7 ++++
 arch/x86/include/asm/kvm_para.h     |   15 ++++++++
 arch/x86/include/asm/tlbflush.h     |    9 +++++
 arch/x86/kernel/kvm.c               |   52 ++++++++++++++++++++++----
 arch/x86/kvm/cpuid.c                |    1 +
 arch/x86/kvm/x86.c                  |   57 ++++++++++++++++++++++++++++-
 arch/x86/mm/pgtable.c               |    6 ++-
 arch/x86/mm/tlb.c                   |   70 +++++++++++++++++++++++++++++++++++
 include/asm-generic/tlb.h           |    9 +++++
 mm/memory.c                         |   31 +++++++++++++++-
 15 files changed, 260 insertions(+), 15 deletions(-)

