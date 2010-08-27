Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0H0Lhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:37:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45092 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0H0Lh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:37:26 -0400
X-AuditID: b753bd60-a6acdba000005dcc-b9-4c77a372e944
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  5/5] tracing/kprobe: Check invalid argument name
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
Date: Fri, 27 Aug 2010 20:39:12 +0900
Message-ID: <20100827113912.22882.62313.stgit@ltc236.sdl.hitachi.co.jp>
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

Check the argument name whether it is invalid (not C-like
symbol name). This makes event format simple.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
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

