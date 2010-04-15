Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0DOEPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:15:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40004 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0DOEPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:15:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] vmscan: delegate page cleaning io to flusher thread if VM pressure is low
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415130212.D16E.A69D9226@jp.fujitsu.com>
References: <20100415013436.GO2493@dastard> <20100415130212.D16E.A69D9226@jp.fujitsu.com>
Message-Id: <20100415131420.D17D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 13:15:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if pageout() is called from direct reclaim, we can delegate io to
flusher thread if vm pressure is low.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8b78b49..eab6028 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -623,6 +623,13 @@ static enum page_references page_check_references(struct page *page,
 	if (current_is_kswapd())
 		return PAGEREF_RECLAIM_CLEAN;
 
+	/*
+	 * Now VM pressure is not so high. then we can delegate
+	 * page cleaning to flusher thread safely.
+	 */
+	if (!sc->order && sc->priority > DEF_PRIORITY/2)
+		return PAGEREF_RECLAIM_CLEAN;
+
 	return PAGEREF_RECLAIM;
 }
 
-- 
1.6.5.2



