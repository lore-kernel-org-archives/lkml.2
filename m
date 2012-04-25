Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab2DYVSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:18:54 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51015 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab2DYVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:18:29 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v6 3/3] trace: change CPU ring buffer state from tracing_cpumask
Date: Wed, 25 Apr 2012 14:18:24 -0700
Message-Id: <1335388704-26790-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
 <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/trace/ftrace.txt:

tracing_cpumask:

        This is a mask that lets the user only trace
        on specified CPUS. The format is a hex string
        representing the CPUS.

The tracing_cpumask currently doesn't affect the tracing state of
per-CPU ring buffers.

This patch enables/disables CPU recording as its corresponding bit in
tracing_cpumask is set/unset.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 401d77a..6d4c2dd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2650,10 +2650,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
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
-- 
1.7.7.3

