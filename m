Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2JFUU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:20:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46806 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2JFUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:20:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 35/49] tools/power/acpi/acpidump: version 20101221 - find dynamic tables in sysfs
Date: Sat,  6 Oct 2012 16:09:56 -0400
Message-Id: <d4bb1c90c850c5163f28b1c04d16c5d85aaaf815.1349554106.git.len.brown@intel.com>
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

This is unchanged version 20101221, plus a small bit in
DEFINE_ALTERNATE_TYPES to enable building with latest kernel headers.

This version finds dynamic tables exported by Linux in
/sys/firmware/acpi/tables/dynamic

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/acpi/acpidump.c | 187 +++++++++++++++++++++-----------------------
 1 file changed, 89 insertions(+), 98 deletions(-)

diff --git a/tools/power/acpi/acpidump.c b/tools/power/acpi/acpidump.c
index a63dee9..0777987 100644
--- a/tools/power/acpi/acpidump.c
+++ b/tools/power/acpi/acpidump.c
@@ -1,6 +1,5 @@
 /*
  * (c) Alexey Starikovskiy, Intel, 2005-2006.
- * (c) Len Brown, Intel, 2007.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -63,6 +62,8 @@ typedef long long			s64;
 #include <unistd.h>
 #include <getopt.h>
 
+#include <sys/types.h>
+#include <dirent.h>
 
 #include <acpi/acconfig.h>
 #include <acpi/platform/acenv.h>
@@ -186,40 +187,6 @@ static void acpi_show_data(int fd, u8 * data, int size)
 /*
  * Output ACPI table
  */
