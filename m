Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0IRTym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:54:42 -0400
Received: from kroah.org ([198.145.64.141]:51335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab0IRTBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:38 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185956.590210858@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [044/123] tracing: Fix a race in function profile
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=tracing-fix-a-race-in-function-profile.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -369,11 +369,18 @@ static int function_stat_show(struct seq
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
@@ -383,17 +390,17 @@ static int function_stat_show(struct seq
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


