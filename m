Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0CZJGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 05:06:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0CZJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 05:06:28 -0400
Subject: Re: [PATCH 2/6] move_task_off_dead_cpu: take rq->lock around
 select_fallback_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100324163356.GA6380@redhat.com>
References: <20100315091010.GA9131@redhat.com>
	 <1269445284.5109.360.camel@twins> <20100324160727.GA4121@redhat.com>
	 <1269447422.5109.408.camel@twins>  <20100324163356.GA6380@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 10:06:20 +0100
Message-ID: <1269594380.12097.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 17:33 +0100, Oleg Nesterov wrote:
> On 03/24, Peter Zijlstra wrote:
> >
> > Yeah, you made a few good points in 0/6, am now staring at the code on
> > how to close those holes, hope to post something sensible soon.
> 
> Yes, great.
> 
> Speaking of 0/6, I forgot to ask a couple more question...
> 
> try_to_wake_up() does task_rq_lock() which checks TASK_WAKING. Perhaps
> it shouldn't ? I mean, perhaps try_to_wake_up() can take rq->lock without
> checking task->state. It can never race with the owner of TASK_WAKING,
> before anything else we check "p->state & state".

You're right, but creating a special task_rq_lock() for ttwu() went a
little far, but now that we can remove all that again, this too should
be good again.


> And a stupid question. While doing these changes I was really, really
> puzzled by task_rq_lock() which does
> 
> 	local_irq_save(*flags);
> 	rq = task_rq(p);
> 	raw_spin_lock(&rq->lock);
> 
> to the point, I even tried to read the comment which says:
> 
> 	Note the ordering: we can safely lookup the task_rq without
> 	explicitly disabling preemption.
> 
> Could you please explain what does this mean? IOW, why can't we do
> 
> 	rq = task_rq(p);
> 	raw_spin_lock_irqsave(&rq->lock, flags);
> 
> instead?

I'm not sure why that is the case, v2.6.14:kernel/sched.c already has
that. Ingo can you remember any reason for this or should we change the
code like Oleg suggests?

