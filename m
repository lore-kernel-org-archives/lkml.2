Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1HJQao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:30:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1HJQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:30:40 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=vhdKIqpQuCYA:10 a=gI5QGasnKscA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=D6_8q99FMep-hr_qlsUA:9 a=RjGU6B_TXoILX9TiyakA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110810163038.699989334@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 10 Aug 2011 12:22:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 4/5][RFC] kprobes: Inverse taking of module_mutex with kprobe_mutex
References: <20110810162222.017387055@goodmis.org>
Content-Disposition: inline; filename=0004-kprobes-Inverse-taking-of-module_mutex-with-kprobe_m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently module_mutex is taken before kprobe_mutex, but this
can cause issues when we have kprobes register ftrace, as the ftrace
mutex is taken before enabling a tracepoint, which currently takes
the module mutex.

If module_mutex is taken before kprobe_mutex, then we can not
have kprobes use the ftrace infrastructure.

There seems to be no reason that the kprobe_mutex can't be taken
before the module_mutex. Running lockdep shows that it is safe
among the kernels I've run.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b30fd54..e6c25eb 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -561,9 +561,9 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
 	LIST_HEAD(free_list);
 
+	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
-	mutex_lock(&kprobe_mutex);
 
 	/*
 	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
@@ -586,8 +586,8 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	/* Step 4: Free cleaned kprobes after quiesence period */
 	do_free_cleaned_kprobes(&free_list);
 
-	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
+	mutex_unlock(&kprobe_mutex);
 
 	/* Step 5: Kick optimizer again if needed */
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
-- 
1.7.5.4


