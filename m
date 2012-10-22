Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2JVMxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:53:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50307 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab2JVMxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:53:20 -0400
Message-ID: <50854199.9020804@parallels.com>
Date: Mon, 22 Oct 2012 16:52:41 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: David Rientjes <rientjes@google.com>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171515290.20712@chino.kir.corp.google.com> <507FCA90.8060307@parallels.com> <alpine.DEB.2.00.1210181454100.30894@chino.kir.corp.google.com> <5081269B.5000603@parallels.com> <alpine.DEB.2.00.1210191331400.17804@chino.kir.corp.google.com> <50853D47.4030409@parallels.com> <20121022125124.GA8344@dhcp22.suse.cz>
In-Reply-To: <20121022125124.GA8344@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 04:51 PM, Michal Hocko wrote:
> [Sorry for the late reply]
> 
> On Mon 22-10-12 16:34:15, Glauber Costa wrote:
>> On 10/20/2012 12:34 AM, David Rientjes wrote:
>>> On Fri, 19 Oct 2012, Glauber Costa wrote:
>>>
>>>>>>> What about gfp & __GFP_FS?
>>>>>>>
>>>>>>
>>>>>> Do you intend to prevent or allow OOM under that flag? I personally
>>>>>> think that anything that accepts to be OOM-killed should have GFP_WAIT
>>>>>> set, so that ought to be enough.
>>>>>>
>>>>>
>>>>> The oom killer in the page allocator cannot trigger without __GFP_FS 
>>>>> because direct reclaim has little chance of being very successful and 
>>>>> thus we end up needlessly killing processes, and that tends to happen 
>>>>> quite a bit if we dont check for it.  Seems like this would also happen 
>>>>> with memcg if mem_cgroup_reclaim() has a large probability of failing?
>>>>>
>>>>
>>>> I can indeed see tests for GFP_FS in some key locations in mm/ before
>>>> calling the OOM Killer.
>>>>
>>>> Should I test for GFP_IO as well?
>>>
>>> It's not really necessary, if __GFP_IO isn't set then it wouldn't make 
>>> sense for __GFP_FS to be set.
>>>
>>>> If the idea is preventing OOM to
>>>> trigger for allocations that can write their pages back, how would you
>>>> feel about the following test:
>>>>
>>>> may_oom = (gfp & GFP_KERNEL) && !(gfp & __GFP_NORETRY) ?
>>>>
>>>
>>> I would simply copy the logic from the page allocator and only trigger oom 
>>> for __GFP_FS and !__GFP_NORETRY.
>>>
>>
>> That seems reasonable to me. Michal ?
> 
> Yes it makes sense to be consistent with the global case. While we are
> at it, do we need to consider PF_DUMPCORE resp. !__GFP_NOFAIL?
> 
at least from kmem, GFP_NOFAIL will not reach this codepath. We will
ditch it to the root in memcontrol.h

