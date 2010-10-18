Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab0JRUs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:48:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61160 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab0JRUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:48:25 -0400
Message-ID: <4CBCB274.7010108@kernel.org>
Date: Mon, 18 Oct 2010 13:47:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, irq: Check if irq is remapped before freeing irte
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On one system that support intr-rempping when boot with "intremap=off"

got:
[  177.824202] calling  alsa_card_azx_init+0x0/0x1b @ 1
[  177.843968] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  177.848210] HDA Intel 0000:00:1b.0: irq 1435 for MSI/MSI-X
[  177.863797] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  177.895084] hda-intel: no codecs found!
[  177.895501] BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
[  177.913316] IP: [<ffffffff8145fc18>] free_irte+0x47/0xc0
[  177.913859] PGD 0 
[  177.914037] Oops: 0000 [#1] SMP 
[  177.933240] last sysfs file: 
[  177.933501] CPU 0 
[  177.933655] Modules linked in:
[  177.933937] 
[  177.934078] Pid: 15044, comm: work_for_cpu Not tainted 2.6.36-rc8-tip-yh-01994-g95100d0-dirty #198      /Sun Fire X4800
[  177.953986] RIP: 0010:[<ffffffff8145fc18>]  [<ffffffff8145fc18>] free_irte+0x47/0xc0
...
[  178.173326] Call Trace:
[  178.173574]  [<ffffffff810515b4>] destroy_irq+0x3a/0x75
[  178.192934]  [<ffffffff81051834>] arch_teardown_msi_irq+0xe/0x10
[  178.193418]  [<ffffffff81458dc3>] arch_teardown_msi_irqs+0x56/0x7f
[  178.213021]  [<ffffffff81458e79>] free_msi_irqs+0x8d/0xeb
[  178.213490]  [<ffffffff81459673>] pci_disable_msi+0x35/0x3a
[  178.232956]  [<ffffffff81b68917>] azx_free+0x83/0x11c
[  178.233301]  [<ffffffff81cb1ec7>] azx_probe+0x7b1/0xab4
[  178.252885]  [<ffffffff810a59ef>] ? trace_hardirqs_on+0xd/0xf
[  178.253303]  [<ffffffff81442a50>] local_pci_probe+0x4d/0x96
[  178.272801]  [<ffffffff8108e72c>] ? do_work_for_cpu+0x0/0x2b
[  178.273270]  [<ffffffff8108e744>] do_work_for_cpu+0x18/0x2b
[  178.292785]  [<ffffffff8108e72c>] ? do_work_for_cpu+0x0/0x2b
[  178.293220]  [<ffffffff81094135>] kthread+0x9d/0xa5
[  178.312742]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[  178.313222]  [<ffffffff81cc96fc>] ? restore_args+0x0/0x30
[  178.332746]  [<ffffffff81094098>] ? kthread+0x0/0xa5
[  178.333207]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10

Root cause is that irq_2_iommu is embedded into irq_cfg now...

Need to check if that irq is really mapped, before free irte.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/intr_remapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -60,7 +60,7 @@ int get_irte(int irq, struct irte *entry
 	unsigned long flags;
 	int index;
 
-	if (!entry || !irq_iommu)
+	if (!entry || !irq_iommu || !irq_iommu->iommu)
 		return -1;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
@@ -268,7 +268,7 @@ int free_irte(int irq)
 	unsigned long flags;
 	int rc;
 
-	if (!irq_iommu)
+	if (!irq_iommu || !irq_iommu->iommu)
 		return -1;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
