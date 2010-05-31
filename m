Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0EaIit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:38:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:35252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0EaIis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:38:48 -0400
Date: Mon, 31 May 2010 18:38:44 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100531083844.GF9453@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
 <20100527072240.GM22536@laptop>
 <1274957469.13159.20.camel@localhost>
 <20100527120737.GN22536@laptop>
 <1274973693.15516.67.camel@localhost>
 <20100527154435.GS22536@laptop>
 <1275294352.2678.102.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275294352.2678.102.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:25:52AM +0300, Artem Bityutskiy wrote:
> On Fri, 2010-05-28 at 01:44 +1000, Nick Piggin wrote:
> > > if (supers_dirty)
> > > 	bdi_arm_supers_timer();
> > > set_current_state(TASK_INTERRUPTIBLE);
> > > schedule();
> 
> > But we cannot do the above, because again the timer might go off
> > before we set current state. We'd lose the wakeup and never wake
> > up again.
> > 
> > Putting it inside set_current_state() should be OK. I suppose.
> 
> Hmm, but it looks like we cannot do that either. If we do
> 
> set_current_state(TASK_INTERRUPTIBLE);
> if (supers_dirty)
> 	bdi_arm_supers_timer();
> schedule();
> 
> and the kernel is preemptive, is it possible that we get preempted
> before we run 'bdi_arm_supers_timer()', but after we do
> 'set_current_state(TASK_INTERRUPTIBLE)'. And we will never wake up if
> the timer armed in mark_sb_dirty() went off.
> 
> So it looks like this is the way to go:
> 
> /*
>  * Disable preemption for a while to make sure we are not
>  * preempted before the timer is armed.
>  */
> preempt_disable();
> set_current_state(TASK_INTERRUPTIBLE);
> if (supers_dirty)
> 	bdi_arm_supers_timer();
> preempt_enable();
> schedule();

This should not be required because preempt is transparent to these
task sleep/schedule APIs.

The preempt event will not clear TASK_INTERRUPTIBLE, and so the timer
wakeup will set it to TASK_RUNNING (whether or not it has called
schedule() yet and whether or not it is currently preempted).


