Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0LJD5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:57:37 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55158 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124Ab0LJD5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:57:05 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <felipe.contreras@gmail.com>, <nm@ti.com>,
        <ohad@wizery.com>, Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2 3/4] staging: tidspbridge - remove disabling twl when printing DSP stack
Date: Thu,  9 Dec 2010 21:55:41 -0600
Message-Id: <1291953342-4905-4-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the SHM segments are not in lock tlbs, instead
they are in translation tables. So we cannot disable
twl in order to get the DSP stack dump. Also add a check
for __get_free_page allocation.

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/staging/tidspbridge/core/ue_deh.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 0537edf..183900e 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -180,13 +180,8 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	resources = dev_context->resources;
 	dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
 
-	/*
-	 * Before acking the MMU fault, let's make sure MMU can only
-	 * access entry #0. Then add a new entry so that the DSP OS
-	 * can continue in order to dump the stack.
-	 */
-	hw_mmu_twl_disable(resources->dw_dmmu_base);
-	hw_mmu_tlb_flush_all(resources->dw_dmmu_base);
+	if (!dummy_va_addr)
+		return;
 
 	hw_mmu_tlb_add(resources->dw_dmmu_base,
 			virt_to_phys(dummy_va_addr), fault_addr,
-- 
1.7.3.2

