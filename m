Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1ACN53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab1ACN51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:57:27 -0500
Subject: Re: [PATCH 24/32] dlm: dlm workqueues aren't used in memory
 reclaim path
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1294062595-30097-25-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-25-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 03 Jan 2011 13:58:27 +0000
Message-ID: <1294063107.2429.34.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You already acked a patch to do this, which is in the DLM git tree,
waiting for the next merge window:

http://git.kernel.org/?p=linux/kernel/git/teigland/dlm.git;a=commitdiff;h=dcce240ead802d42b1e45ad2fcb2ed4a399cb255

Steve.

On Mon, 2011-01-03 at 14:49 +0100, Tejun Heo wrote:
> dlm isn't depended upon during memory reclaim and so are its two
> workqueues.  Convert to alloc[_ordered]_workqueue() without
> WQ_MEM_RECLAIM.  While at it, fix workqueue allocation failure
> handling.  They return %NULL on failure not ERR_PTR() value.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Christine Caulfield <ccaulfie@redhat.com>
> Cc: David Teigland <teigland@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.
> 
> Thanks.
> 
>  fs/dlm/lowcomms.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> index 37a34c2..9aad7c0 100644
> --- a/fs/dlm/lowcomms.c
> +++ b/fs/dlm/lowcomms.c
> @@ -1430,20 +1430,17 @@ static void work_stop(void)
>  
>  static int work_start(void)
>  {
> -	int error;
> -	recv_workqueue = create_workqueue("dlm_recv");
> -	error = IS_ERR(recv_workqueue);
> -	if (error) {
> -		log_print("can't start dlm_recv %d", error);
> -		return error;
> +	recv_workqueue = alloc_workqueue("dlm_recv", 0, 1);
> +	if (!recv_workqueue) {
> +		log_print("can't start dlm_recv");
> +		return -ENOMEM;
>  	}
>  
> -	send_workqueue = create_singlethread_workqueue("dlm_send");
> -	error = IS_ERR(send_workqueue);
> -	if (error) {
> -		log_print("can't start dlm_send %d", error);
> +	send_workqueue = alloc_ordered_workqueue("dlm_send", 0);
> +	if (!send_workqueue) {
> +		log_print("can't start dlm_send");
>  		destroy_workqueue(recv_workqueue);
> -		return error;
> +		return -ENOMEM;
>  	}
>  
>  	return 0;


