Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2DZPHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:07:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2DZPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:06:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf annotate: Mark jump instructions with no offset
Date: Thu, 26 Apr 2012 12:06:16 -0300
Message-Id: <1335452777-27326-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335452777-27326-1-git-send-email-acme@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I.e. jumps that go to code outside the current function, that is denoted
in objdump -dS as:

   399f877a9f: jne    399f87bcf4 <_L_lock_5154>

I.e. without the + after the name of the current function, like in:

   399f877aa5: jmp    399f877ab2 <_int_free+0x412>

The browser will use that info to avoid drawing connectors to the start
of the function, since ops.target.addr was zero.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xrn35g2mlawz1ydo1p73w3q6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    9 ++++++---
 tools/perf/util/annotate.h |    6 ++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e1e7d0e..5eb3412 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -75,10 +75,13 @@ static int jump__parse(struct ins_operands *ops)
 {
 	const char *s = strchr(ops->raw, '+');
 
-	if (s++ == NULL)
-		return -1;
+	ops->target.addr = strtoll(ops->raw, NULL, 16);
+
+	if (s++ != NULL)
+		ops->target.offset = strtoll(s, NULL, 16);
+	else
+		ops->target.offset = UINT64_MAX;
 
-	ops->target.offset = strtoll(s, NULL, 16);
 	return 0;
 }
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 2b9e3e0..13a21f1 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -2,6 +2,7 @@
 #define __PERF_ANNOTATE_H
 
 #include <stdbool.h>
+#include <stdint.h>
 #include "types.h"
 #include "symbol.h"
 #include <linux/list.h>
@@ -41,6 +42,11 @@ struct disasm_line {
 	struct ins_operands ops;
 };
 
+static inline bool disasm_line__has_offset(const struct disasm_line *dl)
+{
+	return dl->ops.target.offset != UINT64_MAX;
+}
+
 void disasm_line__free(struct disasm_line *dl);
 struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
 size_t disasm__fprintf(struct list_head *head, FILE *fp);
-- 
1.7.9.2.358.g22243

