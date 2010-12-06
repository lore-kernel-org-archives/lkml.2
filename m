Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0LFUZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:25:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:58244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0LFUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:25:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/1] perf record: Fix eternal wait for stillborn child
Date: Mon,  6 Dec 2010 18:25:04 -0200
Message-Id: <1291667104-7050-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291667104-7050-1-git-send-email-acme@infradead.org>
References: <1291667104-7050-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When execvp fails to find the specified command on the path we won't get
SIGCHLD, so send a SIGUSR1 and exit right away.

Current situation would require a SIGINT performed by the user and would
produce meaningless summary.

Now:

[acme@emilia linux]$ ./foo
-bash: ./foo: No such file or directory
[acme@emilia linux]$ perf record ./foo
./foo: No such file or directory
[acme@emilia linux]$

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e2c2de2..564491f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -197,7 +197,7 @@ static void sig_atexit(void)
 	if (child_pid > 0)
 		kill(child_pid, SIGTERM);
 
-	if (signr == -1)
+	if (signr == -1 || signr == SIGUSR1)
 		return;
 
 	signal(signr, SIG_DFL);
@@ -515,6 +515,7 @@ static int __cmd_record(int argc, const char **argv)
 	atexit(sig_atexit);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
+	signal(SIGUSR1, sig_handler);
 
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
@@ -606,6 +607,7 @@ static int __cmd_record(int argc, const char **argv)
 			execvp(argv[0], (char **)argv);
 
 			perror(argv[0]);
+			kill(getppid(), SIGUSR1);
 			exit(-1);
 		}
 
@@ -762,7 +764,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	if (quiet)
+	if (quiet || signr == SIGUSR1)
 		return 0;
 
 	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
-- 
1.6.2.5

