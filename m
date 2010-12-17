Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0LQSlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:41:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44759 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0LQSlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:41:22 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292610297.2266.334.camel@twins>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
	 <20101217165414.GA8997@redhat.com>  <20101217175013.GB8997@redhat.com>
	 <1292610297.2266.334.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 19:41:04 +0100
Message-ID: <1292611264.2266.344.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 19:24 +0100, Peter Zijlstra wrote:
> > Even simpler. This can race with, say, __migrate_task() which does
> > deactivate_task + activate_task and temporary clears on_rq. Although
> > this is simple to fix, I think.
> 
> Yes, another hole.. 

__migrate_task() is a tad special in that it should only migrate
runnable tasks, but of course we can have it preempted with ->state !=
TASK_RUNNING, which makes life interesting, but we can fix that by
including a PREEMPT_ACTIVE test in ttwu.

Other such callers are more straight fwd though:

  rt_mutex_setprio()
  set_user_nice()
  sched_move_task()
  __sched_setscheduler()
  normalize_task()

none of those are fast-path operations, so it is quite doable to also
take the ->pi_lock there and fully serialize them.
  
