Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0C3XUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:37 -0400
Received: from kroah.org ([198.145.64.141]:45759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab0C3XT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:29 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:33 2010
Message-Id: <20100330224733.087568762@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [020/156] function-graph: Init curr_ret_stack with ret_stack
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit ea14eb714041d40fcc5180b5a586034503650149 upstream.

If the graph tracer is active, and a task is forked but the allocating of
the processes graph stack fails, it can cause crash later on.

This is due to the temporary stack being NULL, but the curr_ret_stack
variable is copied from the parent. If it is not -1, then in
ftrace_graph_probe_sched_switch() the following:

	for (index = next->curr_ret_stack; index >= 0; index--)
		next->ret_stack[index].calltime += timestamp;

Will cause a kernel OOPS.

Found with Li Zefan's ftrace_stress_test.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3364,6 +3364,7 @@ void ftrace_graph_init_task(struct task_
 {
 	/* Make sure we do not use the parent ret_stack */
 	t->ret_stack = NULL;
+	t->curr_ret_stack = -1;
 
 	if (ftrace_graph_active) {
 		struct ftrace_ret_stack *ret_stack;
@@ -3373,7 +3374,6 @@ void ftrace_graph_init_task(struct task_
 				GFP_KERNEL);
 		if (!ret_stack)
 			return;
-		t->curr_ret_stack = -1;
 		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
 		t->ftrace_timestamp = 0;


