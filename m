Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0LGHIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:08:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:57744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab0LGHIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:08:23 -0500
Date: Tue, 7 Dec 2010 07:06:49 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Fix eternal wait for stillborn child
Message-ID: <tip-18483b81ee7e70ee68d4b18be618be5cfcc0b290@git.kernel.org>
Git-Commit-ID: 18483b81ee7e70ee68d4b18be618be5cfcc0b290
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 07:06:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18483b81ee7e70ee68d4b18be618be5cfcc0b290
Gitweb:     http://git.kernel.org/tip/18483b81ee7e70ee68d4b18be618be5cfcc0b290
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 6 Dec 2010 15:13:38 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Dec 2010 15:13:38 -0200

perf record: Fix eternal wait for stillborn child

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
