Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1EWJyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:54:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1EWJyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:54:02 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>, stable <stable@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/2] mm: vmscan: Correct use of pgdat_balanced in sleeping_prematurely
Date: Mon, 23 May 2011 10:53:54 +0100
Message-Id: <1306144435-2516-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1306144435-2516-1-git-send-email-mgorman@suse.de>
References: <1306144435-2516-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Johannes Weiner poined out that the logic in commit [1741c877: mm:
kswapd: keep kswapd awake for high-order allocations until a percentage
of the node is balanced] is backwards. Instead of allowing kswapd to go
to sleep when balancing for high order allocations, it keeps it kswapd
running uselessly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8bfd450..1aa262b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2286,7 +2286,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
 	 * must be balanced
 	 */
 	if (order)
-		return pgdat_balanced(pgdat, balanced, classzone_idx);
+		return !pgdat_balanced(pgdat, balanced, classzone_idx);
 	else
 		return !all_zones_ok;
 }
-- 
1.7.3.4

