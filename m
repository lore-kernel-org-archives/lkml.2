Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1E1SQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:16:27 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58409 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab1E1SPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:15:06 -0400
Message-Id: <20110528181502.629531676@gulag1.americas.sgi.com>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 28 May 2011 13:15:06 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Intel pci: Remove Host Bridge devices from identity mapping
Content-Disposition: inline; filename=remove-pci-host-bridge-devices.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When using the 1:1 (identity) PCI DMA remapping, PCI Host Bridge
    devices that do not use the IOMMU causes a kernel panic.  Fix that
    by not inserting those devices into the si_domain.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Cc: stable@kernel.org
---

Specific panic message:

 IOMMU 0 0xfd020000: using Queued invalidation
 IOMMU 1 0xfd040000: using Queued invalidation
 IOMMU 2 0xfd060000: using Queued invalidation
 IOMMU 3 0xfd080000: using Queued invalidation
 IOMMU 4 0xfd0a0000: using Queued invalidation
 IOMMU 5 0xfd0c0000: using Queued invalidation
 IOMMU: hardware identity mapping for device 1000:3e:00.0
 Failed to setup IOMMU pass-through
 BUG: unable to handle kernel NULL pointer dereference at 000000000000001c
 IP: [<ffffffff816378fd>] _raw_spin_lock_irqsave+0xc/0x23
 PGD 0
 Oops: 0002 [#1] SMP
 last sysfs file:
 CPU 512
 Modules linked in:

 Pid: 1, comm: swapper Not tainted 2.6.39-rc7+ #2 Intel Corp. Stoutland Platform
 RIP: 0010:[<ffffffff816378fd>]  [<ffffffff816378fd>] _raw_spin_lock_irqsave+0xc/0x23
 RSP: 0000:ffff88105fd99d00  EFLAGS: 00010046
 RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000007
 RDX: 0000000000010000 RSI: 00000000000000b8 RDI: 000000000000001c
 RBP: ffff88105fd99d00 R08: 0000000000000000 R09: ffff88107d400470
 R10: 000000000000000a R11: 0000000000000086 R12: 000000000000001c
 R13: 00000000000000b8 R14: ffff88107d82947c R15: 0000000000000286
 FS:  0000000000000000(0000) GS:ffff88107fd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 000000000000001c CR3: 0000000001c03000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process swapper (pid: 1, threadinfo ffff88105fd98000, task ffff88105fd90000)
 Stack:
  ffff88105fd99d20 ffffffff812ad179 ffff88107d829400 ffff8b6ffe820f00
  ffff88105fd99d40 ffffffff8108eb2f ffff88105fd99d40 ffff88107d829400
  ffff88105fd99d80 ffffffff8108e396 ffff8beffa854c00 ffff88107d829400
 Call Trace:
  [<ffffffff812ad179>] dmar_msi_mask+0x17/0x3b
  [<ffffffff8108eb2f>] irq_shutdown+0x43/0x4e
  [<ffffffff8108e396>] __free_irq+0xd1/0x15d
  [<ffffffff8108e47b>] free_irq+0x59/0x72
  [<ffffffff812b09b3>] free_dmar_iommu+0x10a/0x1cb
  [<ffffffff812acc7f>] free_iommu+0x16/0x30
  [<ffffffff81e85564>] intel_iommu_init+0x8c1/0x9de
  [<ffffffff81e608c7>] ? dma32_reserve_bootmem+0x6/0x6
  [<ffffffff81e608dd>] pci_iommu_init+0x16/0x41
  [<ffffffff81000218>] do_one_initcall+0x7c/0x130
  [<ffffffff81e5b8a2>] kernel_init+0xf9/0x17e
  [<ffffffff8163eab4>] kernel_thread_helper+0x4/0x10
  [<ffffffff81e5b7a9>] ? do_early_param+0x89/0x89
  [<ffffffff8163eab0>] ? gs_change+0xb/0xb
 Code: b8 00 00 01 00 48 89 e5 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 eb f5 c9 c3 55 48 89 e5 9c 58 fa ba 00 00 01 00 <f0> 0f c1 17 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 0f b7 0f eb f5
 RIP  [<ffffffff816378fd>] _raw_spin_lock_irqsave+0xc/0x23
  RSP <ffff88105fd99d00>
 CR2: 000000000000001c
 ---[ end trace 32b2ebdae113b4c3 ]---
 swapper used greatest stack depth: 3952 bytes left
 Kernel panic - not syncing: Attempted to kill init!
 Pid: 1, comm: swapper Tainted: G      D     2.6.39-rc7+ #2
 Call Trace:
  [<ffffffff81040993>] panic+0xb7/0x1be
  [<ffffffff810338f5>] ? task_rq_unlock+0xc/0xe
  [<ffffffff810340d4>] ? sched_move_task+0xb0/0xbb
  [<ffffffff8107c479>] ? __put_css_set+0x24/0x150
  [<ffffffff81043d0c>] do_exit+0xa9/0x775
  [<ffffffff81040ccb>] ? spin_unlock_irqrestore+0x9/0xb
  [<ffffffff81638931>] oops_end+0xb3/0xbb
  [<ffffffff81027a01>] no_context+0x1f5/0x204
  [<ffffffff81027b92>] __bad_area_nosemaphore+0x182/0x1a5
  [<ffffffff81290b55>] ? __delay+0xa/0xc
  [<ffffffff81290b90>] ? __const_udelay+0x39/0x3b
  [<ffffffff81027c2b>] bad_area_nosemaphore+0xe/0x10
  [<ffffffff8163a65c>] do_page_fault+0x170/0x320
  [<ffffffff81290b55>] ? __delay+0xa/0xc
  [<ffffffff8130f8ec>] ? wait_for_xmitr+0x24/0x89
  [<ffffffff81040b9a>] ? __call_console_drivers+0x78/0x8a
  [<ffffffff8163e36e>] ? apic_timer_interrupt+0xe/0x20
  [<ffffffff81637edf>] page_fault+0x1f/0x30
  [<ffffffff816378fd>] ? _raw_spin_lock_irqsave+0xc/0x23
  [<ffffffff812ad179>] dmar_msi_mask+0x17/0x3b
  [<ffffffff8108eb2f>] irq_shutdown+0x43/0x4e
  [<ffffffff8108e396>] __free_irq+0xd1/0x15d
  [<ffffffff8108e47b>] free_irq+0x59/0x72
  [<ffffffff812b09b3>] free_dmar_iommu+0x10a/0x1cb
  [<ffffffff812acc7f>] free_iommu+0x16/0x30
  [<ffffffff81e85564>] intel_iommu_init+0x8c1/0x9de
  [<ffffffff81e608c7>] ? dma32_reserve_bootmem+0x6/0x6
  [<ffffffff81e608dd>] pci_iommu_init+0x16/0x41
  [<ffffffff81000218>] do_one_initcall+0x7c/0x130
  [<ffffffff81e5b8a2>] kernel_init+0xf9/0x17e
  [<ffffffff8163eab4>] kernel_thread_helper+0x4/0x10
  [<ffffffff81e5b7a9>] ? do_early_param+0x89/0x89
  [<ffffffff8163eab0>] ? gs_change+0xb/0xb

---
 drivers/pci/intel-iommu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -47,6 +47,8 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
+#define IS_BRIDGE_HOST_DEVICE(pdev) \
+			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -2214,6 +2216,9 @@ static int __init iommu_prepare_static_i
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
+		/* Skip Host/PCI Bridge devices */
+		if (IS_BRIDGE_HOST_DEVICE(pdev))
+			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
 			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
 			       hw ? "hardware" : "software", pci_name(pdev));

-- 
