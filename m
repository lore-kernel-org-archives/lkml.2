Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0EaNFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:05:52 -0400
Received: from smtp.nokia.com ([192.100.122.230]:36949 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0EaNFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:05:51 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100531124742.GG9453@laptop>
References: <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk> <20100527072240.GM22536@laptop>
	 <1274957469.13159.20.camel@localhost> <20100527120737.GN22536@laptop>
	 <1274973693.15516.67.camel@localhost> <20100527154435.GS22536@laptop>
	 <1275294352.2678.102.camel@localhost> <20100531083844.GF9453@laptop>
	 <1275296644.2678.122.camel@localhost>  <20100531124742.GG9453@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 16:03:35 +0300
Message-ID: <1275311015.2678.131.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 May 2010 13:05:35.0855 (UTC) FILETIME=[F58D2FF0:01CB00C1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 22:47 +1000, Nick Piggin wrote:
> > set_current_state(TASK_INTERRUPTIBLE);
> > /* 
> >  * XXX: what if we are preempted here. No timer is armed. Our state is
> >  * TASK_INTERRUPTIBLE, supers_dirty is 1, so no one will ever wake us
> >  * up. Thus, we'll sleep forever.
> >  */
> > if (supers_dirty)
> > 	bdi_arm_supers_timer();
> > schedule();
> > 
> > Not sure, but I did quick search and it looks like in preemptive kernel,
> > an interrupt may happen in the XXX place above, then it will call
> > 'preempt_schedule_irq()', which sill call 'schedule()'.
> 
> Yes, preempt does not participate in tsak sleeping exactly for reasons
> such as this.
> 
> From kernel/sched.c:schedule()
> 
>         if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>                 if (unlikely(signal_pending_state(prev->state, prev)))
>                         prev->state = TASK_RUNNING;
>                 else
>                         deactivate_task(rq, prev, DEQUEUE_SLEEP);
>                 switch_count = &prev->nvcsw;
>         }
> 
> If the task is not running, then is only removed from the runqueue
> (or reset to running in case of pending signal) IFF it has not been
> scheduled from an involuntary kernel preemption.
> 
> So in the XXX region, the task will actually be allowed to run again
> until it calls schedule().

Clear now, thanks a lot again!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

