Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab2D0IpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:45:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab2D0IpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:45:12 -0400
Date: Fri, 27 Apr 2012 01:44:54 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-xrn35g2mlawz1ydo1p73w3q6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Mark jump instructions with no offset
Git-Commit-ID: fb29fa58e36df09c807d252247d64a221fcd5bbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:45:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb29fa58e36df09c807d252247d64a221fcd5bbb
Gitweb:     http://git.kernel.org/tip/fb29fa58e36df09c807d252247d64a221fcd5bbb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Apr 2012 14:16:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Apr 2012 14:16:03 -0300

perf annotate: Mark jump instructions with no offset

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
