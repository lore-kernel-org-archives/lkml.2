Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1DOPZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:25:37 -0400
Received: from mail1.elettra.trieste.it ([140.105.4.201]:56573 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755223Ab1DOPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:25:26 -0400
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 4/4] module: Use the binary search for symbols resolution
Date: Fri, 15 Apr 2011 17:24:57 +0200
Message-Id: <1302881097-563-5-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302881097-563-1-git-send-email-abogani@kernel.org>
References: <1302881097-563-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takes advantage of the order and locates symbols using binary search.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 kernel/module.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8845a0b..731173c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -57,6 +57,7 @@
 #include <linux/kmemleak.h>
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
+#include <linux/bsearch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -244,12 +245,15 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 					      unsigned int symnum, void *data),
 				   void *data)
 {
-	unsigned int i, j;
+	unsigned int j;
+	const struct kernel_symbol *sym, *start;
+	size_t size = sizeof(struct kernel_symbol);
 
 	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (cmp(data, &arr[j].start[i]) == 0)
-				return fn(&arr[j], owner, i, data);
+		start = arr[j].start;
+		sym = bsearch(data, start, arr[j].stop - arr[j].start, size, cmp);
+		if (sym != NULL)
+			return fn(&arr[j], owner, sym - start, data);
 	}
 
 	return false;
-- 
1.7.0.4

