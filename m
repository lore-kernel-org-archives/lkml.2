Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1G2Pki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:40:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1G2Pkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:40:36 -0400
Date: Fri, 29 Jul 2011 16:40:31 +0100
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@intel.com>
Cc: linux-mm@kvack.org, P@draigBrady.com, linux-kernel@vger.kernel.org,
        andrea@cpushare.com, tim.c.chen@intel.com, shaohua.li@intel.com,
        akpm@linux-foundation.org, riel@redhat.com, luto@mit.edu
Subject: Re: [PATCH] kswapd: avoid unnecessary rebalance after an
 unsuccessful balancing
Message-ID: <20110729154031.GV3010@suse.de>
References: <1311952990-3844-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1311952990-3844-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 11:23:10PM +0800, Alex Shi wrote:
> In commit 215ddd66, Mel Gorman said kswapd is better to sleep after a
> unsuccessful balancing if there is tighter reclaim request pending in
> the balancing. In this scenario, the 'order' and 'classzone_idx'
> that are checked for tighter request judgment is incorrect, since they
> aren't the one kswapd should read from new pgdat, but the last time pgdat
> value for just now balancing. Then kswapd will skip try_to_sleep func
> and rebalance the last pgdat request. It's not our expected behavior.
> 
> So, I added new variables to distinguish the returned order/classzone_idx
> from last balancing, that can resolved above issue in that scenario.
> 

I'm afraid this changelog is very difficult to read and I do not see
what problem you are trying to solve and I do not see what this patch
might solve.

When balance_pgdat() returns with a lower classzone or order, the values
stored in pgdat are not re-read and instead it tries to go to sleep
based on the starting request. Something like;

1. Read pgdat request A (classzone_idx, order)
2. balance_pgdat()
3.	During pgdat, a new pgdat request B (classzone_idx, order) is placed
4. balance_pgdat() returns but failed so classzone_idx is lower
5. Try to sleep based on pgdat request A

i.e. pgdat request B is not read and there is a comment explaining
why pgdat request B is not read after balance_pgdat() fails.

This patch adds some variables that might improve the readability
for some people but otherwise I can't see what problem is being
fixed. What did I miss?

-- 
Mel Gorman
SUSE Labs
