Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0JZAib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:38:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55396 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0JZAi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:29 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 7/8] staging: tidspbridge - fix some issues after iommu patches
Date: Mon, 25 Oct 2010 19:51:45 -0500
Message-Id: <1288054306-4361-8-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-7-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <1288054306-4361-3-git-send-email-x0095840@ti.com>
 <1288054306-4361-4-git-send-email-x0095840@ti.com>
 <1288054306-4361-5-git-send-email-x0095840@ti.com>
 <1288054306-4361-6-git-send-email-x0095840@ti.com>
 <1288054306-4361-7-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes:

* In delete_node() we need to check for udsp_heap_addr in order
  to unmap the head instead of udsp_heap_res_addr which used
  to be the reserved memory a not valid anymore.

* Fix in get_io_pages() as pointed by Felipe Contreras in this
  mail:

http://marc.info/?l=linux-kernel&m=128735502205183&w=2

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-mmu.c |    2 +-
 drivers/staging/tidspbridge/rmgr/node.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
index 3a00087..54f3ba4 100644
--- a/drivers/staging/tidspbridge/core/dsp-mmu.c
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -196,7 +196,7 @@ static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
 	int i;
 	struct page *pg;
 
-	for (i = 0; i < pages; i++) {
+	for (i = 0; i < pages; i++, uva += PAGE_SIZE) {
 		pa = user_va2_pa(mm, uva);
 
 		if (!pfn_valid(__phys_to_pfn(pa)))
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 3f5abcf..f7fe6c0 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -2541,7 +2541,7 @@ static void delete_node(struct node_object *hnode,
 			kfree(task_arg_obj.strm_out_def);
 			task_arg_obj.strm_out_def = NULL;
 		}
-		if (task_arg_obj.udsp_heap_res_addr) {
+		if (task_arg_obj.udsp_heap_addr) {
 			status = proc_un_map(hnode->hprocessor, (void *)
 					     task_arg_obj.udsp_heap_addr,
 					     pr_ctxt);
-- 
1.6.3.3

