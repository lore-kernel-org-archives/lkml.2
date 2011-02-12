Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab1BLPnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 10:43:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1BLPnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 10:43:19 -0500
Subject: Re: [GIT PULL] dlm fix for 2.6.38
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <20110211233844.GC30276@redhat.com>
References: <20110211233844.GC30276@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Sat, 12 Feb 2011 15:44:35 +0000
Message-ID: <1297525475.2584.1.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2011-02-11 at 18:38 -0500, David Teigland wrote:
> Linus,
> 
> Please pull this fix for a dlm regression from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus
> 
> Thanks,
> Dave
> 
> Author: David Teigland <teigland@redhat.com>
> Date:   Fri Feb 11 16:44:31 2011 -0600
> 
>     dlm: use single thread workqueues
>     
>     The recent commit to use cmwq for send and recv threads
>     dcce240ead802d42b1e45ad2fcb2ed4a399cb255 introduced problems,
>     apparently due to multiple workqueue threads.  Single threads
>     make the problems go away, so return to that until we fully
>     understand the concurrency issues with multiple threads.
>     
>     Signed-off-by: David Teigland <teigland@redhat.com>
> 
> diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> index 9c64ae9..2d8c87b 100644
> --- a/fs/dlm/lowcomms.c
> +++ b/fs/dlm/lowcomms.c
> @@ -1468,15 +1468,13 @@ static void work_stop(void)
>  
>  static int work_start(void)
>  {
> -	recv_workqueue = alloc_workqueue("dlm_recv", WQ_MEM_RECLAIM |
> -					 WQ_HIGHPRI | WQ_FREEZEABLE, 0);
> +	recv_workqueue = create_singlethread_workqueue("dlm_recv");
>  	if (!recv_workqueue) {
>  		log_print("can't start dlm_recv");
>  		return -ENOMEM;
>  	}
>  
> -	send_workqueue = alloc_workqueue("dlm_send", WQ_MEM_RECLAIM |
> -					 WQ_HIGHPRI | WQ_FREEZEABLE, 0);
> +	send_workqueue = create_singlethread_workqueue("dlm_send");
>  	if (!send_workqueue) {
>  		log_print("can't start dlm_send");
>  		destroy_workqueue(recv_workqueue);
> 
> 

What is the issue here? If there is a problem with the workqueues then
we should ask Tejun about it,

Steve.


