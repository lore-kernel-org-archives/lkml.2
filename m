Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab1EPUmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:42:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22882 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab1EPUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uWZxbTfA6z6TPzS9MhTXSzJKkci1RkyAHHrjSX5m7Q/Rlexrdb3QDWR1XiGsBrxrtx
         9gHU7s5pogZku16Y+mvQ==
Date: Mon, 16 May 2011 13:42:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Minchan Kim <minchan.kim@gmail.com>, CAI Qian <caiqian@redhat.com>,
        avagin@gmail.com, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes
 memory (was Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable())
In-Reply-To: <4DCD1027.70408@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105161336500.4353@chino.kir.corp.google.com>
References: <1889981320.330808.1305081044822.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <alpine.DEB.2.00.1105111331480.9346@chino.kir.corp.google.com> <BANLkTi=fNtPZQk5Mp7rbZJFpA1tzBh+VcA@mail.gmail.com> <alpine.DEB.2.00.1105121229150.2407@chino.kir.corp.google.com>
 <BANLkTikJvT8BmfvMeyL8MAyww3Gdgm3kPA@mail.gmail.com> <4DCD1027.70408@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, KOSAKI Motohiro wrote:

> > > Yes, I'm sure we'll still have additional discussion when KOSAKI-san
> > > replies to my review of his patchset, so this quick patch was written only
> > > for CAI's testing at this point.
> > > 
> > > In reference to the above, I think that giving root processes a 3% bonus
> > > at all times may be a bit aggressive.  As mentioned before, I don't think
> > > that all root processes using 4% of memory and the remainder of system
> > > threads are using 1% should all be considered equal.  At the same time, I
> > > do not believe that two threads using 50% of memory should be considered
> > > equal if one is root and one is not.  So my idea was to discount 1% for
> > > every 30% of memory that a root process uses rather than a strict 3%.
> > > 
> > > That change can be debated and I think we'll probably settle on something
> > > more aggressive like 1% for every 10% of memory used since oom scores are
> > > only useful in comparison to other oom scores: in the above scenario where
> > > there are two threads, one by root and one not by root, using 50% of
> > > memory each, I think it would be legitimate to give the root task a 5%
> > > bonus so that it would only be selected if no other threads used more than
> > > 44% of memory (even though the root thread is truly using 50%).
> > > 
> > > This is a heuristic within the oom killer badness scoring that can always
> > > be debated back and forth, but I think a 1% bonus for root processes for
> > > every 10% of memory used is plausible.
> > > 
> > > Comments?
> > 
> > Yes. Tend to agree.
> > Apparently, absolute 3% bonus is a problem in CAI's case.
> > 
> > Your approach which makes bonus with function of rss is consistent
> > with current OOM heuristic.
> > So In consistency POV, I like it as it could help deterministic OOM policy.
> > 
> > About 30% or 10% things, I think it's hard to define a ideal magic
> > value for handling for whole workloads.
> > It would be very arguable. So we might need some standard method to
> > measure it/or redhat/suse peoples. Anyway, I don't want to argue it
> > until we get a number.
> 
> I have small comments. 1) typical system have some small size system daemon
> 2) David's points -= 100 * (points / 3000); line doesn't make any bonus if
> points is less than 3000.

With the 1% bonus per 10% memory consumption, it would be

	points -= 100 * (points / 1000);

instead.  So, yes, this wouldn't give any bonus for root tasks that use 
10% of allowed memory or less.

> Zero root bonus is really desired? It may lead to
> kill system daemon at first issue.

I would think of it this way: if a root task is using 9% of available 
memory and that happens to be the largest consumer of memory, then it 
makes sense to kill it instead of killing other smaller non-root tasks.  
The 3% bonus would have killed the task if all other threads are using 6% 
or less, this just allows them to use 2% more memory now.

On the other hand, if a root task is using 50% of available memory, then a 
45% non-root task would be sacrificed instead.

Perhaps we need to be more aggressive and give more of a bonus to root 
tasks?
