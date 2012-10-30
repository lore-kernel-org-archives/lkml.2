Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab2J3SnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:43:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42030 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2J3SnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:43:05 -0400
From: Behan Webster <behanw@converseincode.com>
To: davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
Subject: [PATCH 2/2] Remove VLAIS usage from netfilter
Date: Tue, 30 Oct 2012 14:42:54 -0400
Message-Id: <1351622574-18421-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351622574-18421-1-git-send-email-behanw@converseincode.com>
References: <1351622574-18421-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). This patch instead calculates offsets into the kmalloc-ed
memory buffer using macros from valign.h.

Patch from series at
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
by PaX Team.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Cc: pageexec@freemail.hu
[Modified to use macros from valign.h]
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 net/netfilter/xt_repldata.h |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 6efe4e5..d2b4232 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -5,31 +5,39 @@
  * they serve as the hanging-off data accessed through repl.data[].
  */
 
+#include <linux/valign.h>
+
 #define xt_alloc_initial_table(type, typ2) ({ \
 	unsigned int hook_mask = info->valid_hooks; \
 	unsigned int nhooks = hweight32(hook_mask); \
 	unsigned int bytes = 0, hooknum = 0, i = 0; \
-	struct { \
-		struct type##_replace repl; \
-		struct type##_standard entries[nhooks]; \
-		struct type##_error term; \
-	} *tbl = kzalloc(sizeof(*tbl), GFP_KERNEL); \
-	if (tbl == NULL) \
+	int replsize = paddedsize(0, 1, \
+		struct type##_replace, struct type##_standard); \
+	int entsize = paddedsize(replsize, nhooks, \
+		struct type##_standard, struct type##_error); \
+	int termsize = paddedsize(replsize+entsize, 1, \
+		struct type##_error, int); \
+	struct type##_replace *repl = kzalloc(replsize+entsize+termsize, \
+		GFP_KERNEL); \
+	if (repl == NULL) \
 		return NULL; \
-	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
-	tbl->term = (struct type##_error)typ2##_ERROR_INIT;  \
-	tbl->repl.valid_hooks = hook_mask; \
-	tbl->repl.num_entries = nhooks + 1; \
-	tbl->repl.size = nhooks * sizeof(struct type##_standard) + \
-	                 sizeof(struct type##_error); \
+	struct type##_standard *entries = paddedstart(repl, replsize, \
+		struct type##_standard); \
+	struct type##_error *term = paddedstart(entries, entsize, \
+		struct type##_error); \
+	strncpy(repl->name, info->name, sizeof(repl->name)); \
+	*term = (struct type##_error)typ2##_ERROR_INIT;  \
+	repl->valid_hooks = hook_mask; \
+	repl->num_entries = nhooks + 1; \
+	repl->size = entsize+termsize; \
 	for (; hook_mask != 0; hook_mask >>= 1, ++hooknum) { \
 		if (!(hook_mask & 1)) \
 			continue; \
-		tbl->repl.hook_entry[hooknum] = bytes; \
-		tbl->repl.underflow[hooknum]  = bytes; \
-		tbl->entries[i++] = (struct type##_standard) \
+		repl->hook_entry[hooknum] = bytes; \
+		repl->underflow[hooknum]  = bytes; \
+		entries[i++] = (struct type##_standard) \
 			typ2##_STANDARD_INIT(NF_ACCEPT); \
 		bytes += sizeof(struct type##_standard); \
 	} \
-	tbl; \
+	repl; \
 })
-- 
1.7.9.5

