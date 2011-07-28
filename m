Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1G1LMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:12:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1G1LMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:12:08 -0400
Date: Thu, 28 Jul 2011 12:12:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrea@cpushare.com" <andrea@cpushare.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
Message-ID: <20110728111203.GM3010@suse.de>
References: <1311840688-11388-1-git-send-email-alex.shi@intel.com>
 <20110728101943.GI3010@suse.de>
 <1311850029.27358.2408.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1311850029.27358.2408.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 06:47:09PM +0800, Alex,Shi wrote:
> On Thu, 2011-07-28 at 18:19 +0800, Mel Gorman wrote:
> > On Thu, Jul 28, 2011 at 04:11:28PM +0800, Alex Shi wrote:
> > > There 2 place to read pgdat in kswapd. One is return from a successful
> > > balance, another is waked up from sleeping. But the new_order and
> > > new_classzone_idx are not assigned after kswapd_try_to_sleep(), that
> > > will cause a bug in the following scenario.
> > > 
> > > After the last time successful balance, kswapd goes to sleep. So the
> > > new_order and new_classzone_idx were assigned to 0 and MAX-1 since there
> > > is no new wakeup during last time balancing. Now, a new wakeup came and
> > > finish balancing successful with order > 0. But since new_order is still
> > > 0, this time successful balancing were judged as a failed balance. so,
> > > if there is another new wakeup coming during balancing, kswapd cann't
> > > read this and still want to try to sleep. And if the new wakeup is a
> > > tighter request, kswapd may goes to sleep, not to do balancing. That is
> > > incorrect.
> > > 
> > > So, to avoid above problem, the new_order and new_classzone_idx need to
> > > be assigned for later successful comparison.
> > > 
> > 
> > Other than a different changelog, this is identical to
> > https://lkml.org/lkml/2011/6/30/157 so
> 
> Oops, I didn't aware this, otherwise it will save me several hours to
> explain what the problem in current code to Shaohua and others. :) 

Sorry for wasting your time.

> In fact, I still hold another patch of kswapd and some idea of how to
> kswapd working that want to talk with you.
> 

Post to linux-mm, cc me.

> > Acked-by: Mel Gorman <mgorman@suse.de>
> > 
> > It won't be merged to -stable until it goes to mainline though so
> > minimally you need to post this to linux-mm.
> > 
> > For -stable, you should explain why it is a candidate. I didn't push
> > the patch at the time because user problems were already resolved
> > and I wanted the merged for 3.0 before revisiting it. What problem
> > did you observe without this patch? With the lack of reference to
> > the other thread or the previous patch, I'm assuming you found and
> > solved the problem independently and I'd like to add a test case.
> 
> Actually, our LKP testing didn't find this problem on this point. Even
> with the patch, performance has no change on our machines. I just find
> this by my eyes. 
> 

Dang. I figured all right that it was unlikely the patch would
actually fix any problem but it looks correct and shouldnt' cause a
regression. You should resend the patch to Andrew cc'ing the people
in the old thread and linux-mm and ask Padraig Brady to test the
patch to confirm his problem does not reappear. When it gets into
mainline, try for -stable but I think there is very little motivation
for merging it there.

> BTW, I have tracked our benchmarks for their hot path in kernel. The
> most exercised benchmark on kswapd is no more than 5% of system load.
> that is fio mmap rand write or randrw. 
> 
> Do you have some benchmark can use kswapd much? 
> 

Not excessively. Except in cases where kswapd is buggy, I don't remember
many cases where it gets very far over 9% . I'll dig through old results
later today or tomorrow and double check.

> BTW, our project http://kernel-perf.sourceforge.net/ 

Thanks.

-- 
Mel Gorman
SUSE Labs
