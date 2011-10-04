Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1JDKmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:42:45 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60757 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab1JDKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:42:43 -0400
X-AuditID: b753bd60-9e4a1ba000005c89-f9-4e8ae320cd43
X-AuditID: b753bd60-9e4a1ba000005c89-f9-4e8ae320cd43
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 1/4] [BUGFIX] ftrace/kprobes: Fix not to delete probes if in
 use
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>
Date: Tue, 04 Oct 2011 19:44:38 +0900
Message-ID: <20111004104438.14591.6553.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kprobe-tracer not to delete a probe if the probe is in use.
In that case, delete operation will return -EBUSY.

This bug can cause a kernel panic if enabled probes are deleted
during perf record.

(Add some probes on functions)
# perf record -e probe:\* -aR sh
sh-4.2# perf probe --del probe:\*
sh-4.2# exit
(kernel panic)

This is originally reported on the fedora bugzilla:

 https://bugzilla.redhat.com/show_bug.cgi?id=742383


I've also checked that this problem doesn't happen on
tracepoints when module removing because perf event
locks target module.

$ sudo ./perf record -e xfs:\* -aR sh
sh-4.2# rmmod xfs
ERROR: Module xfs is in use
sh-4.2# exit
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.203 MB perf.data (~8862 samples) ]

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 kernel/trace/trace_kprobe.c |   58 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5fb3697..00d527c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -836,11 +836,17 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 }
 
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static void unregister_trace_probe(struct trace_probe *tp)
+static int unregister_trace_probe(struct trace_probe *tp)
 {
+	/* Enabled event can not be unregistered */
+	if (trace_probe_is_enabled(tp))
+		return -EBUSY;
+
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 	unregister_probe_event(tp);
+
+	return 0;
 }
 
 /* Register a trace_probe and probe_event */
@@ -854,7 +860,9 @@ static int register_trace_probe(struct trace_probe *tp)
 	/* Delete old (same name) event if exist */
 	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
 	if (old_tp) {
-		unregister_trace_probe(old_tp);
+		ret = unregister_trace_probe(old_tp);
+		if (ret < 0)
+			goto end;
 		free_trace_probe(old_tp);
 	}
 
@@ -892,6 +900,7 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 	mutex_lock(&probe_lock);
 	list_for_each_entry(tp, &probe_list, list) {
 		if (trace_probe_within_module(tp, mod)) {
+			/* Don't need to check busy - this should have gone. */
 			__unregister_trace_probe(tp);
 			ret = __register_trace_probe(tp);
 			if (ret)
@@ -1205,10 +1214,11 @@ static int create_trace_probe(int argc, char **argv)
 			return -ENOENT;
 		}
 		/* delete an event */
-		unregister_trace_probe(tp);
-		free_trace_probe(tp);
+		ret = unregister_trace_probe(tp);
+		if (ret == 0)
+			free_trace_probe(tp);
 		mutex_unlock(&probe_lock);
-		return 0;
+		return ret;
 	}
 
 	if (argc < 2) {
@@ -1317,18 +1327,29 @@ error:
 	return ret;
 }
 
-static void release_all_trace_probes(void)
+static int release_all_trace_probes(void)
 {
 	struct trace_probe *tp;
+	int ret = 0;
 
 	mutex_lock(&probe_lock);
+	/* Ensure no probe is in use. */
+	list_for_each_entry(tp, &probe_list, list)
+		if (trace_probe_is_enabled(tp)) {
+			ret = -EBUSY;
+			goto end;
+		}
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
 		tp = list_entry(probe_list.next, struct trace_probe, list);
 		unregister_trace_probe(tp);
 		free_trace_probe(tp);
 	}
+
+end:
 	mutex_unlock(&probe_lock);
+
+	return ret;
 }
 
 /* Probes listing interfaces */
@@ -1380,9 +1401,13 @@ static const struct seq_operations probes_seq_op = {
 
 static int probes_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC))
-		release_all_trace_probes();
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret = release_all_trace_probes();
+		if (ret < 0)
+			return ret;
+	}
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -2055,6 +2080,21 @@ static __init int kprobe_trace_self_tests_init(void)
 
 	ret = target(1, 2, 3, 4, 5, 6);
 
+	/* Disable trace points before removing it */
+	tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tp == NULL)) {
+		pr_warning("error on getting test probe.\n");
+		warn++;
+	} else
+		disable_trace_probe(tp, TP_FLAG_TRACE);
+
+	tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tp == NULL)) {
+		pr_warning("error on getting 2nd test probe.\n");
+		warn++;
+	} else
+		disable_trace_probe(tp, TP_FLAG_TRACE);
+
 	ret = command_trace_probe("-:testprobe");
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error on deleting a probe.\n");

