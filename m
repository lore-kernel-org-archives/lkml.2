Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab2EBBKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab2EBBKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:10:53 -0400
Date: Wed, 2 May 2012 03:10:31 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
Message-ID: <20120502011031.GD22923@redhat.com>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
 <20120501120819.0af1e54b.akpm@linux-foundation.org>
 <4FA05354.8000304@redhat.com>
 <20120501142656.c9160d96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501142656.c9160d96.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 01, 2012 at 02:26:56PM -0700, Andrew Morton wrote:
> Well, think of a stupid workload which creates a large number of very
> large but sparse files (populated with one page in each 64, for
> example).  Get them all in cache, then sit there touching the inodes to
> keep then fresh.  What's the worst case here?

I suspect in that scenario we may drop more inodes than before and so
a ton of their cache with it and actually worsen the LRU effect
instead of improving them.

I don't think it's a reliablity issue, or we would probably be bitten
by it already, especially with a ton of inodes with just one page at a
very large file offset accessed in a loop. This only makes more sticky
a badness we already have. Testing it for sure, wouldn't be a bad idea
though.

At first glance it sounds like a good tradeoff, as normally the
"worsening" effect of when we have too many and large radix trees that
would lead to more inodes to be dropped than before, shouldn't
materialize and we'd just make better use of the memory we already
allocated to make more accurate decisions on the active/inactive
LRU balancing.
