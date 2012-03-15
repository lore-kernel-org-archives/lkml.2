Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390Ab2COL0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:26:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56910 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760982Ab2COL0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:26:04 -0400
Message-ID: <4F61D167.4000402@parallels.com>
Date: Thu, 15 Mar 2012 15:24:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizf@cn.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC REPOST] cgroup: removing css reference drain wait during
 cgroup removal
References: <20120312213155.GE23255@google.com> <20120312213343.GF23255@google.com> <20120313151148.f8004a00.kamezawa.hiroyu@jp.fujitsu.com> <20120313163914.GD7349@google.com> <20120314092828.3321731c.kamezawa.hiroyu@jp.fujitsu.com> <4F6068F4.4090909@parallels.com> <4F6134E1.5090601@jp.fujitsu.com>
In-Reply-To: <4F6134E1.5090601@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 04:16 AM, KAMEZAWA Hiroyuki wrote:
> (2012/03/14 18:46), Glauber Costa wrote:
>
>> On 03/14/2012 04:28 AM, KAMEZAWA Hiroyuki wrote:
>>> IIUC, in general, even in the processes are in a tree, in major case
>>> of servers, their workloads are independent.
>>> I think FLAT mode is the dafault. 'heararchical' is a crazy thing which
>>> cannot be managed.
>>
>> Better pay attention to the current overall cgroups discussions being
>> held by Tejun then. ([RFD] cgroup: about multiple hierarchies)
>>
>> The topic of whether of adapting all cgroups to be hierarchical by
>> deafult is a recurring one.
>>
>> I personally think that it is not unachievable to make res_counters
>> cheaper, therefore making this less of a problem.
>>
>
>
> I thought of this a little yesterday. Current my idea is applying following
> rule for res_counter.
>
> 1. All res_counter is hierarchical. But behavior should be optimized.
>
> 2. If parent res_counter has UNLIMITED limit, 'usage' will not be propagated
>    to its parent at _charge_.

That doesn't seem to make much sense. If you are unlimited, but your 
parent is limited,
he has a lot more interest to know about the charge than you do. So the 
logic should rather be the opposite: Don't go around getting locks and 
all that if you are unlimited. Your parent might, though.

I am trying to experiment a bit with billing to percpu counters for 
unlimited res_counters. But their inexact nature is giving me quite a 
headache.

> 3. If a res_counter has UNLIMITED limit, at reading usage, it must visit
>     all children and returns a sum of them.
>
> Then,
> 	/cgroup/
> 		memory/                       (unlimited)
> 			libivirt/             (unlimited)
> 				 qeumu/       (unlimited)
> 				        guest/(limited)
>
> All dir can show hierarchical usage and the guest will not have
> any lock contention at runtime.

If we are okay with summing it up at read time, we may as well
keep everything in percpu counters at all times.
>
> By this
>   1. no runtime overhead if the parent has unlimited limit.
>   2. All res_counter can show aggregate resource usage of children.
>
> To do this
>   1. res_coutner should have children list by itself.
>
> Implementation problem
>   - What should happens when a user set new limit to a res_counter which have
>     childrens ? Shouldn't we allow it ? Or take all locks of children and
>     update in atomic ?
Well, increasing the limit should be always possible.

As for the kids, how about:

- ) Take their locks
- ) scan through them seeing if their usage is bellow the new allowance
     -) if it is, then ok
     -) if it is not, then try to reclaim (*). Fail if it is not possible.

(*) May be hard to implement, because we already have the res_counter 
lock taken, and the code may get nasty. So maybe it is better just fail 
if any of your kids usage is over the new allowance...



>   - memory.use_hierarchy should be obsolete ?
If we're going fully hierarchical, yes.
