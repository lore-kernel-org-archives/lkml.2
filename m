Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1G1Kpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:45:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:12820 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1G1Kpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:45:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,281,1309762800"; 
   d="scan'208";a="35463146"
Subject: Re: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
From: "Alex,Shi" <alex.shi@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrea@cpushare.com" <andrea@cpushare.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <20110728101943.GI3010@suse.de>
References: <1311840688-11388-1-git-send-email-alex.shi@intel.com>
	 <20110728101943.GI3010@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 18:47:09 +0800
Message-ID: <1311850029.27358.2408.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 18:19 +0800, Mel Gorman wrote:
> On Thu, Jul 28, 2011 at 04:11:28PM +0800, Alex Shi wrote:
> > There 2 place to read pgdat in kswapd. One is return from a successful
> > balance, another is waked up from sleeping. But the new_order and
> > new_classzone_idx are not assigned after kswapd_try_to_sleep(), that
> > will cause a bug in the following scenario.
> > 
> > After the last time successful balance, kswapd goes to sleep. So the
> > new_order and new_classzone_idx were assigned to 0 and MAX-1 since there
> > is no new wakeup during last time balancing. Now, a new wakeup came and
> > finish balancing successful with order > 0. But since new_order is still
> > 0, this time successful balancing were judged as a failed balance. so,
> > if there is another new wakeup coming during balancing, kswapd cann't
> > read this and still want to try to sleep. And if the new wakeup is a
> > tighter request, kswapd may goes to sleep, not to do balancing. That is
> > incorrect.
> > 
> > So, to avoid above problem, the new_order and new_classzone_idx need to
> > be assigned for later successful comparison.
> > 
> 
> Other than a different changelog, this is identical to
> https://lkml.org/lkml/2011/6/30/157 so

Oops, I didn't aware this, otherwise it will save me several hours to
explain what the problem in current code to Shaohua and others. :) 
In fact, I still hold another patch of kswapd and some idea of how to
kswapd working that want to talk with you.

> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 
> It won't be merged to -stable until it goes to mainline though so
> minimally you need to post this to linux-mm.
> 
> For -stable, you should explain why it is a candidate. I didn't push
> the patch at the time because user problems were already resolved
> and I wanted the merged for 3.0 before revisiting it. What problem
> did you observe without this patch? With the lack of reference to
> the other thread or the previous patch, I'm assuming you found and
> solved the problem independently and I'd like to add a test case.

Actually, our LKP testing didn't find this problem on this point. Even
with the patch, performance has no change on our machines. I just find
this by my eyes. 

BTW, I have tracked our benchmarks for their hot path in kernel. The
most exercised benchmark on kswapd is no more than 5% of system load.
that is fio mmap rand write or randrw. 

Do you have some benchmark can use kswapd much? 

BTW, our project http://kernel-perf.sourceforge.net/ 
> 
> Thanks.
> 


