Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1CWBnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab1CWBnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:43:10 -0400
Date: Tue, 22 Mar 2011 21:43:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Message-ID: <20110323014307.GB10325@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
 <20110322150905.GD3757@redhat.com>
 <AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
 <20110322181231.GJ3757@redhat.com>
 <AANLkTi=fsw8QjA0H2SALc5Tbh+7CLwHkt2Vx9H6VPtpX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=fsw8QjA0H2SALc5Tbh+7CLwHkt2Vx9H6VPtpX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:46:59PM -0700, Chad Talbott wrote:
> Would it be a better approach to avoid calling the feature real-time?
> Or perhaps to use another service tree to allow strict preemption (as
> is done at the task level today)?
> 
> I don't like the approach of tuning tiny slices and taking a
> throughput hit all the time - even if there is no latency sensitive
> group on the system.

I would appreciate if you could respond to all the points raised in
previous mail, otherwise I will just end up asking these again. 

- Why your cfq generation number patch is not sufficient? If you got a 
  workload which consumes little bandwidth only once in a while, it 
  would be placed at the beginning of service tree and you should
  experience smaller latencies.

- Why not mark the group RT group and to handle the worst case where
  user does not run away all the bandwidth, use blkio throttle to 
  set the upper limit on bandwidth. 

Coming up with another prio class or service tree just makes things 
even more complicated for this specialized case. In fact notion of
fairness or disk share is only for BE class. So coming up with another
class will not help anyway.

If you come up with another service tree, then comes a big question
how do you decide the fairness between two service trees.

IMHO, this is too special casing for a particular workload and really
will make CFQ even more complex. 

Thanks
Vivek

> 
> Chad
> 
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
> >
> > You are using the generic notion of a RT thread (which in general means
> > that it gets all the cpu or all the disk ahead of BE task). But you have
> > changed the definition of RT for this special use case. And also now
> > group RT is different from queue RT definition.
> >
> > Why not have similar mechanism for cpu scheduler also then. This
> > application first should be able to get cpu bandwidth in same predictable
> > manner before it gets the disk bandwidth.
> >
> > And I think your generation number patch should address this issue up
> > to great extent. Isn't it? If a latency sensitive task is not using
> > its fair quota, it will get a lower vdisktime and get to dispatch soon?
> >
> > If that soon is not enough, then we could operate with reduce base slice
> > length so that we allocate smaller slices to groups and get better IO
> > latencies at the cost of total throughput.
> >
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
> >
> > Coming up with a new scheduling class is also not desirable as that
> > will demand another service tree and we already have too many. Also
> > it should probably be also done for task and not just group otherwise
> > extending this concept to hierarchical setup will get complicated. Queues
> > and groups will just not gel well.
> >
> > Frankly speaking, the problem you are having should be solved by your
> > generation number patch and by having smaller base slices.
> >
> > Or You could put latency sensitive applications in an RT class and
> > then throttle them using blkio controller. That way you get good
> > latencies as well as you don't starve other tasks.
> >
> > But I don't think overloading the meaning for RT or this specific use
> > case is a good idea.
> >
> > Thanks
> > Vivek
> >
