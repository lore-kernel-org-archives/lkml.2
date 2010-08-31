Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0HaVME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:12:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0HaVMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:12:02 -0400
Date: Tue, 31 Aug 2010 21:11:42 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4C723644.4040708@cn.fujitsu.com>
References: <4C723644.4040708@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix a race in function profile
Message-ID: <tip-3aaba20f26f58843e8f20611e5c0b1c06954310f@git.kernel.org>
Git-Commit-ID: 3aaba20f26f58843e8f20611e5c0b1c06954310f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 21:11:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aaba20f26f58843e8f20611e5c0b1c06954310f
Gitweb:     http://git.kernel.org/tip/3aaba20f26f58843e8f20611e5c0b1c06954310f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 23 Aug 2010 16:50:12 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Aug 2010 16:46:23 -0400

tracing: Fix a race in function profile

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
Cc: stable@kernel.org
LKML-Reference: <4C723644.4040708@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0d88ce9..7cb1f45 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -381,12 +381,19 @@ static int function_stat_show(struct seq_file *m, void *v)
 {
 	struct ftrace_profile *rec = v;
 	char str[KSYM_SYMBOL_LEN];
+	int ret = 0;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
 	unsigned long long avg;
 	unsigned long long stddev;
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
@@ -408,7 +415,6 @@ static int function_stat_show(struct seq_file *m, void *v)
 		do_div(stddev, (rec->counter - 1) * 1000);
 	}
 
-	mutex_lock(&mutex);
 	trace_seq_init(&s);
 	trace_print_graph_duration(rec->time, &s);
 	trace_seq_puts(&s, "    ");
@@ -416,11 +422,12 @@ static int function_stat_show(struct seq_file *m, void *v)
 	trace_seq_puts(&s, "    ");
 	trace_print_graph_duration(stddev, &s);
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
