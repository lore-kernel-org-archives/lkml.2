Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1JGPR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:17:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1JGPR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:17:26 -0400
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        akpm@linux-foundation.org
Cc: Josh Boyer <jwboyer@redhat.com>, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Avoid excessive reclaim due to THP
Date: Fri,  7 Oct 2011 16:17:21 +0100
Message-Id: <1318000643-27996-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thread "[PATCH v2 -mm] limit direct reclaim for higher order
allocations" went silent so this is an attempt to kick it awake again
to close it.

Rik noticed that there was too much memory free on his machine when
THP was running and there is at least one bug report out there that
implies that reclaim due to khugepaged is causing stalls.

In Rik's case, he posted a patch that fixed his
problem. The user on the RH bug reported that a patch from
https://lkml.org/lkml/2011/7/26/103 fixed his problem. However, in many
cases, these patches are complimentary except that Rik's is tidier.

Patch 1 of this series is a patch from Rik that limits the amount
of direct reclaim that occurs as a result of THP. Specifically,
if compaction can go ahead in a zone or is deferred for a zonelist,
then reclaim will stop as it is unlikely freeing more pages will help.

Patch 2 notes that even if patch 1 stops reclaiming, the caller
of shrink_zones will still shrink slabs and scan at the next
priority.  This is unnecessary and wasteful so the patch causes
do_try_to_free_pages() to abort reclaim if shrink_zones() returned
early.

Rik, can you retest with your case just to be sure? Josh, will you
ask the reporter of RH#735946 to retest with these patches to ensure
their problem really gets fixed upstream?

I tested it myself and it appears to behave as expected. Performance
of benchmarks like STREAM that benefit from THP are unchanged
as expected. When running with a basic workload that created a
large anonymous mapping and read it multiple times followed by
writing it multiple times, there are fewer pages direct reclaimed.
Critically, memory utilisation is higher with these patches applied
as predicted. In the vanilla kernel, I can see a few spikes where an
excessive amount of memory memory was reclaimed that is not present
with the patches applied.

Are there any objections to these being merged?

 mm/vmscan.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

-- 
1.7.3.4

