Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0IITow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:44:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:40550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0IITot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:44:49 -0400
Date: Thu, 9 Sep 2010 19:44:22 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mathieu.desnoyers@efficios.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20100827113906.22882.59312.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113906.22882.59312.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobes: Fix handling of argument names
Message-ID: <tip-aba91595cfcebd193425e20aabc407531526a1c5@git.kernel.org>
Git-Commit-ID: aba91595cfcebd193425e20aabc407531526a1c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:44:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aba91595cfcebd193425e20aabc407531526a1c5
Gitweb:     http://git.kernel.org/tip/aba91595cfcebd193425e20aabc407531526a1c5
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 27 Aug 2010 20:39:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Sep 2010 11:47:19 -0300

tracing/kprobes: Fix handling of argument names

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
