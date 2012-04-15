Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2DOJ1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 05:27:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36832 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab2DOJ1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 05:27:20 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kernel-janitors@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/xen/grant-table.c: add error-handling code on failure of gnttab_resume
Date: Sun, 15 Apr 2012 11:27:12 +0200
Message-Id: <1334482032-12339-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Jump to the label ini_nomem as done on the failure of the page allocations
above.

The code at ini_nomem is modified to accommodate different return values.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/xen/grant-table.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index b4d4eac..f100ce2 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1029,6 +1029,7 @@ int gnttab_init(void)
 	int i;
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
+	int ret;
 
 	nr_grant_frames = 1;
 	boot_max_nr_grant_frames = __max_nr_grant_frames();
@@ -1047,12 +1048,16 @@ int gnttab_init(void)
 	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
 	for (i = 0; i < nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
-		if (gnttab_list[i] == NULL)
+		if (gnttab_list[i] == NULL) {
+			ret = -ENOMEM;
 			goto ini_nomem;
+		}
 	}
 
-	if (gnttab_resume() < 0)
-		return -ENODEV;
+	if (gnttab_resume() < 0) {
+		ret = -ENODEV;
+		goto ini_nomem;
+	}
 
 	nr_init_grefs = nr_grant_frames * GREFS_PER_GRANT_FRAME;
 
@@ -1070,7 +1075,7 @@ int gnttab_init(void)
 	for (i--; i >= 0; i--)
 		free_page((unsigned long)gnttab_list[i]);
 	kfree(gnttab_list);
-	return -ENOMEM;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(gnttab_init);
 

