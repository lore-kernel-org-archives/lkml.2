Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0CXQgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:36:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0CXQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:36:04 -0400
Date: Wed, 24 Mar 2010 17:33:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] move_task_off_dead_cpu: take rq->lock around
	select_fallback_rq()
Message-ID: <20100324163356.GA6380@redhat.com>
References: <20100315091010.GA9131@redhat.com> <1269445284.5109.360.camel@twins> <20100324160727.GA4121@redhat.com> <1269447422.5109.408.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269447422.5109.408.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Peter Zijlstra wrote:
>
> Yeah, you made a few good points in 0/6, am now staring at the code on
> how to close those holes, hope to post something sensible soon.

Yes, great.

Speaking of 0/6, I forgot to ask a couple more question...

try_to_wake_up() does task_rq_lock() which checks TASK_WAKING. Perhaps
it shouldn't ? I mean, perhaps try_to_wake_up() can take rq->lock without
checking task->state. It can never race with the owner of TASK_WAKING,
before anything else we check "p->state & state".

And. Without the change above, any owner of TASK_WAKING must disable
preemption and clear irqs.

What do you think?


And a stupid question. While doing these changes I was really, really
puzzled by task_rq_lock() which does

	local_irq_save(*flags);
	rq = task_rq(p);
	raw_spin_lock(&rq->lock);

to the point, I even tried to read the comment which says:

	Note the ordering: we can safely lookup the task_rq without
	explicitly disabling preemption.

Could you please explain what does this mean? IOW, why can't we do

	rq = task_rq(p);
	raw_spin_lock_irqsave(&rq->lock, flags);

instead?

Of course, this doesn't really matter, but I'd like to understand
what I have missed here.

Thanks,

Oleg.

