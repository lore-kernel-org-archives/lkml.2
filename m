Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0LASGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:06:34 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:50435 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0LASGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:06:32 -0500
Subject: Re: [thisops uV3 08/18] Taskstats: Use this_cpu_ops
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101130190845.819605614@linux.com>
References: <20101130190707.457099608@linux.com>
	 <20101130190845.819605614@linux.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Wed, 01 Dec 2010 19:06:26 +0100
Message-ID: <1291226786.2898.22.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

On Tue, 2010-11-30 at 13:07 -0600, Christoph Lameter wrote:
> plain text document attachment (this_cpu_taskstats)
> Use this_cpu_inc_return in one place and avoid ugly __raw_get_cpu in another.
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
> +		int seq = this_cpu_inc_return(taskstats_seqnum);

Hmmm, wouldn't seq now always be one more than before?

I think that "seq = get_cpu_var(taskstats_seqnum)++" first assigns
taskstats_seqnum to seq and then increases the value in contrast to
this_cpu_inc_return() that returns the already increased value, correct?

Maybe that does not hurt here, Balbir?

>  		reply = genlmsg_put(skb, 0, seq, &family, 0, cmd);
>  	} else
> @@ -581,7 +580,7 @@ void taskstats_exit(struct task_struct *
>  		fill_tgid_exit(tsk);
>  	}
> 
> -	listeners = &__raw_get_cpu_var(listener_array);
> +	listeners = __this_cpu_ptr(listener_array);
>  	if (list_empty(&listeners->list))
>  		return;
> 
> 


