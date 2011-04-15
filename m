Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1DOPZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:25:24 -0400
Received: from mail1.elettra.trieste.it ([140.105.4.201]:56573 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754281Ab1DOPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:25:21 -0400
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 1/4] module: Split the find_symbol_in_section function
Date: Fri, 15 Apr 2011 17:24:54 +0200
Message-Id: <1302881097-563-2-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302881097-563-1-git-send-email-abogani@kernel.org>
References: <1302881097-563-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the find_symbol_in_section() in two: the first one
(that is compare_symbol_in_section()) for compare values during the search and
the second one (that is found_symbol_in_section()) executed when values will be
found. Rename each_symbol() in search_symbol() to let its' users notice
the change.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 include/linux/module.h |    3 ++-
 kernel/module.c        |   29 ++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 5de4204..b62f0a2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -475,7 +475,8 @@ const struct kernel_symbol *find_symbol(const char *name,
 					bool warn);
 
 /* Walk the exported symbol table */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+bool search_symbol(int (*cmp) (const void *va, const void *vb),
+				bool (*fn)(const struct symsearch *arr, struct module *owner,
 			    unsigned int symnum, void *data), void *data);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
diff --git a/kernel/module.c b/kernel/module.c
index d5938a5..8845a0b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -238,6 +238,7 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
+				   int (*cmp) (const void *va, const void *vb),
 				   bool (*fn)(const struct symsearch *syms,
 					      struct module *owner,
 					      unsigned int symnum, void *data),
@@ -247,15 +248,16 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 
 	for (j = 0; j < arrsize; j++) {
 		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
-				return true;
+			if (cmp(data, &arr[j].start[i]) == 0)
+				return fn(&arr[j], owner, i, data);
 	}
 
 	return false;
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+bool search_symbol(int (*cmp) (const void *va, const void *data),
+				bool (*fn)(const struct symsearch *arr, struct module *owner,
 			    unsigned int symnum, void *data), void *data)
 {
 	struct module *mod;
@@ -278,7 +280,7 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 #endif
 	};
 
-	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
+	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, cmp, fn, data))
 		return true;
 
 	list_for_each_entry_rcu(mod, &modules, list) {
@@ -304,12 +306,12 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 #endif
 		};
 
-		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
+		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, cmp, fn, data))
 			return true;
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(each_symbol);
+EXPORT_SYMBOL_GPL(search_symbol);
 
 struct find_symbol_arg {
 	/* Input */
@@ -323,15 +325,20 @@ struct find_symbol_arg {
 	const struct kernel_symbol *sym;
 };
 
-static bool find_symbol_in_section(const struct symsearch *syms,
+static int compare_symbol_in_section(const void *va, const void *vb)
+{
+	const struct find_symbol_arg *a;
+	const struct kernel_symbol *b;
+	a = va; b = vb;
+	return strcmp(a->name, b->name);
+}
+
+static bool found_symbol_in_section(const struct symsearch *syms,
 				   struct module *owner,
 				   unsigned int symnum, void *data)
 {
 	struct find_symbol_arg *fsa = data;
 
-	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
-		return false;
-
 	if (!fsa->gplok) {
 		if (syms->licence == GPL_ONLY)
 			return false;
@@ -379,7 +386,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 	fsa.gplok = gplok;
 	fsa.warn = warn;
 
-	if (each_symbol(find_symbol_in_section, &fsa)) {
+	if (search_symbol(compare_symbol_in_section, found_symbol_in_section, &fsa)) {
 		if (owner)
 			*owner = fsa.owner;
 		if (crc)
-- 
1.7.0.4

