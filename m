Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1DLWgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:36:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64987 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1DLWgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type
         :content-transfer-encoding;
        b=GY2AVtrLFGacdUzQP5PgE0+naWelr+B4awnm8aumEHF8zyrSWeSGtE2OBxfjJmT9WM
         dHK07Y8Z0a6D3k6Dz3Kd+5VK7kJhiZ3ermnjHhThHm2ktHaAKDuUZCF2HWxr/dcQasaT
         bgrKmOM5p5QBlqZVmtgFDj+2R3O2aJZwnETZE=
Date: Tue, 12 Apr 2011 18:36:47 -0400 (EDT)
From: Anders Kaseorg <andersk@ksplice.com>
X-X-Sender: andersk@dr-wily.mit.edu
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Alessio Igor Bogani <abogani@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH] module: Use the binary search for symbols resolution
In-Reply-To: <87aafwceop.fsf@rustcorp.com.au>
Message-ID: <alpine.DEB.2.02.1104121809030.2997@dr-wily.mit.edu>
References: <1302024146-2608-1-git-send-email-abogani@kernel.org> <1302024146-2608-2-git-send-email-abogani@kernel.org> <87aafwceop.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Apr 2011 19:22:26 +0200, Alessio Igor Bogani <abogani@kernel.org> wrote:
> Let the linker sort the exported symbols and use the binary search for
> locate them.

Previously, the each_symbol API allowed you to iterate through every 
exported symbol in the kernel.  With your modification it can no longer be 
used for that purpose.  Now, in fact, it’s impossible to use each_symbol 
for _any_ purpose outside module.c:

bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
			    unsigned int symnum, void *data), void *data)

‘void *data’ was intended as an argument of arbitrary type to be passed to 
‘fn’.  But your patched each_symbol_in_section uses it as a ‘struct 
find_symbol_arg *’, and that struct only exists inside module.c.

I’ve refactored your module.c change below to avoid breaking the 
each_symbol API, by introducing an intermediate each_symsearch API that 
can be used for both purposes.

Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
---
 kernel/module.c |   96 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 76 insertions(+), 20 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index efa290e..a67a1c9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -235,28 +235,28 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-static bool each_symbol_in_section(const struct symsearch *arr,
-				   unsigned int arrsize,
-				   struct module *owner,
-				   bool (*fn)(const struct symsearch *syms,
-					      struct module *owner,
-					      unsigned int symnum, void *data),
-				   void *data)
+static bool each_symsearch_in_section(const struct symsearch *arr,
+				      unsigned int arrsize,
+				      struct module *owner,
+				      bool (*fn)(const struct symsearch *syms,
+						 struct module *owner,
+						 void *data),
+				      void *data)
 {
-	unsigned int i, j;
+	unsigned int j;
 
 	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
-				return true;
+		if (fn(&arr[j], owner, data))
+			return true;
 	}
 
 	return false;
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data)
+static bool each_symsearch(bool (*fn)(const struct symsearch *syms,
+				      struct module *owner, void *data),
+			   void *data)
 {
 	struct module *mod;
 	static const struct symsearch arr[] = {
@@ -278,7 +278,7 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 #endif
 	};
 
-	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
+	if (each_symsearch_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
 		return true;
 
 	list_for_each_entry_rcu(mod, &modules, list) {
@@ -304,11 +304,39 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 #endif
 		};
 
-		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
+		if (each_symsearch_in_section(arr, ARRAY_SIZE(arr), mod, fn,
+					      data))
+			return true;
+	}
+	return false;
+}
+
+struct each_symbol_arg {
+	bool (*fn)(const struct symsearch *arr, struct module *owner,
+		   unsigned int symnum, void *data);
+	void *data;
+};
+
+static bool each_symbol_in_symsearch(const struct symsearch *syms,
+				     struct module *owner, void *data)
+{
+	struct each_symbol_arg *esa = data;
+	unsigned int i;
+
+	for (i = 0; i < syms->stop - syms->start; i++) {
+		if (esa->fn(syms, owner, i, esa->data))
 			return true;
 	}
 	return false;
 }
+
+/* Returns true as soon as fn returns true, otherwise false. */
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data)
+{
+	struct each_symbol_arg esa = {fn, data};
+	return each_symsearch(each_symbol_in_symsearch, &esa);
+}
 EXPORT_SYMBOL_GPL(each_symbol);
 
 struct find_symbol_arg {
@@ -323,14 +351,42 @@ struct find_symbol_arg {
 	const struct kernel_symbol *sym;
 };
 
-static bool find_symbol_in_section(const struct symsearch *syms,
-				   struct module *owner,
-				   unsigned int symnum, void *data)
+#define CONFIG_SYMBOLS_BSEARCH
+static bool find_symbol_in_symsearch(const struct symsearch *syms,
+				     struct module *owner,
+				     void *data)
 {
 	struct find_symbol_arg *fsa = data;
+	unsigned int symnum;
+	int result;
+#ifdef CONFIG_SYMBOLS_BSEARCH
+	int start, end;
+#endif
 
-	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
+#ifdef CONFIG_SYMBOLS_BSEARCH
+	start = 0;
+	end = syms->stop - syms->start - 1;
+	while (true) {
+		if (start > end)
+			return false;
+		symnum = (start + end) / 2;
+		result = strcmp(fsa->name, syms->start[symnum].name);
+		if (result < 0)
+			end = symnum - 1;
+		else if (result > 0)
+			start = symnum + 1;
+		else
+			break;
+	}
+#else
+	for (symnum = 0; symnum < syms->stop - syms->start; symnum++) {
+		result = strcmp(fsa->name, syms->start[symnum].name);
+		if (result == 0)
+			break;
+	}
+	if (symnum >= syms->stop - syms->start)
 		return false;
+#endif
 
 	if (!fsa->gplok) {
 		if (syms->licence == GPL_ONLY)
@@ -379,7 +435,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 	fsa.gplok = gplok;
 	fsa.warn = warn;
 
-	if (each_symbol(find_symbol_in_section, &fsa)) {
+	if (each_symsearch(find_symbol_in_symsearch, &fsa)) {
 		if (owner)
 			*owner = fsa.owner;
 		if (crc)
-- 
1.7.5.rc0

