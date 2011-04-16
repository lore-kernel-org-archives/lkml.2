Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1DPN0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:26:54 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57282 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DPN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=veE7iVhcs9T2m6ocbJ7CCrIGaubavVi7eRXJjb0Sz8amnGGySgBF3nfkcg7e9102aq
         t9R5OQMdVF6mIEnfLHHk/TwUYJmg3LiiFXhHolPvisUx/N1dYhanWuQiJk5xD/UX1gJV
         KCCwHfLF86pACVgfm+QPmDAiL5YbNH3tdrZfc=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 1/4] module: Restructure each_symbol() code
Date: Sat, 16 Apr 2011 15:26:10 +0200
Message-Id: <1302960373-5309-2-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302960373-5309-1-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure code to better integrate future improvements.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
---
 kernel/module.c |   75 ++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 55 insertions(+), 20 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index d5938a5..b438b25 100644
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
 			return true;
 	}
 	return false;
 }
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
+			return true;
+	}
+	return false;
+}
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
@@ -323,13 +351,20 @@ struct find_symbol_arg {
 	const struct kernel_symbol *sym;
 };
 
-static bool find_symbol_in_section(const struct symsearch *syms,
-				   struct module *owner,
-				   unsigned int symnum, void *data)
+static bool find_symbol_in_symsearch(const struct symsearch *syms,
+				     struct module *owner,
+				     void *data)
 {
 	struct find_symbol_arg *fsa = data;
+	unsigned int symnum;
+	int result;
 
-	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
+	for (symnum = 0; symnum < syms->stop - syms->start; symnum++) {
+		result = strcmp(fsa->name, syms->start[symnum].name);
+		if (result == 0)
+			break;
+	}
+	if (symnum >= syms->stop - syms->start)
 		return false;
 
 	if (!fsa->gplok) {
@@ -379,7 +414,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 	fsa.gplok = gplok;
 	fsa.warn = warn;
 
-	if (each_symbol(find_symbol_in_section, &fsa)) {
+	if (each_symsearch(find_symbol_in_symsearch, &fsa)) {
 		if (owner)
 			*owner = fsa.owner;
 		if (crc)
-- 
1.7.4.1

