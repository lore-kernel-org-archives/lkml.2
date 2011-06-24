Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab1FXNnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:43:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab1FXNnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:43:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/4] mm: vmscan: Evaluate the watermarks against the correct classzone
Date: Fri, 24 Jun 2011 14:43:17 +0100
Message-Id: <1308922998-15529-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308922998-15529-1-git-send-email-mgorman@suse.de>
References: <1308922998-15529-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When deciding if kswapd is sleeping prematurely, the classzone is
taken into account but this is different to what balance_pgdat() and
the allocator are doing. Specifically, the DMA zone will be checked
based on the classzone used when waking kswapd which could be for a
GFP_KERNEL or GFP_HIGHMEM request. The lowmem reserve limit kicks in,
the watermark is not met and kswapd thinks its sleeping prematurely
keeping kswapd awake in error.

Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 38665ec..d859111 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2341,7 +2341,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
 		}
 
 		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							classzone_idx, 0))
+							i, 0))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;
-- 
1.7.3.4

