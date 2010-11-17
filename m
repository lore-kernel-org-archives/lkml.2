Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695Ab0KQOjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:39:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:38045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812Ab0KQOjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:39:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,211,1288594800"; 
   d="scan'208";a="349902964"
Date: Wed, 17 Nov 2010 22:39:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] writeback: per-task rate limit on
 balance_dirty_pages()
Message-ID: <20101117143903.GA11664@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042849.650810571@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117042849.650810571@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (pause == 0 && nr_dirty < background_thresh)
> +		current->nr_dirtied_pause = ratelimit_pages(bdi);
> +	else if (pause == 1)
> +		current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;

Sorry here is a bug fix for the above line, it's also pushed to the
git tree.

Thanks,
Fengguang
---
Subject: writeback: fix increasement of nr_dirtied_pause
Date: Wed Nov 17 22:31:26 CST 2010

Fix a bug that

	current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;

does not effectively increase nr_dirtied_pause when it's <= 32.
Thus nr_dirtied_pause may never grow up..

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2010-11-17 22:31:09.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-11-17 22:31:23.000000000 +0800
@@ -662,7 +662,7 @@ pause:
 	if (pause == 0 && nr_dirty < background_thresh)
 		current->nr_dirtied_pause = ratelimit_pages(bdi);
 	else if (pause == 1)
-		current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;
+		current->nr_dirtied_pause += current->nr_dirtied_pause / 32 + 1;
 	else if (pause >= HZ/10)
 		/*
 		 * when repeated, writing 1 page per 100ms on slow devices,
