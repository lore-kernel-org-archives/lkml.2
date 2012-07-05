Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2GEIfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:35:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:52153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GEIfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:35:51 -0400
Message-ID: <1341477343.7709.4.camel@twins>
Subject: Re: [RFC BUG] There is a potential bug in "yield_to"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 05 Jul 2012 10:35:43 +0200
In-Reply-To: <4FF526BF.7030000@linux.vnet.ibm.com>
References: <4FF526BF.7030000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 13:31 +0800, Michael Wang wrote:
> Hi, All
> 
> I found there may be a potential bug in "yield_to":
> 
>         local_irq_save(flags);
>         rq = this_rq();
> 
> again:	
> 
> //task's rq may already changed in "sched_move_task"
> 
>         p_rq = task_rq(p);
>         double_rq_lock(rq, p_rq);
>         while (task_rq(p) != p_rq) {
>                 double_rq_unlock(rq, p_rq);
>                 goto again;
>         }
> 
> I think it may happen in this scene:
> 
> 	cpu 0				cpu 1(task a)
> 
> 					yield_to {
> 					disable_irq
> 	sched_move_task {		rq = this_rq();
> 	task_rq_lock(task a)		double_rq_lock
> 
> 	hold lock of rq 1			
> 	set_task_rq			//task rq changed
> 	release lock of rq 1
> 
> 					hold lock of rq 1
> 					but task b no longer
> 					there
> 
> 					set rq 1's current to
> 					skip which is not task a
> 
> which means we hold a rq's lock but it's current is not the one should
> do yield.
> 
> Only "sched_move_task" will cause this issue as it will move the task
> which is still running.
> 
> The bug will make the task who want to do yield failed to set skip buddy
> to himself, but to a innocent task instead, not very harmful and almost
> impossible to occur in normal, but should we fix it with another check
> "rq == this_rq()"?

Uhm, what?!

We've got interrupts disabled, this_rq() cannot ever possibly change, so
rq is always correct.

Only p_rq can change, and we have an again loop on that, so what's the
problem again?
