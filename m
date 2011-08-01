Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1HAJlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:41:40 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47089 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551Ab1HAJjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:36 -0400
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
Subject: [PATCH V2 14/20] dmaengine/amba-pl08x: Add prep_single_byte_llis() routine
Date: Mon, 1 Aug 2011 15:07:24 +0530
Message-ID: <9d3d9fcd8c6268b6bfc85f0d150a46e60d7fc4c5.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code for creating single byte llis is present at several places. Create a
routine to avoid code redundancy.

Also, we don't need one lli per single byte transfer, we can have single lli to
do all single byte transfer.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   61 +++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index c29e55c..0bdf3b8 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -556,6 +556,14 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 	bd->remainder -= len;
 }
 
+static inline void prep_byte_width_lli(struct pl08x_lli_build_data *bd,
+		u32 *cctl, u32 len, int num_llis, size_t *total_bytes)
+{
+	*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
+	pl08x_fill_lli_for_desc(bd, num_llis, len, *cctl);
+	(*total_bytes) += len;
+}
+
 /*
  * This fills in the table of LLIs for the transfer descriptor
  * Note that we assume we never have to change the burst sizes
@@ -567,7 +575,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	struct pl08x_bus_data *mbus, *sbus;
 	struct pl08x_lli_build_data bd;
 	int num_llis = 0;
-	u32 cctl;
+	u32 cctl, early_bytes = 0;
 	size_t max_bytes_per_lli, total_bytes = 0;
 	struct pl08x_lli *llis_va;
 
@@ -616,29 +624,27 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		 mbus == &bd.srcbus ? "src" : "dst",
 		 sbus == &bd.srcbus ? "src" : "dst");
 
-	if (txd->len < mbus->buswidth) {
-		/* Less than a bus width available - send as single bytes */
-		while (bd.remainder) {
-			dev_vdbg(&pl08x->adev->dev,
-				 "%s single byte LLIs for a transfer of "
-				 "less than a bus width (remain 0x%08x)\n",
-				 __func__, bd.remainder);
-			cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
-			pl08x_fill_lli_for_desc(&bd, num_llis++, 1, cctl);
-			total_bytes++;
-		}
-	} else {
-		/* Make one byte LLIs until master bus is aligned */
-		while ((mbus->addr) % (mbus->buswidth)) {
-			dev_vdbg(&pl08x->adev->dev,
-				"%s adjustment lli for less than bus width "
-				 "(remain 0x%08x)\n",
-				 __func__, bd.remainder);
-			cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
-			pl08x_fill_lli_for_desc(&bd, num_llis++, 1, cctl);
-			total_bytes++;
-		}
+	/*
+	 * Send byte by byte for following cases
+	 * - Less than a bus width available
+	 * - until master bus is aligned
+	 */
+	if (bd.remainder < mbus->buswidth)
+		early_bytes = bd.remainder;
+	else if ((mbus->addr) % (mbus->buswidth)) {
+		early_bytes = mbus->buswidth - (mbus->addr) % (mbus->buswidth);
+		if ((bd.remainder - early_bytes) < mbus->buswidth)
+			early_bytes = bd.remainder;
+	}
+
+	if (early_bytes) {
+		dev_vdbg(&pl08x->adev->dev, "%s byte width LLIs "
+				"(remain 0x%08x)\n", __func__, bd.remainder);
+		prep_byte_width_lli(&bd, &cctl, early_bytes, num_llis++,
+				&total_bytes);
+	}
 
+	if (bd.remainder) {
 		/*
 		 * Master now aligned
 		 * - if slave is not then we must set its width down
@@ -689,13 +695,12 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		/*
 		 * Send any odd bytes
 		 */
-		while (bd.remainder) {
-			cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
+		if (bd.remainder) {
 			dev_vdbg(&pl08x->adev->dev,
-				"%s align with boundary, single odd byte (remain %zu)\n",
+				"%s align with boundary, send odd bytes (remain %zu)\n",
 				__func__, bd.remainder);
-			pl08x_fill_lli_for_desc(&bd, num_llis++, 1, cctl);
-			total_bytes++;
+			prep_byte_width_lli(&bd, &cctl, bd.remainder,
+					num_llis++, &total_bytes);
 		}
 	}
 
-- 
1.7.2.2

