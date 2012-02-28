Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab2B1CqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:46:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab2B1CqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:46:01 -0500
Date: Mon, 27 Feb 2012 18:45:20 -0800
From: tip-bot for Olof Johansson <olof@lixom.net>
Message-ID: <tip-a6a46f415dca828a04a435ca1f67de0bc5b9ae30@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        olof@lixom.net, tglx@linutronix.de, matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olof@lixom.net, tglx@linutronix.de, matt.fleming@intel.com
In-Reply-To: <1329081869-20779-4-git-send-email-olof@lixom.net>
References: <1329081869-20779-4-git-send-email-olof@lixom.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/eficross] x86, efi: Cleanup config table walking
Git-Commit-ID: a6a46f415dca828a04a435ca1f67de0bc5b9ae30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 18:45:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6a46f415dca828a04a435ca1f67de0bc5b9ae30
Gitweb:     http://git.kernel.org/tip/a6a46f415dca828a04a435ca1f67de0bc5b9ae30
Author:     Olof Johansson <olof@lixom.net>
AuthorDate: Sun, 12 Feb 2012 13:24:27 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 23 Feb 2012 18:54:33 -0800

x86, efi: Cleanup config table walking

Trivial cleanup, move guid and table pointers to local copies to
make the code cleaner.

Signed-off-by: Olof Johansson <olof@lixom.net>
Link: http://lkml.kernel.org/r/1329081869-20779-4-git-send-email-olof@lixom.net
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/platform/efi/efi.c |   61 +++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 511fb15..03259d1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -455,53 +455,48 @@ static void __init efi_systab_init(void *phys)
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
 		pr_err("Could not map Configuration table!\n");
 
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
