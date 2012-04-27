Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778Ab2D0Iij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:38:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495Ab2D0Iif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:38:35 -0400
Date: Fri, 27 Apr 2012 01:38:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-bwse2wib954y0db7dq91bes5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Suppress the callq address
Git-Commit-ID: d22328855666464731ee95d9e1e8d35dc7a39d8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:38:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d22328855666464731ee95d9e1e8d35dc7a39d8d
Gitweb:     http://git.kernel.org/tip/d22328855666464731ee95d9e1e8d35dc7a39d8d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Apr 2012 15:26:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 15:26:47 -0300

perf annotate browser: Suppress the callq address

    0.00 |       callq  ffffffff8112f190 <__mod_zone_page_state>

Becomes:

    0.00 |       callq  __mod_zone_page_state

But if you press 'o' it gets verbose, i.e. as in objdump -dS:

    0.00 | ffffffff8116bdda:  callq  ffffffff8112f190 <__mod_zone_page_state>

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bwse2wib954y0db7dq91bes5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/annotate.h |    1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7f6c14b..b07d7d1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -20,12 +20,50 @@ const char 	*disassembler_style;
 
 static int call__parse(struct ins_operands *ops)
 {
-	ops->target = strtoull(ops->raw, NULL, 16);
+	char *endptr, *tok, *name;
+
+	ops->target = strtoull(ops->raw, &endptr, 16);
+
+	name = strchr(endptr, '<');
+	if (name == NULL)
+		goto indirect_call;
+
+	name++;
+
+	tok = strchr(name, '>');
+	if (tok == NULL)
+		return -1;
+
+	*tok = '\0';
+	ops->target_name = strdup(name);
+	*tok = '>';
+
+	return ops->target_name == NULL ? -1 : 0;
+
+indirect_call:
+	tok = strchr(endptr, '*');
+	if (tok == NULL)
+		return -1;
+
+	ops->target = strtoull(tok + 1, NULL, 16);
 	return 0;
 }
 
+static int call__scnprintf(struct ins *ins, char *bf, size_t size,
+			   struct ins_operands *ops, bool addrs)
+{
+	if (addrs)
+		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
+
+	if (ops->target_name)
+		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->target_name);
+
+	return scnprintf(bf, size, "%-6.6s *%" PRIx64, ins->name, ops->target);
+}
+
 static struct ins_ops call_ops = {
-	.parse = call__parse,
+	.parse	   = call__parse,
+	.scnprintf = call__scnprintf,
 };
 
 bool ins__is_call(const struct ins *ins)
@@ -251,6 +289,7 @@ void disasm_line__free(struct disasm_line *dl)
 {
 	free(dl->line);
 	free(dl->name);
+	free(dl->ops.target_name);
 	free(dl);
 }
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a6f60d5..8a8af0d 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -11,6 +11,7 @@ struct ins;
 
 struct ins_operands {
 	char	*raw;
+	char	*target_name;
 	u64	target;
 };
 
