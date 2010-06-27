Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0F0Leb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 07:34:31 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:56617 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab0F0Lea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 07:34:30 -0400
Date: Sun, 27 Jun 2010 13:34:23 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: recalculate lru_pages on each priority
Message-ID: <20100627113422.GA14504@cmpxchg.org>
References: <20100625181221.805A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625181221.805A.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 06:13:20PM +0900, KOSAKI Motohiro wrote:
> shrink_zones() need relatively long time. and lru_pages can be
> changed dramatically while shrink_zones().
> then, lru_pages need recalculate on each priority.

In the direct reclaim path, we bail out of that loop after
SWAP_CLUSTER_MAX reclaimed pages, so in this case, decreasing priority
levels actually mean we do _not_ make any progress and the total
number of lru pages should not change (much).  The possible distortion
in shrink_slab() is small.

However, for the suspend-to-disk case the reclaim target can be a lot
higher and we inevitably end up at higher priorities even though we
make progress, but fail to increase pressure on the shrinkers as well
without your patch.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
