Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2DTVc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:32:28 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62740 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2DTVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:09 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 5/8] kallsyms: convert the kallsyms storage to store the type separately
Date: Fri, 20 Apr 2012 16:29:51 -0500
Message-ID: <1334957394-12086-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to quickly access the symbol type field it must be stored in
its own character array.  Historically the kallsysms symbol type field
was stored as the first character of the name.

This patch introduces the kallsyms_type_table for looking up a symbol
type immediately.  This new table will be used for fast comparisons to
determine if a kallsym reference is a symbol or a line location.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kallsyms.c    |   26 +++++---------------------
 scripts/kallsyms.c   |   49 +++++++++++++++++++++++++++++++++++++++++--------
 scripts/namespace.pl |    1 +
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 079f1d3..550f273 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -38,6 +38,7 @@
  */
 extern const unsigned long kallsyms_addresses[] __attribute__((weak));
 extern const u8 kallsyms_names[] __attribute__((weak));
+extern const u8 kallsyms_type_table[] __attribute__((weak));
 
 /*
  * Tell the compiler that the count isn't in the small data section if the arch
@@ -88,7 +89,7 @@ static int is_ksym_addr(unsigned long addr)
  */
 static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 {
-	int len, skipped_first = 0;
+	int len;
 	const u8 *tptr, *data;
 
 	/* Get the compressed symbol length from the first symbol byte. */
@@ -112,11 +113,8 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 		len--;
 
 		while (*tptr) {
-			if (skipped_first) {
-				*result = *tptr;
-				result++;
-			} else
-				skipped_first = 1;
+			*result = *tptr;
+			result++;
 			tptr++;
 		}
 	}
@@ -128,20 +126,6 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 }
 
 /*
- * Get symbol type information. This is encoded as a single char at the
- * beginning of the symbol name.
- */
-static char kallsyms_get_symbol_type(unsigned int off)
-{
-	/*
-	 * Get just the first code, look it up in the token table,
-	 * and return the first char from this token.
-	 */
-	return kallsyms_token_table[kallsyms_token_index[kallsyms_names[off + 1]]];
-}
-
-
-/*
  * Find the offset on the compressed stream given and index in the
  * kallsyms array.
  */
@@ -445,7 +429,7 @@ static unsigned long get_ksymbol_core(struct kallsym_iter *iter)
 	iter->module_name[0] = '\0';
 	iter->value = kallsyms_addresses[iter->pos];
 
-	iter->type = kallsyms_get_symbol_type(off);
+	iter->type = kallsyms_type_table[iter->pos];
 
 	off = kallsyms_expand_symbol(off, iter->name);
 
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..0516416 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -34,6 +34,7 @@ struct sym_entry {
 	unsigned int len;
 	unsigned int start_pos;
 	unsigned char *sym;
+	unsigned char stype;
 };
 
 struct text_range {
@@ -54,6 +55,7 @@ static struct text_range text_ranges[] = {
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static int all_symbols = 0;
+static int lineloc_symbols = 0;
 static char symbol_prefix_char = '\0';
 
 int token_profit[0x10000];
@@ -101,17 +103,33 @@ static int read_symbol_tr(const char *sym, unsigned long long addr)
 
 static int read_symbol(FILE *in, struct sym_entry *s)
 {
-	char str[500];
+	static char str[500];
+	static char tstr[500];
 	char *sym, stype;
 	int rc;
+	static int read_elf_time = 0;
+
+	if (!fgets(tstr, 500, in))
+		return -1;
+	if (!read_elf_time)
+		rc = sscanf(tstr, "%llx %c %499s\n", &s->addr, &stype, str);
+	else
+		goto do_read_elf;
 
-	rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
 	if (rc != 3) {
-		if (rc != EOF && fgets(str, 500, in) == NULL)
-			fprintf(stderr, "Read error or end of file.\n");
+		if (lineloc_symbols)
+do_read_elf:
+			rc = sscanf(tstr, "%499s %llx\n", str, &s->addr);
+		if (rc == 2) {
+			stype = 0xff;
+			sym = str;
+			read_elf_time = 1;
+			goto got_sym;
+		}
 		return -1;
 	}
 
+got_sym:
 	sym = str;
 	/* skip prefix char */
 	if (symbol_prefix_char && str[0] == symbol_prefix_char)
@@ -151,8 +169,8 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 			"unable to allocate required amount of memory\n");
 		exit(EXIT_FAILURE);
 	}
-	strcpy((char *)s->sym + 1, str);
-	s->sym[0] = stype;
+	s->stype = stype;
+	strcpy((char *)s->sym, str);
 
 	return 0;
 }
@@ -186,16 +204,17 @@ static int symbol_valid(struct sym_entry *s)
 		"kallsyms_markers",
 		"kallsyms_token_table",
 		"kallsyms_token_index",
+		"kallsyms_type_table",
 
 	/* Exclude linker generated symbols which vary between passes */
 		"_SDA_BASE_",		/* ppc */
 		"_SDA2_BASE_",		/* ppc */
 		NULL };
 	int i;
-	int offset = 1;
+	int offset = 0;
 
 	/* skip prefix char */
-	if (symbol_prefix_char && *(s->sym + 1) == symbol_prefix_char)
+	if (symbol_prefix_char && *(s->sym) == symbol_prefix_char)
 		offset++;
 
 	/* if --all-symbols is not specified, then symbols outside the text
@@ -353,6 +372,18 @@ static void write_src(void)
 	}
 	printf("\n");
 
+	output_label("kallsyms_type_table");
+	off = 0;
+	for (i = 0; i < table_cnt; i++) {
+		printf("\t.byte 0x%02x", table[i].stype);
+		for (k = 0; k < 15 && i < table_cnt; k++) {
+			i++;
+			printf(", 0x%02x", table[i].stype);
+		}
+		printf("\n");
+	}
+	printf("\n");
+
 	output_label("kallsyms_markers");
 	for (i = 0; i < ((table_cnt + 255) >> 8); i++)
 		printf("\tPTR\t%d\n", markers[i]);
@@ -640,6 +671,8 @@ int main(int argc, char **argv)
 		for (i = 1; i < argc; i++) {
 			if(strcmp(argv[i], "--all-symbols") == 0)
 				all_symbols = 1;
+			else if (strcmp(argv[i], "--ll-symbols") == 0)
+				lineloc_symbols = 1;
 			else if (strncmp(argv[i], "--symbol-prefix=", 16) == 0) {
 				char *p = &argv[i][16];
 				/* skip quote */
diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index a71be6b..1809f4e 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -116,6 +116,7 @@ my %nameexception = (
     '_sinittext'	=> 1,
     'kallsyms_names'	=> 1,
     'kallsyms_num_syms'	=> 1,
+    'kallsyms_type_table' => 1,
     'kallsyms_addresses'=> 1,
     '__this_module'	=> 1,
     '_etext'		=> 1,
-- 
1.7.10

