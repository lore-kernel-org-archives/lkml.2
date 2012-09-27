Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2I0Otu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:49:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65486 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2I0Otr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:49:47 -0400
Date: Thu, 27 Sep 2012 07:49:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120927144942.GB4251@mtj.dyndns.org>
References: <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <20120927142822.GG3429@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927142822.GG3429@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mel.

On Thu, Sep 27, 2012 at 03:28:22PM +0100, Mel Gorman wrote:
> > In addition, how is userland supposed to know which
> > workload is shared kmem heavy or not? 
> 
> By using a bit of common sense.
> 
> An application may not be able to figure this out but the administrator
> is going to be able to make a very educated guess. If processes running
> within two containers are not sharing a filesystem hierarchy for example
> then it'll be clear they are not sharing dentries.
> 
> If there was a suspicion they were then it could be analysed with
> something like SystemTap probing when files are opened and see if files
> are being opened that are shared between containers.
> 
> It's not super-easy but it's not impossible either and I fail to see why
> it's such a big deal for you.

Because we're not even trying to actually solve the problem but just
dumping it to userland.  If dentry/inode usage is the only case we're
being worried about, there can be better ways to solve it or at least
we should strive for that.

Also, the problem is not that it is impossible if you know and
carefully plan for things beforehand (that would be one extremely
competent admin) but that the problem is undiscoverable.  With kmemcg
accounting disabled, there's no way to tell a looking cgroup the admin
thinks running something which doesn'ft tax kmem much could be
generating a ton without the admin ever noticing.

> > The fact that the numbers don't really mean what they apparently
> > should mean.
> 
> I think it is a reasonable limitation that only some kernel allocations are
> accounted for although I'll freely admit I'm not a cgroup or memcg user
> either.
> 
> My understanding is that this comes down to cost -- accounting for the
> kernel memory usage is expensive so it is limited only to the allocations
> that are easy to abuse by an unprivileged process. Hence this is
> initially concerned with stack pages with dentries and TCP usage to
> follow in later patches.

I think the cost isn't too prohibitive considering it's already using
memcg.  Charging / uncharging happens only as pages enter and leave
slab caches and the hot path overhead is essentially single
indirection.  Glauber's benchmark seemed pretty reasonable to me and I
don't yet think that warrants exposing this subtle tree of
configuration.

> > Sure, conferences are useful for building consensus but that's the
> > extent of it.  Sorry that I didn't realize the implications then but
> > conferences don't really add any finality to decisions.
> > 
> > So, this seems properly crazy to me at the similar level of
> > use_hierarchy fiasco.  I'm gonna NACK on this.
> 
> I think you're over-reacting to say the very least :|

The part I nacked is enabling kmemcg on a populated cgroup and then
starting accounting from then without any apparent indication that any
past allocation hasn't been considered.  You end up with numbers which
nobody can't tell what they really mean and there's no mechanism to
guarantee any kind of ordering between populating the cgroup and
configuring it and there's *no* way to find out what happened
afterwards neither.  This is properly crazy and definitely deserves a
nack.

Thanks.

-- 
tejun
