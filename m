Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2AYQNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:13:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2AYQNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:13:51 -0500
From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 25 Jan 2012 16:51:05 +0100
Subject: [PATCH] agp: fix scratch page cleanup
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20120125161350.82538402A7@alaris.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In error cleanup of agp_backend_initialize() and in agp_backend_cleanup(),
agp_destroy_page() is passed virtual address of the scratch page. This
leads to a kernel warning if the initialization fails (or upon regular
cleanup) as pointer to struct page should be passed instead.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/char/agp/backend.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index 4b71647..317c28c 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -194,10 +194,10 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 
 err_out:
 	if (bridge->driver->needs_scratch_page) {
-		void *va = page_address(bridge->scratch_page_page);
+		struct page *page = bridge->scratch_page_page;
 
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
+		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_UNMAP);
+		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_FREE);
 	}
 	if (got_gatt)
 		bridge->driver->free_gatt_table(bridge);
@@ -221,10 +221,10 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
 
 	if (bridge->driver->agp_destroy_page &&
 	    bridge->driver->needs_scratch_page) {
-		void *va = page_address(bridge->scratch_page_page);
+		struct page *page = bridge->scratch_page_page;
 
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
+		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_UNMAP);
+		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_FREE);
 	}
 }
 
-- 
1.7.7

