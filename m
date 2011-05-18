Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1ERSdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:33:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:44757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459Ab1ERSdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:33:39 -0400
Date: Wed, 18 May 2011 18:33:19 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-dfad3d598c4bbbaf137588e22bac1ce624529f7e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
In-Reply-To: <20110421023738.476989377@goodmis.org>
References: <20110421023738.476989377@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/recordmcount: Add warning logic to warn on mcount not recorded
Git-Commit-ID: dfad3d598c4bbbaf137588e22bac1ce624529f7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 18:33:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfad3d598c4bbbaf137588e22bac1ce624529f7e
Gitweb:     http://git.kernel.org/tip/dfad3d598c4bbbaf137588e22bac1ce624529f7e
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 12 Apr 2011 18:53:25 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 16 May 2011 14:44:20 -0400

ftrace/recordmcount: Add warning logic to warn on mcount not recorded

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
