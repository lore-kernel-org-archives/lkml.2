Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0HRTE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:04:29 -0400
Received: from mx2.netapp.com ([216.240.18.37]:17936 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0HRTEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:04:21 -0400
X-IronPort-AV: E=Sophos;i="4.56,228,1280732400"; 
   d="scan'208";a="431410609"
Subject: [PATCH] VM: kswapd should not do blocking memory allocations
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Wed, 18 Aug 2010 15:04:01 -0400
Message-ID: <1282158241.8540.85.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
X-OriginalArrivalTime: 18 Aug 2010 19:04:02.0612 (UTC) FILETIME=[1F361F40:01CB3F08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Allowing kswapd to do GFP_KERNEL memory allocations (or any blocking memory
allocations) is wrong and can cause deadlocks in try_to_release_page(), as
the filesystem believes it is safe to allocate new memory and block,
whereas kswapd is there specifically to clear a low-memory situation...

Set the gfp_mask to GFP_IOFS instead.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/mm/vmscan.c b/mm/vmscan.c
index ec5ddcc..716dd16 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2095,7 +2095,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
-		.gfp_mask = GFP_KERNEL,
+		.gfp_mask = GFP_IOFS,
 		.may_unmap = 1,
 		.may_swap = 1,
 		/*

