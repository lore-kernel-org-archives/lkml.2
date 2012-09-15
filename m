Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2IOBfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:35:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62742 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab2IOBf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:35:29 -0400
Date: Sat, 15 Sep 2012 09:35:52 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: "Jens Axboe" <jaxboe@fusionio.com>
Cc: shli <shli@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 2/3] block: Fix not tracing all device plug-operation.
References: <201208101945571256852@gmail.com>, 
	<5025080A.1040001@fusionio.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201209150935486569381@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8F1ZoxN012644

On 2012-08-10 21:09 Jens Axboe <jaxboe@fusionio.com> Wrote:
>On 08/10/2012 01:46 PM, Jianpeng Ma wrote:
>> If process handled two or more devices,there will not be trace some
>> devices plug-operation.
>> 
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  block/blk-core.c |   16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>> 
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 7a3abc6..034f186 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1521,11 +1521,25 @@ get_rq:
>>  				struct request *__rq;
>>  
>>  				__rq = list_entry_rq(plug->list.prev);
>> -				if (__rq->q != q)
>> +				if (__rq->q != q) {
>>  					plug->should_sort = 1;
>> +					trace_block_plug(q);
>> +				}
>> +			} else {
>> +				struct request *__rq;
>> +				list_for_each_entry_reverse(__rq, &plug->list,
>> +					queuelist) {
>> +					if (__rq->q == q) {
>> +						list_add_tail(&req->queuelist,
>> +							&__rq->queuelist);
>> +						goto stat_acct;
>
>Did you verify this? It doesn't look right to me. You browse the list in
>reverse, which means __rq is the first one that has a matching q. Then
>you add the new req IN FRONT of that. You would want list_add() here
>instead, adding it as the last member of that q string, not in the
>middle.
>
>-- 
>Jens Axboe
>
Hi all:
	How about those patches? Ok or wrong? 
Thanks!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
