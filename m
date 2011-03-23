Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab1CWVC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:02:58 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36589 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab1CWVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Nuklgzp+6dhcO/NmyXBDefq37tYVOwCkmInBgNqdXLxSKNAVJ8xn7HFsNOxaWQHrqo
         0boe4+tbiv+2tSzT6VkIVzM8fq6GwNSgvD8Mva1mBqqwyMSzn+D6IErjZElF+p5bG6Hq
         PZNNvfF2PH/V/yASHBON4zpz6DpSF8wro0gYU=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Lance Taylor <ian@airs.com>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
Date: Wed, 23 Mar 2011 22:00:43 +0100
Message-Id: <1300914043-2297-3-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300914043-2297-1-git-send-email-abogani@kernel.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 kernel/module.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1f9f7bc..932726d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -235,6 +235,18 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
+struct find_symbol_arg {
+	/* Input */
+	const char *name;
+	bool gplok;
+	bool warn;
+
+	/* Output */
+	struct module *owner;
+	const unsigned long *crc;
+	const struct kernel_symbol *sym;
+};
+
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
@@ -243,12 +255,26 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 					      unsigned int symnum, void *data),
 				   void *data)
 {
-	unsigned int i, j;
+	unsigned int j, i;
+	struct find_symbol_arg *fsa = data;
+	size_t num;
+	int start, end, mid, result;
 
 	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
-				return true;
+		num = arr[j].stop - arr[j].start;
+		start = 0, end = num - 1, mid, result, i = 0;
+		while (start <= end) {
+			i++;
+			mid = (start + end) / 2;
+			result = strcmp(fsa->name, arr[j].start[mid].name);
+			if (result < 0)
+				end = mid - 1;
+			else if (result > 0)
+				start = mid + 1;
+			else
+				if (fn(&arr[j], owner, mid, data))
+					return true;
+		}
 	}
 
 	return false;
@@ -311,27 +337,12 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 }
 EXPORT_SYMBOL_GPL(each_symbol);
 
-struct find_symbol_arg {
-	/* Input */
-	const char *name;
-	bool gplok;
-	bool warn;
-
-	/* Output */
-	struct module *owner;
-	const unsigned long *crc;
-	const struct kernel_symbol *sym;
-};
-
 static bool find_symbol_in_section(const struct symsearch *syms,
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
-- 
1.7.4.1

