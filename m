Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1BYDmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:42:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20610 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1BYDmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Yd1WCtf5kaf8Hc5nMcMVjfREBVvLXUd60gminScyv0+rM1Lp8qeqXQ0pSNOQWoVoWb
         +JN6Ely8zUPZtzYT8VPQ==
MIME-Version: 1.0
In-Reply-To: <1298545501.2428.18.camel@twins>
References: <20110216031831.571628191@google.com> <20110216031841.068673650@google.com>
 <1298467933.2217.765.camel@twins> <20110224052101.GA2755@in.ibm.com> <1298545501.2428.18.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 24 Feb 2011 19:41:25 -0800
Message-ID: <AANLkTimp7btpRkUo=vTpPTwrJrhY2KiEJ4N+oZUWH-sg@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 3:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-02-24 at 10:51 +0530, Bharata B Rao wrote:
>> Hi Peter,
>>
>> I will only answer a couple of your questions and let Paul clarify the rest...
>>
>> On Wed, Feb 23, 2011 at 02:32:13PM +0100, Peter Zijlstra wrote:
>> > On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
>> >
>> >
>> > > @@ -1363,6 +1407,9 @@ enqueue_task_fair(struct rq *rq, struct
>> > >                   break;
>> > >           cfs_rq = cfs_rq_of(se);
>> > >           enqueue_entity(cfs_rq, se, flags);
>> > > +         /* don't continue to enqueue if our parent is throttled */
>> > > +         if (cfs_rq_throttled(cfs_rq))
>> > > +                 break;
>> > >           flags = ENQUEUE_WAKEUP;
>> > >   }
>> > >
>> > > @@ -1390,8 +1437,11 @@ static void dequeue_task_fair(struct rq
>> > >           cfs_rq = cfs_rq_of(se);
>> > >           dequeue_entity(cfs_rq, se, flags);
>> > >
>> > > -         /* Don't dequeue parent if it has other entities besides us */
>> > > -         if (cfs_rq->load.weight)
>> > > +         /*
>> > > +          * Don't dequeue parent if it has other entities besides us,
>> > > +          * or if it is throttled
>> > > +          */
>> > > +         if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
>> > >                   break;
>> > >           flags |= DEQUEUE_SLEEP;
>> > >   }
>> >
>> > How could we even be running if our parent was throttled?

The only way this can happen is if we are on our way out.  The example
given doesn't apply to this case I don't think
>>
>> The task isn't running actually. One of its parents up in the heirarchy has
>> been throttled and been already dequeued. Now this task sits on its immediate
>> parent's runqueue which isn't throttled but not really running also since
>> the hierarchy is throttled.
>> In this situation, load balancer can try to pull
>> this task. When that happens, load balancer tries to dequeue it and this
>> check will ensure that we don't attempt to dequeue a group entity in our
>> hierarchy which has already been dequeued.
>
> That's insane, its throttled, that means it should be dequeued and
> should thus invisible for the load-balancer.

I agree.  We ensure this does not happen by making the h_load zero.
Something I thought I was doing but apparently not, will fix in
repost.

> load-balancer will try and move tasks around to balance load, but all in
> vain, it'll move phantom loads around and get most confused at best.
>

Yeah this shouldn't happen, I don't think this example is a valid one.

> Pure and utter suckage if you ask me.
>
>> > > @@ -1438,10 +1524,16 @@ static void account_cfs_rq_quota(struct
>> > >
>> > >   cfs_rq->quota_used += delta_exec;
>> > >
>> > > - if (cfs_rq->quota_used < cfs_rq->quota_assigned)
>> > > + if (cfs_rq_throttled(cfs_rq) ||
>> > > +         cfs_rq->quota_used < cfs_rq->quota_assigned)
>> > >           return;
>> >
>> > So we are throttled but running anyway, I suppose this comes from the PI
>> > ceiling muck?
>>
>> When a cfs_rq is throttled, its representative se (and all its parent
>> se's) get dequeued and the task is marked for resched. But the task entity is
>> still on its throttled parent's cfs_rq (=> task->se.on_rq = 1). Next during
>> put_prev_task_fair(), we enqueue the task back on its throttled parent's
>> cfs_rq at which time we end up calling update_curr() on throttled cfs_rq.
>> This check would help us bail out from that situation.
>
> But why bother with this early exit? At worst you'll call
> tg_request_cfs_quota() in vain, at best you'll find there is runtime
> because the period tick just happened on another cpu and you're good to
> go, yay!

It's for the non-preemptible case where we could be running for non
trivial time after reschedule()

Considering your second point I suppose there could be a micro-benefit
in checking in case the period tick did just happen to occur and then
self unthrottling... but I don't think it's really worth it.


>
>
>
