Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2DXWmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:42:16 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11909 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806Ab2DXWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:48 -0400
From: Greg Pearson <greg.pearson@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        Greg Pearson <greg.pearson@hp.com>
Subject: [PATCH 1/1] x86: Use x2apic physical mode based on FADT setting
Date: Tue, 24 Apr 2012 16:38:35 -0600
Message-Id: <1335307115-15480-1-git-send-email-greg.pearson@hp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide systems that do not support x2apic cluster mode
a mechanism to select x2apic physical mode using the
FADT FORCE_APIC_PHYSICAL_DESTINATION_MODE bit.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
---
 arch/x86/kernel/apic/x2apic_phys.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8a778db..c372926 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -6,6 +6,10 @@
 #include <linux/init.h>
 #include <linux/dmar.h>
 
+#ifdef CONFIG_ACPI
+#include <linux/acpi.h>
+#endif
+
 #include <asm/smp.h>
 #include <asm/x2apic.h>
 
@@ -24,6 +28,14 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (x2apic_phys)
 		return x2apic_enabled();
+#ifdef CONFIG_ACPI
+	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
+		x2apic_enabled()) {
+		printk(KERN_DEBUG "System requires x2apic physical mode\n");
+		return 1;
+	}
+#endif
 	else
 		return 0;
 }
-- 
1.7.5.4

