Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1LZRRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:17:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1LZRRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:17:37 -0500
Date: Mon, 26 Dec 2011 18:11:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20111226171151.GA4472@redhat.com>
References: <1324633794.24803.48.camel@twins> <20111223154137.GA27901@redhat.com> <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26, Yasunori Goto wrote:
>
> >
> > IIRC, this was already discussed a bit. Say, try_to_wake_up(TASK_INTERRUPTIBLE)
> > can wakeup a TASK_UNINTERRUPTIBLE task if it temporary sets INTERRUPTIBLE but
> > doesn't call schedule() in this state.
>
> Oleg-san,
>
> Could you point the discussion?
> I don't understand yet how it occurred...

Suppose that the task T does

	set_current_state(TASK_INTERRUPTIBLE);

	set_current_state(TASK_UNINTERRUPTIBLE);
	schedule();

try_to_wake_up(TASK_UNINTERRUPTIBLE) in between can observe this task
in TASK_INTERRUPTIBLE state. Then it can set RUNNING/WAKING after T
sets ->state = TASK_UNINTERRUPTIBLE.

For example, this is possibly if T simply does wait_event() twice when
the the 1st wait_event() doesn't sleep.

Basically this is the same race you described, but I think you found
the case when we can't tolerate the spurious wakeup.

Oleg.

