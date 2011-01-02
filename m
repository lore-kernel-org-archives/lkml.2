Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1ABIDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:03:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:34698 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1ABHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 062/260] tracing: Fix a race in function profile
Date: Sun,  2 Jan 2011 02:15:58 -0500
Message-Id: <1293952756-15010-63-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:13.0445 (UTC) FILETIME=[A305A150:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

commit 3aaba20f26f58843e8f20611e5c0b1c06954310f upstream.

While we are reading trace_stat/functionX and someone just
disabled function_profile at that time, we can trigger this:

	divide error: 0000 [#1] PREEMPT SMP
	...
	EIP is at function_stat_show+0x90/0x230
	...

This fix just takes the ftrace_profile_lock and checks if
rec->counter is 0. If it's 0, we know the profile buffer
has been reset.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4C723644.4040708@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/trace/ftrace.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2404b59..ed676ba 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -380,11 +380,18 @@ static int function_stat_show(struct seq_file *m, void *v)
 {
 	struct ftrace_profile *rec = v;
 	char str[KSYM_SYMBOL_LEN];
+	int ret = 0;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
 	unsigned long long avg;
 #endif
+	mutex_lock(&ftrace_profile_lock);
+
+	/* we raced with function_profile_reset() */
+	if (unlikely(rec->counter == 0)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
@@ -394,17 +401,17 @@ static int function_stat_show(struct seq_file *m, void *v)
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
-	mutex_lock(&mutex);
 	trace_seq_init(&s);
 	trace_print_graph_duration(rec->time, &s);
 	trace_seq_puts(&s, "    ");
 	trace_print_graph_duration(avg, &s);
 	trace_print_seq(m, &s);
-	mutex_unlock(&mutex);
 #endif
 	seq_putc(m, '\n');
+out:
+	mutex_unlock(&ftrace_profile_lock);
 
-	return 0;
+	return ret;
 }
 
 static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
-- 
1.7.3.3

