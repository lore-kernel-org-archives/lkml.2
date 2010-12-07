Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0LGPqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:46:33 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:44873 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753215Ab0LGPqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:46:32 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 4hvlJJ4VM1nYFESi5slKesvPy0DW1zaMQ6pB86UaP6Ou1A1
 5P7DSkyusKxnCkh_vSL3_YAbYC6xrF_WOdoenz55EMvkOjvHLF7251rQvSjL
 4oAi5xLCWyOm7nQbT2pn.fT18ZTXrTzd3msda47v2zrCmJ.H7t3AikenAAMz
 y9uyRQKv6FwlUBZgHhJRoaQst_Qnj4WFsGg4ZokQd4XkRdhKCkF081imfJ6w
 .6LzdFQ45gS1DT0Jf.CT9xZaBzvou0AwSBF56w8kMO3pABW60Cs4OAO6_6yp
 45HMv0fPapF2wZ8YeqQ1W
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 09:46:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Straggler: Connector: Use this_cpu_operations
In-Reply-To: <20101206173958.685460926@linux.com>
Message-ID: <alpine.DEB.2.00.1012070945150.26552@router.home>
References: <20101206173958.685460926@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch was originally in the use cpuops patchset but it needs an
inc_return and is therefore dependant on an extension of the cpu ops.
Fixed up and verified that it compiles.


Subject: Connector: Use this_cpu operations

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
--- linux-2.6.orig/drivers/connector/cn_proc.c	2010-12-07 09:40:48.000000000 -0600
+++ linux-2.6/drivers/connector/cn_proc.c	2010-12-07 09:41:13.000000000 -0600
@@ -43,9 +43,10 @@ static DEFINE_PER_CPU(__u32, proc_event_

 static inline void get_seq(__u32 *ts, int *cpu)
 {
-	*ts = get_cpu_var(proc_event_counts)++;
+	preempt_disable();
+	*ts = __this_cpu_inc_return(proc_event_counts) -1;
 	*cpu = smp_processor_id();
-	put_cpu_var(proc_event_counts);
+	preempt_enable();
 }

 void proc_fork_connector(struct task_struct *task)

