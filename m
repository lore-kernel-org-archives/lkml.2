Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1HaLhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1HaLhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:37:46 -0400
Date: Wed, 31 Aug 2011 13:37:10 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/3] compaction accouting fix
Message-ID: <20110831113710.GC17512@redhat.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <282a4531f23c5e35cfddf089f93559130b4bb660.1321112552.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282a4531f23c5e35cfddf089f93559130b4bb660.1321112552.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 01:37:43AM +0900, Minchan Kim wrote:
> I saw the following accouting of compaction during test of the series.
> 
> compact_blocks_moved 251
> compact_pages_moved 44
> 
> It's very awkward to me although it's possbile because it means we try to compact 251 blocks
> but it just migrated 44 pages. As further investigation, I found isolate_migratepages doesn't
> isolate any pages but it returns ISOLATE_SUCCESS and then, it just increases compact_blocks_moved
> but doesn't increased compact_pages_moved.
> 
> This patch makes accouting of compaction works only in case of success of isolation.
> 
> CC: Mel Gorman <mgorman@suse.de>
> CC: Johannes Weiner <jweiner@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>

It's a teensy-bit awkward that isolate_migratepages() can return
success without actually isolating any new pages, just because there
are still some pages left from a previous run (cc->nr_migratepages is
maintained across isolation calls).

Maybe isolate_migratepages() should just return an error if compaction
should really be aborted and 0 otherwise, and have compact_zone()
always check for cc->nr_migratepages itself?

	if (isolate_migratepages(zone, cc) < 0) {
		ret = COMPACT_PARTIAL;
		goto out;
	}

	if (!cc->nr_migratepages)
		continue;

	...

Just a nit-pick, though.  If you don't agree, just leave it as is.
