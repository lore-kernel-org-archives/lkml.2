Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2I3IsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:48:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44968 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2I3Ir5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:47:57 -0400
Date: Sun, 30 Sep 2012 17:47:50 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120930084750.GI10383@mtj.dyndns.org>
References: <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927150950.GG29104@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927150950.GG29104@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Sep 27, 2012 at 05:09:50PM +0200, Michal Hocko wrote:
> On Thu 27-09-12 07:33:00, Tejun Heo wrote:
> > I'm not too convinced.  First of all, the overhead added by kmemcg
> > isn't big. 
> 
> You are probably talking about memory overhead which is indeed not that
> big (except for possible side effects as fragmentation which you mention
> bellow). But the runtime overhead is present, as far as I understand from
> what Glauber said. But, on the other hand, it is fair to say that those
> who _want_ use the feature should pay for it.

Yeah, as long as the overhead is reasonable and it doesn't affect
non-users, I think we should put more emphasis on simplicity.  cgroup
is pretty hairy (from both implementation and interface POVs) to begin
with.  Unfortunately, what's reasonable or how much more emphasis
varies widely depending on who one asks.

> > The hot path overhead is quite minimal - it doesn't do much more than
> > indirecting one more time.  In terms of memory usage, it sure could
> > lead to a bit more fragmentation but even if it gets to several megs
> > per cgroup, I don't think that's something excessive.  So, there is
> > overhead but I don't believe it to be prohibitive.
> 
> Remember that users do not want to pay even "something minimal" when the
> feature is not needed.

Yeah but, if we can get it down to, say, around 1% under most
workloads for memcg users, it is quite questionable to introduce full
hierarchical configuration to allow avoiding that, isn't it?

> > The distinction between "trusted" and "untrusted" is something
> > artificially created due to the assumed deficiency of kmemcg
> > implementation.  
> 
> Not really. It doesn't have to do anything with the overhead (be it
> memory or runtime). It really boils down to "do I need/want it at all".
> Why would I want to think about how much kernel memory is in use in the
> first place? Or do you think that user memory accounting should be
> deprecated?

But you can apply the same "do I need/want it at all" question to the
configuration parameter too.  I can see your point but the decision
seems muddy to me, and if muddy, I prefer to err on the side of being
too conservative.

> > This is userland visible API.  
> 
> I am not sure which API visible part you have in mind but
> kmem.limit_in_bytes will be there whether we go with global knob or "no
> limit no accounting" approach. 

I mean full hierarchical configuration of it.  It becomes something
which each memcg user cares about instead of something which the base
system / admin flips on system boot.

> > We can always expand the flexibility.  Let's do the simple thing
> > first.  As an added bonus, it would enable using static_keys for
> > accounting branches too.
> 
> While I do agree with you in general and being careful is at place in
> this area as time shown several times, this seems to be too restrictive
> in this particular case.
> We won't save almost no code with the global knob so I am not sure
> what we are actually saving here. Global knob will just give us all or
> nothing semantic without making the whole thing simpler. You will stick
> with static branches and checkes whether the group accountable anyway,
> right?

The thing is about the same argument can be made about .use_hierarchy
too.  It doesn't necessarily make the code much harier.  Especially
because the code is structured with that feature on mind, removing
.use_hierarchy might not remove whole lot of code; however, the wider
range of behavior which got exposed through that poses a much larger
problem when we try to make modifications on related behaviors.  We
get a lot more locked down by seemingly not too much code and our long
term maintainability / sustainability suffers as a result.

I'm not trying to say this is as bad as .use_hierarchy but want to
point out that memcg and cgroup in general have had pretty strong
tendency to choose overly flexible and complex designs and interfaces
and it's probably about time we become more careful especially about
stuff which is visible to userland.

Thanks.

-- 
tejun
