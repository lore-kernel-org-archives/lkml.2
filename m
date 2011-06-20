Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1FTOmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:42:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:37296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1FTOmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:42:19 -0400
Subject: Re: [PATCH 6/7] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <4DF80A40.9040201@redhat.com>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
	 <1308007897-17013-7-git-send-email-glommer@redhat.com>
	 <1308048147.19856.14.camel@twins>  <4DF80A40.9040201@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Jun 2011 16:41:33 +0200
Message-ID: <1308580893.26237.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 22:26 -0300, Glauber Costa wrote:
> On 06/14/2011 07:42 AM, Peter Zijlstra wrote:
> > On Mon, 2011-06-13 at 19:31 -0400, Glauber Costa wrote:
> >> @@ -1981,12 +1987,29 @@ static void update_rq_clock_task(struct rq
> >> *rq, s64 delta)
> >>
> >>          rq->prev_irq_time += irq_delta;
> >>          delta -= irq_delta;
> >> +#endif
> >> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> >> +       if (static_branch((&paravirt_steal_rq_enabled))) {
> >
> > Why is that a different variable from the touch_steal_time() one?
> 
> because they track different things, touch_steal_time() and 
> update_rq_clock() are
> called from different places at different situations.
> 
> If we advance prev_steal_time in touch_steal_time(), and later on call 
> update_rq_clock_task(), we won't discount the time already flushed from 
> the rq_clock. Conversely, if we call update_rq_clock_task(), and only 
> then arrive at touch_steal_time, we won't account steal time properly.

But that's about prev_steal_time vs prev_steal_time_acc, I agree those
should be different.

> update_rq_clock_task() is called whenever update_rq_clock() is called.
> touch_steal_time is called every tick. If there is a causal relation 
> between them that would allow us to track it in a single location, I 
> fail to realize.

Both are steal time muck, I was wondering why we'd want to do one and
not the other when we have a high res stealtime clock.

> >> +
> >> +               steal = paravirt_steal_clock(cpu_of(rq));
> >> +               steal -= rq->prev_steal_time_acc;
> >> +
> >> +               rq->prev_steal_time_acc += steal;
> >
> > You have this addition in the wrong place, when you clip:
> 
> I begin by disagreeing
> >> +               if (steal>  delta)
> >> +                       steal = delta;
> >
> > you just lost your steal delta, so the addition to prev_steal_time_acc
> > needs to be after the clip.

> Unlike irq time, steal time can be extremely huge. Just think of a 
> virtual machine that got interrupted for a very long time. We'd have 
> steal >> delta, leading to steal == delta for a big number of iterations.
> That would affect cpu power for an extended period of time, not
> reflecting present situation, just the past. So I like to think of delta
> as a hard cap for steal time.
> 
> Obviously, I am open to debate.

I'm failing to see how this would happen, if the virtual machine wasn't
scheduled for a long long while, delta would be huge too. But suppose it
does happen, wouldn't it be likely that the virtual machine would
receive similar bad service in the near future? Making the total
accounting relevant.
