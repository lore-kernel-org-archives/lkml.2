Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2ELTxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:53:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51840 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2ELTxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:53:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/8] perf annotate: Use raw form for register indirect call instructions
Date: Sat, 12 May 2012 16:53:00 -0300
Message-Id: <1336852387-16322-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336852387-16322-1-git-send-email-acme@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

   callq  *0x10(%rax)

was being rendered in simplified mode as:

   callq  *10

I.e. hexa, but without the 0x and omitting the register. In such cases
just use the raw form.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-m91tv004h2m1fkfgu6ovx3hb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 6b4146b..9a020d1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -56,6 +56,12 @@ static int call__parse(struct ins_operands *ops)
 	return ops->target.name == NULL ? -1 : 0;
 
 indirect_call:
+	tok = strchr(endptr, '(');
+	if (tok != NULL) {
+		ops->target.addr = 0;
+		return 0;
+	}
+
 	tok = strchr(endptr, '*');
 	if (tok == NULL)
 		return -1;
@@ -70,6 +76,9 @@ static int call__scnprintf(struct ins *ins, char *bf, size_t size,
 	if (ops->target.name)
 		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->target.name);
 
+	if (ops->target.addr == 0)
+		return ins__raw_scnprintf(ins, bf, size, ops);
+
 	return scnprintf(bf, size, "%-6.6s *%" PRIx64, ins->name, ops->target.addr);
 }
 
-- 
1.7.9.2.358.g22243

