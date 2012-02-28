Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966Ab2B1WZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:25:48 -0500
Received: from mga07.intel.com ([143.182.124.22]:55082 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757220Ab2B1WZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:25:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.60.11.234 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
	<alpine.LFD.2.02.1202282240340.2794@ionos>
	<CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
Date: Tue, 28 Feb 2012 14:25:43 -0800
Message-ID: <CABE8wwvFR2z0uuy6qyuer1XD0p2UQXS97GOHMcp3wXnot74QgQ@mail.gmail.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
From: Dan Williams <dan.j.williams@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Andrzej Jakowski <andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 2:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Feb 28, 2012 at 1:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Tue, 28 Feb 2012, Peter Zijlstra wrote:
>>
>>> On Mon, 2012-02-27 at 12:38 -0800, Dan Williams wrote:
>>> > An experimental hack to tease out whether we are continuing to
>>> > run the softirq handler past the point of needing scheduling.
>>> >
>>> > It allows only one trip through __do_softirq() as long as need_resched()
>>> > is set which hopefully creates the back pressure needed to get ksoftirqd
>>> > scheduled.
>>> >
>>> > Targeted to address reports like the following that are produced
>>> > with i/o tests to a sas domain with a large number of disks (48+), and
>>> > lots of debugging enabled (slub_deubg, lockdep) that makes the
>>> > block+scsi softirq path more cpu-expensive than normal.
>>> >
>>> > With this patch applied the softlockup detector seems appeased, but it
>>> > seems odd to need changes to kernel/softirq.c so maybe I have overlooked
>>> > something that needs changing at the block/scsi level?
>>> >
>>> > BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78]
>>>
>>> So you're stuck in softirq for 22s+, max_restart is 10, this gives that
>>> on average you spend 2.2s+ per softirq invocation, this is completely
>>> absolutely bonkers. Softirq handlers should never consume significant
>>> amount of cpu-time.
>>>
>>> Thomas, think its about time we put something like the below in?
>>
>> Absolutely. Anything which consumes more than a few microseconds in
>> the softirq handler needs to be sorted out, no matter what.
>
> Looks like everyone is guilty:
>
> [  422.765336] softirq took longer than 1/4 tick: 3 NET_RX ffffffff813f0aa0
> ...
> [  423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff812519c8
> [  423.985093] softirq took longer than 1/4 tick: 6 TASKLET ffffffff8103422e
> [  423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff8105e2e1
> [  424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff810a0fed
> [  424.008691] softirq loop took longer than 1/2 tick need_resched:
> yes max_restart: 10
>
> As expected whenever that 1/2 tick message gets emitted the softirq
> handler is almost running in a need_resched() context.
>
> $ grep need_resched.*no log | wc -l
> 295
> $ grep need_resched.*yes log | wc -l
> 3201
>
> One of these warning messages gets printed out at a rate of 1 every
> 40ms. (468 second log w/ 11,725 of these messages).
>
> So is it a good idea to get more aggressive about scheduling ksoftrrqd?
>

Keep in mind this is with slub_debug and lockdep turned on, but we are
basically looking to do extended i/o runs on large topologies and want
the soft lockup detector to not generate false positives.
