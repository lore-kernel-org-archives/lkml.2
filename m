Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0IIRG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:06:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:38053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab0IIRG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:06:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] tracing/kprobe: Fix a memory leak in error case
Date: Thu,  9 Sep 2010 14:06:41 -0300
Message-Id: <1284052005-25658-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1284052005-25658-1-git-send-email-acme@infradead.org>
References: <1284052005-25658-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.6.2.5

