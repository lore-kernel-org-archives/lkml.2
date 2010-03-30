Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0C3Hbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:31:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50314 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0C3Hbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:31:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
In-Reply-To: <20100330065358.GA24828@sli10-desk.sh.intel.com>
References: <20100330153750.8EA2.A69D9226@jp.fujitsu.com> <20100330065358.GA24828@sli10-desk.sh.intel.com>
Message-Id: <20100330160820.8EA8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Mar 2010 16:31:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Very unfortunately, this patch isn't acceptable. In past time, vmscan 
> > > > had similar logic, but 1% swap-out made lots bug reports. 
> > > can you elaborate this?
> > > Completely restore previous behavior (do full scan with priority 0) is
> > > ok too.
> > 
> > This is a option. but we need to know the root cause anyway.
> I thought I mentioned the root cause in first mail. My debug shows
> recent_rotated[0] is big, but recent_rotated[1] is almost zero, which makes
> percent[0] 0. But you can double check too.

To revert can save percent[0]==0 && priority==0 case. but it shouldn't
happen, I think. It mean to happen big latency issue.

Can you please try following patch? Also, I'll prepare reproduce environment soon.



---
 mm/vmscan.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79c8098..abf7f79 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1571,15 +1571,19 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	 */
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		spin_lock_irq(&zone->lru_lock);
-		reclaim_stat->recent_scanned[0] /= 2;
-		reclaim_stat->recent_rotated[0] /= 2;
+		while (reclaim_stat->recent_scanned[0] > anon / 4) {
+			reclaim_stat->recent_scanned[0] /= 2;
+			reclaim_stat->recent_rotated[0] /= 2;
+		}
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
 		spin_lock_irq(&zone->lru_lock);
-		reclaim_stat->recent_scanned[1] /= 2;
-		reclaim_stat->recent_rotated[1] /= 2;
+		while (reclaim_stat->recent_scanned[1] > file / 4) {
+			reclaim_stat->recent_scanned[1] /= 2;
+			reclaim_stat->recent_rotated[1] /= 2;
+		}
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
-- 
1.6.5.2





