Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2LKPCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:02:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab2LKPCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:02:46 -0500
Date: Tue, 11 Dec 2012 10:02:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Zhao Shuai <zhaoshuai@freebsd.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: performance drop after using blkcg
Message-ID: <20121211150234.GC5580@redhat.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211144718.GF7084@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 06:47:18AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, Dec 11, 2012 at 09:43:36AM -0500, Vivek Goyal wrote:
> > I think if one sets slice_idle=0 and group_idle=0 in CFQ, for all practical
> > purposes it should become and IOPS based group scheduling.
> 
> No, I don't think it is.  You can't achieve isolation without idling
> between group switches.  We're measuring slices in terms of iops but
> what cfq actually schedules are still time slices, not IOs.

I think I have not been able to understand your proposal. Can you explain
a bit more.

This is what CFQ does in iops_mode(). It will calculate the number of
requests dispatched from a group and scale that number based on weight
and put the group back on service tree. So if you have not got your
fair share in terms of number of requests dispatched to the device,
you will be put ahead in the queue and given a chance to dispatch 
requests first. 

Now couple of things.

- There is no idling here. If device is asking for more requests (deep
  queue depth) then this group will be removed from service tree and
  CFQ will move on to serve other queued group. So if there is a dependent
  reader it will lose its share.

  If we try to idle here, then we have solved nothing in terms of
  performance problems.  Device is faster but your workload can't cope
  with it so you are artificially slowing down the device.

- But if all the contending workloads/groups are throwing enough IO
  traffic on the device and don't get expired, they they should be able
  to dispatch number of requests to device in proportion to their weight.

So this is effectively trying to keep track of number of reqeusts
dispatched from the group instead of time slice consumed by group and
then do the scheduling.

cfq_group_served() {
        if (iops_mode(cfqd))
                charge = cfqq->slice_dispatch;
	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
}

Isn't it effectively IOPS scheduling. One should get IOPS rate in proportion to
their weight (as long as they can throw enough traffic at device to keep
it busy). If not, can you please give more details about your proposal.

Thanks
Vivek
