Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab0JLQfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:35:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30077 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab0JLQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:35:11 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117744608"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 5/7] xen: add xen hvm acpi_register_gsi variant
Date: Tue, 12 Oct 2010 17:34:47 +0100
Message-Id: <1286901289-8156-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:35:10.0452 (UTC) FILETIME=[6FF2EB40:01CB6A2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/acpi.h |    3 +++
 arch/x86/kernel/acpi/boot.c |    3 ++-
 arch/x86/pci/xen.c          |    6 ++++++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 92091de..55d106b 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -93,6 +93,9 @@ extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
 void acpi_pic_sci_set_trigger(unsigned int, u16);
 
+extern int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
+				  int trigger, int polarity);
+
 static inline void disable_acpi(void)
 {
 	acpi_disabled = 1;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 031f0c2..71232b9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -537,7 +537,8 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	return gsi;
 }
 
-static int (*__acpi_register_gsi)(struct device *dev, u32 gsi, int trigger, int polarity) = acpi_register_gsi_pic;
+int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
+			   int trigger, int polarity) = acpi_register_gsi_pic;
 
 /*
  * success: return IRQ number (>=0)
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index e7f897b..ef9b8b2 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -53,6 +53,12 @@ static int xen_hvm_register_pirq(u32 gsi, int triggering)
 
 	return irq;
 }
+
+static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
+				 int trigger, int polarity)
+{
+	return xen_hvm_register_pirq(gsi, trigger);
+}
 #endif
 
 #if defined(CONFIG_PCI_MSI)
-- 
1.5.6.5

