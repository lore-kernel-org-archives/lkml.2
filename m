Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2E2BPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2E2BPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:15:32 -0400
Message-ID: <4FC42370.600@redhat.com>
Date: Tue, 29 May 2012 09:16:32 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Avoid missed wakeup in request waitqueue
References: <1338178743-16956-1-git-send-email-asias@redhat.com> <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 06:26 PM, Tejun Heo wrote:
> On Mon, May 28, 2012 at 12:19:03PM +0800, Asias He wrote:
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 1f61b74..1a45877 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -359,9 +359,10 @@ EXPORT_SYMBOL(blk_put_queue);
>>    */
>>   void blk_drain_queue(struct request_queue *q, bool drain_all)
>>   {
>> +	int i;
>> +
>>   	while (true) {
>>   		bool drain = false;
>> -		int i;
>>
>>   		spin_lock_irq(q->queue_lock);
>>
>> @@ -400,6 +401,14 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
>>   			break;
>>   		msleep(10);
>>   	}
>> +
>> +	/* Wake up threads which are sleeping on get_request() */
>> +	spin_lock_irq(q->queue_lock);
>> +	for (i = 0; i<  ARRAY_SIZE(q->rq.wait); i++) {
>> +		if (waitqueue_active(&q->rq.wait[i]))
>> +			wake_up_all(&q->rq.wait[i]);
>> +	}
>> +	spin_unlock_irq(q->queue_lock);
>
> I don't think we need waitqueue_active() optimization here.  Let's
> just do,
>
> 	/* please explain why this is necessary */
> 	for (i = 0; i<  ARRAY_SIZE(q->rq.wait); i++)
> 		wake_up_all(&q->rq.wait[i]);

OK. V2 is on its way.


-- 
Asias
