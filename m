Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab2BIDcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:32:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37385 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab2BIDcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:32:42 -0500
From: Tang Liang <liang.tang@oracle.com>
To: mjg59@srcf.ucam.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad.wilk@oracle.com
Cc: liang.tang@oracle.com
Subject: [PATCH 2/5] EFI: seperate get efi table info code to single function
Date: Thu,  9 Feb 2012 11:32:52 +0800
Message-Id: <1328758372-24202-1-git-send-email-liang.tang@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
References: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F333E54.0045,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seperate get efi table info code to generic function,
xen efi driver will call it too.

Signed-off-by: Tang Liang <liang.tang@oracle.com>
Suggested-by:: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/platform/efi/efi.c |   77 ++++++++++++++++++++++++-------------------
 include/linux/efi.h         |    2 +
 2 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d567e29..d7b19ee 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -446,6 +446,47 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
+void get_efi_table_info(efi_config_table_t *config_tables, int nr_tables,
+			struct efi *efi_t)
+{
+	int i;
+
+	printk(KERN_INFO);
+	for (i = 0; i < nr_tables; i++) {
+		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
+			efi_t->mps = config_tables[i].table;
+			printk(" MPS=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					ACPI_20_TABLE_GUID)) {
+			efi_t->acpi20 = config_tables[i].table;
+			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					ACPI_TABLE_GUID)) {
+			efi_t->acpi = config_tables[i].table;
+			printk(" ACPI=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					SMBIOS_TABLE_GUID)) {
+			efi_t->smbios = config_tables[i].table;
+			printk(" SMBIOS=0x%lx ", config_tables[i].table);
+#ifdef CONFIG_X86_UV
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					UV_SYSTEM_TABLE_GUID)) {
+			efi_t->uv_systab = config_tables[i].table;
+			printk(" UVsystab=0x%lx ", config_tables[i].table);
+#endif
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					HCDP_TABLE_GUID)) {
+			efi_t->hcdp = config_tables[i].table;
+			printk(" HCDP=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					UGA_IO_PROTOCOL_GUID)) {
+			efi_t->uga = config_tables[i].table;
+			printk(" UGA=0x%lx ", config_tables[i].table);
+		}
+	}
+	printk("\n");
+}
+
 static void efi_init_generic(void)
 {
 	efi_config_table_t *config_tables;
@@ -507,40 +548,8 @@ static void efi_init_generic(void)
 	if (config_tables == NULL)
 		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
 
-	printk(KERN_INFO);
-	for (i = 0; i < efi.systab->nr_tables; i++) {
-		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
-			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_20_TABLE_GUID)) {
-			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_TABLE_GUID)) {
-			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					SMBIOS_TABLE_GUID)) {
-			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx ", config_tables[i].table);
-#ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab = config_tables[i].table;
-			printk(" UVsystab=0x%lx ", config_tables[i].table);
-#endif
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					HCDP_TABLE_GUID)) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = config_tables[i].table;
-			printk(" UGA=0x%lx ", config_tables[i].table);
-		}
-	}
-	printk("\n");
+	get_efi_table_info(config_tables, efi.systab->nr_tables, &efi);
+
 	early_iounmap(config_tables,
 			  efi.systab->nr_tables * sizeof(efi_config_table_t));
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 62e0a1f..633371c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -474,6 +474,8 @@ extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 extern void efi_init_function_register(struct efi_init_funcs *funcs);
+extern void get_efi_table_info(efi_config_table_t *config_tables, int nr_tables,
+			       struct efi *efi_t);
 
 /**
  * efi_range_is_wc - check the WC bit on an address range
-- 
1.7.7.5

