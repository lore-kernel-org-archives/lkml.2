Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2BBUUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:20:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab2BBUUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:20:47 -0500
Date: Thu, 2 Feb 2012 15:20:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] block: relocate elevator initialized test from
 blk_cleanup_queue() to blk_drain_queue()
Message-ID: <20120202202042.GC1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328131156-13290-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:19:07PM -0800, Tejun Heo wrote:
> blk_cleanup_queue() may be called for a queue which doesn't have
> elevator initialized to skip invoking blk_drain_queue().
> blk_drain_queue() will be used for other purposes too and may be
> called for such half-initialized queues from other paths.  Move
> q->elevator test into blk_drain_queue().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-core.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1b73d06..ddda1cc 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -359,6 +359,13 @@ EXPORT_SYMBOL(blk_put_queue);
>   */
>  void blk_drain_queue(struct request_queue *q, bool drain_all)
>  {
> +	/*
> +	 * The caller might be trying to tear down @q before its elevator
> +	 * is initialized, in which case we don't want to call into it.
> +	 */
> +	if (!q->elevator)
> +		return;
> +

Shouldn't blk_throtl_drain() be called irrespective of the fact whether
elevator is initilialized or not? On bio based drivers, there will be
no elevator but bios can still be throttled.

Thanks
Vivek
