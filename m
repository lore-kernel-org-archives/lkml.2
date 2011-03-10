Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1CJUWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:22:42 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42627 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1CJUWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:22:41 -0500
Subject: [PATCH] cciss: Add missing allocation in scsi_cmd_stack_setup and
	corresponding deallocation
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Thu, 10 Mar 2011 14:22:38 -0600
Message-ID: <20110310202238.30533.92210.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This bit got lost somewhere along the way.  Without this, panic.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 514470d..6961002 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -222,7 +222,12 @@ scsi_cmd_stack_setup(ctlr_info_t *h, struct cciss_scsi_adapter_data_t *sa)
 		sa->cmd_sg_list = NULL;
 		return -ENOMEM;
 	}
-
+	stk->elem = kmalloc(sizeof(stk->elem[0]) * stk->nelems, GFP_KERNEL);
+	if (!stk->elem) {
+		pci_free_consistent(h->pdev, size, stk->pool,
+		stk->cmd_pool_handle);
+		return -1;
+	}
 	for (i = 0; i < stk->nelems; i++) {
 		stk->elem[i] = &stk->pool[i];
 		stk->elem[i]->busaddr = (__u32) (stk->cmd_pool_handle + 
@@ -252,6 +257,8 @@ scsi_cmd_stack_free(ctlr_info_t *h)
 	pci_free_consistent(h->pdev, size, stk->pool, stk->cmd_pool_handle);
 	stk->pool = NULL;
 	cciss_free_sg_chain_blocks(sa->cmd_sg_list, stk->nelems);
+	kfree(stk->elem);
+	stk->elem = NULL;
 }
 
 #if 0

