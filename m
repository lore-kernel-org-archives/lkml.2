Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0IIRHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:07:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0IIRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:06:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] tracing/kprobe: Fix handling of C-unlike argument names
Date: Thu,  9 Sep 2010 14:06:45 -0300
Message-Id: <1284052005-25658-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1284052005-25658-1-git-send-email-acme@infradead.org>
References: <1284052005-25658-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.6.2.5

