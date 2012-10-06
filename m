Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2JFUTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:19:35 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43655 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab2JFUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:19:32 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 32/49] tools/power/acpi/acpidump: version 20060606
Date: Sat,  6 Oct 2012 16:09:53 -0400
Message-Id: <4f1004207ed67903c60ed6476da0cc571b19a220.1349554106.git.len.brown@intel.com>
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

This is unchanged version 20060606, plus a small bit in
DEFINE_ALTERNATE_TYPES to enable building with latest kernel headers.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/acpi/acpidump.c | 97 +++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 38 deletions(-)

diff --git a/tools/power/acpi/acpidump.c b/tools/power/acpi/acpidump.c
index 3f0a9da..3bb8e82 100644
--- a/tools/power/acpi/acpidump.c
+++ b/tools/power/acpi/acpidump.c
@@ -1,5 +1,5 @@
 /*
- * (c) Alexey Starikovskiy, Intel, 2005.
+ * (c) Alexey Starikovskiy, Intel, 2005-2006.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -77,16 +77,16 @@ static inline u8 checksum(u8 * buffer, u32 length)
 }
 
 static unsigned long psz, addr, length;
-static int print, connect;
+static int print, connect, skip;
 static u8 select_sig[4];
 
 static unsigned long read_efi_systab( void )
 {
+	char buffer[80];
+	unsigned long addr;
 	FILE *f = fopen("/sys/firmware/efi/systab", "r");
 	if (f) {
-		char buffer[80];
 		while (fgets(buffer, 80, f)) {
-			unsigned long addr;
 			if (sscanf(buffer, "ACPI20=0x%lx", &addr) == 1)
 				return addr;
 		}
@@ -97,13 +97,15 @@ static unsigned long read_efi_systab( void )
 
 static u8 *acpi_map_memory(unsigned long where, unsigned length)
 {
+	unsigned long offset;
+	u8 *there;
 	int fd = open("/dev/mem", O_RDONLY);
 	if (fd < 0) {
 		fprintf(stderr, "acpi_os_map_memory: cannot open /dev/mem\n");
 		exit(1);
 	}
-	unsigned long offset = where % psz;
-	u8 *there = mmap(NULL, length + offset, PROT_READ, MAP_PRIVATE,
+	offset = where % psz;
+	there = mmap(NULL, length + offset, PROT_READ, MAP_PRIVATE,
 			 fd, where - offset);
 	close(fd);
 	if (there == MAP_FAILED) return 0;
@@ -118,10 +120,11 @@ static void acpi_unmap_memory(u8 * there, unsigned length)
 
 static struct acpi_table_header *acpi_map_table(unsigned long where, char *sig)
 {
+	unsigned size;
 	struct acpi_table_header *tbl = (struct acpi_table_header *)
 	    acpi_map_memory(where, sizeof(struct acpi_table_header));
 	if (!tbl || (sig && memcmp(sig, tbl->signature, 4))) return 0;
-	unsigned size = tbl->length;
+	size = tbl->length;
 	acpi_unmap_memory((u8 *) tbl, sizeof(struct acpi_table_header));
 	return (struct acpi_table_header *)acpi_map_memory(where, size);
 }
@@ -133,12 +136,13 @@ static void acpi_unmap_table(struct acpi_table_header *tbl)
 
 static struct acpi_rsdp_descriptor *acpi_scan_for_rsdp(u8 *begin, u32 length)
 {
+	struct acpi_rsdp_descriptor *rsdp;
 	u8 *i, *end = begin + length;
 	/* Search from given start address for the requested length */
 	for (i = begin; i < end; i += ACPI_RSDP_SCAN_STEP) {
 		/* The signature and checksum must both be correct */
 		if (memcmp((char *)i, "RSD PTR ", 8)) continue;
-		struct acpi_rsdp_descriptor *rsdp = (struct acpi_rsdp_descriptor *)i;
+		rsdp = (struct acpi_rsdp_descriptor *)i;
 		/* Signature matches, check the appropriate checksum */
 		if (!checksum((u8 *) rsdp, (rsdp->revision < 2) ?
 			      ACPI_RSDP_CHECKSUM_LENGTH :
@@ -156,9 +160,10 @@ static struct acpi_rsdp_descriptor *acpi_scan_for_rsdp(u8 *begin, u32 length)
 static void acpi_show_data(int fd, u8 * data, int size)
 {
 	char buffer[256];
+	int len;
 	int i, remain = size;
 	while (remain > 0) {
-		int len = snprintf(buffer, 256, "  %04x:", size - remain);
+		len = snprintf(buffer, 256, "  %04x:", size - remain);
 		for (i = 0; i < 16 && i < remain; i++) {
 			len +=
 			    snprintf(&buffer[len], 256 - len, " %02x", data[i]);
@@ -200,6 +205,10 @@ static void write_table(int fd, struct acpi_table_header *tbl, unsigned long add
 			write(fd, tbl, tbl->length);
 		}
 	} else if (!select_done && !memcmp(select_sig, tbl->signature, 4)) {
+		if (skip > 0) {
+			--skip;
+			return;
+		}
 		if (print) {
 			acpi_show_table(fd, tbl, addr);
 		} else {
@@ -265,8 +274,10 @@ no_facs:
 
 static int acpi_dump_SDT(int fd, struct acpi_rsdp_descriptor *rsdp)
 {
-	struct acpi_table_header *tbl = 0;
-	int xsdt = 1;
+	struct acpi_table_header *sdt, *tbl = 0;
+	int xsdt = 1, i, num;
+	char *offset;
+	unsigned long addr;
 	if (rsdp->revision > 1 && rsdp->xsdt_physical_address) {
 		tbl = acpi_map_table(rsdp->xsdt_physical_address, "XSDT");
 	}
@@ -275,17 +286,17 @@ static int acpi_dump_SDT(int fd, struct acpi_rsdp_descriptor *rsdp)
 		tbl = acpi_map_table(rsdp->rsdt_physical_address, "RSDT");
 	}
 	if (!tbl) return 0;
-	struct acpi_table_header *sdt = malloc(tbl->length);
+	sdt = malloc(tbl->length);
 	memcpy(sdt, tbl, tbl->length);
 	acpi_unmap_table(tbl);
 	if (checksum((u8 *)sdt, sdt->length))
 		fprintf(stderr, "Wrong checksum for %s!\n", (xsdt)?"XSDT":"RSDT");
-	int i, num = (sdt->length - sizeof(struct acpi_table_header))/((xsdt)?sizeof(u64):sizeof(u32));
-	char *offset = (char *)sdt + sizeof(struct acpi_table_header);
-	unsigned long addr;
+	num = (sdt->length - sizeof(struct acpi_table_header))/((xsdt)?sizeof(u64):sizeof(u32));
+	offset = (char *)sdt + sizeof(struct acpi_table_header);
 	for (i = 0; i < num; ++i, offset += ((xsdt) ? sizeof(u64) : sizeof(u32))) {
 		addr = (xsdt) ? (unsigned long)(*(u64 *)offset):
 				(unsigned long)(*(u32 *)offset);
+		if (!addr) continue;
 		tbl = acpi_map_table(addr, 0);
 		if (!tbl) continue;
 		if (!memcmp(tbl->signature, FADT_SIG, 4)) {
@@ -330,29 +341,36 @@ static void usage(const char *progname)
 	puts("\t--binary or -b -- dump data in binary form rather than in hex-dump format");
 	puts("\t--length 0x456 or -l 0x456 -- works only with --addr, dump physical memory"
 		"\n\t\tregion without trying to understand it's contents");
+	puts("\t--skip 2 or -s 2 -- skip 2 tables of the given name and output only 3rd one");
 	puts("\t--help or -h -- this help message");
 	exit(0);
 }
 
+static struct option long_options[] = {
+	{"addr", 1, 0, 0},
+	{"table", 1, 0, 0},
+	{"output", 1, 0, 0},
+	{"binary", 0, 0, 0},
+	{"length", 1, 0, 0},
+	{"skip", 1, 0, 0},
+	{"help", 0, 0, 0},
+	{0, 0, 0, 0}
+};
 int main(int argc, char **argv)
 {
+	int option_index, c, fd;
+	u8 *raw;
+	struct acpi_rsdp_descriptor rsdpx, *x = 0;
+	char *filename = 0;
+	char buff[80];
 	memset(select_sig, 0, 4);
 	print = 1;
 	connect = 0;
-	char *filename = 0;
 	addr = length = 0;
+	skip = 0;
 	while (1) {
-		int option_index = 0;
-		static struct option long_options[] = {
-			{"addr", 1, 0, 0},
-			{"table", 1, 0, 0},
-			{"output", 1, 0, 0},
-			{"binary", 0, 0, 0},
-			{"length", 1, 0, 0},
-			{"help", 0, 0, 0},
-			{0, 0, 0, 0}
-		};
-		int c = getopt_long(argc, argv, "a:t:o:bl:h",
+		option_index = 0;
+		c = getopt_long(argc, argv, "a:t:o:bl:s:h",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -376,6 +394,9 @@ int main(int argc, char **argv)
 				length = strtoul(optarg, (char **)NULL, 16);
 				break;
 			case 5:
+				skip = strtoul(optarg, (char **)NULL, 10);
+				break;
+			case 6:
 				usage(argv[0]);
 				exit(0);
 			}
@@ -395,6 +416,9 @@ int main(int argc, char **argv)
 		case 'l':
 			length = strtoul(optarg, (char **)NULL, 16);
 			break;
+		case 's':
+			skip = strtoul(optarg, (char **)NULL, 10);
+			break;
 		case 'h':
 			usage(argv[0]);
 			exit(0);
@@ -404,20 +428,19 @@ int main(int argc, char **argv)
 			exit(0);
 		}
 	}
-	
-	int fd = STDOUT_FILENO;
+
+	fd = STDOUT_FILENO;
 	if (filename) {
 		fd = creat(filename, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
 		if (fd < 0)
 			return fd;
 	}
-	
+
 	if (!select_sig[0] && !print) {
 		connect = 1;
 	}
-	
+
 	psz = sysconf(_SC_PAGESIZE);
-	u8 *raw;
 	if (length && addr) {
 		/* We know length and address, it means we just want a memory dump */
 		if (!(raw = acpi_map_memory(addr, length)))
@@ -426,7 +449,7 @@ int main(int argc, char **argv)
 		acpi_unmap_memory(raw, length);
 		return 0;
 	}
-	
+
 	length = sizeof(struct acpi_rsdp_descriptor);
 	if (!addr) {
 		addr = read_efi_systab();
@@ -435,12 +458,11 @@ int main(int argc, char **argv)
 			length = ACPI_HI_RSDP_WINDOW_SIZE;
 		}
 	}
-	
-	struct acpi_rsdp_descriptor rsdpx, *x = 0;
+
 	if (!(raw = acpi_map_memory(addr, length)) ||
-	    !(x = acpi_scan_for_rsdp(raw, length))) 
+	    !(x = acpi_scan_for_rsdp(raw, length)))
 		goto not_found;
-	
+
 	/* Find RSDP and print all found tables */
 	memcpy(&rsdpx, x, sizeof(struct acpi_rsdp_descriptor));
 	acpi_unmap_memory(raw, length);
@@ -454,7 +476,6 @@ int main(int argc, char **argv)
 		write(fd, x, (rsdpx.revision < 2) ?
 			ACPI_RSDP_CHECKSUM_LENGTH : ACPI_RSDP_XCHECKSUM_LENGTH);
 	} else if (!select_sig[0] || !memcmp("RSD PTR ", select_sig, 4)) {
-		char buff[80];
 		addr += (long)x - (long)raw;
 		length = snprintf(buff, 80, "RSD PTR @ %p\n", (void *)addr);
 		write(fd, buff, length);
-- 
1.8.0.rc0.18.gf84667d

