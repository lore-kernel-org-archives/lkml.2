Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1ELKJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:09:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1ELKJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:09:29 -0400
Subject: Re: [PATCH] sched: rt_rq runtime leakage bug fix
From: Peter Zijlstra <peterz@infradead.org>
To: Cheng Xu <chengxu@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DCAC79A.7050505@linux.vnet.ibm.com>
References: <4DCA3C0C.3080901@linux.vnet.ibm.com>
	 <1305105711.2914.205.camel@laptop>  <4DCAC79A.7050505@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 12:12:30 +0200
Message-ID: <1305195150.2914.268.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 01:30 +0800, Cheng Xu wrote:
> 
> I tried but hit a boot-time error "Unable to handle kernel paging
> request for data at address 0x100000008", and therefore would like to
> propose an alternative patch like,
> 
I probably made a silly mistake somehwere, it was after all something
quickly typed in an email :-)

> #define for_each_rt_rq(rt_rq, iter, rq) \
>         for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
>              (&iter->list != &task_groups) && (rt_rq = iter->rt_rq[cpu_of(rq)]); \
>              iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
> 
> This worked, it seems to pass the tests.  Is this correct from a scheduler perspective?

Creative ;-), it would be nice to know why the , operator version
doesn't work though, since that looks to be the more conventional way to
write it.

That said, I don't see a problem with using your existing on.

> For the not CONFIG_RT_GROUP_SCHED part, I used 
> 
> typedef struct rt_rq *rt_rq_iter_t;
> 
> #define for_each_rt_rq(rt_rq, iter, rq) \
>         (void) iter; \
>         for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
> 
> An alternative is 
> #define for_each_rt_rq(rt_rq, iter, rq) \
>         for (rt_rq = iter = &rq->rt; iter; rt_rq = iter = NULL)

Tough call that, the first has a multi-statement macro, which is
generally discouraged because then:

  for()
   for_each_rt_rq() {
   }

will not work as expected, so I think we want the second version.

> The patch is attached below. Could you check whether it is workable? Thank you. 

Yes, given how things are I can't really see it getting any better,
thanks!