-
-#define MAX_TABLES 128
-int next_table_dump;
-u64 dumped_tables[MAX_TABLES];
-
-void
-set_table_dumped(u64 address) {
-	if (next_table_dump >= MAX_TABLES) {
-		printf("increase MAX_TABLES\n");
-		exit(1);
-	}
-	dumped_tables[next_table_dump++] = address;
-}
-
-/*
- * list the tables as they are dumped
- * check the list so that they are not dumped twice.
- *
- * this is needed because we follow both the XSDT and RSDT
- * which generally point to all duplicate tables
- * except the FADT
- */
-int
-check_table_dumped(u64 address) {
-	int i;
-
-	for (i = 0; i < MAX_TABLES; ++i) {
-		if (address == dumped_tables[i])
-			return 1;
-		if (dumped_tables[i] == 0)
-			return 0;
-	}
-	return 0;
-}
 static void acpi_show_table(int fd, struct acpi_table_header *table, unsigned long addr)
 {
 	char buff[80];
@@ -233,10 +200,6 @@ static void acpi_show_table(int fd, struct acpi_table_header *table, unsigned lo
 static void write_table(int fd, struct acpi_table_header *tbl, unsigned long addr)
 {
 	static int select_done = 0;
-
-	if (check_table_dumped((u64)addr))
-		return;
-
 	if (!select_sig[0]) {
 		if (print) {
 			acpi_show_table(fd, tbl, addr);
@@ -255,7 +218,6 @@ static void write_table(int fd, struct acpi_table_header *tbl, unsigned long add
 		}
 		select_done = 1;
 	}
-	set_table_dumped((u64) addr);
 }
 
 static void acpi_dump_FADT(int fd, struct acpi_table_header *tbl, unsigned long xaddr) {
@@ -312,26 +274,30 @@ no_facs:
 	write_table(fd, (struct acpi_table_header *)&x, xaddr);
 }
 
-
-static int acpi_dump_RSDT(int fd, struct acpi_rsdp_descriptor *rsdp)
+static int acpi_dump_SDT(int fd, struct acpi_rsdp_descriptor *rsdp)
 {
 	struct acpi_table_header *sdt, *tbl = 0;
-	int i, num;
+	int xsdt = 1, i, num;
 	char *offset;
 	unsigned long addr;
-
-	tbl = acpi_map_table(rsdp->rsdt_physical_address, "RSDT");
+	if (rsdp->revision > 1 && rsdp->xsdt_physical_address) {
+		tbl = acpi_map_table(rsdp->xsdt_physical_address, "XSDT");
+	}
+	if (!tbl && rsdp->rsdt_physical_address) {
+		xsdt = 0;
+		tbl = acpi_map_table(rsdp->rsdt_physical_address, "RSDT");
+	}
 	if (!tbl) return 0;
-
 	sdt = malloc(tbl->length);
 	memcpy(sdt, tbl, tbl->length);
 	acpi_unmap_table(tbl);
 	if (checksum((u8 *)sdt, sdt->length))
-		fprintf(stderr, "Wrong checksum for %s!\n", "RSDT");
-	num = (sdt->length - sizeof(struct acpi_table_header))/sizeof(u32);
+		fprintf(stderr, "Wrong checksum for %s!\n", (xsdt)?"XSDT":"RSDT");
+	num = (sdt->length - sizeof(struct acpi_table_header))/((xsdt)?sizeof(u64):sizeof(u32));
 	offset = (char *)sdt + sizeof(struct acpi_table_header);
-	for (i = 0; i < num; ++i, offset += sizeof(u32)) {
-		addr = (unsigned long)(*(u32 *)offset);
+	for (i = 0; i < num; ++i, offset += ((xsdt) ? sizeof(u64) : sizeof(u32))) {
+		addr = (xsdt) ? (unsigned long)(*(u64 *)offset):
+				(unsigned long)(*(u32 *)offset);
 		if (!addr) continue;
 		tbl = acpi_map_table(addr, 0);
 		if (!tbl) continue;
@@ -339,66 +305,92 @@ static int acpi_dump_RSDT(int fd, struct acpi_rsdp_descriptor *rsdp)
 			acpi_dump_FADT(fd, tbl, addr);
 		} else {
 			if (checksum((u8 *)tbl, tbl->length))
-				fprintf(stderr, "Wrong checksum for %.4s!\n", tbl->signature);
+				fprintf(stderr, "Wrong checksum for generic table!\n");
 			write_table(fd, tbl, addr);
 		}
 		acpi_unmap_table(tbl);
 		if (connect) {
-			(*(u32*)offset) = lseek(fd, 0, SEEK_CUR);
+			if (xsdt)
+				(*(u64*)offset) = lseek(fd, 0, SEEK_CUR);
+			else
+				(*(u32*)offset) = lseek(fd, 0, SEEK_CUR);
 		}
 	}
-	addr = (unsigned long)rsdp->rsdt_physical_address;
-	if (connect) {
-		rsdp->rsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+	if (xsdt) {
+		addr = (unsigned long)rsdp->xsdt_physical_address;
+		if (connect) {
+			rsdp->xsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+		}
+	} else {
+		addr = (unsigned long)rsdp->rsdt_physical_address;
+		if (connect) {
+			rsdp->rsdt_physical_address = lseek(fd, 0, SEEK_CUR);
+		}
 	}
 	write_table(fd, sdt, addr);
 	free (sdt);
 	return 1;
 }
 
+#define DYNAMIC_SSDT	"/sys/firmware/acpi/tables/dynamic"
 
-static int acpi_dump_XSDT(int fd, struct acpi_rsdp_descriptor *rsdp)
+static void acpi_dump_dynamic_SSDT(int fd)
 {
-	struct acpi_table_header *sdt, *tbl = 0;
-	int i, num;
-	char *offset;
-	unsigned long addr;
-	if (rsdp->revision > 1 && rsdp->xsdt_physical_address) {
-		tbl = acpi_map_table(rsdp->xsdt_physical_address, "XSDT");
+	struct stat file_stat;
+	char filename[256], *ptr;
+	DIR *tabledir;
+	struct dirent *entry;
+	FILE *fp;
+	int count, readcount, length;
+	struct acpi_table_header table_header, *ptable;
+
+	if (stat(DYNAMIC_SSDT, &file_stat) == -1) {
+		/* The directory doesn't exist */
+		return;
 	}
-	if (!tbl) return 0;
-
-	sdt = malloc(tbl->length);
-	memcpy(sdt, tbl, tbl->length);
-	acpi_unmap_table(tbl);
-	if (checksum((u8 *)sdt, sdt->length))
-		fprintf(stderr, "Wrong checksum for %s!\n", "XSDT");
-	num = (sdt->length - sizeof(struct acpi_table_header))/sizeof(u64);
-	offset = (char *)sdt + sizeof(struct acpi_table_header);
-	for (i = 0; i < num; ++i, offset += sizeof(u64)) {
-		addr = (unsigned long)(*(u64 *)offset);
-		if (!addr) continue;
-		tbl = acpi_map_table(addr, 0);
-		if (!tbl) continue;
-		if (!memcmp(tbl->signature, FADT_SIG, 4)) {
-			acpi_dump_FADT(fd, tbl, addr);
-		} else {
-			if (checksum((u8 *)tbl, tbl->length))
-				fprintf(stderr, "Wrong checksum for %.4s\n", tbl->signature);
-			write_table(fd, tbl, addr);
+	tabledir = opendir(DYNAMIC_SSDT);
+	if(!tabledir){
+		/*can't open the directory */
+		return;
+         }
+
+	while ((entry = readdir(tabledir)) != 0){
+		/* skip the file of . /.. */
+		if (entry->d_name[0] == '.')
+			continue;
+
+		sprintf(filename, "%s/%s", DYNAMIC_SSDT, entry->d_name);
+		fp = fopen(filename, "r");
+		if (fp == NULL) {
+			fprintf(stderr, "Can't open the file of %s\n",
+						filename);
+			continue;
 		}
-		acpi_unmap_table(tbl);
-		if (connect) {
-			(*(u64*)offset) = lseek(fd, 0, SEEK_CUR);
+		/* Read the Table header to parse the table length */
+		count = fread(&table_header, 1, sizeof(struct acpi_table_header), fp);
+		if (count < sizeof(table_header)) {
+			/* the length is lessn than ACPI table header. skip it */
+			fclose(fp);
+			continue;
 		}
+		length = table_header.length;
+		ptr = malloc(table_header.length);
+		fseek(fp, 0, SEEK_SET);
+		readcount = 0;
+		while(!feof(fp) && readcount < length) {
+			count = fread(ptr + readcount, 1, 256, fp);
+			readcount += count;
+		}
+		fclose(fp);
+		ptable = (struct acpi_table_header *) ptr;
+		if (checksum((u8 *) ptable, ptable->length))
+			fprintf(stderr, "Wrong checksum "
+					"for dynamic SSDT table!\n");
+		write_table(fd, ptable, 0);
+		free(ptr);
 	}
-	addr = (unsigned long)rsdp->xsdt_physical_address;
-	if (connect) {
-		rsdp->xsdt_physical_address = lseek(fd, 0, SEEK_CUR);
-	}
-	write_table(fd, sdt, addr);
-	free (sdt);
-	return 1;
+	closedir(tabledir);
+	return;
 }
 
 static void usage(const char *progname)
@@ -518,6 +510,7 @@ int main(int argc, char **argv)
 			goto not_found;
 		write(fd, raw, length);
 		acpi_unmap_memory(raw, length);
+		close(fd);
 		return 0;
 	}
 
@@ -540,12 +533,7 @@ int main(int argc, char **argv)
 	if (connect) {
 		lseek(fd, sizeof(struct acpi_rsdp_descriptor), SEEK_SET);
 	}
-	if (rsdpx.revision > 1 && rsdpx.xsdt_physical_address) {
-		/* ACPIDUMP uses xsdt table */
-		if (!acpi_dump_XSDT(fd, &rsdpx))
-			goto not_found;
-	}
-	if (!acpi_dump_RSDT(fd, &rsdpx))
+	if (!acpi_dump_SDT(fd, &rsdpx))
 		goto not_found;
 	if (connect) {
 		lseek(fd, 0, SEEK_SET);
@@ -560,8 +548,11 @@ int main(int argc, char **argv)
 		buff[0] = '\n';
 		write(fd, buff, 1);
 	}
+	acpi_dump_dynamic_SSDT(fd);
+	close(fd);
 	return 0;
 not_found:
+	close(fd);
 	fprintf(stderr, "ACPI tables were not found. If you know location "
 		"of RSD PTR table (from dmesg, etc), "
 		"supply it with either --addr or -a option\n");
-- 
1.8.0.rc0.18.gf84667d

