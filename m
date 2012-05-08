Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2EHWPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:15:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3586 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2EHWPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:15:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 08 May 2012 15:14:48 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Tue, 8 May 2012 15:14:48 -0700
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Topic: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Index: Ac0tZXwx5Ctm/V5JSnegJFyEdTLyRAAAe2Gw
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
 <1336514192.8226.52.camel@twins>
In-Reply-To: <1336514192.8226.52.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to bug you when it is late for you..

You're right, there is no real difference at all.
Only cosmetic difference when you look at the output of cat /proc/sched_debug.

But I suddenly realized maybe the increment/decrement of nr_interruptible is reversed.
Maybe that's the source of the problem: decrement in activate task and increment in deactivate task !!

Code snip:

/*
 * activate_task - move a task to the runqueue.
 */
static void activate_task(struct rq *rq, struct task_struct *p, int flags)
{
	if (task_contributes_to_load(p))
		rq->nr_uninterruptible--; <<<<< why decrement in activate task

	enqueue_task(rq, p, flags);
	inc_nr_running(rq);
}

/*
 * deactivate_task - remove a task from the runqueue.
 */
static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
{
	if (task_contributes_to_load(p))
		rq->nr_uninterruptible++; <<<<< why increment in deactivate task

	dequeue_task(rq, p, flags);
	dec_nr_running(rq);
}

Thanks,
--Diwakar.

-----Original Message-----
From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
Sent: Tuesday, May 08, 2012 2:57 PM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value

On Tue, 2012-05-08 at 14:39 -0700, Diwakar Tundlam wrote:
> Declare nr_uninterruptible as a signed long to avoid garbage values 
> seen in cat /proc/sched_debug when a task is moved to the run queue of 
> a newly online core. This is part of a global counter where only the 
> total sum over all CPUs matters.

Its late here, but do explain how any of this makes any difference what so ever? Since all we do with that field is add/sub the whole sign issue shouldn't matter one way or the other.


