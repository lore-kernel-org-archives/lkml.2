Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1ALNJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:09:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab1ALNJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pFOnpt6yd2PhqH+aWSjOIbK3aA44HYR74v2RBG+REv0Ij6Qv/90tjWe4A2l2q/IvcE
         9Om/WEjljAitQRoApC2qaJ4CsynZ2clBMKgUcKJ8A/u888ERh/21iDBcUM+y/7zMz/6X
         9RunLk1Agnuf2KeaX/O+p3GxnPmAMC8POWDxk=
Date: Wed, 12 Jan 2011 14:08:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Screwing with the concurrency limit
Message-ID: <20110112130831.GA10920@mtj.dyndns.org>
References: <4D287AED.9090304@gmail.com>
 <20110108161840.GC13269@mtj.dyndns.org>
 <20110108163733.GD13269@mtj.dyndns.org>
 <iga94g$hkf$1@dough.gmane.org>
 <20110109144154.GA22453@mtj.dyndns.org>
 <4D2CB1B1.10102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2CB1B1.10102@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 11, 2011 at 11:38:25AM -0800, Kent Overstreet wrote:
> >Can you please explain the use case a bit more?  Is something per-cpu?
> >ie. Are your write locks per-cpu?  How frequent do you expect the
> >write locking to be?  I think adjusting max_active per-cpu should be
> >doable but I'd rather stay away from that.
> 
> Hm, I must not be explaining myself very well.

Heh, you were doing just fine.  I was inbetween flights so I probably
was the one to blame.  I don't believe we're misunderstanding the
problem but we are talking about approaches from the opposite
directions.

> Forget about the write locks for the moment.
> 
> So, high rate of work items, latency sensitive and _usually_ execute
> without blocking.
> 
> We would like a concurrency limit of 1 when they don't block -
> otherwise we're just scheduling for no reason. But sometimes they do
> block, and it's impossible to know whether they will or won't ahead
> of time.

Might be a bit of tangent but cmwq is aimed at minimizing scheduling
unless necessary to maintain execution bandwidth, so its users
shouldn't usually be concerned about that.

> That's the catch, if we have to block and we have a concurrency
> limit of 1, we've got latency sensitive jobs queued on this CPU that
> are waiting around for no reason.
> 
> The write locks are the reason the concurrency limit pretty much has
> to be 1, because if it's not we'll sometimes just be trying to
> execute everything pointlessly.

But the situation is different here and there's this quite disruptive
condition where the usual behavior doesn't result in a very desirable
outcome.

> So I'm trying to have my cake and eat it to. If a work item is
> executing, right before it blocks on IO it would like to do
> something to say "hey, start running whatever is available for this
> cpu". And it's only blocking the other work items on the cpu it's
> on, that's why I suggested adjusting only the local max_active.

Yeap, understood.  I just think it would be better to approach it from
the other direction.  Instead of trying to micro manage concurrency in
hot paths, I think it would be better to somehow communicate the
exceptional condition above to the workqueue code.  Another thing to
consider is that marking those exceptional conditions is necessary for
other purposes too and already in use, so I'd like to head that way
instead of introducing something completely different.

> >>What I was really hoping for was something like... maybe
> >>move_work_to_workqueue() - if you could do that on the work item
> >>you're executing, move it from the workqueue that has max_active = 1
> >>to a different one - it's stateless from the caller's perspective.
> >
> >I don't think that's gonna be a good idea.  It's too specialized
> >soultion which is likely to bite our asses down the road.
> 
> Well, I'm hoping I figure out the right way to convey what I'm
> trying to do, because I don't _think_ it's actually as specialized
> as it sounds. But as far as keeping the code sane, I agree with you
> there.

I don't know.  In this case, you might know that you will sleep but
that usually isn't a piece of information usually available until you
actually sleep.  A lot of sleep conditions are buried deeply under
various APIs which might sleep (memory allocation, competing on
resources which may be shared with various different users and so on).
So, the schedule() itself is the only reliable indication that we're
gonna lose execution concurrency and that is what cmwq implements.
I'm not (yet) quite convinced extending micro control upwards is a
good idea.

So, can you please explain a bit more about your use case?  How often
do you expect the write operations would be?  Maybe we can implement a
per-workqueue inhibit hint if the existing max_active adjustment is
insufficient or too expensive.  If the micro management from API users
is the only way to go, maybe we'll go there but let's talk about it
first.

Thanks.

-- 
tejun
