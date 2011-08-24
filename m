Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1HXG6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:58:54 -0400
Received: from ozlabs.org ([203.10.76.45]:43441 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab1HXG6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:58:52 -0400
X-Mailbox-Line: From anton@samba.org Wed Aug 24 16:52:43 2011
Message-Id: <20110824065243.161953371@samba.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Aug 2011 16:40:17 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] perf symbols: Add some heuristics for choosing the best duplicate symbol
References: <20110824064013.205515988@samba.org>
Content-Disposition: inline; filename=duplicate_symbols_1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try and pick the best symbol based on a few heuristics:

-  Prefer a non weak symbol over a weak one
-  Prefer a global symbol over a non global one
-  Prefer a symbol with less underscores (idea taken from kallsyms.c)
-  If all else fails, choose the symbol with the longest name

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/util/symbol.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/symbol.c	2011-08-24 14:53:38.672717864 +1000
+++ linux-2.6-tip/tools/perf/util/symbol.c	2011-08-24 16:22:00.636612163 +1000
@@ -88,6 +88,92 @@ bool symbol_type__is_a(char symbol_type,
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
@@ -694,6 +780,7 @@ int dso__load_kallsyms(struct dso *dso,
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	symbols__fixup_duplicate(&dso->symbols[map->type]);
 	symbols__fixup_end(&dso->symbols[map->type]);
 
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
@@ -1271,6 +1358,7 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
+		symbols__fixup_duplicate(&dso->symbols[map->type]);
 		symbols__fixup_end(&dso->symbols[map->type]);
 		if (kmap) {
 			/*


