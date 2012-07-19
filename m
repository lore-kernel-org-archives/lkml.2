Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2GSM7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:59:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40232 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2GSM7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:59:02 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86, mm: Send tlb flush IPIs to online cpus only
To: msb@chromium.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        shaohua.li@intel.com, yinghai@kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        akpm@linux-foundation.org, sfr@canb.auug.org.au, cl@gentwo.org,
        olofj@chromium.org, paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 19 Jul 2012 18:27:33 +0530
Message-ID: <20120719125643.30033.58913.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12071902-7014-0000-0000-00000194C149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep reports:
We are seeing a softlockup reporting during shutdown. The stack
trace shows us that we are inside default_send_IPI_mask_logical:

 BUG: soft lockup - CPU#0 stuck for 11s! [lmt-udev:23605]
 Pid: 23605, comm: lmt-udev Tainted: G        WC   3.2.7 #1
 EIP: 0060:[<8101eec6>] EFLAGS: 00000202 CPU: 0
 EIP is at flush_tlb_others_ipi+0x8a/0xba
 Call Trace:
  [<8101f0bb>] flush_tlb_mm+0x5e/0x62
  [<8101e36c>] pud_populate+0x2c/0x31
  [<8101e409>] pgd_alloc+0x98/0xc7
  [<8102c881>] mm_init.isra.38+0xcc/0xf3
  [<8102cbc2>] dup_mm+0x68/0x34e
  [<8139bbae>] ? _cond_resched+0xd/0x21
  [<810a5b7c>] ? kmem_cache_alloc+0x26/0xe2
  [<8102d421>] ? copy_process+0x556/0xda6
  [<8102d641>] copy_process+0x776/0xda6
  [<8102dd5e>] do_fork+0xcb/0x1d4
  [<810a8c96>] ? do_sync_write+0xd3/0xd3
  [<810a94ab>] ? vfs_read+0x95/0xa2
  [<81008850>] sys_clone+0x20/0x25
  [<8139d8c5>] ptregs_clone+0x15/0x30
  [<8139d7f7>] ? sysenter_do_call+0x12/0x26

Before the softlock, we see the following kernel warning:

 WARNING: at ../../arch/x86/kernel/apic/ipi.c:113 default_send_IPI_mask_logical+0x58/0x73()
 Pid: 23605, comm: lmt-udev Tainted: G         C   3.2.7 #1
 Call Trace:
  [<8102e666>] warn_slowpath_common+0x68/0x7d
  [<81016c36>] ? default_send_IPI_mask_logical+0x58/0x73
  [<8102e68f>] warn_slowpath_null+0x14/0x18
  [<81016c36>] default_send_IPI_mask_logical+0x58/0x73
  [<8101eec2>] flush_tlb_others_ipi+0x86/0xba
  [<8101f0bb>] flush_tlb_mm+0x5e/0x62
  [<8101e36c>] pud_populate+0x2c/0x31
  [<8101e409>] pgd_alloc+0x98/0xc7
  [<8102c881>] mm_init.isra.38+0xcc/0xf3
  [<8102cbc2>] dup_mm+0x68/0x34e
  [<8139bbae>] ? _cond_resched+0xd/0x21
  [<810a5b7c>] ? kmem_cache_alloc+0x26/0xe2
  [<8102d421>] ? copy_process+0x556/0xda6
  [<8102d641>] copy_process+0x776/0xda6
  [<8102dd5e>] do_fork+0xcb/0x1d4
  [<810a8c96>] ? do_sync_write+0xd3/0xd3
  [<810a94ab>] ? vfs_read+0x95/0xa2
  [<81008850>] sys_clone+0x20/0x25
  [<8139d8c5>] ptregs_clone+0x15/0x30
  [<8139d7f7>] ? sysenter_do_call+0x12/0x26

So we are sending an IPI to a cpu which is now offline. Once a cpu is offline,
it will no longer respond to IPIs. This explains the softlockup.

A cpu in the mm_cpumask could go offline before we send the invalidate
IPI causing us to wait forever. Avoid this by sending the IPI to only the
online cpus.

[Since flush_tlb_others_ipi() is always called with preempt disabled, it is
not possible for a CPU to go offline once we enter this function, because
CPU offline goes through the stop_machine() stuff (which cannot proceed until
all preempt disabled sections are exited). So we don't have to worry about
any race between CPU offline and the target cpumask calculation in
flush_tlb_others_ipi().]

Addresses http://crosbug.com/31737

Reported-and-debugged-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Olof Johansson <olofj@chromium.org>
---

 arch/x86/mm/tlb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5e57e11..9d387a9 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -186,7 +186,11 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 
 	f->flush_mm = mm;
 	f->flush_va = va;
-	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
+
+	cpumask_and(to_cpumask(f->flush_cpumask), cpumask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(f->flush_cpumask));
+
+	if (!cpumask_empty(to_cpumask(f->flush_cpumask))) {
 		/*
 		 * We have to send the IPI only to
 		 * CPUs affected.

