Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1GFG6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:58:44 -0400
Received: from relay.parallels.com ([195.214.232.42]:36383 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GFG6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:58:43 -0400
Message-ID: <4E1407A1.5080809@parallels.com>
Date: Wed, 6 Jul 2011 10:58:41 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/2] cfq: request-deadline policy
References: <20110704130838.27757.87486.stgit@localhost6> <20110705150420.GD24348@redhat.com>
In-Reply-To: <20110705150420.GD24348@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Jul 04, 2011 at 05:08:38PM +0400, Konstantin Khlebnikov wrote:
>> CFQ is designed for sharing disk bandwidth proportionally between queues and groups
>> and for reordering requests to reduce disks seek time. Currently it cannot
>> gurantee or estimate latency for individual requests, even if latencies are low
>> for almost all requests, some of them can stuck inside scheduler for a long time.
>> The fair policy is good as long as someone luckless begins to die due to a timeout.
>>
>> This patch implements fifo requests dispatching with deadline policy: now cfq
>> obliged to dispatch request if it stuck in the queue for more than deadline.
>>
>> This way now cfq can try to ensure the expected latency of requests execution.
>> It is like a safety valve, it should not work all time, but it should keep latency
>> in sane range when the scheduler is unable to effectively handle flow of requests,
>> especially in cases when the "noop" or "deadline" shows better performance.
>>
>> deadline can be tuned via /sys/block/<device>/queue/iosched/deadline_{sync,async}
>> it by default 2000ms for sync and 4000ms for async requests, use 0 to disable it.
>
> What's the workload where you are running into issues with existing
> policy?

This is huge internal test workload,
there >100 containers with mail/http/ftp and something more.

>
> We have low_latency=1 by default and which tries to schedule every
> queue once in 300ms atleast. And with-in queue we already have the
> notion of looking at fifo and dispatch the expired request first.

Without this patch some requests stuck in the scheduler for more than 30 seconds,
and it looks like it is no limit.

With this patch max-wait-time (from the second patch) shows 7 seconds for this workload,
so of course queue is over-congested, but it continues to work predictably.

>
> So to me sync queue scheduling shold be pretty good. Async queues
> can get starved though. With-in sync queue, if some requests have
> expired, it is probably because of the fact that disk is slow and
> we are throwing too much IO at it. So if we start always dispatching
> expired requests first, then the notion of fairness is out of the
> window.
>
> Why not use deadline scheduler for your case?

Because the scheduler must be universal, load can be arbitrary and constantly changing,
we also can not modify each machine separately.

>
> Thanks
> Vivek

