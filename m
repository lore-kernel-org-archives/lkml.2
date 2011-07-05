Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1GEPEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1GEPE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:04:29 -0400
Date: Tue, 5 Jul 2011 11:04:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] cfq: request-deadline policy
Message-ID: <20110705150420.GD24348@redhat.com>
References: <20110704130838.27757.87486.stgit@localhost6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704130838.27757.87486.stgit@localhost6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 05:08:38PM +0400, Konstantin Khlebnikov wrote:
> CFQ is designed for sharing disk bandwidth proportionally between queues and groups
> and for reordering requests to reduce disks seek time. Currently it cannot
> gurantee or estimate latency for individual requests, even if latencies are low
> for almost all requests, some of them can stuck inside scheduler for a long time.
> The fair policy is good as long as someone luckless begins to die due to a timeout.
> 
> This patch implements fifo requests dispatching with deadline policy: now cfq
> obliged to dispatch request if it stuck in the queue for more than deadline.
> 
> This way now cfq can try to ensure the expected latency of requests execution.
> It is like a safety valve, it should not work all time, but it should keep latency
> in sane range when the scheduler is unable to effectively handle flow of requests,
> especially in cases when the "noop" or "deadline" shows better performance.
> 
> deadline can be tuned via /sys/block/<device>/queue/iosched/deadline_{sync,async}
> it by default 2000ms for sync and 4000ms for async requests, use 0 to disable it.

What's the workload where you are running into issues with existing
policy?

We have low_latency=1 by default and which tries to schedule every 
queue once in 300ms atleast. And with-in queue we already have the
notion of looking at fifo and dispatch the expired request first.

So to me sync queue scheduling shold be pretty good. Async queues
can get starved though. With-in sync queue, if some requests have
expired, it is probably because of the fact that disk is slow and
we are throwing too much IO at it. So if we start always dispatching
expired requests first, then the notion of fairness is out of the
window.

Why not use deadline scheduler for your case?

Thanks
Vivek
