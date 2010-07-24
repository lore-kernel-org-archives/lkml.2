Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0GXIoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:44:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47395 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0GXIow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:44:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 1/2] vmscan: shrink_all_slab() use reclaim_state instead the return value of shrink_slab()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100724174038.3C96.A69D9226@jp.fujitsu.com>
References: <20100722190100.GA22269@amd> <20100724174038.3C96.A69D9226@jp.fujitsu.com>
Message-Id: <20100724174405.3C99.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 24 Jul 2010 17:44:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, shrink_slab() doesn't return number of reclaimed objects. IOW,
current shrink_all_slab() is broken. Thus instead we use reclaim_state
to detect no reclaimable slab objects.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7256e0..bfa1975 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -300,18 +300,16 @@ static unsigned long shrink_slab(struct zone *zone, unsigned long scanned, unsig
 void shrink_all_slab(void)
 {
 	struct zone *zone;
-	unsigned long nr;
+	struct reclaim_state reclaim_state;
 
-again:
-	nr = 0;
-	for_each_zone(zone)
-		nr += shrink_slab(zone, 1, 1, 1, GFP_KERNEL);
-	/*
-	 * If we reclaimed less than 10 objects, might as well call
-	 * it a day. Nothing special about the number 10.
-	 */
-	if (nr >= 10)
-		goto again;
+	current->reclaim_state = &reclaim_state;
+	do {
+		reclaim_state.reclaimed_slab = 0;
+		for_each_zone(zone)
+			shrink_slab(zone, 1, 1, 1, GFP_KERNEL);
+	} while (reclaim_state.reclaimed_slab);
+
+	current->reclaim_state = NULL;
 }
 
 static inline int is_page_cache_freeable(struct page *page)
-- 
1.6.5.2



