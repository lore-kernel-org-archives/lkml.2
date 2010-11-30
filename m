Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0K3TLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:11:17 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45204 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754757Ab0K3TIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:47 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XOqCW68VM1kzyElG9c9K49lspHY2NFhCyrC4N0c8e4G7dVp
 xsOhh3q4CXQWoAW542HkQMN7WxwRoNOxPwpcSrbjWG9apoKpGfAIC0xLIShw
 jlerCbYZW0eHc8F27Z6R5ONdfDSYlmTgT8nerJoo7G.YGqNakWZK1M1MNy5N
 fD4fUXZhPGesWytzwIWTF4ll6R0wzl_uCtMDfustzNqZ0zBPVrvfxtaRfh5N
 XBc5ZuQ.2SxjBxQrPHK.RaWDZ_EGLe_9ZA0RA3bkiTAOvbpzC.pIVIazLN36
 phZObgsKusGR257lt.QMw
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190845.819605614@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:15 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 08/18] Taskstats: Use this_cpu_ops
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_taskstats
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_inc_return in one place and avoid ugly __raw_get_cpu in another.

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
+		int seq = this_cpu_inc_return(taskstats_seqnum);
 
 		reply = genlmsg_put(skb, 0, seq, &family, 0, cmd);
 	} else
@@ -581,7 +580,7 @@ void taskstats_exit(struct task_struct *
 		fill_tgid_exit(tsk);
 	}
 
-	listeners = &__raw_get_cpu_var(listener_array);
+	listeners = __this_cpu_ptr(listener_array);
 	if (list_empty(&listeners->list))
 		return;
 

