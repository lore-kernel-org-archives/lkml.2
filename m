Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0IITnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:43:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:40488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0IITng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:43:36 -0400
Date: Thu, 9 Sep 2010 19:43:12 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mathieu.desnoyers@efficios.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <20100827113846.22882.12670.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113846.22882.12670.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Fix a memory leak in error case
Message-ID: <tip-61a527362234ac3352a91ac67c50c6f7cd248eb1@git.kernel.org>
Git-Commit-ID: 61a527362234ac3352a91ac67c50c6f7cd248eb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:43:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61a527362234ac3352a91ac67c50c6f7cd248eb1
Gitweb:     http://git.kernel.org/tip/61a527362234ac3352a91ac67c50c6f7cd248eb1
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 27 Aug 2010 20:38:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Sep 2010 11:47:18 -0300

tracing/kprobe: Fix a memory leak in error case

Fix a memory leak which happens when a field name conflicts with others. In
error case, free_trace_probe() will free all arguments until nr_args, so this
increments nr_args the begining of the loop instead of the end.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20100827113846.22882.12670.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_kprobe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 8b27c98..0116c03 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -992,6 +992,9 @@ static int create_trace_probe(int argc, char **argv)
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		/* Increment count for freeing args in error case */
+		tp->nr_args++;
+
 		/* Parse argument name */
 		arg = strchr(argv[i], '=');
 		if (arg)
@@ -1021,11 +1024,8 @@ static int create_trace_probe(int argc, char **argv)
 		ret = parse_probe_arg(arg, tp, &tp->args[i], is_return);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
-			kfree(tp->args[i].name);
 			goto error;
 		}
-
-		tp->nr_args++;
 	}
 
 	ret = register_trace_probe(tp);
