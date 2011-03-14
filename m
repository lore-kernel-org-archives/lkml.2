Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1CNWLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab1CNWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:11:42 -0400
Date: Mon, 14 Mar 2011 18:11:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add unaccounted time to timeslice_used.
Message-ID: <20110314221138.GH31120@redhat.com>
References: <1299877572-30353-1-git-send-email-teravest@google.com>
 <20110314135516.GA31120@redhat.com>
 <AANLkTi=UwYRUkZ4WjqU3eiFcnmW4KnnB4xNBanopip9S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=UwYRUkZ4WjqU3eiFcnmW4KnnB4xNBanopip9S@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 02:55:27PM -0700, Justin TerAvest wrote:
> On Mon, Mar 14, 2011 at 6:55 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Mar 11, 2011 at 01:06:12PM -0800, Justin TerAvest wrote:
> >> There are two kind of times that tasks are not charged for: the first
> >> seek and the extra time slice used over the allocated timeslice. Both
> >> of these exported as a new unaccounted_time stat.
> >>
> >> I think it would be good to have this reported in 'time' as well, but
> >> that is probably a separate discussion.
> >>
> >
> > Justin,
> >
> > I would say that for such optimization do make sure that you mention that
> > these are useful only if one is driving a queue depth of 1.
> 
> Hi Vivek,
> 
> That's a good point. I should have mentioned that.
> 
> >
> > Otherwise previous queue might have dumped bunch of requests in device
> > and expired. Now new queue's first request completion time is also
> > impacted by the requests dumped by other queues.
> >
> > There are already so many stats which I have never used so far and I have
> > not encountered anybody else using these either. I think primary reason
> > being that in general nobody forced the queue depth of 1 hence most of the
> > timing stats are of no use.
> 
> We could probably put the data collected here back into "time"
> eventually, but having it separate right now helps build confidence in
> the accuracy of the stats.

Again putting it into time will make sense only if request queue depth
is 1. So you shall have to keep track whether we are driving queue
depth 1 or not and then add the data accordingly.

In fact, instead of adding a new file for unaccounted_time, I think a
better idea would be (as you said), that add it to "time" if we are
driving queue depth 1. In that case "unaccounted_time" can at max be
a debugging feature and can be moved under #CONFIG_DEBUG_BLK_CGROUP or
get rid of unaccounted_time entirely.

Jens what do you think?

I really would prefer avoiding another stat file until and unless it is really
useful.

> 
> >
> > So personally I am not very keen on keep on increasing number of stats in
> > CFQ which are useful only when using queue depth 1 as that might not be
> > the common case. But Jens likes it, so....
> >
> > Also a comment inline.
> >
> > [..]
> >> @@ -3314,9 +3321,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >>       BUG_ON(!cfq_cfqq_on_rr(cfqq));
> >>
> >>       cfq_service_tree_add(cfqd, cfqq, 1);
> >> -
> >> -     cfqq->slice_end = 0;
> >> -     cfq_mark_cfqq_slice_new(cfqq);
> >> +     __cfq_set_active_queue(cfqd, cfqq);
> >
> > So far a new queue selection was always in select_queue(). Now this will
> > change it and new queue selection will also take place in
> > cfq_preempt_queue().
> >
> > Also I think this is not right. It is not necessary that we select the
> > preempting queue. For example a sync queue in one group can preempt the
> > async in root group but it might happen that we still select again
> > the root group's sync queue for dispatch.
> >
> > So queue selection logic should be driven by select_queue() which selects
> > group first then workload with-in group and then queue with-in workload
> > and we shoud not be setting active queue here.
> 
> That sounds reasonable. I will send out another version of the patch
> that will only clear the stats for the cfqq.

I think Jens already committed this version of patch. So please general
an incremental patch on top of his for-2.6.39/core branch.

Thanks
Vivek
