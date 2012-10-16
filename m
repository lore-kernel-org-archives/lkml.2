Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2JPGiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:38:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43560 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2JPGiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:38:00 -0400
Date: Tue, 16 Oct 2012 14:38:34 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: shli <shli@kernel.org>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] block: Add blk_rq_pos(rq) to sort rq when plushing plug-list.
References: <2012101520345871894911@gmail.com> <CANejiEWL5_tdSbfzMq3YAtOfVtEkTQFYqLZ8t39eDhTaHTBb4g@mail.gmail.com>, 
	<CANejiEWWnrY_dKKuKLvjRms85crO+A7hi8P6nTkGMX9O2TL4kQ@mail.gmail.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201210161438319848315@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9G6c9C6029898

On 2012-10-15 21:18 Shaohua Li <shli@kernel.org> Wrote:
>2012/10/15 Shaohua Li <shli@fusionio.com>:
>> 2012/10/15 Jianpeng Ma <majianpeng@gmail.com>:
>>> My workload is a raid5 which had 16 disks. And used our filesystem to
>>> write using direct-io mode.
>>> I used the blktrace to find those message:
>>>
>>> 8,16   0     3570     1.083923979  2519  I   W 144323176 + 24 [md127_raid5]
>>> 8,16   0        0     1.083926214     0  m   N cfq2519 insert_request
>>> 8,16   0     3571     1.083926586  2519  I   W 144323072 + 104 [md127_raid5]
>>> 8,16   0        0     1.083926952     0  m   N cfq2519 insert_request
>>> 8,16   0     3572     1.083927180  2519  U   N [md127_raid5] 2
>>> 8,16   0        0     1.083927870     0  m   N cfq2519 Not idling.st->count:1
>>> 8,16   0        0     1.083928320     0  m   N cfq2519 dispatch_insert
>>> 8,16   0        0     1.083928951     0  m   N cfq2519 dispatched a request
>>> 8,16   0        0     1.083929443     0  m   N cfq2519 activate rq,drv=1
>>> 8,16   0     3573     1.083929530  2519  D   W 144323176 + 24 [md127_raid5]
>>> 8,16   0        0     1.083933883     0  m   N cfq2519 Not idling.st->count:1
>>> 8,16   0        0     1.083934189     0  m   N cfq2519 dispatch_insert
>>> 8,16   0        0     1.083934654     0  m   N cfq2519 dispatched a request
>>> 8,16   0        0     1.083935014     0  m   N cfq2519 activate rq,drv=2
>>> 8,16   0     3574     1.083935101  2519  D   W 144323072 + 104 [md127_raid5]
>>> 8,16   0     3575     1.084196179     0  C   W 144323176 + 24 [0]
>>> 8,16   0        0     1.084197979     0  m   N cfq2519 complete rqnoidle 0
>>> 8,16   0     3576     1.084769073     0  C   W 144323072 + 104 [0]
>>>   ......
>>> 8,16   1     3596     1.091394357  2519  I   W 144322544 + 16 [md127_raid5]
>>> 8,16   1        0     1.091396181     0  m   N cfq2519 insert_request
>>> 8,16   1     3597     1.091396571  2519  I   W 144322520 + 24 [md127_raid5]
>>> 8,16   1        0     1.091396934     0  m   N cfq2519 insert_request
>>> 8,16   1     3598     1.091397165  2519  I   W 144322488 + 32 [md127_raid5]
>>> 8,16   1        0     1.091397477     0  m   N cfq2519 insert_request
>>> 8,16   1     3599     1.091397708  2519  I   W 144322432 + 56 [md127_raid5]
>>> 8,16   1        0     1.091398023     0  m   N cfq2519 insert_request
>>> 8,16   1     3600     1.091398284  2519  U   N [md127_raid5] 4
>>> 8,16   1        0     1.091398986     0  m   N cfq2519 Not idling. st->count:1
>>> 8,16   1        0     1.091399511     0  m   N cfq2519 dispatch_insert
>>> 8,16   1        0     1.091400217     0  m   N cfq2519 dispatched a request
>>> 8,16   1        0     1.091400688     0  m   N cfq2519 activate rq,drv=1
>>> 8,16   1     3601     1.091400766  2519  D   W 144322544 + 16 [md127_raid5]
>>> 8,16   1        0     1.091406151     0  m   N cfq2519 Not idling.st->count:1
>>> 8,16   1        0     1.091406460     0  m   N cfq2519 dispatch_insert
>>> 8,16   1        0     1.091406931     0  m   N cfq2519 dispatched a request
>>> 8,16   1        0     1.091407291     0  m   N cfq2519 activate rq,drv=2
>>> 8,16   1     3602     1.091407378  2519  D   W 144322520 + 24 [md127_raid5]
>>> 8,16   1        0     1.091414006     0  m   N cfq2519 Not idling.st->count:1
>>> 8,16   1        0     1.091414297     0  m   N cfq2519 dispatch_insert
>>> 8,16   1        0     1.091414702     0  m   N cfq2519 dispatched a request
>>> 8,16   1        0     1.091415047     0  m   N cfq2519 activate rq, drv=3
>>> 8,16   1     3603     1.091415125  2519  D   W 144322488 + 32 [md127_raid5]
>>> 8,16   1        0     1.091416469     0  m   N cfq2519 Not idling.st->count:1
>>> 8,16   1        0     1.091416754     0  m   N cfq2519 dispatch_insert
>>> 8,16   1        0     1.091417186     0  m   N cfq2519 dispatched a request
>>> 8,16   1        0     1.091417535     0  m   N cfq2519 activate rq,drv=4
>>> 8,16   1     3604     1.091417628  2519  D   W 144322432 + 56 [md127_raid5]
>>> 8,16   1     3605     1.091857225  4393  C   W 144322544 + 16 [0]
>>> 8,16   1        0     1.091858753     0  m   N cfq2519 complete rqnoidle 0
>>> 8,16   1     3606     1.092068456  4393  C   W 144322520 + 24 [0]
>>> 8,16   1        0     1.092069851     0  m   N cfq2519 complete rqnoidle 0
>>> 8,16   1     3607     1.092350440  4393  C   W 144322488 + 32 [0]
>>> 8,16   1        0     1.092351688     0  m   N cfq2519 complete rqnoidle 0
>>> 8,16   1     3608     1.093629323     0  C   W 144322432 + 56 [0]
>>> 8,16   1        0     1.093631151     0  m   N cfq2519 complete rqnoidle 0
>>> 8,16   1        0     1.093631574     0  m   N cfq2519 will busy wait
>>> 8,16   1        0     1.093631829     0  m   N cfq schedule dispatch
>>>
>>> Because in func "elv_attempt_insert_merge", it only to try to
>>> backmerge.So the four request can't merge in theory.
>>> I trace ten minutes and count those situation, it can count 25%.
>>>
>>> With the patch,i tested and not found situation like above.
>>>
>>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>>> ---
>>>  block/blk-core.c |    3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index a33870b..3c95c4d 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2868,7 +2868,8 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
>>>         struct request *rqa = container_of(a, struct request, queuelist);
>>>         struct request *rqb = container_of(b, struct request, queuelist);
>>>
>>> -       return !(rqa->q <= rqb->q);
>>> +       return !(rqa->q < rqb->q ||
>>> +               (rqa->q == rqb->q && blk_rq_pos(rqa) < blk_rq_pos(rqb)));
>>>  }
>>
>> Does this one help too?
>> http://marc.info/?l=linux-kernel&m=132399972114668&w=2
>>
>> I thought the real problem is we don't do recursive request
>> merge. I had no objection to the patch itself, but just hope we
>> can make recursive merge work, which is more generic.
>
>Oh, wait, the 4 requests aren't merged completely in your case.
>And the requests are from one thread and plug context.
>Not the issue I mentioned. I'm wondering how this could happen.
>they should be merged in attempt_plug_merge already.
Hi shaohua,
	I think i missed some messages about blktrace.So make you confused.
