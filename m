Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2JVQbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:31:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:56263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2JVQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:31:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf trace: Validate syscall id before growing syscall table
Date: Mon, 22 Oct 2012 14:30:21 -0200
Message-Id: <1350923425-15400-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350923425-15400-1-git-send-email-acme@infradead.org>
References: <1350923425-15400-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In some cases the ID for a syscall read thru the raw_syscalls tracepoint
is bogus, still needs to be investigated why, but to make the tool more
robust first try to resolve the ID to a name via libaudit and if it
fails, don't grow the table.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0lsokw3xor7c4ijo45u6bauh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dec8ced..83c6515 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -56,6 +56,10 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 {
 	char tp_name[128];
 	struct syscall *sc;
+	const char *name = audit_syscall_to_name(id, trace->audit_machine);
+
+	if (name == NULL)
+		return -1;
 
 	if (id > trace->syscalls.max) {
 		struct syscall *nsyscalls = realloc(trace->syscalls.table, (id + 1) * sizeof(*sc));
@@ -75,11 +79,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	}
 
 	sc = trace->syscalls.table + id;
-	sc->name = audit_syscall_to_name(id, trace->audit_machine);
-	if (sc->name == NULL)
-		return -1;
-
-	sc->fmt = syscall_fmt__find(sc->name);
+	sc->name = name;
+	sc->fmt  = syscall_fmt__find(sc->name);
 
 	snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->name);
 	sc->tp_format = event_format__new("syscalls", tp_name);
-- 
1.7.1

