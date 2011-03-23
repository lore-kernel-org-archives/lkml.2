Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1CWUlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:41:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab1CWUlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:51 -0400
Date: Wed, 23 Mar 2011 16:41:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Message-ID: <20110323204146.GK13315@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
 <20110322150905.GD3757@redhat.com>
 <AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
 <20110322181231.GJ3757@redhat.com>
 <AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 01:10:32PM -0700, Chad Talbott wrote:
> On Tue, Mar 22, 2011 at 11:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Mar 22, 2011 at 10:39:36AM -0700, Chad Talbott wrote:
> >> On Tue, Mar 22, 2011 at 8:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Why not just implement simply RT class groups and always allow an RT
> >> > group to preempt an BE class. Same thing we do for cfq queues. I will
> >> > not worry too much about a run away application consuming all the
> >> > bandwidth. If that's a concern we could use blkio controller to limit
> >> > the IO rate of a latency sensitive applicaiton to make sure it does
> >> > not starve BE applications.
> >>
> >> That is not quite the same semantics.  This limited preemption patch
> >> is still work-conserving.  If the RT task in the only task on the
> >> system with IO, it will be able to use all available disk time.
> >>
> >
> > It is not same semantics but it feels like too much of special casing
> > for a single use case.
> 
> How are you counting use cases?

This is the first time I have heard this requirement. So if 2-3 different
folks come up with similar concern, then I have idea an idea that this
is a generic need.

You also have not explained what is the workload and what are the
acceptable latencies etc.

> 
> > You are using the generic notion of a RT thread (which in general means
> > that it gets all the cpu or all the disk ahead of BE task). But you have
> > changed the definition of RT for this special use case. And also now
> > group RT is different from queue RT definition.
> 
> Perhaps the name RT has too much of a "this group should be able to
> starve all other groups" connotation.  Is there a better name?  Maybe
> latency sensitive?

I think what you are trying to achieve is that you want to define an
additional task and group property, say latency sensitive. This is
third property apart from ioclass and ioprio. To me you still want
the task/group to be BE class so that it shares the disk in a
proportional weight manner but this additional property will make sure
that task can preempt the non latency sensitive task/group.

