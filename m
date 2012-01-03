Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2ACRMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:12:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38623 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2ACRMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:12:00 -0500
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3/5] x86: efi: cleanup config table walking
Date: Tue,  3 Jan 2012 09:11:20 -0800
Message-Id: <1325610682-24811-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325610682-24811-1-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup, move guid and table pointers to local copies to
make the code cleaner.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 arch/x86/platform/efi/efi.c |   61 +++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 965b155..5d6696b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -454,53 +454,48 @@ static void __init efi_systab_init(void *phys)
 static void __init efi_config_init(u64 tables, int nr_tables)
 {
 	efi_config_table_t *config_tables;
-	int i;
+	int i, sz = sizeof(efi_config_table_t);
 
 	/*
 	 * Let's see what config tables the firmware passed to us.
 	 */
-	config_tables = early_ioremap(
-		efi.systab->tables,
-		efi.systab->nr_tables * sizeof(efi_config_table_t));
+	config_tables = early_ioremap(efi.systab->tables,
+				      efi.systab->nr_tables * sz);
 	if (config_tables == NULL)
 		pr_err("Could not map EFI Configuration Table!\n");
 
 	pr_info("");
 	for (i = 0; i < efi.systab->nr_tables; i++) {
-		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
-			efi.mps = config_tables[i].table;
-			pr_cont(" MPS=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_20_TABLE_GUID)) {
-			efi.acpi20 = config_tables[i].table;
-			pr_cont(" ACPI 2.0=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_TABLE_GUID)) {
-			efi.acpi = config_tables[i].table;
-			pr_cont(" ACPI=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					SMBIOS_TABLE_GUID)) {
-			efi.smbios = config_tables[i].table;
-			pr_cont(" SMBIOS=0x%lx ", config_tables[i].table);
+		efi_guid_t guid = config_tables[i].guid;
+		unsigned long table = config_tables[i].table;
+
+		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
+			efi.mps = table;
+			pr_cont(" MPS=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {
+			efi.acpi20 = table;
+			pr_cont(" ACPI 2.0=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {
+			efi.acpi = table;
+			pr_cont(" ACPI=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {
+			efi.smbios = table;
+			pr_cont(" SMBIOS=0x%lx ", table);
 #ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab = config_tables[i].table;
-			pr_cont(" UVsystab=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(guid, UV_SYSTEM_TABLE_GUID)) {
+			efi.uv_systab = table;
+			pr_cont(" UVsystab=0x%lx ", table);
 #endif
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					HCDP_TABLE_GUID)) {
-			efi.hcdp = config_tables[i].table;
-			pr_cont(" HCDP=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = config_tables[i].table;
-			pr_cont(" UGA=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {
+			efi.hcdp = table;
+			pr_cont(" HCDP=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {
+			efi.uga = table;
+			pr_cont(" UGA=0x%lx ", table);
 		}
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables,
-			  efi.systab->nr_tables * sizeof(efi_config_table_t));
+	early_iounmap(config_tables, efi.systab->nr_tables * sz);
 }
 
 static void __init efi_runtime_init(void)
-- 
1.7.8.GIT

