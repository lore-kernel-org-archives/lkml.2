Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0IIRHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:07:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:38054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0IIRG6 (ORCPT
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
Subject: [PATCH 4/5] tracing/kprobes: Fix handling of argument names
Date: Thu,  9 Sep 2010 14:06:44 -0300
Message-Id: <1284052005-25658-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1284052005-25658-1-git-send-email-acme@infradead.org>
References: <1284052005-25658-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Set "argN" name for each argument automatically if it has no specified name.
Since dynamic trace event(kprobe_events) accepts special characters for its
argument, its format can show those special characters (e.g. '$', '%', '+').
However, perf can't parse those format because of the character (especially
'%') mess up the format.  This sets "argX" name for those arguments if user
omitted the argument names.

E.g.
 # echo 'p do_fork %ax IP=%ip $stack' > tracing/kprobe_events
 # cat tracing/kprobe_events
 p:kprobes/p_do_fork_0 do_fork arg1=%ax IP=%ip arg3=$stack

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20100827113906.22882.59312.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_kprobe.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0116c03..a39251e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -997,15 +997,18 @@ static int create_trace_probe(int argc, char **argv)
 
 		/* Parse argument name */
 		arg = strchr(argv[i], '=');
-		if (arg)
+		if (arg) {
 			*arg++ = '\0';
-		else
+			tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+		} else {
 			arg = argv[i];
+			/* If argument name is omitted, set "argN" */
+			snprintf(buf, MAX_EVENT_NAME_LEN, "arg%d", i + 1);
+			tp->args[i].name = kstrdup(buf, GFP_KERNEL);
+		}
 
-		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
 		if (!tp->args[i].name) {
-			pr_info("Failed to allocate argument%d name '%s'.\n",
-				i, argv[i]);
+			pr_info("Failed to allocate argument[%d] name.\n", i);
 			ret = -ENOMEM;
 			goto error;
 		}
@@ -1014,7 +1017,7 @@ static int create_trace_probe(int argc, char **argv)
 			*tmp = '_';	/* convert : to _ */
 
 		if (conflict_field_name(tp->args[i].name, tp->args, i)) {
-			pr_info("Argument%d name '%s' conflicts with "
+			pr_info("Argument[%d] name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
 			goto error;
@@ -1023,7 +1026,7 @@ static int create_trace_probe(int argc, char **argv)
 		/* Parse fetch argument */
 		ret = parse_probe_arg(arg, tp, &tp->args[i], is_return);
 		if (ret) {
-			pr_info("Parse error at argument%d. (%d)\n", i, ret);
+			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
 		}
 	}
-- 
1.6.2.5

