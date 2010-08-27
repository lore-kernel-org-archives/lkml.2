Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0H0Lh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:37:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45067 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab0H0LhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:37:20 -0400
X-AuditID: b753bd60-a7adaba000000a18-ce-4c77a36d0171
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 4/5] tracing/kprobes: Set a name for each argument
	automatically
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
Date: Fri, 27 Aug 2010 20:39:06 +0900
Message-ID: <20100827113906.22882.59312.stgit@ltc236.sdl.hitachi.co.jp>
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

Set "argN" name for each argument automatically if it has
no specified name. Since dynamic trace event(kprobe_events)
accepts special characters for its argument, its format
can show those special characters (e.g. '$', '%', '+').
However, perf can't parse those format because of the
character (especially '%') mess up the format.
This sets "argX" name for those arguments if user omitted
the argument names.

E.g.
 # echo 'p do_fork %ax IP=%ip $stack' > tracing/kprobe_events
 # cat tracing/kprobe_events
 p:kprobes/p_do_fork_0 do_fork arg1=%ax IP=%ip arg3=$stack

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
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

