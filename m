Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1ERQK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:10:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab1ERQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:10 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=oVaVB9Z9H3kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=AneZBf28MwWtiNV2IugA:9 a=GtFIwdtD1vAc1vZ-om4A:7 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160908.909643800@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 11/15] ftrace/recordmcount: Remove duplicate code to find mcount symbol
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-recordmcount-Remove-duplicate-code-to-find-mc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code in sift_rel_mcount() and nop_mcount() to get the mcount symbol
number is identical. Replace the two locations with a call to a function
that does the work.

Cc: John Reiser <jreiser@bitwagon.com>
Link: http://lkml.kernel.org/r/20110421023739.488093407@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |   51 +++++++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 22033d5..deb6a51 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -28,6 +28,7 @@
 #undef __has_rel_mcount
 #undef has_rel_mcount
 #undef tot_relsize
+#undef get_mcountsym
 #undef do_func
 #undef Elf_Addr
 #undef Elf_Ehdr
@@ -56,6 +57,7 @@
 # define has_rel_mcount		has64_rel_mcount
 # define tot_relsize		tot64_relsize
 # define do_func		do64
+# define get_mcountsym		get_mcountsym_64
 # define is_fake_mcount		is_fake_mcount64
 # define fn_is_fake_mcount	fn_is_fake_mcount64
 # define MIPS_is_fake_mcount	MIPS64_is_fake_mcount
@@ -85,6 +87,7 @@
 # define has_rel_mcount		has32_rel_mcount
 # define tot_relsize		tot32_relsize
 # define do_func		do32
+# define get_mcountsym		get_mcountsym_32
 # define is_fake_mcount		is_fake_mcount32
 # define fn_is_fake_mcount	fn_is_fake_mcount32
 # define MIPS_is_fake_mcount	MIPS32_is_fake_mcount
@@ -237,6 +240,26 @@ static void append_func(Elf_Ehdr *const ehdr,
 	uwrite(fd_map, ehdr, sizeof(*ehdr));
 }
 
+static unsigned get_mcountsym(Elf_Sym const *const sym0,
+			      Elf_Rel const *relp,
+			      char const *const str0)
+{
+	unsigned mcountsym = 0;
+
+	Elf_Sym const *const symp =
+		&sym0[Elf_r_sym(relp)];
+	char const *symname = &str0[w(symp->st_name)];
+	char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
+
+	if (symname[0] == '.')
+		++symname;  /* ppc64 hack */
+	if (strcmp(mcount, symname) == 0 ||
+	    (altmcount && strcmp(altmcount, symname) == 0))
+		mcountsym = Elf_r_sym(relp);
+
+	return mcountsym;
+}
+
 /*
  * Look at the relocations in order to find the calls to mcount.
  * Accumulate the section offsets that are found, and their relocation info,
@@ -274,18 +297,8 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 	unsigned t;
 
 	for (t = nrel; t; --t) {
-		if (!mcountsym) {
-			Elf_Sym const *const symp =
-				&sym0[Elf_r_sym(relp)];
-			char const *symname = &str0[w(symp->st_name)];
-			char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
-
-			if (symname[0] == '.')
-				++symname;  /* ppc64 hack */
-			if (strcmp(mcount, symname) == 0 ||
-			    (altmcount && strcmp(altmcount, symname) == 0))
-				mcountsym = Elf_r_sym(relp);
-		}
+		if (!mcountsym)
+			mcountsym = get_mcountsym(sym0, relp, str0);
 
 		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
 			uint_t const addend = _w(_w(relp->r_offset) - recval);
@@ -342,18 +355,8 @@ static void nop_mcount(Elf_Shdr const *const relhdr,
 	for (t = nrel; t; --t) {
 		int ret = -1;
 
-		if (!mcountsym) {
-			Elf_Sym const *const symp =
-				&sym0[Elf_r_sym(relp)];
-			char const *symname = &str0[w(symp->st_name)];
-			char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
-
-			if (symname[0] == '.')
-				++symname;  /* ppc64 hack */
-			if (strcmp(mcount, symname) == 0 ||
-			    (altmcount && strcmp(altmcount, symname) == 0))
-				mcountsym = Elf_r_sym(relp);
-		}
+		if (!mcountsym)
+			mcountsym = get_mcountsym(sym0, relp, str0);
 
 		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
 			if (make_nop)
-- 
1.7.4.4


