Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1BQWXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:23:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680Ab1BQWXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:23:04 -0500
Date: Thu, 17 Feb 2011 14:22:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        Kent Overstreet <kent.overstreet@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: Stop reclaim/compaction earlier due to
 insufficient progress if !__GFP_REPEAT
Message-Id: <20110217142209.8736cca1.akpm@linux-foundation.org>
In-Reply-To: <20110216095048.GA4473@csn.ul.ie>
References: <20110209154606.GJ27110@cmpxchg.org>
	<20110209164656.GA1063@csn.ul.ie>
	<20110209182846.GN3347@random.random>
	<20110210102109.GB17873@csn.ul.ie>
	<20110210124838.GU3347@random.random>
	<20110210133323.GH17873@csn.ul.ie>
	<20110210141447.GW3347@random.random>
	<20110210145813.GK17873@csn.ul.ie>
	<20110216095048.GA4473@csn.ul.ie>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 09:50:49 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> should_continue_reclaim() for reclaim/compaction allows scanning to continue
> even if pages are not being reclaimed until the full list is scanned. In
> terms of allocation success, this makes sense but potentially it introduces
> unwanted latency for high-order allocations such as transparent hugepages
> and network jumbo frames that would prefer to fail the allocation attempt
> and fallback to order-0 pages.  Worse, there is a potential that the full
> LRU scan will clear all the young bits, distort page aging information and
> potentially push pages into swap that would have otherwise remained resident.

afaict the patch affects order-0 allocations as well.  What are the
implications of this?

Also, what might be the downsides of this change, and did you test for
them?

> This patch will stop reclaim/compaction if no pages were reclaimed in the
> last SWAP_CLUSTER_MAX pages that were considered.

a) Why SWAP_CLUSTER_MAX?  Is (SWAP_CLUSTER_MAX+7) better or worse?

b) The sentence doesn't seem even vaguely accurate.  shrink_zone()
   will scan vastly more than SWAP_CLUSTER_MAX pages before calling
   should_continue_reclaim().  Confused.

c) The patch doesn't "stop reclaim/compaction" fully.  It stops it
   against one zone.  reclaim will then advance on to any other
   eligible zones.

