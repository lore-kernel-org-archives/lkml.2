Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab1FVTma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:42:30 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52851 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab1FVTm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:42:29 -0400
Message-ID: <4E0245A1.3090903@kernel.dk>
Date: Wed, 22 Jun 2011 21:42:25 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] sched: Separate the scheduler entry for preemption
References: <20110622174659.496793734@linutronix.de> <20110622174918.813258321@linutronix.de> <20110622184328.GA6475@infradead.org>
In-Reply-To: <20110622184328.GA6475@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 20:43, Christoph Hellwig wrote:
> On Wed, Jun 22, 2011 at 05:52:13PM -0000, Thomas Gleixner wrote:
>> Block-IO and workqueues call into notifier functions from the
>> scheduler core code with interrupts and preemption disabled. These
>> calls should be made before entering the scheduler core.
>>
>> To simplify this, separate the scheduler core code into
>> __schedule(). __schedule() is directly called from the places which
>> set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
>> checks into schedule(), so they are only called when a task voluntary
>> goes to sleep.
> 
> I don't think that works.  We'll need to flush the block requests even
> for an involuntary schedule.

Yep, doing it just for voluntary schedule() is pointless, since the
caller should just do the flushing on his own. The whole point of the
sched hook was to ensure that involuntary schedules flushed it.

-- 
Jens Axboe

