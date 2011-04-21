Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1DUVlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:41:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1DUVlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=T3ZG3sEsYcLhGEmktOv1d3vLzd7IuzFordVaYyonJKWc86OENFmtwlhFsH7/xj90Se
         GqLMVCpaQdoISE/iw0jw==
Date: Thu, 21 Apr 2011 14:41:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: always set nodes with regular memory in
 N_NORMAL_MEMORY
In-Reply-To: <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104211440240.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_NORMAL_MEMORY is intended to include all nodes that have present memory 
in regular zones, that is, zones below ZONE_HIGHMEM.  This should be done 
regardless of whether CONFIG_HIGHMEM is set or not.

This fixes ia64 so that the nodes get set appropriately in the nodemask 
for DISCONTIGMEM and mips if it does not enable CONFIG_HIGHMEM even for 
32-bit kernels.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it 
relies on this nodemask to setup kmem_cache_node data structures for each 
cache.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4727,7 +4727,6 @@ out:
 /* Any regular memory on that node ? */
 static void check_for_regular_memory(pg_data_t *pgdat)
 {
-#ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
 
 	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
@@ -4735,7 +4734,6 @@ static void check_for_regular_memory(pg_data_t *pgdat)
 		if (zone->present_pages)
 			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 	}
-#endif
 }
 
 /**
