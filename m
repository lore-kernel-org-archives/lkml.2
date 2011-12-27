Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1L0Gsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:48:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56789 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1L0Gss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:48:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Tue, 27 Dec 2011 15:48:29 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111226171151.GA4472@redhat.com>
References: <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com> <20111226171151.GA4472@redhat.com>
Message-Id: <20111227154828.5120.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/26, Yasunori Goto wrote:
> >
> > >
> > > IIRC, this was already discussed a bit. Say, try_to_wake_up(TASK_INTERRUPTIBLE)
> > > can wakeup a TASK_UNINTERRUPTIBLE task if it temporary sets INTERRUPTIBLE but
> > > doesn't call schedule() in this state.
> >
> > Oleg-san,
> >
> > Could you point the discussion?
> > I don't understand yet how it occurred...
> 
> Suppose that the task T does
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	schedule();
> 
> try_to_wake_up(TASK_UNINTERRUPTIBLE) in between can observe this task
> in TASK_INTERRUPTIBLE state. Then it can set RUNNING/WAKING after T
> sets ->state = TASK_UNINTERRUPTIBLE.
> 
> For example, this is possibly if T simply does wait_event() twice when
> the the 1st wait_event() doesn't sleep.
> 
> Basically this is the same race you described, but I think you found
> the case when we can't tolerate the spurious wakeup.
> 
> Oleg.
> 
> On 12/26, Yasunori Goto wrote:
> >
> > >
> > > IIRC, this was already discussed a bit. Say, try_to_wake_up(TASK_INTERRUPTIBLE)
> > > can wakeup a TASK_UNINTERRUPTIBLE task if it temporary sets INTERRUPTIBLE but
> > > doesn't call schedule() in this state.
> >
> > Oleg-san,
> >
> > Could you point the discussion?
> > I don't understand yet how it occurred...
> 
> Suppose that the task T does
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	schedule();
> 
> try_to_wake_up(TASK_UNINTERRUPTIBLE) in between can observe this task
> in TASK_INTERRUPTIBLE state. Then it can set RUNNING/WAKING after T
> sets ->state = TASK_UNINTERRUPTIBLE.
> 
> For example, this is possibly if T simply does wait_event() twice when
> the the 1st wait_event() doesn't sleep.
> 
> Basically this is the same race you described, but I think you found
> the case when we can't tolerate the spurious wakeup.

Thanks.

I suppose your idea which uses cmpxchg(old_state, RUNNING) is best way.
I'll remake my patch.



> 
> Oleg.
> 

-- 
Yasunori Goto 


