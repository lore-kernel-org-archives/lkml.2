Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1HEKEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:04:09 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:54586 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab1HEKD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:56 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <alim.akhtar@gmail.com>
Subject: [PATCH V3 15/20] dmaengine/amba-pl08x: Align lli_len to max(src.width, dst.width)
Date: Fri, 5 Aug 2011 15:32:40 +0530
Message-ID: <8967f2741aae7a7a76afb0c5b3658b91b9259f4f.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently lli_len is aligned to min of two widths, which looks to be incorrect.
Instead it should be aligned to max of both widths.

Lets say, total_size = 441 bytes

MIN: lets check if min() suits or not:

CASE 1: srcwidth = 1, dstwidth = 4
min(src, dst) = 1

i.e. We program transfer size in control reg to 441.
Now, till 440 bytes everything is fine, but on the last byte DMAC can't transfer
1 byte to dst, as its width is 4.

CASE 2: srcwidth = 4, dstwidth = 1
min(src, dst) = 1

i.e. we program transfer size in control reg to 110 (data transferred = 110 * srcwidth).
So, here too 1 byte is left, but on the source side.

MAX: Lets check if max() suits or not:

CASE 3: srcwidth = 1, dstwidth = 4
max(src, dst) = 4

Aligned size is 440

i.e. We program transfer size in control reg to 440.
Now, all 440 bytes will be transferred without any issues.

CASE 4: srcwidth = 4, dstwidth = 1
max(src, dst) = 4

Aligned size is 440

i.e. We program transfer size in control reg to 110 (data transferred = 110 * srcwidth).
Now, also all 440 bytes will be transferred without any issues.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 45d8a5d..4bcf603 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -669,20 +669,22 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		 * width left
 		 */
 		while (bd.remainder > (mbus->buswidth - 1)) {
-			size_t lli_len, tsize;
+			size_t lli_len, tsize, width;
 
 			/*
 			 * If enough left try to send max possible,
 			 * otherwise try to send the remainder
 			 */
 			lli_len = min(bd.remainder, max_bytes_per_lli);
+
 			/*
-			 * Check against minimum bus alignment: Calculate actual
+			 * Check against maximum bus alignment: Calculate actual
 			 * transfer size in relation to bus width and get a
-			 * maximum remainder of the smallest bus width - 1
+			 * maximum remainder of the highest bus width - 1
 			 */
-			tsize = lli_len / min(mbus->buswidth, sbus->buswidth);
-			lli_len	= tsize * min(mbus->buswidth, sbus->buswidth);
+			width = max(mbus->buswidth, sbus->buswidth);
+			lli_len = (lli_len / width) * width;
+			tsize = lli_len / bd.srcbus.buswidth;
 
 			dev_vdbg(&pl08x->adev->dev,
 				"%s fill lli with single lli chunk of "
-- 
1.7.2.2