We can't do this additional property for group alone because once we
move to hierarhical setup and everything is entity (be it task or queue)
and then we need to decide whether one entity can preempt another
entity or not. By not definining this property for tasks, latency 
sensitive group will always preempt a task on same tree. (May be
that's what you want for your use case). But it is still odd to add
additional properties only for groups and not tasks.

This is the new paradigm (atleast to me). It introduces additional 
complextiy in a already complicated system. So it makes sense to make
sure that there are more than 1 users of this functionality.

> 
> > Why not have similar mechanism for cpu scheduler also then. This
> > application first should be able to get cpu bandwidth in same predictable
> > manner before it gets the disk bandwidth.
> 
> Perhaps this is a good idea.  If the CPU scheduler folks like it, I'll
> be happy to support that.

> 
> > And I think your generation number patch should address this issue up
> > to great extent. Isn't it? If a latency sensitive task is not using
> > its fair quota, it will get a lower vdisktime and get to dispatch soon?
> 
> It will get to dispatch as soon as the current task's timeslice
> expires.  This could be a long time, depending on the number of other
> tasks and groups on the system.  We'd like to provide a latency
> guarantee that's dependent only on the behavior of the low-latency
> application.

What are your latency requirements? I believe maximum slice length can
be 180ms in default settings. You can change base slice to 50 and that
will make maximum slice length to 90. For default case it will be 50ms.

So question is what workload it is which can not tolerate these latencies.

> 
> > If that soon is not enough, then we could operate with reduce base slice
> > length so that we allocate smaller slices to groups and get better IO
> > latencies at the cost of total throughput.
> 
> With the limited preemption patch, I can still achieve good throughput
> for many tasks, as long as the low-latency task is "quiet" or when
> there is no low-latency task on the system.  If I use very small
> timeslices, then I always pay a throughput price, even when there is
> no low-latency task on the system or that task isn't doing any IO.

Ok, that's fine. So with-in BE class you are trying to define another
type of groups that is "low latency". That's why I think this is third
propety apart from ioprio and ioclass.

> 
> >> > If RT starving BE is an issue, then it is an issue with plain cfq queue
> >> > also. First we shall have to fix it there.
> >> >
> >> > This definition that a latency sensitive task get prioritized only
> >> > till it is consuming its fair share and if task starts using more than
> >> > fair share then CFQ automatically stops prioritizing it sounds little
> >> > odd to me. If you are looking for predictability, then we lost it. We
> >> > shall have to very well know that task is not eating more than its
> >> > fair share before we can gurantee any kind of latencies to that task. And
> >> > if we know that task is not hogging the disk, there is anyway no risk
> >> > of it starving other groups/tasks completely.
> >>
> >> In a shared environment, we have to be a little bit defensive.  We
> >> hope that a latency sensitive task is well characterized and won't
> >> exceed its share of the disk, and that we haven't over-committed the
> >> disk.  If the app does do more IO than expected, then we'd like them
> >> to bear the burden.  We have a choice of two outcomes.  A single job
> >> sometimes failing to achieve low disk latency when it's very busy.  Or
> >> all jobs on a disk sometimes being very slow when another (unrelated)
> >> job is very busy.  The first is easier to understand and debug.
> >
> > To me you are trying to come up with a new scheduling class which is
> > not RT and you are trying to overload the meaning of RT for your use
> > case and that's the issue I have.
> 
> Can we come up with a better name?  I've used low-latency and
> latency-sensitive in this email, and it's not too cumbersome.
> 
> > Coming up with a new scheduling class is also not desirable as that
> > will demand another service tree and we already have too many. Also
> > it should probably be also done for task and not just group otherwise
> > extending this concept to hierarchical setup will get complicated. Queues
> > and groups will just not gel well.
> 
> Is there a plan to provide RT class for groups in the hierarchical
> future to allow full symmetry with RT tasks?
> 
> > Frankly speaking, the problem you are having should be solved by your
> > generation number patch and by having smaller base slices.
> 
> Again, the throughput price is quite high to pay for all disks - even
> when they have no latency sensitive groups, or those groups are not
> issuing IO.
> 
> > Or You could put latency sensitive applications in an RT class and
> > then throttle them using blkio controller. That way you get good
> > latencies as well as you don't starve other tasks.
> 
> This is closer to the semantics offered by this patchset, but requires
> debugging the complex interactions between two scheduling policies to
> understand the resulting behavior.

Can you explain that a bit more? throttling behavior is very clear that
a group is allowed dispatch as long as it does not cross the limit.
Otherwise bio is put in a queue and later submitted to underlying devices.

So as long as latency sensitive task is with-in rate limit, it will get
the latency you want. The moment it tries to do lot of IO, it will get
throttled and practically becomes a oridinary BE task. I believe that's
what your patchset does. latency sensitive gets priority only if it
is consuming its fair share of disk. The only difference here is that
defination of fair share is abosolute (specified interms of bps or iops)
instead of it being dynamic depending on how many groups are doing IO.
 
blktrace results show the throttle as well cfq logs in same file so
correlating two policies is really easy. So I really don't think that
understanding the resulting is behavior is hard. I will be happy to be
proven wrong though.

> 
> > But I don't think overloading the meaning for RT or this specific use
> > case is a good idea.
> 
> I hear you loud and clear, but I disagree.

You disagree with what? Changing the definition of RT is fine. ioclass RT
means one thing for tasks and other thing for group, is it fine?

If we really end up doing it, I think we shall have to define an 
additional group file say, blkio.preempt_fair_share. This will mean
that this is a BE group but has additional property which allows it to
preempt existing entity on service tree as long as it does not exceed
it fair share. That way we don't have to define a new class or don't
have to come up with additional service tree.

But I would prefer that you seriously consider implementing RT group class
and rate limit it with throttling logic. Because I believe it should solve
your issue. Only question would be what should be upper limit and I think
that will depend on type of storage your are using and what's your
workload.

Also if you can give a better example where this kind of latency matters,
it will help to understand the problem better.

Thanks
Vivek

