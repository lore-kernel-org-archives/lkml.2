Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1KXCU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:20:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58014 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab1KXCU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:20:26 -0500
Message-ID: <4ECDAA55.1030102@cn.fujitsu.com>
Date: Thu, 24 Nov 2011 10:22:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: Re: [RFC][PATCH 0/3] impelemnt cgroup_(subsys)_disabled in generic.
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-24 10:20:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-24 10:20:05,
	Serialize complete at 2011-11-24 10:20:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
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
>    182,932,842,128 cycles                    #    0.000 GHz                     [33.33%]
>    192,711,643,877 instructions              #    1.05  insns per cycle         [49.99%]
>        761,483,416 cache-references                                             [49.98%]
>            159,908 cache-misses              #    0.021 % of all cache refs     [50.00%]
>     33,253,084,874 branches                                                     [33.34%]
>        109,796,792 branch-misses             #    0.33% of all branches         [33.34%]
> 
>       58.289265709 seconds time elapsed
> 
> (After patch)
>  Performance counter stats for './malloc 1':
> 
>    183,068,407,487 cycles                    #    0.000 GHz                     [33.33%]
>    191,834,248,678 instructions              #    1.05  insns per cycle         [50.00%]
>        798,635,028 cache-references                                             [49.98%]
>             95,562 cache-misses              #    0.012 % of all cache refs     [50.00%]
>     32,755,318,286 branches                                                     [33.34%]
>         77,774,624 branch-misses             #    0.24% of all branches         [33.34%]
> 
>       58.332356996 seconds time elapsed
> 
> There is no differece in 'time' ;) 
> But I got an impression that 'branch' score gets better in several tests.
> 
> Thanks,
> -Kame
> 
> P.S. maybe I can replace 'do_swap_account' with jump_label, too.
> 

The numbers sugguest using jump label is a win.

However I'm not quite convinced that we make it generic. The subsys.disabled flag
was introduced long ago for memcg, but yet it has no other users.

So maybe for now make use of jump label in memcg only? We probably still needs
a bit help from cgroup core, to provide a subsys->disable() callback.

--
Li Zefan
