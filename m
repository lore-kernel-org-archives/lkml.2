Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2JFUTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:19:51 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38888 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JFUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:19:45 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 33/49] tools/power/acpi/acpidump: version 20070714
Date: Sat,  6 Oct 2012 16:09:54 -0400
Message-Id: <981efe9ab9e91e13ec75836300515428a30017df.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This is unchanged version 20070714, plus a small bit in
DEFINE_ALTERNATE_TYPES to enable building with latest kernel headers.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/acpi/Makefile   |   7 ++-
 tools/power/acpi/acpidump.c | 127 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 103 insertions(+), 31 deletions(-)

diff --git a/tools/power/acpi/Makefile b/tools/power/acpi/Makefile
index faf5ff5..dad79a6 100644
--- a/tools/power/acpi/Makefile
+++ b/tools/power/acpi/Makefile
@@ -1,11 +1,10 @@
-PROG=	acpidump
+PROG= acpidump
 SRCS=	acpidump.c
 KERNEL_INCLUDE := ../../../include
-CFLAGS += -Wall -Wstrict-prototypes -Os -s -D_LINUX -DDEFINE_ALTERNATE_TYPES -I$(KERNEL_INCLUDE) 
+CFLAGS += -Wall -Wstrict-prototypes -Wdeclaration-after-statement -Os -s -D_LINUX -DDEFINE_ALTERNATE_TYPES -I$(KERNEL_INCLUDE) 
 
 all: acpidump
-
-acpidump : $(SRCS) 
+$(PROG) : $(SRCS)
 	$(CC) $(CFLAGS) $(SRCS) -o $(PROG)
 
 CLEANFILES= $(PROG)
diff --git a/tools/power/acpi/acpidump.c b/tools/power/acpi/acpidump.c
index 3bb8e82..8e5e194 100644
--- a/tools/power/acpi/acpidump.c
+++ b/tools/power/acpi/acpidump.c
@@ -1,5 +1,6 @@
 /*
  * (c) Alexey Starikovskiy, Intel, 2005-2006.
+ * (c) Len Brown, Intel, 2007.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -185,6 +186,40 @@ static void acpi_show_data(int fd, u8 * data, int size)
 /*
  * Output ACPI table
  */
