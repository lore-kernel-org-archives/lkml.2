Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1IWU0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:26:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:39407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1IWU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Eric B Munson <emunson@mgebm.net>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf symbols: Add some heuristics for choosing the best duplicate symbol
Date: Fri, 23 Sep 2011 17:26:19 -0300
Message-Id: <1316809586-28529-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Try and pick the best symbol based on a few heuristics:

-  Prefer a non weak symbol over a weak one
-  Prefer a global symbol over a non global one
-  Prefer a symbol with less underscores (idea taken from kallsyms.c)
-  If all else fails, choose the symbol with the longest name

Cc: Eric B Munson <emunson@mgebm.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110824065243.161953371@samba.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0d94ddb..870b3b8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -86,6 +86,92 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 	}
 }
 
+static int prefix_underscores_count(const char *str)
+{
+	const char *tail = str;
+
+	while (*tail == '_')
+		tail++;
+
+	return tail - str;
+}
+
+#define SYMBOL_A 0
+#define SYMBOL_B 1
+
+static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
+{
+	s64 a;
+	s64 b;
+
+	/* Prefer a symbol with non zero length */
+	a = syma->end - syma->start;
+	b = symb->end - symb->start;
+	if ((b == 0) && (a > 0))
+		return SYMBOL_A;
+	else if ((a == 0) && (b > 0))
+		return SYMBOL_B;
+
+	/* Prefer a non weak symbol over a weak one */
+	a = syma->binding == STB_WEAK;
+	b = symb->binding == STB_WEAK;
+	if (b && !a)
+		return SYMBOL_A;
+	if (a && !b)
+		return SYMBOL_B;
+
+	/* Prefer a global symbol over a non global one */
+	a = syma->binding == STB_GLOBAL;
+	b = symb->binding == STB_GLOBAL;
+	if (a && !b)
+		return SYMBOL_A;
+	if (b && !a)
+		return SYMBOL_B;
+
+	/* Prefer a symbol with less underscores */
+	a = prefix_underscores_count(syma->name);
+	b = prefix_underscores_count(symb->name);
+	if (b > a)
+		return SYMBOL_A;
+	else if (a > b)
+		return SYMBOL_B;
+
+	/* If all else fails, choose the symbol with the longest name */
+	if (strlen(syma->name) >= strlen(symb->name))
+		return SYMBOL_A;
+	else
+		return SYMBOL_B;
+}
+
+static void symbols__fixup_duplicate(struct rb_root *symbols)
+{
+	struct rb_node *nd;
+	struct symbol *curr, *next;
+
+	nd = rb_first(symbols);
+
+	while (nd) {
+		curr = rb_entry(nd, struct symbol, rb_node);
+again:
+		nd = rb_next(&curr->rb_node);
+		next = rb_entry(nd, struct symbol, rb_node);
+
+		if (!nd)
+			break;
+
+		if (curr->start != next->start)
+			continue;
+
+		if (choose_best_symbol(curr, next) == SYMBOL_A) {
+			rb_erase(&next->rb_node, symbols);
+			goto again;
+		} else {
+			nd = rb_next(&curr->rb_node);
+			rb_erase(&curr->rb_node, symbols);
+		}
+	}
+}
+
 static void symbols__fixup_end(struct rb_root *symbols)
 {
 	struct rb_node *nd, *prevnd = rb_first(symbols);
@@ -692,6 +778,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	symbols__fixup_duplicate(&dso->symbols[map->type]);
 	symbols__fixup_end(&dso->symbols[map->type]);
 
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
@@ -1269,6 +1356,7 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
+		symbols__fixup_duplicate(&dso->symbols[map->type]);
 		symbols__fixup_end(&dso->symbols[map->type]);
 		if (kmap) {
 			/*
-- 
1.6.2.5

