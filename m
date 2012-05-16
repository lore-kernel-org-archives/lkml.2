Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab2EPGv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:51:57 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60532 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759389Ab2EPGvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:51:48 -0400
Date: Wed, 16 May 2012 08:51:32 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "nai.xia" <nai.xia@gmail.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
Message-ID: <20120516065132.GC1769@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
 <4FB33A4E.1010208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB33A4E.1010208@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nai,

On Wed, May 16, 2012 at 01:25:34PM +0800, nai.xia wrote:
> Hi Johannes,
> 
> Just out of curiosity(since I didn't study deep into the
> reclaiming algorithms), I can recall from here that around 2005,
> there was an(or some?) implementation of the "Clock-pro" algorithm
> which also have the idea of "reuse distance", but it seems that algo
> did not work well enough to get merged? Does this patch series finally
> solve the problem(s) with "Clock-pro" or totally doesn't have to worry
> about the similar problems?

As far as I understood, clock-pro set out to solve more problems than
my patch set and it failed to satisfy everybody.

The main error case was that it could not partially cache data of a
set that was bigger than memory.  Instead, looping over the file
repeatedly always has to read every single page because the most
recent page allocations would push out the pages needed in the nearest
future.  I never promised to solve this problem in the first place.
But giving more memory to the big looping load is not useful in our
current situation, and at least my code protects smaller sets of
active cache from these loops.  So it's not optimal, but it sucks only
half as much :)

There may have been improvements from clock-pro, but it's hard to get
code merged that does not behave as expected in theory with nobody
understanding what's going on.

My code is fairly simple, works for the tests I've done and the
behaviour observed so far is understood (at least by me).
