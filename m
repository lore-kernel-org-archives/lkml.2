Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab0HaTZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:25:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54791 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab0HaTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:25:30 -0400
X-Authority-Analysis: v=1.1 cv=PwepQEbt00S2KBGxbslVOIF+r0Mv8f+EI4NDy2BEsUE= c=1 sm=0 a=Vqe9azvFISkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=Pf1VxDEs3eoOzUUc9RkA:9 a=ka_LfQYnRXEjhFjwzMQA:7 a=pY0DJb-nNY1f3fXsT6mBGwgd9_kA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v2.6.36] tracing: Fix a race in function profile
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 15:25:27 -0400
Message-ID: <1283282727.1377.356.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I was able to reproduce the bug and also confirmed that this fixed it.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Li Zefan (1):
      tracing: Fix a race in function profile

----
 kernel/trace/ftrace.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)
---------------------------
commit 7294923e53b229603c893cbdaeba0c388276ec36
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Mon Aug 23 16:50:12 2010 +0800

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
    LKML-Reference: <4C723644.4040708@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


