Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2AZPcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:32:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:45730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2AZPch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:32:37 -0500
Message-ID: <1327591943.2446.111.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 16:32:23 +0100
In-Reply-To: <20120125174330.GA23303@redhat.com>
References: <1326721082.2442.234.camel@twins>
	 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
	 <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com>
	 <20120118094219.GE5842@elte.hu> <20120118142005.GB10105@redhat.com>
	 <1327400349.2614.10.camel@laptop> <1327402527.2614.17.camel@laptop>
	 <20120125154547.GA6671@redhat.com> <1327510290.2614.95.camel@laptop>
	 <20120125174330.GA23303@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 18:43 +0100, Oleg Nesterov wrote:
> And this time I do not understand your reply.

Hmm, I wouldn't either, I think I got ->on_cpu and ->on_rq confused. Let
me try again.

So since we never call schedule() the p->on_rq thing will always be
true. This means we don't need to consider all the icky ttwu after that,
it also means the whole thing is inside ->pi_lock.

So we only have to consider the exact case Yasunori-San illustrated, and
waiting on ->pi_lock is sufficient.

However I think your proposal:

>                 for (;;) {
>                         tsk->state = TASK_DEAD;
>                         schedule();
>                 }

should equally work, if we hit the race and call schedule() with ->state
= TASK_RUNNING, we'll simply loop and try again observing the TASK_DEAD
on the second+ go.

Now I prefer your solution since it doesn't add anything to the exit
path.
