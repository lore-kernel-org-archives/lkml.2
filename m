Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2AXKTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:19:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:40779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab2AXKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:19:12 -0500
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
 condition
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120118142005.GB10105@redhat.com>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
	 <1326721082.2442.234.camel@twins>
	 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
	 <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com>
	 <20120118094219.GE5842@elte.hu>  <20120118142005.GB10105@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 11:19:09 +0100
Message-ID: <1327400349.2614.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 15:20 +0100, Oleg Nesterov wrote:
> do_exit() is different because it can not handle the spurious wakeup.
> Well, may be we can? we can simply do
> 
>                 for (;;) {
>                         tsk->state = TASK_DEAD;
>                         schedule();
>                 }
> 
> __schedule() can't race with ttwu() once it takes rq->lock. If the
> exiting task is deactivated, finish_task_switch() will see EXIT_DEAD.

TASK_DEAD, right?

> Unless I missed something, the only problem is preempt_disable(),
> but schedule_debug() checks ->exit_state.
> 
> OTOH, if we fix this race then probably schedule_debug() should
> check state == EXIT_DEAD instead. 

Hmm, interesting. On the up side that removes the need for that inf loop
after BUG, down side is of course that we loose the BUG itself too. Now
I'm not too sure we actually care about that, a task spinning at 100% in
x state should be fairly obvious borkage and its not like we hit this
thing very often.



