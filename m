Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740Ab2J3OJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:09:33 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:33701 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271Ab2J3OJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:09:29 -0400
X-AuditID: b753bd60-99054ba000002f78-2e-508fdf13fc6b
Message-ID: <508FDF13.2080406@hitachi.com>
Date: Tue, 30 Oct 2012 23:07:15 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [RFC][PATCH 1/2] makedumpfile: Add a new "-p" option to exclude hwpoison
 page from vmcore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"makedumpfile" has filtering function to exclude some types of pages,
like zero page, free page, user data, etc, without saving the whole dump.

This patch introduce a new "-p" option into "makedumpfile" to
exclude hwpoison page while copying vmcore to dumpfile.


Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
diff -uprN a/makedumpfile.8 b/makedumpfile.8
--- a/makedumpfile.8	2012-10-01 15:26:54.510354074 +0900
+++ b/makedumpfile.8	2012-10-28 20:03:44.110007190 +0900
@@ -192,6 +192,14 @@ by dump_level 11, makedumpfile retries i
     30 |      |   X   |   X   |  X   |  X
     31 |  X   |   X   |   X   |  X   |  X
 
+.TP
+\fB\-p\fR
+Exclude \fIhwpoison_page\fR.
+.br
+Hwpoison pages are not copied to DUMPFILE using this option, because those
+pages are corrupt.
+.br
+This option can be specified with -d option.
 
 .TP
 \fB\-E\fR
diff -uprN a/makedumpfile.c b/makedumpfile.c
--- a/makedumpfile.c	2012-10-01 15:26:54.510354074 +0900
+++ b/makedumpfile.c	2012-10-28 20:21:00.506032658 +0900
@@ -43,6 +43,7 @@ unsigned long long pfn_cache;
 unsigned long long pfn_cache_private;
 unsigned long long pfn_user;
 unsigned long long pfn_free;
+unsigned long long pfn_hwpoison;
 
 unsigned long long num_dumped;
 
@@ -969,6 +970,7 @@ get_structure_info(void)
 	ENUM_NUMBER_INIT(PG_lru, "PG_lru");
 	ENUM_NUMBER_INIT(PG_private, "PG_private");
 	ENUM_NUMBER_INIT(PG_swapcache, "PG_swapcache");
+	ENUM_NUMBER_INIT(PG_hwpoison, "PG_hwpoison");
 
 	TYPEDEF_SIZE_INIT(nodemask_t, "nodemask_t");
 
@@ -1371,6 +1373,7 @@ write_vmcoreinfo_data(void)
 	WRITE_NUMBER("PG_lru", PG_lru);
 	WRITE_NUMBER("PG_private", PG_private);
 	WRITE_NUMBER("PG_swapcache", PG_swapcache);
+	WRITE_NUMBER("PG_hwpoison", PG_hwpoison);
 
 	/*
 	 * write the source file of 1st kernel
@@ -1659,6 +1662,7 @@ read_vmcoreinfo(void)
 	READ_NUMBER("PG_lru", PG_lru);
 	READ_NUMBER("PG_private", PG_private);
 	READ_NUMBER("PG_swapcache", PG_swapcache);
+	READ_NUMBER("PG_hwpoison", PG_hwpoison);
 
 	READ_SRCFILE("pud_t", pud_t);
 
@@ -3856,6 +3860,13 @@ __exclude_unnecessary_pages(unsigned lon
 			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
 				pfn_user++;
 		}
+		/*
+		 * Exclude the hwpoison page.
+		 */
+		else if (info->exclude_hwpoison && isHWPOISON(flags)) {
+			clear_bit_on_2nd_bitmap_for_kernel(pfn);
+			pfn_hwpoison++;
+		}
 	}
 	return TRUE;
 }
