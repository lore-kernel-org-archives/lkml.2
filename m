Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab1KWI3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:29:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56850 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1KWI3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:29:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Nov 2011 17:28:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: cgroups@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: [RFC][PATCH 0/3] impelemnt cgroup_(subsys)_disabled in generic.
Message-Id: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, memory cgroup has 'mem_cgroup_disabled()' in memcontrol.h

I made a brief trial to use static_branch() for that function. At doing that,
I thought it will be better to implement generic cgroup functions rather
than having memory cgroup's its own one.

This series consists of 3 patches
1 .... implement cgroup_xxxx_disabled() in generic.
2 .... use jump_label for cgroup_xxxx_disabled()
3 .... remove mem_cgroup_disabled() in memcontrol.c

And I post this series for getting review/comments.
I'm not sure patches for using jump_label is worth to be merged.

I did a test to run a loop
	while(-) {
		mmap(1M)
		touch all pages
		munmap()
	}

and measured performance score in ROOT cgroup. Here,

(Before patch)
   182,932,842,128 cycles                    #    0.000 GHz                     [33.33%]
   192,711,643,877 instructions              #    1.05  insns per cycle         [49.99%]
       761,483,416 cache-references                                             [49.98%]
           159,908 cache-misses              #    0.021 % of all cache refs     [50.00%]
    33,253,084,874 branches                                                     [33.34%]
       109,796,792 branch-misses             #    0.33% of all branches         [33.34%]

      58.289265709 seconds time elapsed

(After patch)
 Performance counter stats for './malloc 1':

   183,068,407,487 cycles                    #    0.000 GHz                     [33.33%]
   191,834,248,678 instructions              #    1.05  insns per cycle         [50.00%]
       798,635,028 cache-references                                             [49.98%]
            95,562 cache-misses              #    0.012 % of all cache refs     [50.00%]
    32,755,318,286 branches                                                     [33.34%]
        77,774,624 branch-misses             #    0.24% of all branches         [33.34%]

      58.332356996 seconds time elapsed

There is no differece in 'time' ;) 
But I got an impression that 'branch' score gets better in several tests.

Thanks,
-Kame

P.S. maybe I can replace 'do_swap_account' with jump_label, too.



