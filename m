Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab2JXGDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:03:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab2JXGDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:03:06 -0400
Date: Tue, 23 Oct 2012 23:01:30 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0lsokw3xor7c4ijo45u6bauh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Validate syscall id before growing syscall table
Git-Commit-ID: 3a531260a14631ae8d231279b8738884bf808e7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 23 Oct 2012 23:01:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a531260a14631ae8d231279b8738884bf808e7b
Gitweb:     http://git.kernel.org/tip/3a531260a14631ae8d231279b8738884bf808e7b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 20 Oct 2012 12:39:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 21 Oct 2012 23:07:36 -0200

perf trace: Validate syscall id before growing syscall table

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
