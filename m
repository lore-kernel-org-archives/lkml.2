Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1HKIXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:23:46 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:38599 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1HKIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:23:42 -0400
X-ASG-Debug-ID: 1313051021-03d6a510a92980e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E439189.1030905@fusionio.com>
Date: Thu, 11 Aug 2011 10:23:37 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Kyungmin Park <kmpark@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [RFC PATCH v2] Add new elevator ops for request hint
References: <20110811004216.GA24810@july> <CANejiEXgsVW4qk3hwHvd6YzgRsZueAB3ZSh3Rvx3fz9tM7KHPw@mail.gmail.com> <CANejiEUSU_hfex5i5znjAUU9Te2o-fgKuO=uD0UW+a4eaiU4Bw@mail.gmail.com>
X-ASG-Orig-Subj: Re: [RFC PATCH v2] Add new elevator ops for request hint
In-Reply-To: <CANejiEUSU_hfex5i5znjAUU9Te2o-fgKuO=uD0UW+a4eaiU4Bw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313051021
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71438
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-11 03:14, Shaohua Li wrote:
> 2011/8/11 Shaohua Li <shli@kernel.org>:
>> 2011/8/11 Kyungmin Park <kmpark@infradead.org>:
>>> Hi Jens
>>>
>>> Now eMMC device requires the upper layer information to improve the data
>>> performance and reliability.
>>>
>>> . Context ID
>>> Using the context information, it can sort out the data internally and improve the performance.
>>> The main problem is that it's needed to define "What's the context".
>>> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>>>
>>> . Data Tag
>>> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
>>> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
>>>
>>> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
>>>
>>> Sample usage is following in drivers/mmc/card/block.c
>>>
>>>        struct elevator_queue *e = md->queue.queue->elevator;
>>>        struct request_hint hint;
>>>        int ret;
>>>
>>>        if (e->ops->elevator_get_req_hint_fn && req)
>>>                ret = e->ops->elevator_get_req_hint_fn(req, &hint);
>> please put this to blkdev.h or similar. directly using it here
>> is abnormal.
> BTW, we can add a (rq->cmd_flags & REQ_ELVPRIV) check here to make
> sure the request is at io scheduler.

Yep, that should all go inside elv_get_request_context() or whatever is
a good name. I don't want the hint structure, the caller can just check
the request flags himself.

So something like:

int elv_get_request_context(struct request_queue *q, struct request *rq)
{
        struct elevator_queue *e = q->elevator;

        if (!(rq->cmd_flags & REQ_ELVPRIV))
                return -1;

        if (e->ops->elevator_get_req_context_fn)
                return e->ops->elevator_get_req_context_fn(q, rq);

        return -1;
}

and then cfq/others adding that helper to provide the mapping.

Context is a bad name, but so is hint. Perhaps app_key would be better,
as it more direcly infers what is being returned.

-- 
Jens Axboe