+
+#define MAX_TABLES 128
+int next_table_dump;
+u64 dumped_tables[MAX_TABLES];
+
+void
+set_table_dumped(u64 address) {
+	if (next_table_dump >= MAX_TABLES) {
+		printf("increase MAX_TABLES\n");
+		exit(1);
+	}
+	dumped_tables[next_table_dump++] = address;
+}
+
+/*
+ * list the tables as they are dumped
+ * check the list so that they are not dumped twice.
+ *
+ * this is needed because we follow both the XSDT and RSDT
+ * which generally point to all duplicate tables
+ * except the FADT
+ */
+int
+check_table_dumped(u64 address) {
+	int i;
+
+	for (i = 0; i < MAX_TABLES; ++i) {
+		if (address == dumped_tables[i])
+			return 1;
+		if (dumped_tables[i] == 0)
+			return 0;
+	}
+	return 0;
+}
 static void acpi_show_table(int fd, struct acpi_table_header *table, unsigned long addr)
 {
 	char buff[80];
@@ -198,6 +233,10 @@ static void acpi_show_table(int fd, struct acpi_table_header *table, unsigned lo
 static void write_table(int fd, struct acpi_table_header *tbl, unsigned long addr)
 {
 	static int select_done = 0;
+
+	if (check_table_dumped((u64)addr))
+		return;
+
 	if (!select_sig[0]) {
 		if (print) {
 			acpi_show_table(fd, tbl, addr);
@@ -216,6 +255,7 @@ static void write_table(int fd, struct acpi_table_header *tbl, unsigned long add
 		}
 		select_done = 1;
 	}
+	set_table_dumped((u64) addr);
 }
 
 static void acpi_dump_FADT(int fd, struct acpi_table_header *tbl, unsigned long xaddr) {
@@ -272,30 +312,26 @@ no_facs:
 	write_table(fd, (struct acpi_table_header *)&x, xaddr);
 }
 
-static int acpi_dump_SDT(int fd, struct acpi_rsdp_descriptor *rsdp)
+
+static int acpi_dump_RSDT(int fd, struct acpi_rsdp_descriptor *rsdp)
 {
 	struct acpi_table_header *sdt, *tbl = 0;
-	int xsdt = 1, i, num;
+	int i, num;
 	char *offset;
 	unsigned long addr;
-	if (rsdp->revision > 1 && rsdp->xsdt_physical_address) {
-		tbl = acpi_map_table(rsdp->xsdt_physical_address, "XSDT");
-	}
-	if (!tbl && rsdp->rsdt_physical_address) {
-		xsdt = 0;
-		tbl = acpi_map_table(rsdp->rsdt_physical_address, "RSDT");
-	}
+
+	tbl = acpi_map_table(rsdp->rsdt_physical_address, "RSDT");
 	if (!tbl) return 0;
+
 	sdt = malloc(tbl->length);
 	memcpy(sdt, tbl, tbl->length);
 	acpi_unmap_table(tbl);
 	if (checksum((u8 *)sdt, sdt->length))
-		fprintf(stderr, "Wrong checksum for %s!\n", (xsdt)?"XSDT":"RSDT");
-	num = (sdt->length - sizeof(struct acpi_table_header))/((xsdt)?sizeof(u64):sizeof(u32));
+		fprintf(stderr, "Wrong checksum for %s!\n", "RSDT");
+	num = (sdt->length - sizeof(struct acpi_table_header))/sizeof(u32);
 	offset = (char *)sdt + sizeof(struct acpi_table_header);
-	for (i = 0; i < num; ++i, offset += ((xsdt) ? sizeof(u64) : sizeof(u32))) {
-		addr = (xsdt) ? (unsigned long)(*(u64 *)offset):
-				(unsigned long)(*(u32 *)offset);
+	for (i = 0; i < num; ++i, offset += sizeof(u32)) {
+		addr = (unsigned long)(*(u32 *)offset);
 		if (!addr) continue;
 		tbl = acpi_map_table(addr, 0);
 		if (!tbl) continue;
@@ -303,28 +339,63 @@ static int acpi_dump_SDT(int fd, struct acpi_rsdp_descriptor *rsdp)
 			acpi_dump_FADT(fd, tbl, addr);
 		} else {
 			if (checksum((u8 *)tbl, tbl->length))
-				fprintf(stderr, "Wrong checksum for generic table!\n");
+				fprintf(stderr, "Wrong checksum for %.4s!\n", tbl->signature);
 			write_table(fd, tbl, addr);
 		}
 		acpi_unmap_table(tbl);
 		if (connect) {
-			if (xsdt)
-				(*(u64*)offset) = lseek(fd, 0, SEEK_CUR);
-			else
-				(*(u32*)offset) = lseek(fd, 0, SEEK_CUR);
+			(*(u32*)offset) = lseek(fd, 0, SEEK_CUR);
 		}
 	}
-	if (xsdt) {
-		addr = (unsigned long)rsdp->xsdt_physical_address;
-		if (connect) {
-			rsdp->xsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+	addr = (unsigned long)rsdp->rsdt_physical_address;
+	if (connect) {
+		rsdp->rsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+	}
+	write_table(fd, sdt, addr);
+	free (sdt);
+	return 1;
+}
+
+
+static int acpi_dump_XSDT(int fd, struct acpi_rsdp_descriptor *rsdp)
+{
+	struct acpi_table_header *sdt, *tbl = 0;
+	int i, num;
+	char *offset;
+	unsigned long addr;
+	if (rsdp->revision > 1 && rsdp->xsdt_physical_address) {
+		tbl = acpi_map_table(rsdp->xsdt_physical_address, "XSDT");
+	}
+	if (!tbl) return 0;
+
+	sdt = malloc(tbl->length);
+	memcpy(sdt, tbl, tbl->length);
+	acpi_unmap_table(tbl);
+	if (checksum((u8 *)sdt, sdt->length))
+		fprintf(stderr, "Wrong checksum for %s!\n", "XSDT");
+	num = (sdt->length - sizeof(struct acpi_table_header))/sizeof(u64);
+	offset = (char *)sdt + sizeof(struct acpi_table_header);
+	for (i = 0; i < num; ++i, offset += sizeof(u64)) {
+		addr = (unsigned long)(*(u64 *)offset);
+		if (!addr) continue;
+		tbl = acpi_map_table(addr, 0);
+		if (!tbl) continue;
+		if (!memcmp(tbl->signature, FADT_SIG, 4)) {
+			acpi_dump_FADT(fd, tbl, addr);
+		} else {
+			if (checksum((u8 *)tbl, tbl->length))
+				fprintf(stderr, "Wrong checksum for %.4s\n", tbl->signature);
+			write_table(fd, tbl, addr);
 		}
-	} else {
-		addr = (unsigned long)rsdp->rsdt_physical_address;
+		acpi_unmap_table(tbl);
 		if (connect) {
-			rsdp->rsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+			(*(u64*)offset) = lseek(fd, 0, SEEK_CUR);
 		}
 	}
+	addr = (unsigned long)rsdp->xsdt_physical_address;
+	if (connect) {
+		rsdp->xsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+	}
 	write_table(fd, sdt, addr);
 	free (sdt);
 	return 1;
@@ -469,7 +540,9 @@ int main(int argc, char **argv)
 	if (connect) {
 		lseek(fd, sizeof(struct acpi_rsdp_descriptor), SEEK_SET);
 	}
-	if (!acpi_dump_SDT(fd, &rsdpx))
+	if (!acpi_dump_XSDT(fd, &rsdpx))
+		goto not_found;
+	if (!acpi_dump_RSDT(fd, &rsdpx))
 		goto not_found;
 	if (connect) {
 		lseek(fd, 0, SEEK_SET);
-- 
1.8.0.rc0.18.gf84667d

