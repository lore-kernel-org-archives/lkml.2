Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1IWU0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:26:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34984 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1IWU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Eric B Munson <emunson@mgebm.net>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/12] perf symbols: /proc/kallsyms does not sort module symbols
Date: Fri, 23 Sep 2011 17:26:17 -0300
Message-Id: <1316809586-28529-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

kallsyms__parse assumes that /proc/kallsyms is sorted and sets the end
of the previous symbol to the start of the current one.

Unfortunately module symbols are not sorted, eg:

ffffffffa0081f30 t e1000_clean_rx_irq   [e1000e]
ffffffffa00817a0 t e1000_alloc_rx_buffers       [e1000e]

Some symbols end up with a negative length and others have a length
larger than they should. This results in confusing perf output.

We already have a function to fixup the end of zero length symbols so
use that instead.

Cc: Eric B Munson <emunson@mgebm.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110824065242.969681349@samba.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   33 +++++++++++----------------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index bb5d32f..f119e85 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -438,18 +438,11 @@ int kallsyms__parse(const char *filename, void *arg,
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
@@ -480,24 +473,18 @@ int kallsyms__parse(const char *filename, void *arg,
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
 
@@ -703,6 +690,8 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	symbols__fixup_end(&dso->symbols[map->type]);
+
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 		dso->symtab_type = SYMTAB__GUEST_KALLSYMS;
 	else
-- 
1.6.2.5

