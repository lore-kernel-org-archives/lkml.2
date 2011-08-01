Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1HAJkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:40:20 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:51394 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab1HAJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:51 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH V2 16/20] dmaengine/amba-pl08x: Choose peripheral bus as master bus
Date: Mon, 1 Aug 2011 15:07:26 +0530
Message-ID: <f7c6713e493ea64cbb9a659753f3ba508f033a86.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have DMA transfers between peripheral and memory, then we shouldn't
reduce width of peripheral at all, as that may be a strict requirement. But we
can always reduce width of memory access, with some compromise in performance.
Thus, we must select peripheral as master and not memory.

Also this rearranges code to make it shorter.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index ef02fb9..c969309 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -496,34 +496,24 @@ struct pl08x_lli_build_data {
  * byte data), slave is still not aligned, then its width will be reduced to
  * BYTE.
  * - prefers the destination bus if both available
- * - if fixed address on one bus the other will be chosen
+ * - prefers bus with fixed address (i.e. peripheral)
  */
 static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
 	struct pl08x_bus_data **mbus, struct pl08x_bus_data **sbus, u32 cctl)
 {
 	if (!(cctl & PL080_CONTROL_DST_INCR)) {
-		*mbus = &bd->srcbus;
-		*sbus = &bd->dstbus;
-	} else if (!(cctl & PL080_CONTROL_SRC_INCR)) {
 		*mbus = &bd->dstbus;
 		*sbus = &bd->srcbus;
+	} else if (!(cctl & PL080_CONTROL_SRC_INCR)) {
+		*mbus = &bd->srcbus;
+		*sbus = &bd->dstbus;
 	} else {
-		if (bd->dstbus.buswidth == 4) {
-			*mbus = &bd->dstbus;
-			*sbus = &bd->srcbus;
-		} else if (bd->srcbus.buswidth == 4) {
-			*mbus = &bd->srcbus;
-			*sbus = &bd->dstbus;
-		} else if (bd->dstbus.buswidth == 2) {
+		if (bd->dstbus.buswidth >= bd->srcbus.buswidth) {
 			*mbus = &bd->dstbus;
 			*sbus = &bd->srcbus;
-		} else if (bd->srcbus.buswidth == 2) {
+		} else {
 			*mbus = &bd->srcbus;
 			*sbus = &bd->dstbus;
-		} else {
-			/* bd->srcbus.buswidth == 1 */
-			*mbus = &bd->dstbus;
-			*sbus = &bd->srcbus;
 		}
 	}
 }
-- 
1.7.2.2

