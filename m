Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0LFRRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:17:01 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44454 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753898Ab0LFRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lwT3bWsVM1kBZ7lWWV1yM8gLX4jMCM4P3ao5Jw3db6MgjI1
 Idr9T_l3VncJTc45WmViz5EqINbPTym2xuQLvGDZNtQFQ.jJaIoANhhcPKSb
 7AlStps1KT7NT8LZ4E7qtNkod3usanU1rGWVYYTcFmdVGGPX9ikdiBF58FiC
 YbqEMaUiS9GqQ4Q3WHsLl4rvc8mpjLaMVw2O3N7EXwpAI2Yxx4KGr8KGXjJ3
 JOSsXQD8_WSFGIelvBxa8Ge77KYDD4a0XqeatrIj._RE7DVuIIAUJGu_FQr8
 ExjuxxUFmZYteTC3TR9S0
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171641.471462516@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:27 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Scott James Remnant <scott@ubuntu.com>,
        Mike Frysinger <vapier@gentoo.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 09/11] Connector: Use this_cpu operations
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_cn_proc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_seq can benefit from this_cpu_operations. Address calculation is avoided
and the increment is done using an xadd.

Cc: Scott James Remnant <scott@ubuntu.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/connector/cn_proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/connector/cn_proc.c
===================================================================
--- linux-2.6.orig/drivers/connector/cn_proc.c	2010-11-30 09:38:33.000000000 -0600
+++ linux-2.6/drivers/connector/cn_proc.c	2010-11-30 09:39:38.000000000 -0600
@@ -43,9 +43,10 @@ static DEFINE_PER_CPU(__u32, proc_event_
 
 static inline void get_seq(__u32 *ts, int *cpu)
 {
-	*ts = get_cpu_var(proc_event_counts)++;
+	preempt_disable();
+	*ts = __this_cpu_inc(proc_event_counts);
 	*cpu = smp_processor_id();
-	put_cpu_var(proc_event_counts);
+	preempt_enable();
 }
 
 void proc_fork_connector(struct task_struct *task)

