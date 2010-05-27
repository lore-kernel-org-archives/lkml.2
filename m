Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0E0QHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:07:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48312 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0E0QHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:07:11 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100527154435.GS22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk> <20100527072240.GM22536@laptop>
	 <1274957469.13159.20.camel@localhost> <20100527120737.GN22536@laptop>
	 <1274973693.15516.67.camel@localhost>  <20100527154435.GS22536@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 19:04:35 +0300
Message-ID: <1274976275.15516.79.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2010 16:06:09.0901 (UTC) FILETIME=[857E69D0:01CAFDB6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 01:44 +1000, Nick Piggin wrote:
> > I think this will change the behavior of 'sync_supers()' too much. ATM,
> > it makes only one SB pass, then sleeps, then another one, then sleeps.
> > And we should probably preserve this behavior. So I'd rather make it:
> > 
> > if (supers_dirty)
> > 	bdi_arm_supers_timer();
> > set_current_state(TASK_INTERRUPTIBLE);
> > schedule();
> > 
> > This way we will keep the behavior closer to the original.
> 
> Well your previous code had the same issue (ie. it could loop again
> in sync_supers). But fair point perhaps.

I think no, it either armed the timer of went to sleep, but it does not
matter much :-)

> But we cannot do the above, because again the timer might go off
> before we set current state. We'd lose the wakeup and never wake
> up again.
> 
> Putting it inside set_current_state() should be OK. I suppose.

Oh, right!

> > There is spin_lock(&sb_lock) in sync_supers(), so strictly speak this
> > 'smp_mb()' is not needed if we move supers_dirty = 0 into
> > 'sync_supers()' and add a comment that a mb is required, in case some
> > one modifies the code later?
> > 
> > Or this is not worth it?
> 
> It's a bit tricky. spin_lock only gives an acquire barrier, which
> prevents CPU executing instructions inside the critical section
> before acquiring the lock. It actually allows stores to be deferred
> from becoming visible to other CPUs until inside the critical section.
> So the load of sb->s_dirty could indeed still happen before the
> store is seen.
> 
> Locks do allow you to avoid thinking about barriers, but *only* when
> all memory accesses to all shared variables are inside the locks
> (or when a section has just a single access, which by definition don't
> need ordering with another access).

Oh, ok. I need to read carefully Documentation/memory-barriers.txt.

> > BTW, do you want me to keep you to be the patch author, add your
> > signed-off-by and my original commit message?
> 
> I'm not concerned. You contributed more to the idea+implementation,
> so record yourself as author.

Ok, but thank you a lot for helping!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

