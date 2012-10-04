Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2JDL6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:58:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49244 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2JDL6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:58:52 -0400
Message-ID: <506D7922.1050108@parallels.com>
Date: Thu, 4 Oct 2012 15:55:14 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <50635F46.7000700@parallels.com> <20120926201629.GB20342@google.com> <50637298.2090904@parallels.com> <20120927120806.GA29104@dhcp22.suse.cz> <20120927143300.GA4251@mtj.dyndns.org> <20120927144307.GH3429@suse.de> <20120927145802.GC4251@mtj.dyndns.org> <50649B4C.8000208@parallels.com> <20120930082358.GG10383@mtj.dyndns.org> <50695817.2030201@parallels.com> <20121003225458.GE19248@localhost>
In-Reply-To: <20121003225458.GE19248@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 02:54 AM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Mon, Oct 01, 2012 at 12:45:11PM +0400, Glauber Costa wrote:
>>> where kmemcg_slab_idx is updated from sched notifier (or maybe add and
>>> use current->kmemcg_slab_idx?).  You would still need __GFP_* and
>>> in_interrupt() tests but current->mm and PF_KTHREAD tests can be
>>> rolled into index selection.
>>
>> How big would this array be? there can be a lot more kmem_caches than
>> there are memcgs. That is why it is done from memcg side.
> 
> The total number of memcgs are pretty limited due to the ID thing,
> right?  And kmemcg is only applied to subset of caches.  I don't think
> the array size would be a problem in terms of memory overhead, would
> it?  If so, RCU synchronize and dynamically grow them?
> 
> Thanks.
> 

I don't want to assume the number of memcgs will always be that limited.
Sure, the ID limitation sounds pretty much a big one, but people doing
VMs usually want to stack as many VMs as they possibly can in an
environment, and the less things preventing that from happening, the better.

That said, now that I've experimented with this a bit, indexing from the
cache may have some advantages: it can get too complicated to propagate
new caches appearing to all memcgs that already in-flight. We don't have
this problem from the cache side, because instances of it are guaranteed
not to exist at this point by definition.

I don't want to bloat unrelated kmem_cache structures, so I can't embed
a memcg array in there: I would have to have a pointer to a memcg array
that gets assigned at first use. But if we don't want to have a static
number, as you and christoph already frowned upon heavily, we may have
to do that memcg side as well.

The array gets bigger, though, because it pretty much has to be enough
to accomodate all css_ids. Even now, they are more than the 400 I used
in this patchset. Not allocating all of them at once will lead to more
complication and pointer chasing in here.

I'll take a look at the alternatives today and tomorrow.
