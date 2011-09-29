Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1I2L5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:57:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:64832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab1I2L5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:57:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,460,1312182000"; 
   d="scan'208";a="56922052"
Date: Thu, 29 Sep 2011 19:57:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/18] writeback: dirty rate control
Message-ID: <20110929115712.GA18183@localhost>
References: <20110904015305.367445271@intel.com>
 <20110904020914.980576896@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904020914.980576896@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A minor fix to this patch.

While testing the fio mmap workload, bdi->dirty_ratelimit is observed
to be knocked down to 1 and then brought up high in regular intervals.

The showed up problem is, it took long delays to bring up
bdi->dirty_ratelimit due to the round-down problem of the below
task_ratelimit calculation: when dirty_ratelimit=1 and pos_ratio = 1.5,
the resulted task_ratelimit will be 1, which fooled stops the logic
from increasing dirty_ratelimit as long as pos_ratio < 2. The below
change (from round-down to round-up) can nicely fix this problem.

Thanks,
Fengguang
---

--- linux-next.orig/mm/page-writeback.c	2011-09-24 15:52:11.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-09-24 15:52:11.000000000 +0800
@@ -766,6 +766,7 @@ static void bdi_update_dirty_ratelimit(s
 	 */
 	task_ratelimit = (u64)dirty_ratelimit *
 					pos_ratio >> RATELIMIT_CALC_SHIFT;
+	task_ratelimit++; /* it helps rampup dirty_ratelimit from tiny values */
 
 	/*
 	 * A linear estimation of the "balanced" throttle rate. The theory is,
