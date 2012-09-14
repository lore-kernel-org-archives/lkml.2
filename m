Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab2INVil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:38:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab2INVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: [PATCH 12/24] ARM: msm: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:40 +0200
Message-Id: <1347658492-11608-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kEi6i0WtXaISfPKdcEmLxULugblOkbXQCw62yqILVuH
 +GuwUxyMTso5aoo7A13OrUNYMRxc8IsaIqnn+Zzc56slxDReW9
 oP6UK1lV44saHmX1bqijs59LAHndZ+21VFFWy+2ozuVPFeKXrp
 CJ9Va/nF7+BhrUGip/9aauMOoNd8oCu8DtrC4H97ivRvfZvd89
 oiI0VzYXzcUOhPcN8KSsOcYzVMXiWdNZB4iz1QlExfPKVA6DZk
 x4MIrRqXNbnUAxGAFdS3phqsuCHrm0WxAzOfvwP/pceCMs1h9P
 iEDZO5mi2etspcZOwrf+KHO6nXYOkqynnZhnFor1e1Sya3GtbN
 ir1AXLAHn+NuwNjWSSzQGWJ4edsrk/L3mVeh2NyvqWABBzYqFC
 gsdI52ZXun0cA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-msm/smd.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
index 657be73..f4e475c 100644
--- a/arch/arm/mach-msm/smd.c
+++ b/arch/arm/mach-msm/smd.c
@@ -52,13 +52,14 @@ static int msm_smd_debug_mask;
 
 struct shared_info {
 	int ready;
-	unsigned state;
+	void __iomem *state;
 };
 
 static unsigned dummy_state[SMSM_STATE_COUNT];
 
 static struct shared_info smd_info = {
-	.state = (unsigned) &dummy_state,
+	/* FIXME: not a real __iomem pointer */
+	.state = &dummy_state,
 };
 
 module_param_named(debug_mask, msm_smd_debug_mask,
@@ -796,22 +797,22 @@ void *smem_alloc(unsigned id, unsigned size)
 	return smem_find(id, size);
 }
 
-void *smem_item(unsigned id, unsigned *size)
+void __iomem *smem_item(unsigned id, unsigned *size)
 {
 	struct smem_shared *shared = (void *) MSM_SHARED_RAM_BASE;
 	struct smem_heap_entry *toc = shared->heap_toc;
 
 	if (id >= SMEM_NUM_ITEMS)
-		return 0;
+		return NULL;
 
 	if (toc[id].allocated) {
 		*size = toc[id].size;
-		return (void *) (MSM_SHARED_RAM_BASE + toc[id].offset);
+		return (MSM_SHARED_RAM_BASE + toc[id].offset);
 	} else {
 		*size = 0;
 	}
 
-	return 0;
+	return NULL;
 }
 
 void *smem_find(unsigned id, unsigned size_in)
@@ -857,7 +858,7 @@ static irqreturn_t smsm_irq_handler(int irq, void *data)
 int smsm_change_state(enum smsm_state_item item,
 		      uint32_t clear_mask, uint32_t set_mask)
 {
-	unsigned long addr = smd_info.state + item * 4;
+	void __iomem *addr = smd_info.state + item * 4;
 	unsigned long flags;
 	unsigned state;
 
@@ -943,10 +944,10 @@ int smd_core_init(void)
 	/* wait for essential items to be initialized */
 	for (;;) {
 		unsigned size;
-		void *state;
+		void __iomem *state;
 		state = smem_item(SMEM_SMSM_SHARED_STATE, &size);
 		if (size == SMSM_V1_SIZE || size == SMSM_V2_SIZE) {
-			smd_info.state = (unsigned)state;
+			smd_info.state = state;
 			break;
 		}
 	}
-- 
1.7.10

