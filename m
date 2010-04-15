Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0DOELm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:11:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39863 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0DOELl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:11:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if current is kswapd
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415130212.D16E.A69D9226@jp.fujitsu.com>
References: <20100415013436.GO2493@dastard> <20100415130212.D16E.A69D9226@jp.fujitsu.com>
Message-Id: <20100415131106.D174.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 13:11:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, vmscan pageout() is one of IO throuput degression source.
Some IO workload makes very much order-0 allocation and reclaim
and pageout's 4K IOs are making annoying lots seeks.

At least, kswapd can avoid such pageout() because kswapd don't
need to consider OOM-Killer situation. that's no risk.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3ff3311..d392a50 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -614,6 +614,13 @@ static enum page_references page_check_references(struct page *page,
 	if (referenced_page)
 		return PAGEREF_RECLAIM_CLEAN;
 
+	/*
+	 * Delegate pageout IO to flusher thread. They can make more
+	 * effective IO pattern.
+	 */
+	if (current_is_kswapd())
+		return PAGEREF_RECLAIM_CLEAN;
+
 	return PAGEREF_RECLAIM;
 }
 
-- 
1.6.5.2



