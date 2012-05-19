Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2ESKXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:23:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2ESKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:22:59 -0400
Date: Sat, 19 May 2012 03:21:45 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-71babb2705e2203a64c27ede13ae3508a0d2c16c@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, vnagarnaik@google.com,
        hpa@zytor.com, mingo@kernel.org, dhsharp@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, chavey@google.com,
        tglx@linutronix.de, teravest@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, dhsharp@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, chavey@google.com,
        tglx@linutronix.de, teravest@google.com
In-Reply-To: <1336096792-25373-3-git-send-email-vnagarnaik@google.com>
References: <1336096792-25373-3-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  change CPU ring buffer state from tracing_cpumask
Git-Commit-ID: 71babb2705e2203a64c27ede13ae3508a0d2c16c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 19 May 2012 03:21:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71babb2705e2203a64c27ede13ae3508a0d2c16c
Gitweb:     http://git.kernel.org/tip/71babb2705e2203a64c27ede13ae3508a0d2c16c
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Thu, 3 May 2012 18:59:52 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 16 May 2012 19:50:38 -0400

tracing: change CPU ring buffer state from tracing_cpumask

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
---
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
