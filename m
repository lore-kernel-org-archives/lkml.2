Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0LFRkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:20 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:42366 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752646Ab0LFRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: apJiWdgVM1l.ZgTNF1rqEqFH76oLTspQ8_qNEy5C7Ke8O6B
 CMRAnKSC7mxF9TzW_u_Uo6wkXjYLVeytMFkRjO67jZDyLG86AasD9_AJAy_r
 JcA1WRIVcFrLtfVZw5lxCTlTV.NUaDs7cWlWwnlQsd9M_ATbS_pJMZ3iIC98
 2sIO.qFDMM0zfzVns8TZrxRu.rMh7HNdkfIeF0OWJ9cowAgb1lLC1upmRKaq
 .PExIw_t_3O82yI9VdZKkc8rBzD2gWwTXnpSM6XIcBzc01KLAnhO8mHqaZvA
 uhjXHv4x7TOBozTjpc6tc
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174016.530242493@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:04 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 6/9] Taskstats: Use this_cpu_ops
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_taskstats
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_inc_return in one place and avoid ugly __raw_get_cpu in another.

V3->V4:
	- Fix off by one.

Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 kernel/taskstats.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/taskstats.c
===================================================================
--- linux-2.6.orig/kernel/taskstats.c	2010-11-30 10:06:35.000000000 -0600
+++ linux-2.6/kernel/taskstats.c	2010-11-30 10:10:14.000000000 -0600
@@ -89,8 +89,7 @@ static int prepare_reply(struct genl_inf
 		return -ENOMEM;
 
 	if (!info) {
-		int seq = get_cpu_var(taskstats_seqnum)++;
-		put_cpu_var(taskstats_seqnum);
+		int seq = this_cpu_inc_return(taskstats_seqnum) - 1;
 
 		reply = genlmsg_put(skb, 0, seq, &family, 0, cmd);
 	} else
@@ -581,7 +580,7 @@ void taskstats_exit(struct task_struct *
 		fill_tgid_exit(tsk);
 	}
 
-	listeners = &__raw_get_cpu_var(listener_array);
+	listeners = __this_cpu_ptr(listener_array);
 	if (list_empty(&listeners->list))
 		return;
 

