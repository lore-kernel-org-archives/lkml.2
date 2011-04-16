Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1DPNaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:30:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36454 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1DPNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qJq9QVYTX4ylwyvU4NG3FaUsJQdlhoKQPM6MTqneglfe4m7OzNbiOjRxQe2SQdnxoY
         /DTDwSr4jgM+5EdDZsykxxhc1lzJLLEl5UX3MDvZ+2B/pLPTa3FeHIOsLmxNTHnQEiNS
         ptXADO++90xGnOpSfAUTQpVoZv/1SSLjOwwZ0=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 4/4] module: Use the binary search for symbols resolution
Date: Sat, 16 Apr 2011 15:26:13 +0200
Message-Id: <1302960373-5309-5-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302960373-5309-1-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takes advantage of the order and locates symbols using binary search.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 kernel/module.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b438b25..74a57c1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -57,6 +57,7 @@
 #include <linux/kmemleak.h>
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
+#include <linux/bsearch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -351,22 +352,30 @@ struct find_symbol_arg {
 	const struct kernel_symbol *sym;
 };
 
+static int cmp_name(const void *va, const void *vb)
+{
+	const char *a;
+	const struct kernel_symbol *b;
+	a = va; b = vb;
+	return strcmp(a, b->name);
+}
+
 static bool find_symbol_in_symsearch(const struct symsearch *syms,
 				     struct module *owner,
 				     void *data)
 {
 	struct find_symbol_arg *fsa = data;
+	struct kernel_symbol *sym;
 	unsigned int symnum;
-	int result;
 
-	for (symnum = 0; symnum < syms->stop - syms->start; symnum++) {
-		result = strcmp(fsa->name, syms->start[symnum].name);
-		if (result == 0)
-			break;
-	}
-	if (symnum >= syms->stop - syms->start)
+	sym = bsearch(fsa->name, syms->start, syms->stop - syms->start,
+		sizeof(struct kernel_symbol), cmp_name);
+
+	if (sym == NULL)
 		return false;
 
+	symnum = sym - syms->start;
+
 	if (!fsa->gplok) {
 		if (syms->licence == GPL_ONLY)
 			return false;
-- 
1.7.4.1

