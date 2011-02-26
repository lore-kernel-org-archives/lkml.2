Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab1BZAXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:23:51 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57748 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab1BZAXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:23:35 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 7/8] dmatest: fix automatic buffer unmap type
Date: Fri, 25 Feb 2011 16:23:24 -0800
Message-Id: <1298679805-14108-8-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
References: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Fri, 25 Feb 2011 16:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmatest code relies on the DMAEngine API to automatically call
dma_unmap_single() on src buffers. The flags it passes are incorrect,
fix them.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/dmatest.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 5589358..7e1b0aa 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -285,7 +285,12 @@ static int dmatest_func(void *data)
 
 	set_user_nice(current, 10);
 
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP | DMA_PREP_INTERRUPT;
+	/*
+	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
+	 * dst buffers are freed by ourselves below
+	 */
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
+	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
 
 	while (!kthread_should_stop()
 	       && !(iterations && total_tests >= iterations)) {
-- 
1.7.3.4

