Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0K3TJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:09:52 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45254 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754216Ab0K3TIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:53 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lf8T7nAVM1lFfTOJE8mQt7UrNafoLWMI31op3jOAz5RLLQq
 RS1Fsm7bwCHbwmm9GKwhmhZeRjn_GxoiNuJpaybc8A8DuSE_HPmKUEJyuk.O
 OEChBuG5oeXB0dk5K1S0U5ij3nFqYNfpDDzuvDi8tswnLALjKeMGGMfwR6rr
 MMvN4nyeC1qjmltp8NSswr48Z9DiXH8BMDMCNqXLbI2JDmPhMMasgzuqYX8h
 ao7OUZGxk_Wsic0SNP.nDIRHOnHXnJ3_n2qmaAgLQRswA0sEnN4uV
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190851.156410048@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:24 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Scott James Remnant <scott@ubuntu.com>,
        Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 17/18] Connector: Use this_cpu operations
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_cn_proc
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

