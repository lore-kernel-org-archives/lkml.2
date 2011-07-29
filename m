Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1G2KuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:50:21 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:37544 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932166Ab1G2KuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:15 -0400
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
Subject: [PATCH 13/18] dmaengine/amba-pl08x: Align lli_len to max(src.width, dst.width)
Date: Fri, 29 Jul 2011 16:19:23 +0530
Message-ID: <afe9e5154d96c0f44c64c411c98b5db75969db6c.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
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
---
 drivers/dma/amba-pl08x.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 590397d..44f317a 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -662,20 +662,22 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
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

