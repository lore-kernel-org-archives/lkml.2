Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2DTPGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:06:44 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:4386 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab2DTPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:06:41 -0400
Subject: [PATCH 05/17] hpsa: do not read from controller unnecessarily in
	completion code
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:06:40 -0500
Message-ID: <20120420150640.10596.43679.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

MSI/MSI-X interrupts can't race the DMA completion they are communicating
so no need to read from controller to flush the DMA to the host if
MSI or MSI-X interrupts are being used.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7b28d54..48f7812 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -258,12 +258,12 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h)
 {
 	unsigned long register_value = FIFO_EMPTY;
 
-	/* flush the controller write of the reply queue by reading
-	 * outbound doorbell status register.
-	 */
-	register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
 	/* msi auto clears the interrupt pending bit. */
 	if (!(h->msi_vector || h->msix_vector)) {
+		/* flush the controller write of the reply queue by reading
+		 * outbound doorbell status register.
+		 */
+		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
 		writel(SA5_OUTDB_CLEAR_PERF_BIT, h->vaddr + SA5_OUTDB_CLEAR);
 		/* Do a read in order to flush the write to the controller
 		 * (as per spec.)

