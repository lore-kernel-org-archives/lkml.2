Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HAAnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:43:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:13725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1HAAnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:43:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,297,1309762800"; 
   d="scan'208";a="2848865"
Subject: Re: [PATCH] kswapd: avoid unnecessary rebalance after an
 unsuccessful balancing
From: "Alex,Shi" <alex.shi@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "P@draigBrady.com" <P@draigBrady.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrea@cpushare.com" <andrea@cpushare.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "riel@redhat.com" <riel@redhat.com>, "luto@mit.edu" <luto@mit.edu>
In-Reply-To: <20110729154031.GV3010@suse.de>
References: <1311952990-3844-1-git-send-email-alex.shi@intel.com>
	 <20110729154031.GV3010@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 08:45:17 +0800
Message-ID: <1312159517.27358.2446.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 23:40 +0800, Mel Gorman wrote:
> On Fri, Jul 29, 2011 at 11:23:10PM +0800, Alex Shi wrote:
> > In commit 215ddd66, Mel Gorman said kswapd is better to sleep after a
> > unsuccessful balancing if there is tighter reclaim request pending in
> > the balancing. In this scenario, the 'order' and 'classzone_idx'
> > that are checked for tighter request judgment is incorrect, since they
> > aren't the one kswapd should read from new pgdat, but the last time pgdat
> > value for just now balancing. Then kswapd will skip try_to_sleep func
> > and rebalance the last pgdat request. It's not our expected behavior.
> > 
> > So, I added new variables to distinguish the returned order/classzone_idx
> > from last balancing, that can resolved above issue in that scenario.
> > 
> 
> I'm afraid this changelog is very difficult to read and I do not see
> what problem you are trying to solve and I do not see what this patch
> might solve.
> 
> When balance_pgdat() returns with a lower classzone or order, the values
> stored in pgdat are not re-read and instead it tries to go to sleep
> based on the starting request. Something like;

Thanks for your comments, I will use this comments style next time, list
request A, B etc. 

> 
> 1. Read pgdat request A (classzone_idx, order)

Assume the order of A > 0, like is 3.

> 2. balance_pgdat()
> 3.	During pgdat, a new pgdat request B (classzone_idx, order) is placed
> 4. balance_pgdat() returns but failed so classzone_idx is lower

Another balance_pgdat() failure indicate is returned order == 0, am I
right?  If so, the next step of kswapd is not trying to sleep, but do
request A balance again.  And I thought this behavior doesn't match the
comments in kswapd. 

> 5. Try to sleep based on pgdat request A 

> 
> i.e. pgdat request B is not read and there is a comment explaining
> why pgdat request B is not read after balance_pgdat() fails.
> 
> This patch adds some variables that might improve the readability
> for some people but otherwise I can't see what problem is being
> fixed. What did I miss?
> 


