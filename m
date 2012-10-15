Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2JOMz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:55:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59990 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2JOMzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <2012101520345871894911@gmail.com>
References: <2012101520345871894911@gmail.com>
Date: Mon, 15 Oct 2012 20:55:23 +0800
X-Google-Sender-Auth: WMPCW6LBOQ_kazKlzlR2hI0rcQU
Message-ID: <CANejiEWL5_tdSbfzMq3YAtOfVtEkTQFYqLZ8t39eDhTaHTBb4g@mail.gmail.com>
Subject: Re: [PATCH] block: Add blk_rq_pos(rq) to sort rq when plushing plug-list.
From: Shaohua Li <shli@fusionio.com>
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 Jianpeng Ma <majianpeng@gmail.com>:
> My workload is a raid5 which had 16 disks. And used our filesystem to
> write using direct-io mode.
> I used the blktrace to find those message:
>
> 8,16   0     3570     1.083923979  2519  I   W 144323176 + 24 [md127_raid5]
> 8,16   0        0     1.083926214     0  m   N cfq2519 insert_request
> 8,16   0     3571     1.083926586  2519  I   W 144323072 + 104 [md127_raid5]
> 8,16   0        0     1.083926952     0  m   N cfq2519 insert_request
> 8,16   0     3572     1.083927180  2519  U   N [md127_raid5] 2
> 8,16   0        0     1.083927870     0  m   N cfq2519 Not idling.st->count:1
> 8,16   0        0     1.083928320     0  m   N cfq2519 dispatch_insert
> 8,16   0        0     1.083928951     0  m   N cfq2519 dispatched a request
> 8,16   0        0     1.083929443     0  m   N cfq2519 activate rq,drv=1
> 8,16   0     3573     1.083929530  2519  D   W 144323176 + 24 [md127_raid5]
> 8,16   0        0     1.083933883     0  m   N cfq2519 Not idling.st->count:1
> 8,16   0        0     1.083934189     0  m   N cfq2519 dispatch_insert
> 8,16   0        0     1.083934654     0  m   N cfq2519 dispatched a request
> 8,16   0        0     1.083935014     0  m   N cfq2519 activate rq,drv=2
> 8,16   0     3574     1.083935101  2519  D   W 144323072 + 104 [md127_raid5]
> 8,16   0     3575     1.084196179     0  C   W 144323176 + 24 [0]
> 8,16   0        0     1.084197979     0  m   N cfq2519 complete rqnoidle 0
> 8,16   0     3576     1.084769073     0  C   W 144323072 + 104 [0]
>   ......
> 8,16   1     3596     1.091394357  2519  I   W 144322544 + 16 [md127_raid5]
> 8,16   1        0     1.091396181     0  m   N cfq2519 insert_request
> 8,16   1     3597     1.091396571  2519  I   W 144322520 + 24 [md127_raid5]
> 8,16   1        0     1.091396934     0  m   N cfq2519 insert_request
> 8,16   1     3598     1.091397165  2519  I   W 144322488 + 32 [md127_raid5]
> 8,16   1        0     1.091397477     0  m   N cfq2519 insert_request
> 8,16   1     3599     1.091397708  2519  I   W 144322432 + 56 [md127_raid5]
> 8,16   1        0     1.091398023     0  m   N cfq2519 insert_request
> 8,16   1     3600     1.091398284  2519  U   N [md127_raid5] 4
> 8,16   1        0     1.091398986     0  m   N cfq2519 Not idling. st->count:1
> 8,16   1        0     1.091399511     0  m   N cfq2519 dispatch_insert
> 8,16   1        0     1.091400217     0  m   N cfq2519 dispatched a request
> 8,16   1        0     1.091400688     0  m   N cfq2519 activate rq,drv=1
> 8,16   1     3601     1.091400766  2519  D   W 144322544 + 16 [md127_raid5]
> 8,16   1        0     1.091406151     0  m   N cfq2519 Not idling.st->count:1
> 8,16   1        0     1.091406460     0  m   N cfq2519 dispatch_insert
> 8,16   1        0     1.091406931     0  m   N cfq2519 dispatched a request
> 8,16   1        0     1.091407291     0  m   N cfq2519 activate rq,drv=2
> 8,16   1     3602     1.091407378  2519  D   W 144322520 + 24 [md127_raid5]
> 8,16   1        0     1.091414006     0  m   N cfq2519 Not idling.st->count:1
> 8,16   1        0     1.091414297     0  m   N cfq2519 dispatch_insert
> 8,16   1        0     1.091414702     0  m   N cfq2519 dispatched a request
> 8,16   1        0     1.091415047     0  m   N cfq2519 activate rq, drv=3
> 8,16   1     3603     1.091415125  2519  D   W 144322488 + 32 [md127_raid5]
> 8,16   1        0     1.091416469     0  m   N cfq2519 Not idling.st->count:1
> 8,16   1        0     1.091416754     0  m   N cfq2519 dispatch_insert
> 8,16   1        0     1.091417186     0  m   N cfq2519 dispatched a request
> 8,16   1        0     1.091417535     0  m   N cfq2519 activate rq,drv=4
> 8,16   1     3604     1.091417628  2519  D   W 144322432 + 56 [md127_raid5]
> 8,16   1     3605     1.091857225  4393  C   W 144322544 + 16 [0]
> 8,16   1        0     1.091858753     0  m   N cfq2519 complete rqnoidle 0
> 8,16   1     3606     1.092068456  4393  C   W 144322520 + 24 [0]
> 8,16   1        0     1.092069851     0  m   N cfq2519 complete rqnoidle 0
> 8,16   1     3607     1.092350440  4393  C   W 144322488 + 32 [0]
> 8,16   1        0     1.092351688     0  m   N cfq2519 complete rqnoidle 0
> 8,16   1     3608     1.093629323     0  C   W 144322432 + 56 [0]
> 8,16   1        0     1.093631151     0  m   N cfq2519 complete rqnoidle 0
> 8,16   1        0     1.093631574     0  m   N cfq2519 will busy wait
> 8,16   1        0     1.093631829     0  m   N cfq schedule dispatch
>
> Because in func "elv_attempt_insert_merge", it only to try to
> backmerge.So the four request can't merge in theory.
> I trace ten minutes and count those situation, it can count 25%.
>
> With the patch,i tested and not found situation like above.
>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  block/blk-core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a33870b..3c95c4d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2868,7 +2868,8 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
>         struct request *rqa = container_of(a, struct request, queuelist);
>         struct request *rqb = container_of(b, struct request, queuelist);
>
> -       return !(rqa->q <= rqb->q);
> +       return !(rqa->q < rqb->q ||
> +               (rqa->q == rqb->q && blk_rq_pos(rqa) < blk_rq_pos(rqb)));
>  }

Does this one help too?
http://marc.info/?l=linux-kernel&m=132399972114668&w=2

I thought the real problem is we don't do recursive request
merge. I had no objection to the patch itself, but just hope we
can make recursive merge work, which is more generic.

Thanks,
Shaohua
