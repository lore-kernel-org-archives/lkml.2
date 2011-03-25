Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1CYVcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:32:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab1CYVcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:32:07 -0400
Date: Fri, 25 Mar 2011 17:32:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Message-ID: <20110325213202.GB21593@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
 <20110322150905.GD3757@redhat.com>
 <AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
 <20110322181231.GJ3757@redhat.com>
 <AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
 <20110323204146.GK13315@redhat.com>
 <AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 02:47:54PM -0700, Chad Talbott wrote:
> On Wed, Mar 23, 2011 at 1:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Mar 23, 2011 at 01:10:32PM -0700, Chad Talbott wrote:
> >> On Tue, Mar 22, 2011 at 11:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Tue, Mar 22, 2011 at 10:39:36AM -0700, Chad Talbott wrote:
> >> >> On Tue, Mar 22, 2011 at 8:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> > Why not just implement simply RT class groups and always allow an RT
> >> >> > group to preempt an BE class. Same thing we do for cfq queues. I will
> >> >> > not worry too much about a run away application consuming all the
> >> >> > bandwidth. If that's a concern we could use blkio controller to limit
> >> >> > the IO rate of a latency sensitive applicaiton to make sure it does
> >> >> > not starve BE applications.
> >> >>
> >> >> That is not quite the same semantics. �This limited preemption patch
> >> >> is still work-conserving. �If the RT task in the only task on the
> >> >> system with IO, it will be able to use all available disk time.
> >> >>
> >> >
> >> > It is not same semantics but it feels like too much of special casing
> >> > for a single use case.
> >>
> >> How are you counting use cases?
> >
> > This is the first time I have heard this requirement. So if 2-3 different
> > folks come up with similar concern, then I have idea an idea that this
> > is a generic need.
> >
> > You also have not explained what is the workload and what are the
> > acceptable latencies etc.
> >
> >>
> >> > You are using the generic notion of a RT thread (which in general means
> >> > that it gets all the cpu or all the disk ahead of BE task). But you have
> >> > changed the definition of RT for this special use case. And also now
> >> > group RT is different from queue RT definition.
> >>
> >> Perhaps the name RT has too much of a "this group should be able to
> >> starve all other groups" connotation. �Is there a better name? �Maybe
> >> latency sensitive?

This is jut not RT name. It is also the using the term blkio.class. At
some point of time, it will be a good idea to be able to define ioclass
for group also (like taskss). So we can use blkio.class to define the
ioclass of the group.

> >
> > I think what you are trying to achieve is that you want to define an
> > additional task and group property, say latency sensitive. This is
> > third property apart from ioclass and ioprio. To me you still want
> > the task/group to be BE class so that it shares the disk in a
> > proportional weight manner but this additional property will make sure
> > that task can preempt the non latency sensitive task/group.
> >
> > We can't do this additional property for group alone because once we
> > move to hierarhical setup and everything is entity (be it task or queue)
> > and then we need to decide whether one entity can preempt another
> > entity or not. By not definining this property for tasks, latency
> > sensitive group will always preempt a task on same tree. (May be
> > that's what you want for your use case). But it is still odd to add
> > additional properties only for groups and not tasks.
> 
> You raise a good point about hierarchy.  We'd like to use Gui's
> hierarchy patches or similar functionality.  As you point out there is
> currently an asymmetry between groups and tasks.  Tasks can be RT, but
> groups cannot.  This complicates the hierarchy implementation.
> 
> How about adding a blkio.class and blkio.class_device interface to a
> truly RT service class?  This class would be able to starve a BE class
> (thus be more like the traditional RT/BE divide), and could be
> implemented similarly to RT/BE cfqqs today.  This way groups and
> queues could easily be scheduled as peers.

I think defining blkio.class and coming up with RT and IDLE (if needed)
groups separately makes sense to me. So in cfqd we can define a news
service tree where RT groups get queued up. Once hierarchical
implementation happens, RT queue and RT group entities will go on a
single tree.

[..]
> >> Is there a plan to provide RT class for groups in the hierarchical
> >> future to allow full symmetry with RT tasks?
> 
> I'm still interested in the answer to this question.  If there's
> currently no plan, is there at least an interest in seeing an
> implementation?

This is one of the possible expansions I have in mind. Just that I did
not plan to do it immediaely as I did not have any immediate need. So
feel free to implement the notion of RT cfq groups.

[..]
> I'd like to provide the lowest possible latency to a single privileged
> group per disk.  At the same time, I need to be able to ensure that
> the privileged group isn't able to completely consume the throughput
> on the disk.  It will likely share that disk with system daemons and
> other "critical" functionality.  It's not important that those daemons
> get the same latency guarantees, but they must be guaranteed some disk
> time.
> 
> > If we really end up doing it, I think we shall have to define an
> > additional group file say, blkio.preempt_fair_share. This will mean
> > that this is a BE group but has additional property which allows it to
> > preempt existing entity on service tree as long as it does not exceed
> > it fair share. That way we don't have to define a new class or don't
> > have to come up with additional service tree.
> 
> I think I hear you objecting more to the name RT.  And that if we had
> this "limited preemption" functionality, it should be called by a
> different name.
> 

I think, it was combination of few things.

- Use of RT namespace.
- usage of blkio.class namespace
- Assymetry between task and group properties

So 1 and 2 can be easily fixed by using a different name.
say blkio_preempt_fair_share. The only remaining issue will be  3rd piece.

> > But I would prefer that you seriously consider implementing RT group class
> > and rate limit it with throttling logic. Because I believe it should solve
> > your issue. Only question would be what should be upper limit and I think
> > that will depend on type of storage your are using and what's your
> > workload.
> >
> > Also if you can give a better example where this kind of latency matters,
> > it will help to understand the problem better.
> 
> The general problem is that a distributed system is generally made up
> of multiple machines, and that any significant operation against that
> system will involved multiple machines.  The response to any external
> request will likely be determined by the sum of the latencies of the
> components.  So I want to reduce the latency on a single drive as much
> as possible.
> 
> This thread is getting tangled.  I see a few options:
> 
>   a) Pursue the functionality in my original patchset with a different name.
>   b) Build a true RT class for groups and try with blk-throttle.
> 
> You seem pretty unenthusiastic about a).  How do you feel about b)?

IMHO, Using RT group with throttling avoids introducing asymmetry between
task and group attributes. So I will prefer that approch. Though it means
more code as we will be introducing RT groups but that might be useful
in general for something else too. (I am assuming that somebody makes
use of RT class for cfqq).

The one more down side of trying to use throttling is that one needs to
come up with absolute limit. So one shall have to know disk capacity
and if there are no BE tasks running then latency sensitive task will
be unnecessarily throttled (until and unless some management software
can monitor it and change limit dynamically).

So if you are worried about setting the absolute limit part, then I guess
I am fine with option a). But if you think that setting absolute limit
is not a problem, then option b) is preferred.

Thanks
Vivek
