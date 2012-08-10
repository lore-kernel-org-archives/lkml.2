Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2HJNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 09:09:58 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33811 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab2HJNJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 09:09:57 -0400
X-ASG-Debug-ID: 1344604195-0421b5402c658d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <5025080A.1040001@fusionio.com>
Date: Fri, 10 Aug 2012 15:09:30 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jianpeng Ma <majianpeng@gmail.com>
CC: shli <shli@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] block: Fix not tracing all device plug-operation.
References: <201208101945571256852@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 2/3] block: Fix not tracing all device plug-operation.
In-Reply-To: <201208101945571256852@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1344604195
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.105236
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 01:46 PM, Jianpeng Ma wrote:
> If process handled two or more devices,there will not be trace some
> devices plug-operation.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  block/blk-core.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7a3abc6..034f186 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1521,11 +1521,25 @@ get_rq:
>  				struct request *__rq;
>  
>  				__rq = list_entry_rq(plug->list.prev);
> -				if (__rq->q != q)
> +				if (__rq->q != q) {
>  					plug->should_sort = 1;
> +					trace_block_plug(q);
> +				}
> +			} else {
> +				struct request *__rq;
> +				list_for_each_entry_reverse(__rq, &plug->list,
> +					queuelist) {
> +					if (__rq->q == q) {
> +						list_add_tail(&req->queuelist,
> +							&__rq->queuelist);
> +						goto stat_acct;

Did you verify this? It doesn't look right to me. You browse the list in
reverse, which means __rq is the first one that has a matching q. Then
you add the new req IN FRONT of that. You would want list_add() here
instead, adding it as the last member of that q string, not in the
middle.

-- 
Jens Axboe

