Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1BVUOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:30 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:23949 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1BVUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:28 -0500
Subject: [PATCH 3/6] cciss: Mask off error bits of c->busaddr in
	cmd_special_free when calling pci_free_consistent
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 22 Feb 2011 14:14:26 -0600
Message-ID: <20110222201426.21961.97588.stgit@beardog.cce.hp.com>
In-Reply-To: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
References: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 2e832b0..03cead6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -193,7 +193,7 @@ static int __devinit cciss_find_cfg_addrs(struct pci_dev *pdev,
 	u64 *cfg_offset);
 static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar);
-
+static inline u32 cciss_tag_discard_error_bits(ctlr_info_t *h, u32 tag);
 
 /* performant mode helper functions */
 static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
@@ -973,8 +973,8 @@ static void cmd_special_free(ctlr_info_t *h, CommandList_struct *c)
 	temp64.val32.upper = c->ErrDesc.Addr.upper;
 	pci_free_consistent(h->pdev, sizeof(ErrorInfo_struct),
 			    c->err_info, (dma_addr_t) temp64.val);
-	pci_free_consistent(h->pdev, sizeof(CommandList_struct),
-			    c, (dma_addr_t) c->busaddr);
+	pci_free_consistent(h->pdev, sizeof(CommandList_struct), c,
+		(dma_addr_t) cciss_tag_discard_error_bits(h, (u32) c->busaddr));
 }
 
 static inline ctlr_info_t *get_host(struct gendisk *disk)

