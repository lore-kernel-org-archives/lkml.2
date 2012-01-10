Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2AIQlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:41:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:16646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab2AIQlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:41:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105119508"
Date: Tue, 10 Jan 2012 00:58:56 -0500
From: Youquan Song <youquan.song@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120110055856.GA23741@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com> <1326103578.2442.50.camel@twins> <20120110001445.GA20542@linux-youquan.bj.intel.com> <1326107156.2442.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326107156.2442.59.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note, this has the hard-coded assumption you only have 2 threads per
> core, which while true for intel, isn't true in general. I think you
> meant to write *= group->group_weight or somesuch.
> 
> Also, you forgot to limit this to the SD_SHARE_CPUPOWER domain, you're
> now doubling the capacity for all domains.
> 
> Furthermore, have a look at the SD_PREFER_SIBLING logic and make sure
> you're not fighting that.
> 
Thanks Peter! Here is the patch. 

-Youquan

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..4ada3e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3923,6 +3923,10 @@ static inline void update_sg_lb_stats(struct
sched_domain *sd,
                                                SCHED_POWER_SCALE);
        if (!sgs->group_capacity)
                sgs->group_capacity = fix_small_capacity(sd, group);
+
+       if (sched_smt_power_savings && !(sd->flags & SD_SHARE_CPUPOWER))
+               sgs->group_capacity = group->group_weight;
+
        sgs->group_weight = group->group_weight;

        if (sgs->group_capacity > sgs->sum_nr_running)
