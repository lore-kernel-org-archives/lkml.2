Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab2I1Qka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:40:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab2I1Qk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:40:27 -0400
Date: Fri, 28 Sep 2012 09:40:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-3m9su7jhwnxvepnr3ne1du5k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add aliases for some syscalls
Git-Commit-ID: aec1930b0f6f281a0ca038cd03aceace3fe0bb61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:40:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aec1930b0f6f281a0ca038cd03aceace3fe0bb61
Gitweb:     http://git.kernel.org/tip/aec1930b0f6f281a0ca038cd03aceace3fe0bb61
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 27 Sep 2012 13:16:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 27 Sep 2012 13:18:49 -0300

perf trace: Add aliases for some syscalls

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
 1 files changed, 18 insertions(+), 8 deletions(-)

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
