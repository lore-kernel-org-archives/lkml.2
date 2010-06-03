Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab0FCAwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:52:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47978 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0FCAwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W9sbL61Aww6iGG7Imq+vRy616J7TtbXijKnQe46TG4wdQ6e5wUNaYnR3GWYGLeYjXX
         vk69PAioIwJxnyvDSvE55i1Do2bqwEsVKehULYJY4Gea5IUQGE33i/n/QjBndM+UupZi
         pv6++JiyzUiKbk3J3KSgsI5X7nIJZu6fg6D04=
MIME-Version: 1.0
In-Reply-To: <20100603083259.7231.A69D9226@jp.fujitsu.com>
References: <20100602220429.F51E.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com>
	<20100603083259.7231.A69D9226@jp.fujitsu.com>
Date: Thu, 3 Jun 2010 09:52:49 +0900
Message-ID: <AANLkTinxHv6VfaG-RXymfPwOMQi-cJTX3Tj0x6ROkZzo@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 8:36 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Wed, 2 Jun 2010, KOSAKI Motohiro wrote:
>>
>> > > > @@ -291,9 +309,10 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>> > > >                  * Otherwise we could get an easy OOM deadlock.
>> > > >                  */
>> > > >                 if (p->flags & PF_EXITING) {
>> > > > -                       if (p != current)
>> > > > +                       if (p != current) {
>> > > > +                               boost_dying_task_prio(p, mem);
>> > > >                                 return ERR_PTR(-1UL);
>> > > > -
>> > > > +                       }
>> > > >                         chosen = p;
>> > > >                         *ppoints = ULONG_MAX;
>> > > >                 }
>> > >
>> > > This has the potential to actually make it harder to free memory if p is
>> > > waiting to acquire a writelock on mm->mmap_sem in the exit path while the
>> > > thread holding mm->mmap_sem is trying to run.
>> >
>> > if p is waiting, changing prio have no effect. It continue tol wait to release mmap_sem.
>> >
>>
>> And that can reduce the runtime of the thread holding a writelock on
>> mm->mmap_sem, making the exit actually take longer than without the patch
>> if its priority is significantly higher, especially on smaller machines.
>
> If p need mmap_sem, p is going to sleep to wait mmap_sem. if p doesn't,
> quickly exit is good thing. In other word, task fairness is not our goal
> when oom occur.
>

Tend to agree. I didn't agree boosting of whole threads' priority.

Task fairness VS system hang is trade off. task fairness is best
effort but system hang is critical.
Also, we have tried to it.

        /*
         * We give our sacrificial lamb high priority and access to
         * all the memory it needs. That way it should be able to
         * exit() and clear out its resources quickly...
         */
        p->rt.time_slice = HZ;
        set_tsk_thread_flag(p, TIF_MEMDIE);

But I think above code is meaningless unless p use SCHED_RR.
So boosting of lowest RT priority with FIFO is to meet above comment's
goal, I think.

-- 
Kind regards,
Minchan Kim
