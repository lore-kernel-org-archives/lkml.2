Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1DUCia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:38:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1DUChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:40 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ew87T6pUlhcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=C-1pDWcX_W-oYYX42ZsA:9 a=t8gTZTDO_FBpKLDQmYcA:7 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421023739.723658553@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Reiser <jreiser@bitwagon.com>
Subject: [RFC][PATCH 11/11] ftrace/recordmcount: Add helper function get_sym_str_and_relp()
References: <20110421022825.535486725@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-recordmcount-Add-helper-function-get_sym_str_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code to get the symbol, string, and relp pointers in the two functions
sift_rel_mcount() and nop_mcount() are identical and also non-trivial.
Moving this duplicate code into a single helper function makes the code
easier to read and more maintainable.

Cc: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |   67 ++++++++++++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index deb6a51..3c00fab 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -29,6 +29,7 @@
 #undef has_rel_mcount
 #undef tot_relsize
 #undef get_mcountsym
+#undef get_sym_str_and_relp
 #undef do_func
 #undef Elf_Addr
 #undef Elf_Ehdr
@@ -56,6 +57,7 @@
 # define __has_rel_mcount	__has64_rel_mcount
 # define has_rel_mcount		has64_rel_mcount
 # define tot_relsize		tot64_relsize
+# define get_sym_str_and_relp	get_sym_str_and_relp_64
 # define do_func		do64
 # define get_mcountsym		get_mcountsym_64
 # define is_fake_mcount		is_fake_mcount64
@@ -86,6 +88,7 @@
 # define __has_rel_mcount	__has32_rel_mcount
 # define has_rel_mcount		has32_rel_mcount
 # define tot_relsize		tot32_relsize
+# define get_sym_str_and_relp	get_sym_str_and_relp_32
 # define do_func		do32
 # define get_mcountsym		get_mcountsym_32
 # define is_fake_mcount		is_fake_mcount32
@@ -260,6 +263,29 @@ static unsigned get_mcountsym(Elf_Sym const *const sym0,
 	return mcountsym;
 }
 
+static void get_sym_str_and_relp(Elf_Shdr const *const relhdr,
+				 Elf_Ehdr const *const ehdr,
+				 Elf_Sym const **sym0,
+				 char const **str0,
+				 Elf_Rel const **relp)
+{
+	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
+		+ (void *)ehdr);
+	unsigned const symsec_sh_link = w(relhdr->sh_link);
+	Elf_Shdr const *const symsec = &shdr0[symsec_sh_link];
+	Elf_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
+	Elf_Rel const *const rel0 = (Elf_Rel const *)(_w(relhdr->sh_offset)
+		+ (void *)ehdr);
+
+	*sym0 = (Elf_Sym const *)(_w(symsec->sh_offset)
+				  + (void *)ehdr);
+
+	*str0 = (char const *)(_w(strsec->sh_offset)
+			       + (void *)ehdr);
+
+	*relp = rel0;
+}
+
 /*
  * Look at the relocations in order to find the calls to mcount.
  * Accumulate the section offsets that are found, and their relocation info,
@@ -276,26 +302,16 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 {
 	uint_t *const mloc0 = mlocp;
 	Elf_Rel *mrelp = *mrelpp;
-	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
-		+ (void *)ehdr);
-	unsigned const symsec_sh_link = w(relhdr->sh_link);
-	Elf_Shdr const *const symsec = &shdr0[symsec_sh_link];
-	Elf_Sym const *const sym0 = (Elf_Sym const *)(_w(symsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
-	char const *const str0 = (char const *)(_w(strsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf_Rel const *const rel0 = (Elf_Rel const *)(_w(relhdr->sh_offset)
-		+ (void *)ehdr);
+	Elf_Sym const *sym0;
+	char const *str0;
+	Elf_Rel const *relp;
 	unsigned rel_entsize = _w(relhdr->sh_entsize);
 	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
-	Elf_Rel const *relp = rel0;
-
 	unsigned mcountsym = 0;
 	unsigned t;
 
+	get_sym_str_and_relp(relhdr, ehdr, &sym0, &str0, &relp);
+
 	for (t = nrel; t; --t) {
 		if (!mcountsym)
 			mcountsym = get_mcountsym(sym0, relp, str0);
@@ -331,27 +347,18 @@ static void nop_mcount(Elf_Shdr const *const relhdr,
 {
 	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
 		+ (void *)ehdr);
-	unsigned const symsec_sh_link = w(relhdr->sh_link);
-	Elf_Shdr const *const symsec = &shdr0[symsec_sh_link];
-	Elf_Sym const *const sym0 = (Elf_Sym const *)(_w(symsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
-	char const *const str0 = (char const *)(_w(strsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf_Rel const *const rel0 = (Elf_Rel const *)(_w(relhdr->sh_offset)
-		+ (void *)ehdr);
+	Elf_Sym const *sym0;
+	char const *str0;
+	Elf_Rel const *relp;
+	Elf_Shdr const *const shdr = &shdr0[w(relhdr->sh_info)];
 	unsigned rel_entsize = _w(relhdr->sh_entsize);
 	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
-	Elf_Rel const *relp = rel0;
-
-	Elf_Shdr const *const shdr = &shdr0[w(relhdr->sh_info)];
-
 	unsigned mcountsym = 0;
 	unsigned t;
 	int once = 0;
 
+	get_sym_str_and_relp(relhdr, ehdr, &sym0, &str0, &relp);
+
 	for (t = nrel; t; --t) {
 		int ret = -1;
 
-- 
1.7.2.3


