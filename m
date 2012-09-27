Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2I0VTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:19:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:49038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2I0VSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:18:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf trace: Add aliases for some syscalls
Date: Thu, 27 Sep 2012 18:18:06 -0300
Message-Id: <1348780686-16108-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348780686-16108-1-git-send-email-acme@infradead.org>
References: <1348780686-16108-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

What we get from audit_syscall_to_name isn't what we find in the
syscalls: tracepoint events, so add the alias that allows the tool to
find prctl, fstat, fstatat and stat.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3m9su7jhwnxvepnr3ne1du5k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5fa1820..8f113da 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -9,15 +9,20 @@
 
 static struct syscall_fmt {
 	const char *name;
+	const char *alias;
 	bool	   errmsg;
 	bool	   timeout;
 } syscall_fmts[] = {
-	{ .name	    = "futex",	  .errmsg = true, },
-	{ .name	    = "poll",	  .errmsg = true, .timeout = true, },
-	{ .name	    = "ppoll",	  .errmsg = true, .timeout = true, },
-	{ .name	    = "read",	  .errmsg = true, },
-	{ .name	    = "recvfrom", .errmsg = true, },
-	{ .name	    = "select",	  .errmsg = true, .timeout = true, },
+	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
+	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
+	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
+	{ .name	    = "futex",	    .errmsg = true, },
+	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
+	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
+	{ .name	    = "read",	    .errmsg = true, },
+	{ .name	    = "recvfrom",   .errmsg = true, },
+	{ .name	    = "select",	    .errmsg = true, .timeout = true, },
+	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 };
 
 static int syscall_fmt__cmp(const void *name, const void *fmtp)
@@ -74,10 +79,15 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	if (sc->name == NULL)
 		return -1;
 
-	snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->name);
+	sc->fmt = syscall_fmt__find(sc->name);
 
+	snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->name);
 	sc->tp_format = event_format__new("syscalls", tp_name);
-	sc->fmt = syscall_fmt__find(sc->name);
+
+	if (sc->tp_format == NULL && sc->fmt && sc->fmt->alias) {
+		snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->fmt->alias);
+		sc->tp_format = event_format__new("syscalls", tp_name);
+	}
 
 	return sc->tp_format != NULL ? 0 : -1;
 }
-- 
1.7.9.2.358.g22243

