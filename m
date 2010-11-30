Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0K3IdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:33:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43181 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0K3Ic7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:32:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CF4B686.2020902@jp.fujitsu.com>
Date: Tue, 30 Nov 2010 17:32:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        suresh.b.siddha@intel.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org, indou.takao@jp.fujitsu.com
Subject: [PATCH 2/2] dmar: Fix dmar interrupt affinity handling
References: <4CF4B597.4030708@jp.fujitsu.com>
In-Reply-To: <4CF4B597.4030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the problem that changing IRQ affinity of dmar fault interrupt
causes "No irq handler for vector (irq XX)" message and dmar fault
interrupts are never notified after that.

The dmar_msi_set_affinity() must configure upper address register of
remapping hardware interrupt in x2apic mode.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-next-20101125/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-next-20101125.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-next-20101125/arch/x86/kernel/apic/io_apic.c
@@ -3413,6 +3413,9 @@ dmar_msi_set_affinity(struct irq_data *d
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI;
+	if (x2apic_enabled())
+		msg.address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 


