Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2IQRVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:21:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2IQRV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:21:29 -0400
Date: Mon, 17 Sep 2012 10:21:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120917172123.GB18677@google.com>
References: <20120913205827.GO7677@google.com>
 <5052E7DF.7040000@parallels.com>
 <20120914174329.GD17747@google.com>
 <5056E467.2090108@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5056E467.2090108@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Mon, Sep 17, 2012 at 12:50:47PM +0400, Glauber Costa wrote:
> > Can you be a bit more specific?
>
> What I mean is that if some operation needs to operate locked, they will
> have to lock. Whether or not the locking is called from cgroup core or
> not. If the lock is not available outside, people will end up calling a
> core function that locks.

I was asking whether you have certain specific operations on mind.

> >> And the problem is that people need to lock. cgroup_lock is needed
> >> because the data you are accessing is protected by it. The way I see it,
> >> it is incredible how we were able to revive the BKL in the form of
> >> cgroup_lock after we finally manage to successfully get rid of it!
> > 
> > I wouldn't go as far as comparing it to BKL.
>
> Of course not, since it is not system-wide. But I think the comparison
> still holds in spirit...

Subsystem-wide locks covering non-hot paths aren't evil things.  We
have a lot of them and they work fine.  BKL was a completely different
beast initially with implicit locking on kernel entry and unlocking on
sleeping and then got morphed into some chimera inbetween afterwards.

Simple locking is a good thing.  If finer-grained locking is
necessary, we sure do that but please stop throwing over-generalized
half-arguments at it.  It doesn't help anything.

> you seem to hear "comount", and think of unified vision, and that is the
> reason for this discussion to still be going on. Mounting is all about
> the root. And if you comount, hierarchies have the same root.
>
> In your example, the different controllers are comounted. They have not
> the same view, but the possible views are restricted to be a subset of
> the underlying tree - because they are mounted in the same place, forced
> or not.

Heh, I can't really tell whether you understand it or not.  Here and
in the previous thread too.  You seem to understand that there are
different views upto this point.

> In a situation like this, it makes all the sense in the world to use the
> css_id as a primary identifier, because it will be guaranteed to be the

And then you say something like this (or that this would remove
walking different hierarchies in the previous thread - yes, to a
certain point but not completely).  css_id is a per-css attribute.
How can that be the "primariy" identifier when there can be multiple
views?  For each userland-visible cgroup, there must be a css_set
which points to the css's belonging to it, which may not be at the
same level - multiple nodes in the userland visible tree may point to
the same css.

If you mean that css_id would be the primary identifier for that
specific controller's css, why even say that?  That's true now and
won't ever change.

> same. What makes the tree overly flexible, is that you can have multiple
> roots, starting in multiple places, with arbitrary topologies downwards.

And now you seem to be on the same page again.  But then again, you're
asserting that incorporating forced co-mounts *now* is a gradual step
towards the goal, which is utterly bonkers.  I don't know.  I just
can't understand what you're thinking at all.

Thanks.

-- 
tejun
