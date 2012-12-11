Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2LKQBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:01:45 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49927 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2LKQBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:01:44 -0500
Date: Tue, 11 Dec 2012 08:01:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhao Shuai <zhaoshuai@freebsd.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: performance drop after using blkcg
Message-ID: <20121211160137.GJ7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
 <20121211150234.GC5580@redhat.com>
 <20121211151412.GG7084@htj.dyndns.org>
 <20121211153725.GD5580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211153725.GD5580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Dec 11, 2012 at 10:37:25AM -0500, Vivek Goyal wrote:
> I have experimented with schemes like that but did not see any very
> promising resutls. Assume device supports queue depth of 128, and there
> is one dependent reader and one writer. If reader goes away and comes
> back and preempts low priority writer, in that small time window writer
> has dispatched enough requests to introduce read delays. So preemption
> helps only so much. I am curious to know how iops based scheduler solve
> these issues.  
> 
> Only way to provide effective isolation seemed to be idling and the
> moment we idle we kill the performance. It does not matter whether we
> are scheduling time or iops.

If the completion latency of IOs fluctuates heavily depend on queue
depth, queue depth would need to be throttled so that lower priority
queue can't overwhelm the device queue while prospect higher priority
accessors exist.  Another aspect is that devices are getting a lot
more consistent in terms of latency.

While idling would also solve isolation issue with unordered deep
device queue, it really is a solution for a rotational device with
large seek penalty as the time lost while idling can often/somtimes
made up by the save from lower seeks.  For non-rot devices with deep
queue, the right thing to do would be controlling queue depth or
propagate priority to the device queue (from what I hear, people are
working on it. dunno how well it would turn out tho).

> >  cfq is way too heavy and
> > ill-suited for high speed non-rot devices which are becoming more and
> > more consistent in terms of iops they can handle.
> > 
> > I think we need something better suited for the maturing non-rot
> > devices.  They're becoming very different from what cfq was built for
> > and we really shouldn't be maintaining several rb trees which need
> > full synchronization for each IO.  We're doing way too much and it
> > just isn't scalable.
> 
> I am fine with doing things differently in a different scheduler. But 
> what I am aruging here is that atleast with CFQ we should be able to
> experiment and figure out what works.  In CFQ all the code is there and
> if this iops based scheduling has merit, one should be able to quickly
> experiment and demonstrate how would one do things differently.
> 
> To me I have not been able to understand yet that what is iops based
> scheduling doing differently. Will we idle there or not. If we idle
> we again have performance problems.

When the device can do tens of thousands ios per sec, I don't think it
makes much sense to idle the device.  You just lose too much.

> So doing things out of CFQ is fine. I am only after understanding the
> technical idea which will solve the problem of provinding isolation
> as well as fairness without losing throughput. And I have not been
> able to get a hang of it yet.

I think it already has some aspect of it.  It has the half-iops mode
for a reason, right?  It just is very inefficient and way more complex
than it needs to be.

Thanks.

-- 
tejun
