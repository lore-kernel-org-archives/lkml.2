Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2I0SeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:34:16 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48145 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab2I0SeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:34:14 -0400
Message-ID: <50649B4C.8000208@parallels.com>
Date: Thu, 27 Sep 2012 22:30:36 +0400
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
References: <50634FC9.4090609@parallels.com> <20120926193417.GJ12544@google.com> <50635B9D.8020205@parallels.com> <20120926195648.GA20342@google.com> <50635F46.7000700@parallels.com> <20120926201629.GB20342@google.com> <50637298.2090904@parallels.com> <20120927120806.GA29104@dhcp22.suse.cz> <20120927143300.GA4251@mtj.dyndns.org> <20120927144307.GH3429@suse.de> <20120927145802.GC4251@mtj.dyndns.org>
In-Reply-To: <20120927145802.GC4251@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 06:58 PM, Tejun Heo wrote:
> Hello, Mel.
> 
> On Thu, Sep 27, 2012 at 03:43:07PM +0100, Mel Gorman wrote:
>>> I'm not too convinced.  First of all, the overhead added by kmemcg
>>> isn't big. 
>>
>> Really?
>>
>> If kmemcg was globally accounted then every __GFP_KMEMCG allocation in
>> the page allocator potentially ends up down in
>> __memcg_kmem_newpage_charge which
>>
>> 1. takes RCU read lock
>> 2. looks up cgroup from task
>> 3. takes a reference count
>> 4. memcg_charge_kmem -> __mem_cgroup_try_charge
>> 5. release reference count
>>
>> That's a *LOT* of work to incur for cgroups that do not care about kernel
>> accounting. This is why I thought it was reasonable that the kmem accounting
>> not be global.
> 
> But that happens only when pages enter and leave slab and if it still
> is significant, we can try to further optimize charging.  Given that
> this is only for cases where memcg is already in use and we provide a
> switch to disable it globally, I really don't think this warrants
> implementing fully hierarchy configuration.
> 

Not totally true. We still have to match every allocation to the right
cache, and that is actually our heaviest hit, responsible for the 2, 3 %
we're seeing when this is enabled. It is the kind of path so hot that
people frown upon branches being added, so I don't think we'll ever get
this close to being free.

