Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2JAKMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:12:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40120 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab2JAKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:12:40 -0400
Message-ID: <50696BC5.8040808@parallels.com>
Date: Mon, 1 Oct 2012 14:09:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-7-git-send-email-glommer@parallels.com> <20120926155108.GE15801@dhcp22.suse.cz> <5064392D.5040707@parallels.com> <20120927134432.GE29104@dhcp22.suse.cz> <50658B3B.9020303@parallels.com> <20121001094846.GC8622@dhcp22.suse.cz>
In-Reply-To: <20121001094846.GC8622@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 01:48 PM, Michal Hocko wrote:
> On Fri 28-09-12 15:34:19, Glauber Costa wrote:
>> On 09/27/2012 05:44 PM, Michal Hocko wrote:
>>>>> the reference count aquired by mem_cgroup_get will still prevent the
>>>>> memcg from going away, no?
>>> Yes but you are outside of the rcu now and we usually do css_get before
>>> we rcu_unlock. mem_cgroup_get just makes sure the group doesn't get
>>> deallocated but it could be gone before you call it. Or I am just
>>> confused - these 2 levels of ref counting is really not nice.
>>>
>>> Anyway, I have just noticed that __mem_cgroup_try_charge does
>>> VM_BUG_ON(css_is_removed(&memcg->css)) on a given memcg so you should
>>> keep css ref count up as well.
>>>
>>
>> IIRC, css_get will prevent the cgroup directory from being removed.
>> Because some allocations are expected to outlive the cgroup, we
>> specifically don't want that.
> 
> Yes, but how do you guarantee that the above VM_BUG_ON doesn't trigger?
> Task could have been moved to another group between mem_cgroup_from_task
> and mem_cgroup_get, no?
> 

Ok, after reading this again (and again), you seem to be right. It
concerns me, however, that simply getting the css would lead us to a
double get/put pair, since try_charge will have to do it anyway.

I considered just letting try_charge selecting the memcg, but that is
not really what we want, since if that memcg will fail kmem allocations,
we simply won't issue try charge, but return early.

Any immediate suggestions on how to handle this ?

