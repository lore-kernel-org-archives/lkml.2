Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0LGJfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:35:15 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:40776 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0LGJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:35:12 -0500
Subject: Re: [cpuops inc_return V1 6/9] Taskstats: Use this_cpu_ops
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101206174016.530242493@linux.com>
References: <20101206173958.685460926@linux.com>
	 <20101206174016.530242493@linux.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Tue, 07 Dec 2010 10:35:08 +0100
Message-ID: <1291714508.1910.8.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

On Mon, 2010-12-06 at 11:40 -0600, Christoph Lameter wrote:
> plain text document attachment (cpuops_inc_return_taskstats)
> Use this_cpu_inc_return in one place and avoid ugly __raw_get_cpu in another.
> 
> V3->V4:
> 	- Fix off by one.
> 
> Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  kernel/taskstats.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/kernel/taskstats.c
> ===================================================================
> --- linux-2.6.orig/kernel/taskstats.c	2010-11-30 10:06:35.000000000 -0600
> +++ linux-2.6/kernel/taskstats.c	2010-11-30 10:10:14.000000000 -0600
> @@ -89,8 +89,7 @@ static int prepare_reply(struct genl_inf
>  		return -ENOMEM;
> 
>  	if (!info) {
> -		int seq = get_cpu_var(taskstats_seqnum)++;
> -		put_cpu_var(taskstats_seqnum);
> +		int seq = this_cpu_inc_return(taskstats_seqnum) - 1;

This looks good now.

>  		reply = genlmsg_put(skb, 0, seq, &family, 0, cmd);
>  	} else
> @@ -581,7 +580,7 @@ void taskstats_exit(struct task_struct *
>  		fill_tgid_exit(tsk);
>  	}
> 
> -	listeners = &__raw_get_cpu_var(listener_array);
> +	listeners = __this_cpu_ptr(listener_array);

I think this is wrong and should be:

-	listeners = &__raw_get_cpu_var(listener_array);
+	listeners = __this_cpu_ptr(>>>> & <<< listener_array);

Michael


