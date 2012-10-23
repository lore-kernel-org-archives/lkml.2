Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2JWJhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab2JWJhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:37:41 -0400
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] mm: make zone_pcp_reset independ on MEMORY_HOTREMOVE
Date: Tue, 23 Oct 2012 11:37:27 +0200
Message-Id: <1350985047-23148-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

340175b7 (mm/hotplug: free zone->pageset when a zone becomes empty)
introduced zone_pcp_reset and hided it inside CONFIG_MEMORY_HOTREMOVE.
The function is since 506e5fb7 (memory-hotplug: allocate zone's pcp
before onlining pages) called also called from online_pages which
is called outside CONFIG_MEMORY_HOTREMOVE which causes a linkage error.

The function, although not used outside of MEMORY_{HOTPLUT,HOTREMOVE},
seems like universal enough so let's keep it at its current location
and only remove the HOTREMOVE guard.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e29912e..30e359c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5981,7 +5981,6 @@ void __meminit zone_pcp_update(struct zone *zone)
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
@@ -6001,6 +6000,7 @@ void zone_pcp_reset(struct zone *zone)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
  */
-- 
1.7.10.4

