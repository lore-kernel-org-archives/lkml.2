Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab1HXG73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:59:29 -0400
Received: from ozlabs.org ([203.10.76.45]:43441 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab1HXG6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:58:50 -0400
X-Mailbox-Line: From anton@samba.org Wed Aug 24 16:52:43 2011
Message-Id: <20110824065242.969681349@samba.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Aug 2011 16:40:15 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] perf symbols: /proc/kallsyms does not sort module symbols
References: <20110824064013.205515988@samba.org>
Content-Disposition: inline; filename=kallsyms_1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kallsyms__parse assumes that /proc/kallsyms is sorted and sets the
end of the previous symbol to the start of the current one.

Unfortunately module symbols are not sorted, eg:

ffffffffa0081f30 t e1000_clean_rx_irq   [e1000e]
ffffffffa00817a0 t e1000_alloc_rx_buffers       [e1000e]

Some symbols end up with a negative length and others have a length
larger than they should. This results in confusing perf output.

We already have a function to fixup the end of zero length symbols
so use that instead.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/util/symbol.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/symbol.c	2011-08-19 12:33:21.501373684 +1000
+++ linux-2.6-tip/tools/perf/util/symbol.c	2011-08-19 12:33:24.711429312 +1000
@@ -440,18 +440,11 @@ int kallsyms__parse(const char *filename
 	char *line = NULL;
 	size_t n;
 	int err = -1;
-	u64 prev_start = 0;
-	char prev_symbol_type = 0;
-	char *prev_symbol_name;
 	FILE *file = fopen(filename, "r");
 
 	if (file == NULL)
 		goto out_failure;
 
-	prev_symbol_name = malloc(KSYM_NAME_LEN);
-	if (prev_symbol_name == NULL)
-		goto out_close;
-
 	err = 0;
 
 	while (!feof(file)) {
@@ -482,24 +475,18 @@ int kallsyms__parse(const char *filename
 			break;
 		}
 
-		if (prev_symbol_type) {
-			u64 end = start;
-			if (end != prev_start)
-				--end;
-			err = process_symbol(arg, prev_symbol_name,
-					     prev_symbol_type, prev_start, end);
-			if (err)
-				break;
-		}
-
-		memcpy(prev_symbol_name, symbol_name, len + 1);
-		prev_symbol_type = symbol_type;
-		prev_start = start;
+		/*
+		 * module symbols are not sorted so we add all
+		 * symbols with zero length and rely on
+		 * symbols__fixup_end() to fix it up.
+		 */
+		err = process_symbol(arg, symbol_name,
+				     symbol_type, start, start);
+		if (err)
+			break;
 	}
 
-	free(prev_symbol_name);
 	free(line);
-out_close:
 	fclose(file);
 	return err;
 
@@ -705,6 +692,8 @@ int dso__load_kallsyms(struct dso *dso,
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	symbols__fixup_end(&dso->symbols[map->type]);
+
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 		dso->symtab_type = SYMTAB__GUEST_KALLSYMS;
 	else