I trace some message using blktrace:
 8,16   0     6638     2.453619407  2579  Q   W 7493144 + 8 [md0_raid5]
  8,16   0     6639     2.453620460  2579  G   W 7493144 + 8 [md0_raid5]
  8,16   0     6640     2.453639311  2579  Q   W 7493120 + 8 [md0_raid5]
  8,16   0     6641     2.453639842  2579  G   W 7493120 + 8 [md0_raid5]
  8,16   0     6642     2.453647796  2579  Q   W 7493128 + 8 [md0_raid5]
  8,16   0     6643     2.453647940  2579  M   W 7493128 + 8 [md0_raid5]
  8,16   0     6644     2.453658249  2579  Q   W 7493136 + 8 [md0_raid5]
  8,16   0     6645     2.453658393  2579  M   W 7493136 + 8 [md0_raid5]
  8,16   0     6646     2.453665309  2579  Q   W 7493152 + 8 [md0_raid5]
  8,16   0     6647     2.453665504  2579  M   W 7493152 + 8 [md0_raid5]
  8,16   0     6648     2.453672411  2579  Q   W 7493160 + 8 [md0_raid5]
  8,16   0     6649     2.453672606  2579  M   W 7493160 + 8 [md0_raid5]
  8,16   0     6650     2.453679255  2579  Q   W 7493168 + 8 [md0_raid5]
  8,16   0     6651     2.453679441  2579  M   W 7493168 + 8 [md0_raid5]
  8,16   0     6652     2.453685948  2579  Q   W 7493176 + 8 [md0_raid5]
  8,16   0     6653     2.453686149  2579  M   W 7493176 + 8 [md0_raid5]
  8,16   0     6654     2.453693074  2579  Q   W 7493184 + 8 [md0_raid5]
  8,16   0     6655     2.453693254  2579  M   W 7493184 + 8 [md0_raid5]
  8,16   0     6656     2.453704290  2579  Q   W 7493192 + 8 [md0_raid5]
  8,16   0     6657     2.453704482  2579  M   W 7493192 + 8 [md0_raid5]
  8,16   0     6658     2.453715016  2579  Q   W 7493200 + 8 [md0_raid5]
  8,16   0     6659     2.453715247  2579  M   W 7493200 + 8 [md0_raid5]
  8,16   0     6660     2.453721730  2579  Q   W 7493208 + 8 [md0_raid5]
  8,16   0     6661     2.453721974  2579  M   W 7493208 + 8 [md0_raid5]
  8,16   0     6662     2.453728202  2579  Q   W 7493216 + 8 [md0_raid5]
  8,16   0     6663     2.453728436  2579  M   W 7493216 + 8 [md0_raid5]
  8,16   0     6664     2.453734782  2579  Q   W 7493224 + 8 [md0_raid5]
  8,16   0     6665     2.453735019  2579  M   W 7493224 + 8 [md0_raid5]
  8,16   0     6666     2.453741401  2579  Q   W 7493232 + 8 [md0_raid5]
  8,16   0     6667     2.453741632  2579  M   W 7493232 + 8 [md0_raid5]
  8,16   0     6668     2.453748148  2579  Q   W 7493240 + 8 [md0_raid5]
  8,16   0     6669     2.453748386  2579  M   W 7493240 + 8 [md0_raid5]
  8,16   0     6670     2.453851843  2579  I   W 7493144 + 104 [md0_raid5]
  8,16   0        0     2.453853661     0  m   N cfq2579 insert_request
  8,16   0     6671     2.453854064  2579  I   W 7493120 + 24 [md0_raid5]
  8,16   0        0     2.453854439     0  m   N cfq2579 insert_request
  8,16   0     6672     2.453854793  2579  U   N [md0_raid5] 2
  8,16   0        0     2.453855513     0  m   N cfq2579 Not idling. st->count:1
  8,16   0        0     2.453855927     0  m   N cfq2579 dispatch_insert
  8,16   0        0     2.453861771     0  m   N cfq2579 dispatched a request
  8,16   0        0     2.453862248     0  m   N cfq2579 activate rq, drv=1
  8,16   0     6673     2.453862332  2579  D   W 7493120 + 24 [md0_raid5]
  8,16   0        0     2.453865957     0  m   N cfq2579 Not idling. st->count:1
  8,16   0        0     2.453866269     0  m   N cfq2579 dispatch_insert
  8,16   0        0     2.453866707     0  m   N cfq2579 dispatched a request
  8,16   0        0     2.453867061     0  m   N cfq2579 activate rq, drv=2
  8,16   0     6674     2.453867145  2579  D   W 7493144 + 104 [md0_raid5]
  8,16   0     6675     2.454147608     0  C   W 7493120 + 24 [0]
  8,16   0        0     2.454149357     0  m   N cfq2579 complete rqnoidle 0
  8,16   0     6676     2.454791505     0  C   W 7493144 + 104 [0]
  8,16   0        0     2.454794803     0  m   N cfq2579 complete rqnoidle 0
  8,16   0        0     2.454795160     0  m   N cfq schedule dispatch

>From above messages,we can found why rq[W 7493144 + 104] and rq[W 7493120 + 24] do not merge.
Because the bio order is:
  8,16   0     6638     2.453619407  2579  Q   W 7493144 + 8 [md0_raid5]
  8,16   0     6639     2.453620460  2579  G   W 7493144 + 8 [md0_raid5]
  8,16   0     6640     2.453639311  2579  Q   W 7493120 + 8 [md0_raid5]
  8,16   0     6641     2.453639842  2579  G   W 7493120 + 8 [md0_raid5]
Because the bio(7493144) first and bio(7493120) later.So the subsequent bios will be divided into two parts.
As you mentions, recursive merge doesn't work for this situation.
Why is can occur?I think because the raid operation.It disorder some bios.

Is it ok? If ok,i'll resend the patch using useful message.

Thanks!
Jianpeng


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
