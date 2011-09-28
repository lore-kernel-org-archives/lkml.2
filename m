Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851Ab1I1Irq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:47:46 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41704 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1I1Iro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:47:44 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2]block: avoid unnecessary plug list flush
References: <1317179485.22361.10.camel@sli10-conroe>
Date: Wed, 28 Sep 2011 17:47:35 +0900
In-Reply-To: <1317179485.22361.10.camel@sli10-conroe> (Shaohua Li's message of
	"Wed, 28 Sep 2011 11:11:25 +0800")
Message-ID: <87y5x9cau0.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> get_request_wait() could sleep and flush the plug list. If the list
> is already flushed, don't flush again.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Namhyung Kim <namhyung@gmail.com>

Good catch! If get_request_wait() updated request_count after sleeping
we could live with the original code, but your change makes more sense IMHO.

Thanks.


>
> ---
>  block/blk-core.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> Index: linux/block/blk-core.c
> ===================================================================
> --- linux.orig/block/blk-core.c	2011-09-28 11:05:06.000000000 +0800
> +++ linux/block/blk-core.c	2011-09-28 11:05:22.000000000 +0800
> @@ -1299,15 +1299,17 @@ get_rq:
>  		 */
>  		if (list_empty(&plug->list))
>  			trace_block_plug(q);
> -		else if (!plug->should_sort) {
> -			struct request *__rq;
> +		else {
> +			if (!plug->should_sort) {
> +				struct request *__rq;
>  
> -			__rq = list_entry_rq(plug->list.prev);
> -			if (__rq->q != q)
> -				plug->should_sort = 1;
> +				__rq = list_entry_rq(plug->list.prev);
> +				if (__rq->q != q)
> +					plug->should_sort = 1;
> +			}
> +			if (request_count >= BLK_MAX_REQUEST_COUNT)
> +				blk_flush_plug_list(plug, false);
>  		}
> -		if (request_count >= BLK_MAX_REQUEST_COUNT)
> -			blk_flush_plug_list(plug, false);
>  		list_add_tail(&req->queuelist, &plug->list);
>  		drive_stat_acct(req, 1);
>  	} else {
