Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966202Ab2C3VW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:22:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52026 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966148Ab2C3VWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:16 -0400
Message-Id: <20120330194847.328176634@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 108/175] UBI: fix error handling in ubi_scan()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit a29852be492d61001d86c6ebf5fff9b93d7b4be9 upstream.

Two bad things can happen in ubi_scan():
1. If kmem_cache_create() fails we jump to out_si and call
   ubi_scan_destroy_si() which calls kmem_cache_destroy().
   But si->scan_leb_slab is NULL.
2. If process_eb() fails we jump to out_vidh, call
   kmem_cache_destroy() and ubi_scan_destroy_si() which calls
   again kmem_cache_destroy().

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/scan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -1174,7 +1174,7 @@ struct ubi_scan_info *ubi_scan(struct ub
 
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
@@ -1325,7 +1323,9 @@ void ubi_scan_destroy_si(struct ubi_scan
 		}
 	}
 
-	kmem_cache_destroy(si->scan_leb_slab);
+	if (si->scan_leb_slab)
+		kmem_cache_destroy(si->scan_leb_slab);
+
 	kfree(si);
 }
 


