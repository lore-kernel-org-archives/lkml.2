Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1GZMoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:44:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab1GZMn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:43:56 -0400
MIME-Version: 1.0
Date: Tue, 26 Jul 2011 20:43:54 +0800
Message-ID: <CAJd=RBDCLp0hXNtXVSzUd4De+z9cZLpTDftnxWVGeHauAbsWaQ@mail.gmail.com>
Subject: [RFC patch] DMAengine/Langwell: put tx descriptor in error path
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When preparing LLI based periphral transfer, if error encountered, the newly
prepared tx descriptor should be put for later recycling.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..b78a65a 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -793,6 +793,7 @@ static struct dma_async_tx_descriptor
*intel_mid_dma_prep_slave_sg(
 				32, 0);
 	if (NULL == desc->lli_pool) {
 		pr_err("MID_DMA:LLI pool create failed\n");
+		midc_desc_put(midc, desc);
 		return NULL;
 	}

@@ -800,6 +801,7 @@ static struct dma_async_tx_descriptor
*intel_mid_dma_prep_slave_sg(
 	if (!desc->lli) {
 		pr_err("MID_DMA: LLI alloc failed\n");
 		pci_pool_destroy(desc->lli_pool);
+		midc_desc_put(midc, desc);
 		return NULL;
 	}
