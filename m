Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1GYEYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 00:24:03 -0400
Received: from ozlabs.org ([203.10.76.45]:47354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1GYEX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 00:23:59 -0400
Date: Mon, 25 Jul 2011 14:23:56 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix symbol resolution on old ppc64 ABI
Message-ID: <20110725142356.0c722c6b@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The synthetic symbol creation code has an issue with the old ppc64
ABI. We end up with duplicate symbols of different sizes that overlap.

To fix this, walk all of the symbols and remove any duplicates that
are the length of a function descriptor.

Before:     
     
     5.46%      ppc64_cpu  [kernel.kallsyms]     [k] 0xc0000000003a2ddc
                     |
                     --- 0xc0000000003a2dc0
                        |
                        |--99.99%-- 0xc0000000003a2dd4
                        |          |
                        |          |--99.40%-- .cpu_node_mask

After:

     5.51%      ppc64_cpu  [kernel.kallsyms]     [k] .__bitmap_weight
                     |
                     --- .__bitmap_weight
                        |          
                        |--99.41%-- .__bitmap_weight
                        |          |          
                        |          |--89.55%-- .cpu_node_mask

Signed-off-by: Anton Blanchard <anton@samba.org>
---

I'd prefer not to add a ppc64 specific hack here, but I'm not sure
how we can fix this in a simpler way.

Index: linux-2.6-tip/tools/perf/util/symbol.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/symbol.c	2011-07-24 15:06:14.423324103 +1000
+++ linux-2.6-tip/tools/perf/util/symbol.c	2011-07-24 15:21:42.149736397 +1000
@@ -107,6 +107,58 @@ static void symbols__fixup_end(struct rb
 		curr->end = roundup(curr->start, 4096);
 }
 
+/*
+ * There are two 64bit PowerPC ABIs. The old version creates symbols at the
+ * first instruction of each function by adding a '.' to the start of a symbol
+ * name. A function descriptor called foo has a a symbol called .foo at the
+ * address of the first instruction.
+ *
+ * The new version doesn't create these '.' symbols and instead requires us
+ * to synthesize symbols by parsing the function descriptor section (which
+ * provides a mapping of function name to instruction address, amongst other
+ * things).
+ *
+ * If we created synthetic symbols for an old style object then we end up
+ * with duplicate symbols. The '.' symbol that covers the entire function,
+ * and a fake synthetic symbol that is the length of a function descriptor.
+ *
+ * To fix this, we walk all of the symbols and remove any duplicates that
+ * are the length of a function descriptor.
+ */
+
+/* A ppc64 function descriptor contains 3 64bit values */
+#define PPC64_FUNCTION_DESCRIPTOR_LEN  (3 * sizeof(u64))
+
+static void symbols__fixup_ppc64(struct rb_root *symbols)
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
+		if (curr->start == next->start) {
+			if ((curr->end - curr->start + 1) ==
+					PPC64_FUNCTION_DESCRIPTOR_LEN) {
+				nd = rb_next(&curr->rb_node);
+				rb_erase(&curr->rb_node, symbols);
+			} else if ((next->end - next->start + 1) ==
+					PPC64_FUNCTION_DESCRIPTOR_LEN) {
+				rb_erase(&next->rb_node, symbols);
+				goto again;
+			}
+		}
+	}
+}
+
 static void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 {
 	struct map *prev, *curr;
@@ -1278,6 +1330,9 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
+		if (ehdr.e_machine == EM_PPC64)
+			symbols__fixup_ppc64(&dso->symbols[map->type]);
+
 		symbols__fixup_end(&dso->symbols[map->type]);
 		if (kmap) {
 			/*
