Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0LPTD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:03:59 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52137 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0LPTD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:03:58 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292525893.2708.50.camel@laptop>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl>  <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 20:03:40 +0100
Message-ID: <1292526220.2708.55.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 19:58 +0100, Peter Zijlstra wrote:
> > > +    * Since we've already set TASK_WAKING this task's CPU cannot
> > > +    * change from under us.
> > 
> > I think it can. Yes, we've set TASK_WAKING. But, at least the task
> > itself can change its state back to TASK_RUNNING without calling
> > schedule. Say, __wait_event()-like code.
> 
> Oh crud, you're right, that's going to make all this cmpxchg stuff lots
> more interesting :/ 

Hrmph, we can add a task_is_waking() test to the rq->lock in schedule(),
like we have for __task_rq_lock():

  local_irq_save(flags);
again:
  while (task_is_waking(current))
	cpu_relax();
  raw_spin_lock(rq->lock);
  if (task_is_waking(current)) {
	raw_spin_unlock(rq->lock);
	goto again;
  }


But that's not particularly pretty...
