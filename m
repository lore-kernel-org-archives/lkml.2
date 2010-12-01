Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0LAG4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:56:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:34092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0LAG4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:56:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="682661708"
Message-Id: <20101201062244.447287381@intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 30 Nov 2010 22:22:27 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: [patch 2/4] x86, vtd: fix the vt-d fault handling irq migration in the x2apic mode
References: <20101201062225.292364637@intel.com>
Content-Disposition: inline; filename=fix_dmar_set_affinity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: x86, vtd: fix the vt-d fault handling irq migration in the x2apic mode

In x2apic mode, we need to set the upper address register of the fault
handling interrupt register of the vt-d hardware. Without this
irq migration of the vt-d fault handling interrupt is broken.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [v2.6.32+]
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 file changed, 2 insertions(+)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3367,6 +3367,8 @@ dmar_msi_set_affinity(struct irq_data *d
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	if (x2apic_mode)
+		msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 


