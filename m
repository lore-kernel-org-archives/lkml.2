Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0H0LhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:37:06 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35334 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0H0LhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:37:01 -0400
X-AuditID: b753bd60-a78bfba000005a63-8f-4c77a35a8100
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  1/5] tracing/kprobe: Fix a memory leak in error case
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 20:38:46 +0900
Message-ID: <20100827113846.22882.12670.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20100827113837.22882.92630.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113837.22882.92630.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak which happens when a field name conflicts
with others. In error case, free_trace_probe() will free all
arguments until nr_args, so this increments nr_args the
begining of the loop instead of the end.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
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

