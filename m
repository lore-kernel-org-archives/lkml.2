Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2HOOCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:02:05 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33271 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab2HOOCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:02:04 -0400
Message-ID: <502BABCF.7020608@parallels.com>
Date: Wed, 15 Aug 2012 18:01:51 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <20120814172540.GD6905@dhcp22.suse.cz> <502B6F00.8040207@parallels.com> <20120815130952.GI23985@dhcp22.suse.cz>
In-Reply-To: <20120815130952.GI23985@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 05:09 PM, Michal Hocko wrote:
> On Wed 15-08-12 13:42:24, Glauber Costa wrote:
> [...]
>>>> +
>>>> +	ret = 0;
>>>> +
>>>> +	if (!memcg)
>>>> +		return ret;
>>>> +
>>>> +	_memcg = memcg;
>>>> +	ret = __mem_cgroup_try_charge(NULL, gfp, delta / PAGE_SIZE,
>>>> +	    &_memcg, may_oom);
>>>
>>> This is really dangerous because atomic allocation which seem to be
>>> possible could result in deadlocks because of the reclaim. 
>>
>> Can you elaborate on how this would happen?
> 
> Say you have an atomic allocation and we hit the limit so we get either
> to reclaim which can sleep or to oom which can sleep as well (depending
> on the oom_control).
> 

I see now, you seem to be right.

How about we change the following code in mem_cgroup_do_charge:

        if (gfp_mask & __GFP_NORETRY)
                return CHARGE_NOMEM;

to:

        if ((gfp_mask & __GFP_NORETRY) || (gfp_mask & __GFP_ATOMIC))
                return CHARGE_NOMEM;

?

Would this take care of the issue ?
