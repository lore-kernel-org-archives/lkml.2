Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714Ab2JXVyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:54:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:40940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161328Ab2JXVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:50:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 11/12] perf trace: Print the name of a syscall when failing to read its info
Date: Wed, 24 Oct 2012 19:50:22 -0200
Message-Id: <1351115423-9025-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When failing to read the tracepoint event format, like currently with
sys_execve, that is not defined via SYSCALL_DEFINE macros and thus
doesn't have an entry in:

  $ ls -d /sys/kernel/debug/tracing/events/syscalls/sys_enter_*exec*
  /sys/kernel/debug/tracing/events/syscalls/sys_enter_kexec_load
  $

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
Link: http://lkml.kernel.org/n/tip-q3ak0j8b81yxylykq5wp2uwi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fb83cfe..ba05510 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -278,7 +278,10 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	return &trace->syscalls.table[id];
 
 out_cant_read:
-	printf("Problems reading syscall %d information\n", id);
+	printf("Problems reading syscall %d", id);
+	if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
+		printf("(%s)", trace->syscalls.table[id].name);
+	puts(" information");
 	return NULL;
 }
 
-- 
1.7.9.2.358.g22243

