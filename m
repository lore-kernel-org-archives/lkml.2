Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2GIOkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:40:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38307 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503Ab2GIOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:25 -0400
Message-Id: <20120709143120.057461094@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 23/48] tracing: change CPU ring buffer state from tracing_cpumask
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

commit 71babb2705e2203a64c27ede13ae3508a0d2c16c upstream.

According to Documentation/trace/ftrace.txt:

tracing_cpumask:

        This is a mask that lets the user only trace
        on specified CPUS. The format is a hex string
        representing the CPUS.

The tracing_cpumask currently doesn't affect the tracing state of
per-CPU ring buffers.

This patch enables/disables CPU recording as its corresponding bit in
tracing_cpumask is set/unset.

Link: http://lkml.kernel.org/r/1336096792-25373-3-git-send-email-vnagarnaik@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0ed4df0..08a08ba 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2669,10 +2669,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&global_trace.data[cpu]->disabled);
+			ring_buffer_record_disable_cpu(global_trace.buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&global_trace.data[cpu]->disabled);
+			ring_buffer_record_enable_cpu(global_trace.buffer, cpu);
 		}
 	}
 	arch_spin_unlock(&ftrace_max_lock);


