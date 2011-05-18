Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1ERQLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:11:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab1ERQJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:09 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=o_g3m5omOQgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Mk_WYfw7bvVhj5mrVxQA:9 a=zj5rIVUungHVPCNk1d4A:7 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160907.836298587@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 07/15] ftrace/recordmcount: Add warning logic to warn on mcount not
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-recordmcount-Add-warning-logic-to-warn-on-mco.patch
 recorded
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's some sections that should not have mcount recorded and should not have
modifications to the that code. But currently they waste some time by calling
mcount anyway (which simply returns). As the real answer should be to
either whitelist the section or have gcc ignore it fully.

This change adds a option to recordmcount to warn when it finds a section
that is ignored by ftrace but still contains mcount callers. This is not on
by default as developers may not know if the section should be completely
ignored or added to the whitelist.

Cc: John Reiser <jreiser@bitwagon.com>
Link: http://lkml.kernel.org/r/20110421023738.476989377@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |   32 ++++++++++++++++++++++++--------
 scripts/recordmcount.h |   22 +++++++++++++++++-----
 2 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 78054a4..0e18975 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -24,6 +24,7 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
+#include <getopt.h>
 #include <elf.h>
 #include <fcntl.h>
 #include <setjmp.h>
@@ -39,6 +40,7 @@ static char gpfx;	/* prefix for global symbol name (sometimes '_') */
 static struct stat sb;	/* Remember .st_size, etc. */
 static jmp_buf jmpenv;	/* setjmp/longjmp per-file error escape */
 static const char *altmcount;	/* alternate mcount symbol name */
+static int warn_on_notrace_sect; /* warn when section has mcount not being recorded */
 
 /* setjmp() return values */
 enum {
@@ -397,19 +399,33 @@ do_file(char const *const fname)
 }
 
 int
-main(int argc, char const *argv[])
+main(int argc, char *argv[])
 {
 	const char ftrace[] = "/ftrace.o";
 	int ftrace_size = sizeof(ftrace) - 1;
 	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
+	int c;
+	int i;
 
-	if (argc <= 1) {
-		fprintf(stderr, "usage: recordmcount file.o...\n");
+	while ((c = getopt(argc, argv, "w")) >= 0) {
+		switch (c) {
+		case 'w':
+			warn_on_notrace_sect = 1;
+			break;
+		default:
+			fprintf(stderr, "usage: recordmcount [-w] file.o...\n");
+			return 0;
+		}
+	}
+
+	if ((argc - optind) < 1) {
+		fprintf(stderr, "usage: recordmcount [-w] file.o...\n");
 		return 0;
 	}
 
 	/* Process each file in turn, allowing deep failure. */
-	for (--argc, ++argv; argc > 0; --argc, ++argv) {
+	for (i = optind; i < argc; i++) {
+		char *file = argv[i];
 		int const sjval = setjmp(jmpenv);
 		int len;
 
@@ -418,14 +434,14 @@ main(int argc, char const *argv[])
 		 * function but does not call it. Since ftrace.o should
 		 * not be traced anyway, we just skip it.
 		 */
-		len = strlen(argv[0]);
+		len = strlen(file);
 		if (len >= ftrace_size &&
-		    strcmp(argv[0] + (len - ftrace_size), ftrace) == 0)
+		    strcmp(file + (len - ftrace_size), ftrace) == 0)
 			continue;
 
 		switch (sjval) {
 		default:
-			fprintf(stderr, "internal error: %s\n", argv[0]);
+			fprintf(stderr, "internal error: %s\n", file);
 			exit(1);
 			break;
 		case SJ_SETJMP:    /* normal sequence */
@@ -433,7 +449,7 @@ main(int argc, char const *argv[])
 			fd_map = -1;
 			ehdr_curr = NULL;
 			mmap_failed = 1;
-			do_file(argv[0]);
+			do_file(file);
 			break;
 		case SJ_FAIL:    /* error in do_file or below */
 			++n_error;
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 657dbed..22033d5 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -313,7 +313,8 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
  * into nops.
  */
 static void nop_mcount(Elf_Shdr const *const relhdr,
-		       Elf_Ehdr const *const ehdr)
+		       Elf_Ehdr const *const ehdr,
+		       const char *const txtname)
 {
 	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
 		+ (void *)ehdr);
@@ -336,6 +337,7 @@ static void nop_mcount(Elf_Shdr const *const relhdr,
 
 	unsigned mcountsym = 0;
 	unsigned t;
+	int once = 0;
 
 	for (t = nrel; t; --t) {
 		int ret = -1;
@@ -353,8 +355,18 @@ static void nop_mcount(Elf_Shdr const *const relhdr,
 				mcountsym = Elf_r_sym(relp);
 		}
 
-		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp))
-			ret = make_nop((void *)ehdr, shdr->sh_offset + relp->r_offset);
+		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
+			if (make_nop)
+				ret = make_nop((void *)ehdr, shdr->sh_offset + relp->r_offset);
+			if (warn_on_notrace_sect && !once) {
+				printf("Section %s has mcount callers being ignored\n",
+				       txtname);
+				once = 1;
+				/* just warn? */
+				if (!make_nop)
+					return;
+			}
+		}
 
 		/*
 		 * If we successfully removed the mcount, mark the relocation
@@ -501,12 +513,12 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
 			mlocp = sift_rel_mcount(mlocp,
 				(void *)mlocp - (void *)mloc0, &mrelp,
 				relhdr, ehdr, recsym, recval, reltype);
-		} else if (make_nop && txtname) {
+		} else if (txtname && (warn_on_notrace_sect || make_nop)) {
 			/*
 			 * This section is ignored by ftrace, but still
 			 * has mcount calls. Convert them to nops now.
 			 */
-			nop_mcount(relhdr, ehdr);
+			nop_mcount(relhdr, ehdr, txtname);
 		}
 	}
 	if (mloc0 != mlocp) {
-- 
1.7.4.4


