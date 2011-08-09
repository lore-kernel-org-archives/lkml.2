Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1HITrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:47:05 -0400
Received: from [95.166.99.235] ([95.166.99.235]:58647 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1HITrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:47:03 -0400
Message-ID: <4E4181E4.3090704@kernel.dk>
Date: Tue, 09 Aug 2011 20:52:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, jh80.chung@samsung.com
Subject: Re: [RFC PATCH] request: teach the device more intelligent
References: <20110809034724.GA22257@july>
In-Reply-To: <20110809034724.GA22257@july>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-09 05:47, Kyungmin Park wrote:
> Hi Jens
> 
> Now eMMC device requires the upper layer information to improve the data
> performance and reliability.
> 
> . Context ID
> Using the context information, it can sort out the data internally and improve the performance.
> The main problem is that it's needed to define "What's the context". 
> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
> 
> . Data Tag
> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
> 
> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
> 
> Can you give your opinions and does it proper fields at requests?

You need this to work on all IO schedulers, not just cfq. And since
that's the case, there's no need to add this field since you can just
retrieve it if the driver asks for it. For CFQ, it could look like this:

static int cfq_foo(struct request *rq)
{
        struct cfq_queue *cfqq = rq->elevator_private[1];

        if (cfqq)
                return cfqq->pid;

        return -1;
}

As to the hot part, I think that would be better as just a request flag
like eg the meta flag.

-- 
Jens Axboe

