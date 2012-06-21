Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2FUIay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:30:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab2FUIau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:30:50 -0400
Date: Thu, 21 Jun 2012 01:30:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
In-Reply-To: <4FE2D73C.3060001@kernel.org>
Message-ID: <alpine.DEB.2.00.1206210124380.6635@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com> <4FE2D73C.3060001@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Minchan Kim wrote:

> > If page migration cannot charge the new page to the memcg,
> > migrate_pages() will return -ENOMEM.  This isn't considered in memory
> > compaction however, and the loop continues to iterate over all pageblocks
> > trying in a futile attempt to continue migrations which are only bound to
> > fail.
> 
> 
> Hmm, it might be dumb question.
> I imagine that pages in next pageblock could be in another memcg so it could be successful.
> Why should we stop compaction once it fails to migrate pages in current pageblock/memcg?
> 

 [ You included the gmane.linux.kernel and gmane.linux.kernel.mm
   newsgroups in your reply, not sure why, so I removed them. ]

This was inspired by a system running with a single oom memcg running with 
thp that continuously tried migrating pages resulting in vmstats such as 
this:

compact_blocks_moved 59473599
compact_pages_moved 50041548
compact_pagemigrate_failed 1494277831
compact_stall 1013
compact_fail 573

Obviously not a good result.

We could certainly continue the iteration in cases like this, but I 
thought it would be better to fail and rely on direct reclaim to actually 
try to free some memory, especially if that oom memcg happens to include 
current.

It's possible that subsequent pageblocks would contain memory allocated 
from solely non-oom memcgs, but it's certainly not a guarantee and results 
in terrible performance as exhibited above.  Is there another good 
criteria to use when deciding when to stop isolating and attempting to 
migrate all of these pageblocks?

Other ideas?
