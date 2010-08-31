Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0HaUtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:49:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0HaUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:49:14 -0400
X-Authority-Analysis: v=1.1 cv=h9FjAN2ougM9pVhvDq3M6+cWFo1DP5/t8S/Ny2XAPyw= c=1 sm=0 a=9F6GpCbbJf0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=Pf1VxDEs3eoOzUUc9RkA:9 a=Ofrsbg_AeIgfwf8D9dwA:7 a=AJstL0UEecz3LWDJCYkFoCdv1kAA:4 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH v2][GIT PULL][v2.6.36] tracing: Fix a race in function
 profile
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
        stable <stable@kernel.org>
In-Reply-To: <1283282727.1377.356.camel@gandalf.stny.rr.com>
References: <1283282727.1377.356.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 16:49:12 -0400
Message-ID: <1283287752.1377.451.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull this version instead. The only difference is that I Cc'd the
stable list.

Thanks,

-- Steve

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2


Li Zefan (1):
      tracing: Fix a race in function profile

----
 kernel/trace/ftrace.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)
---------------------------
commit 3aaba20f26f58843e8f20611e5c0b1c06954310f
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
    Cc: stable@kernel.org
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


