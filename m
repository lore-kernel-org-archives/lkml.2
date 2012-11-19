Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab2KSFVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:21:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2KSFVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:21:12 -0500
Message-ID: <50A9C1BD.1060308@gmail.com>
Date: Mon, 19 Nov 2012 13:21:01 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH] trace: use __this_cpu_inc/dec operation instead of __get_cpu_var
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

__this_cpu_inc_return() or __this_cpu_dec generates a single instruction,
which is faster than __get_cpu_var operation.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 18c0aa8..3795694 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1313,7 +1313,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	 */
 	preempt_disable_notrace();
 
-	use_stack = ++__get_cpu_var(ftrace_stack_reserve);
+	use_stack = __this_cpu_inc_return(ftrace_stack_reserve);
 	/*
 	 * We don't need any atomic variables, just a barrier.
 	 * If an interrupt comes in, we don't care, because it would
@@ -1367,7 +1367,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
  out:
 	/* Again, don't let gcc optimize things here */
 	barrier();
-	__get_cpu_var(ftrace_stack_reserve)--;
+	__this_cpu_dec(ftrace_stack_reserve);
 	preempt_enable_notrace();
 
 }
-- 
1.7.1

