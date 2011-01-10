Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1AJKfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:22 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37924 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1AJKfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:20 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293731"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/12] xen: define gnttab_set_map_op/unmap_op
Date: Mon, 10 Jan 2011 10:36:30 +0000
Message-Id: <1294655801-16230-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:19.0300 (UTC) FILETIME=[13CC1440:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: hypercall definitions

These functions populate the gnttab data structures used by the
granttab map and unmap ops and are used in the backend drivers.

Originally xen-unstable.hg 9625:c3bb51c443a7

[ Include Stefano's fix for phys_addr_t ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/grant_table.h |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 9a73170..1821aa1 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -37,10 +37,16 @@
 #ifndef __ASM_GNTTAB_H__
 #define __ASM_GNTTAB_H__
 
-#include <asm/xen/hypervisor.h>
+#include <asm/page.h>
+
+#include <xen/interface/xen.h>
 #include <xen/interface/grant_table.h>
+
+#include <asm/xen/hypervisor.h>
 #include <asm/xen/grant_table.h>
 
+#include <xen/features.h>
+
 /* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
 #define NR_GRANT_FRAMES 4
 
@@ -107,6 +113,37 @@ void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
 
+static inline void
+gnttab_set_map_op(struct gnttab_map_grant_ref *map, phys_addr_t addr,
+		  uint32_t flags, grant_ref_t ref, domid_t domid)
+{
+	if (flags & GNTMAP_contains_pte)
+		map->host_addr = addr;
+	else if (xen_feature(XENFEAT_auto_translated_physmap))
+		map->host_addr = __pa(addr);
+	else
+		map->host_addr = addr;
+
+	map->flags = flags;
+	map->ref = ref;
+	map->dom = domid;
+}
+
+static inline void
+gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
+		    uint32_t flags, grant_handle_t handle)
+{
+	if (flags & GNTMAP_contains_pte)
+		unmap->host_addr = addr;
+	else if (xen_feature(XENFEAT_auto_translated_physmap))
+		unmap->host_addr = __pa(addr);
+	else
+		unmap->host_addr = addr;
+
+	unmap->handle = handle;
+	unmap->dev_bus_addr = 0;
+}
+
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   struct grant_entry **__shared);
-- 
1.5.6.5