@@ -3918,7 +3929,8 @@ exclude_unnecessary_pages_cyclic(void)
 	 */
 	if (info->dump_level & DL_EXCLUDE_CACHE ||
 	    info->dump_level & DL_EXCLUDE_CACHE_PRI ||
-	    info->dump_level & DL_EXCLUDE_USER_DATA) {
+	    info->dump_level & DL_EXCLUDE_USER_DATA ||
+	    info->exclude_hwpoison) {
 
 		gettimeofday(&tv_start, NULL);
 
@@ -4018,11 +4030,13 @@ create_2nd_bitmap(void)
 	}
 
 	/*
-	 * Exclude cache pages, cache private pages, user data pages.
+	 * Exclude cache pages, cache private pages,
+	 * user data pages, hwpoison pages.
 	 */
 	if (info->dump_level & DL_EXCLUDE_CACHE ||
 	    info->dump_level & DL_EXCLUDE_CACHE_PRI ||
-	    info->dump_level & DL_EXCLUDE_USER_DATA) {
+	    info->dump_level & DL_EXCLUDE_USER_DATA ||
+	    info->exclude_hwpoison) {
 		if (!exclude_unnecessary_pages()) {
 			ERRMSG("Can't exclude unnecessary pages.\n");
 			return FALSE;
@@ -5062,7 +5076,8 @@ write_elf_pages_cyclic(struct cache_data
 	/*
 	 * Reset counter for debug message.
 	 */
-	pfn_zero =  pfn_cache = pfn_cache_private = pfn_user = pfn_free = 0;
+	pfn_zero = pfn_cache = pfn_cache_private =
+	pfn_user = pfn_free = pfn_hwpoison = 0;
 	pfn_memhole = info->max_mapnr;
 
 	info->cyclic_start_pfn = 0;
@@ -5902,7 +5917,8 @@ write_kdump_pages_and_bitmap_cyclic(stru
 	/*
 	 * Reset counter for debug message.
 	 */
-	pfn_zero =  pfn_cache = pfn_cache_private = pfn_user = pfn_free = 0;
+	pfn_zero = pfn_cache = pfn_cache_private =
+	pfn_user = pfn_free = pfn_hwpoison = 0;
 	pfn_memhole = info->max_mapnr;
 
 	cd_header->offset
@@ -6687,7 +6703,7 @@ print_report(void)
 	pfn_original = info->max_mapnr - pfn_memhole;
 
 	pfn_excluded = pfn_zero + pfn_cache + pfn_cache_private
-	    + pfn_user + pfn_free;
+	    + pfn_user + pfn_free + pfn_hwpoison;
 	shrinking = (pfn_original - pfn_excluded) * 100;
 	shrinking = shrinking / pfn_original;
 
@@ -6700,6 +6716,7 @@ print_report(void)
 	    pfn_cache_private);
 	REPORT_MSG("    User process data pages : 0x%016llx\n", pfn_user);
 	REPORT_MSG("    Free pages              : 0x%016llx\n", pfn_free);
+	REPORT_MSG("    Hwpoison pages          : 0x%016llx\n", pfn_hwpoison);
 	REPORT_MSG("  Remaining pages  : 0x%016llx\n",
 	    pfn_original - pfn_excluded);
 	REPORT_MSG("  (The number of pages is reduced to %lld%%.)\n",
@@ -7807,7 +7824,7 @@ main(int argc, char *argv[])
 	
 	info->block_order = DEFAULT_ORDER;
 	message_level = DEFAULT_MSG_LEVEL;
-	while ((opt = getopt_long(argc, argv, "b:cDd:EFfg:hi:lMRrsvXx:", longopts,
+	while ((opt = getopt_long(argc, argv, "b:cDd:EFfg:hi:lMpRrsvXx:", longopts,
 	    NULL)) != -1) {
 		switch (opt) {
 		case 'b':
@@ -7868,6 +7885,9 @@ main(int argc, char *argv[])
 		case 'P':
 			info->xen_phys_start = strtoul(optarg, NULL, 0);
 			break;
+		case 'p':
+			info->exclude_hwpoison = 1;
+			break;
 		case 'R':
 			info->flag_rearrange = 1;
 			break;
diff -uprN a/makedumpfile.h b/makedumpfile.h
--- a/makedumpfile.h	2012-10-01 15:26:54.512354076 +0900
+++ b/makedumpfile.h	2012-10-28 19:03:14.623823394 +0900
@@ -107,6 +107,8 @@ test_bit(int nr, unsigned long addr)
 #define isLRU(flags)		test_bit(NUMBER(PG_lru), flags)
 #define isPrivate(flags)	test_bit(NUMBER(PG_private), flags)
 #define isSwapCache(flags)	test_bit(NUMBER(PG_swapcache), flags)
+#define isHWPOISON(flags)	(test_bit(NUMBER(PG_hwpoison), flags) \
+				&& (NUMBER(PG_hwpoison) != NOT_FOUND_NUMBER))
 
 static inline int
 isAnon(unsigned long mapping)
@@ -940,6 +942,11 @@ struct DumpInfo {
 	 */
 	int flag_sadump_diskset;
 	enum sadump_format_type flag_sadump;         /* sadump format type */
+
+	/*
+	 * Exclude hwpoison page
+	 */
+	int	exclude_hwpoison;
 };
 extern struct DumpInfo		*info;
 
@@ -1244,6 +1251,7 @@ struct number_table {
 	long	PG_lru;
 	long	PG_private;
 	long	PG_swapcache;
+	long    PG_hwpoison;
 };
 
 struct srcfile_table {
diff -uprN a/print_info.c b/print_info.c
--- a/print_info.c	2012-10-01 15:26:54.510354074 +0900
+++ b/print_info.c	2012-10-28 19:03:14.624823395 +0900
@@ -109,6 +109,12 @@ print_usage(void)
 	MSG("        16  |                                    X\n");
 	MSG("        31  |   X       X        X       X       X\n");
 	MSG("\n");
+	MSG("  [-p]:\n");
+	MSG("      Exclude hwpoison page.\n");
+	MSG("      Hwpoison pages are not copied to DUMPFILE using this option,\n");
+	MSG("      because those pages are corrupt.\n");
+	MSG("      This option can be specified with -d option.\n");
+	MSG("\n");
 	MSG("  [-E]:\n");
 	MSG("      Create DUMPFILE in the ELF format.\n");
 	MSG("      This option cannot be specified with either of -c option or -l option,\n");
