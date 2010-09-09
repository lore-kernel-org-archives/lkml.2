Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0IITpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:45:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:40584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab0IITpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:45:08 -0400
Date: Thu, 9 Sep 2010 19:44:44 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mathieu.desnoyers@efficios.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20100827113912.22882.62313.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113912.22882.62313.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Fix handling of C-unlike argument names
Message-ID: <tip-da34634fd39958725310d2c30c9b4543945f968b@git.kernel.org>
Git-Commit-ID: da34634fd39958725310d2c30c9b4543945f968b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:44:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da34634fd39958725310d2c30c9b4543945f968b
Gitweb:     http://git.kernel.org/tip/da34634fd39958725310d2c30c9b4543945f968b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 27 Aug 2010 20:39:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Sep 2010 11:47:19 -0300

tracing/kprobe: Fix handling of C-unlike argument names

Check the argument name whether it is invalid (not C-like symbol name). This
makes event format simple.

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20100827113912.22882.62313.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_kprobe.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a39251e..544301d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -514,8 +514,8 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
-/* Check the name is good for event/group */
-static int check_event_name(const char *name)
+/* Check the name is good for event/group/fields */
+static int is_good_name(const char *name)
 {
 	if (!isalpha(*name) && *name != '_')
 		return 0;
@@ -557,7 +557,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	else
 		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
-	if (!event || !check_event_name(event)) {
+	if (!event || !is_good_name(event)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -567,7 +567,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	if (!tp->call.name)
 		goto error;
 
-	if (!group || !check_event_name(group)) {
+	if (!group || !is_good_name(group)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -883,7 +883,7 @@ static int create_trace_probe(int argc, char **argv)
 	int i, ret = 0;
 	int is_return = 0, is_delete = 0;
 	char *symbol = NULL, *event = NULL, *group = NULL;
-	char *arg, *tmp;
+	char *arg;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
@@ -1012,9 +1012,13 @@ static int create_trace_probe(int argc, char **argv)
 			ret = -ENOMEM;
 			goto error;
 		}
-		tmp = strchr(tp->args[i].name, ':');
-		if (tmp)
-			*tmp = '_';	/* convert : to _ */
+
+		if (!is_good_name(tp->args[i].name)) {
+			pr_info("Invalid argument[%d] name: %s\n",
+				i, tp->args[i].name);
+			ret = -EINVAL;
+			goto error;
+		}
 
 		if (conflict_field_name(tp->args[i].name, tp->args, i)) {
 			pr_info("Argument[%d] name '%s' conflicts with "
