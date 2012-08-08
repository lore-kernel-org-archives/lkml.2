Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2HHFf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:35:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56316 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2HHFf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:35:26 -0400
Date: Wed, 8 Aug 2012 13:35:35 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: shli <shli@kernel.org>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [RFC PATCH] block:Fix some problems about handling plug in blk_queue_bio().
References: <201208081005308597351@gmail.com>, 
	<CANejiEXdHaqtXuR47QRimRNcvjxtUn8__7MK5XwW2t658hz=3g@mail.gmail.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208081335333287528@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q785ZXNV019606

On 2012-08-08 11:06 Shaohua Li <shli@kernel.org> Wrote:
>2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
>> I think there are three problems about handling plug in blk_queue_bio():
>> 1:if request_count >= BLK_MAX_REQUEST_COUNT, avoid unnecessary plug->should_sort judge.
>this makes sense, though not a big deal, nice to fix it.
Thanks
>
>> 2:Only two device can trace plug.
>I didn't get the point, can you have more details?

>>if (plug) {
>>		/*
>>		 * If this is the first request added after a plug, fire
>>		 * of a plug trace. If others have been added before, check
>>		 * if we have multiple devices in this plug. If so, make a
>>		 * note to sort the list before dispatch.
>>		 */
>>		if (list_empty(&plug->list))
>>			trace_block_plug(q);
>>		else {
>>			if (!plug->should_sort) {
>>				struct request *__rq;

>>				__rq = list_entry_rq(plug->list.prev);
>>				if (__rq->q != q)
>>					plug->should_sort = 1;
>>			}
>>			if (request_count >= BLK_MAX_REQUEST_COUNT) {
>>				blk_flush_plug_list(plug, false);
>>				trace_block_plug(q);
The code only trace two point;
A:	list_empty(&plug->list)
B:	request_count >= BLK_MAX_REQUEST_COUNT). it's the same like A which plug->list is empty.
Suppose: 
1;reqA-deviceA firstly come, it will call trace_block_plug because the list_empty(plug->list) is true.
2:reqB-deviceB comed, attempt_plug_merge will failed because not deviceB-request-queue.But it'll not to call trace_block_plug.

But call blk_flush_plug_list,it will trace_block_unplug all request_queue.
>
>> 3:When exec blk_flush_plug_list,it use list_sort which has
>> O(nlog(n)) complexity. When insert and sort, it only O(n) complexity.
>but now you do the list iterator for every request, so it's O(n*n)?
>The plug list is unlikely too long, so I didn't worry about the time
>spending on list sort.
Sorry, it's my fault.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
