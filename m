Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965837Ab0GSSkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:40:16 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:5232 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965636Ab0GSSkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:10 -0400
Subject: [PATCH 12/26] cciss: factor out cciss_enable_scsi_prefetch()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:41 -0500
Message-ID: <20100719184541.7908.63558.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out cciss_enable_scsi_prefetch()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9a48695..b4264bc 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4108,6 +4108,18 @@ static inline bool CISS_signature_present(ctlr_info_t *h)
 	return true;
 }
 
+/* Need to enable prefetch in the SCSI core for 6400 in x86 */
+static inline void cciss_enable_scsi_prefetch(ctlr_info_t *h)
+{
+#ifdef CONFIG_X86
+	u32 prefetch;
+
+	prefetch = readl(&(h->cfgtable->SCSI_Prefetch));
+	prefetch |= 0x100;
+	writel(prefetch, &(h->cfgtable->SCSI_Prefetch));
+#endif
+}
+
 static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
 	int prod_index, err;
@@ -4169,16 +4181,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
-#ifdef CONFIG_X86
-	{
-		/* Need to enable prefetch in the SCSI core for 6400 in x86 */
-		__u32 prefetch;
-		prefetch = readl(&(c->cfgtable->SCSI_Prefetch));
-		prefetch |= 0x100;
-		writel(prefetch, &(c->cfgtable->SCSI_Prefetch));
-	}
-#endif
-
+	cciss_enable_scsi_prefetch(c);
 	/* Disabling DMA prefetch and refetch for the P600.
 	 * An ASIC bug may result in accesses to invalid memory addresses.
 	 * We've disabled prefetch for some time now. Testing with XEN

