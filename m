Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab0JLUYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 16:24:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:49400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab0JLUYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 16:24:03 -0400
Date: Tue, 12 Oct 2010 20:23:45 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4CB00122.3030301@kernel.org>
References: <4CB00122.3030301@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Don't setup ioapic irq for sci twice
Message-ID: <tip-fe6dab4e79e82ec35879bfe1a8968b7d15ac0d91@git.kernel.org>
Git-Commit-ID: fe6dab4e79e82ec35879bfe1a8968b7d15ac0d91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 20:23:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe6dab4e79e82ec35879bfe1a8968b7d15ac0d91
Gitweb:     http://git.kernel.org/tip/fe6dab4e79e82ec35879bfe1a8968b7d15ac0d91
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 8 Oct 2010 22:44:02 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 16:53:40 +0200

x86: Don't setup ioapic irq for sci twice

The sparseirq rework triggered a warning in the iommu code, which was
caused by setting up ioapic for ACPI irq 9 twice. This function is
solely to handle interrupts which are on a secondary ioapic and
outside the legacy irq range.

Replace the sparse irq_to_desc check with a non ifdeffed version.

[ tglx: Moved it before the ioapic sparse conversion and simplified
  	the inverse logic ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CB00122.3030301@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/apic/io_apic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 06da8fe..5aae718 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1565,11 +1565,11 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
-#ifdef CONFIG_SPARSE_IRQ
-	desc = irq_to_desc(irq);
-	if (desc)
+
+	/* Only handle the non legacy irqs on secondary ioapics */
+	if (apic_id == 0 || irq < NR_IRQS_LEGACY)
 		return;
-#endif
+
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
