Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2A3RUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:20:22 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab2A3RUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:20:21 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        stable@kernel.org
Subject: [PATCH] UBI: Fix error handling in ubi_scan()
Date: Mon, 30 Jan 2012 18:20:13 +0100
Message-Id: <1327944013-18944-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two bad things can happen in ubi_scan():
1. If kmem_cache_create() fails we jump to out_si and call
   ubi_scan_destroy_si() which calls kmem_cache_destroy().
   But si->scan_leb_slab is NULL.
2. If process_eb() fails we jump to out_vidh, call
   kmem_cache_destroy() and ubi_scan_destroy_si() which calls
   again kmem_cache_destroy().

Signed-off-by: Richard Weinberger <richard@nod.at>
CC: stable@kernel.org
---
 drivers/mtd/ubi/scan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 0cb17d9..b99318e 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -1174,7 +1174,7 @@ struct ubi_scan_info *ubi_scan(struct ubi_device *ubi)
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
-		goto out_slab;
+		goto out_si;
 
 	vidh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
 	if (!vidh)
@@ -1235,8 +1235,6 @@ out_vidh:
 	ubi_free_vid_hdr(ubi, vidh);
 out_ech:
 	kfree(ech);
-out_slab:
-	kmem_cache_destroy(si->scan_leb_slab);
 out_si:
 	ubi_scan_destroy_si(si);
 	return ERR_PTR(err);
@@ -1325,7 +1323,9 @@ void ubi_scan_destroy_si(struct ubi_scan_info *si)
 		}
 	}
 
-	kmem_cache_destroy(si->scan_leb_slab);
+	if (si->scan_leb_slab)
+		kmem_cache_destroy(si->scan_leb_slab);
+
 	kfree(si);
 }
 
-- 
1.7.8.3

