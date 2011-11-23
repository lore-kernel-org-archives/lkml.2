Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1KWKdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:33:40 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40942 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab1KWKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:33:39 -0500
Message-ID: <4ECCCBDA.5060604@parallels.com>
Date: Wed, 23 Nov 2011 08:32:58 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: Re: [RFC][PATCH 0/3] impelemnt cgroup_(subsys)_disabled in generic.
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 06:28 AM, KAMEZAWA Hiroyuki wrote:
>
> Now, memory cgroup has 'mem_cgroup_disabled()' in memcontrol.h
>
> I made a brief trial to use static_branch() for that function. At doing that,
> I thought it will be better to implement generic cgroup functions rather
> than having memory cgroup's its own one.
>
> This series consists of 3 patches
> 1 .... implement cgroup_xxxx_disabled() in generic.
> 2 .... use jump_label for cgroup_xxxx_disabled()
> 3 .... remove mem_cgroup_disabled() in memcontrol.c
>
> And I post this series for getting review/comments.
> I'm not sure patches for using jump_label is worth to be merged.
>
> I did a test to run a loop
> 	while(-) {
> 		mmap(1M)
> 		touch all pages
> 		munmap()
> 	}
>
> and measured performance score in ROOT cgroup. Here,
>
> (Before patch)
>     182,932,842,128 cycles                    #    0.000 GHz                     [33.33%]
>     192,711,643,877 instructions              #    1.05  insns per cycle         [49.99%]
>         761,483,416 cache-references                                             [49.98%]
>             159,908 cache-misses              #    0.021 % of all cache refs     [50.00%]
>      33,253,084,874 branches                                                     [33.34%]
>         109,796,792 branch-misses             #    0.33% of all branches         [33.34%]
>
>        58.289265709 seconds time elapsed
>
> (After patch)
>   Performance counter stats for './malloc 1':
>
>     183,068,407,487 cycles                    #    0.000 GHz                     [33.33%]
>     191,834,248,678 instructions              #    1.05  insns per cycle         [50.00%]
>         798,635,028 cache-references                                             [49.98%]
>              95,562 cache-misses              #    0.012 % of all cache refs     [50.00%]
>      32,755,318,286 branches                                                     [33.34%]
>          77,774,624 branch-misses             #    0.24% of all branches         [33.34%]
>
>        58.332356996 seconds time elapsed
>
> There is no differece in 'time' ;)
> But I got an impression that 'branch' score gets better in several tests.
>

branch and cache misses are a lot smaller as well. I think this is a win.

