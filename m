Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1CQNCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:02:51 -0400
Received: from mx2.netapp.com ([216.240.18.37]:4586 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab1CQNCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:02:48 -0400
X-IronPort-AV: E=Sophos;i="4.63,199,1299484800"; 
   d="scan'208";a="531349922"
Subject: Re: [PATCH] RPC: killing RPC tasks races fixed
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net, skinsbursky@openvz.org
In-Reply-To: <20110317121638.15035.39410.stgit@localhost6.localdomain6>
References: <20110317121638.15035.39410.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 17 Mar 2011 09:01:44 -0400
Message-ID: <1300366904.9654.13.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 17 Mar 2011 13:01:47.0321 (UTC) FILETIME=[79212A90:01CBE4A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 15:16 +0300, Stanislav Kinsbursky wrote:
> task->tk_waitqueue must be checked for NULL before trying to wake up task in
> rpc_killall_tasks() because it can be NULL.
> 
> Here is an example:
> 
> CPU 0               	CPU 1				CPU 2
> --------------------	---------------------	--------------------------
> nfs4_run_open_task
> rpc_run_task
> rpc_execute
> rpc_set_active
> rpc_make_runnable
> (waiting)
> 			rpc_async_schedule
> 			nfs4_open_prepare
> 			nfs_wait_on_sequence
> 						nfs_umount_begin
> 						rpc_killall_tasks
> 						rpc_wake_up_task
> 						rpc_wake_up_queued_task
> 						spin_lock(tk_waitqueue == NULL)
> 						BUG()
> 			rpc_sleep_on
> 			spin_lock(&q->lock)
> 			__rpc_sleep_on
> 			task->tk_waitqueue = q
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@openvz.org>
> 
> ---
>  net/sunrpc/clnt.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index 57d344c..24039fe 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -436,7 +436,9 @@ void rpc_killall_tasks(struct rpc_clnt *clnt)
>  		if (!(rovr->tk_flags & RPC_TASK_KILLED)) {
>  			rovr->tk_flags |= RPC_TASK_KILLED;
>  			rpc_exit(rovr, -EIO);
> -			rpc_wake_up_queued_task(rovr->tk_waitqueue, rovr);
> +			if (rovr->tk_waitqueue)
> +				rpc_wake_up_queued_task(rovr->tk_waitqueue, 
> +							rovr);

Testing for RPC_IS_QUEUED(rovr) would be better, since that would
optimise away the call to rpc_wake_up_queued_task() altogether for those
tasks that aren't queued.

>  		}
>  	}
>  	spin_unlock(&clnt->cl_lock);
> 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

