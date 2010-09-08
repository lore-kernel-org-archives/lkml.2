Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab0IHIUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:20:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:54215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab0IHIUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:20:36 -0400
Message-ID: <4C87474B.3050405@kernel.org>
Date: Wed, 08 Sep 2010 10:20:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org> <20100907100108.GN705@dastard> <4C861582.6080102@kernel.org> <20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org> <20100908073428.GR705@dastard>
In-Reply-To: <20100908073428.GR705@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:20:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/08/2010 09:34 AM, Dave Chinner wrote:
>> I see.  The use case itself shouldn't be problematic at all for cmwq
>> (sans bugs of course).  In the other reply, you said "the system is
>> 100% unresponsive when the livelock occurs", which is kind of
>> puzzling.  It isn't really a livelock.
> 
> Actually, it is. You don't need to burn CPU to livelock, you just
> need a loop in the state machine that cannot be broken by internal
> or external events to be considered livelocked.

Yeah, but for the system to be completely unresponsive even to sysrq,
the system needs to be live/dead locked in a pretty specific way.

> However, this is not what I was calling the livelock problem - this
> is what I was calling the deadlock problem because to all external
> appearences the state machine is deadlocked on the inode lock....
> 
> The livelock case I described where the system is completely
> unresponsive is the one I'm testing the WQ_HIGHPRI mod against.
> 
> FWIW, having considered the above case again, and seeing what the
> WQ_HIGHPRI mod does in terms of queuing, I think that it may also
> solve this deadlock as the log IO completionwill always be queued
> ahead of the data IO completion now.

Cool, but please keep in mind that the nr_active underflow bug may end
up stalling or loosening ordering rules for a workqueue.  Linus has
pulled in the pending fixes today.

>> Hmm... The point where I'm confused is that *delay()'s are busy waits.
>> They burn CPU cycles.  I suppose you're referring to *sleep()'s,
>> right?
> 
> fs/xfs/linux-2.6/time.h:
> 
> static inline void delay(long ticks)
> {
>         schedule_timeout_uninterruptible(ticks);
> }

Heh yeah, there's my confusion.

>> Probably I have overloaded the term 'concurrency' too much.  In this
>> case, I meant the number of workers assigned to work items of the wq.
>> If you fire off N work items which sleep at the same time, cmwq will
>> eventually try to create N workers as each previous worker goes to
>> sleep so that the CPU doesn't sit idle while there are work items to
>> process as long as N < @wq->nr->active.
> 
> Ok, so if I queue N items on a single CPU when max_active == N, they
> get spread across N worker threads on different CPUs? 

They may if necessary to keep the workqueue progressing.

Thanks.

-- 
tejun
