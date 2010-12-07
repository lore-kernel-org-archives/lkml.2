Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0LGOpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:45:17 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38783 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751412Ab0LGOpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:45:16 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cQCh2m8VM1lO_GaTg4eRpiT8I7MqCb8Di8RWcabgbw3hPWr
 7lcCl_zgTXAbxmEEjWX_Y24.nIec4WbDJXB9p5gTZn8o2s6KHMaLoA1Fv0c8
 KPCCy0QxtOIO9qcuiOLuTF57SZy7b7RDr9ArgaszqED2iS1rPIdnnwtshFCC
 BcWxxNUJ9kw093R2..iH6fFjNnxuZ7cr5iOGqbvi6R6aydfL_zfI.fr3Lstg
 RRfgBMm3y0j1DI6KBgV4vMBN3byNxvj4BH4DWbjUAMk2RtvjPD.unxAamuRX
 7_XTL_mNMLmTlMrY0XRaZ
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 08:45:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [cpuops inc_return V1 6/9] Taskstats: Use this_cpu_ops
In-Reply-To: <1291714508.1910.8.camel@holzheu-laptop>
Message-ID: <alpine.DEB.2.00.1012070844350.25976@router.home>
References: <20101206173958.685460926@linux.com>  <20101206174016.530242493@linux.com> <1291714508.1910.8.camel@holzheu-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Dec 2010, Michael Holzheu wrote:

> I think this is wrong and should be:
>
> -	listeners = &__raw_get_cpu_var(listener_array);
> +	listeners = __this_cpu_ptr(>>>> & <<< listener_array);
>

Correct. CONFIG_TASKSTATS was not set. Thus



Subject: Taskstats: Use this_cpu_ops

Use this_cpu_inc_return in one place and avoid ugly __raw_get_cpu in another.

V3->V4:
	- Fix off by one.

V4-V4f:
	- Use &listener_array

Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 kernel/taskstats.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/taskstats.c
===================================================================
--- linux-2.6.orig/kernel/taskstats.c	2010-12-06 11:30:01.000000000 -0600
+++ linux-2.6/kernel/taskstats.c	2010-12-07 08:43:32.000000000 -0600
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
+	listeners = __this_cpu_ptr(&listener_array);
 	if (list_empty(&listeners->list))
 		return;

