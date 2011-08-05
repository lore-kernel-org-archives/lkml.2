Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1HEKHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:07:54 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:41856 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab1HEKD4 (ORCPT
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
Subject: [PATCH V3 12/20] dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
Date: Fri, 5 Aug 2011 15:32:37 +0530
Message-ID: <e7d6848afa263777807f3484bc94b13c92355ae0.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pl080 Manual says: "Bursts do not cross the 1KB address boundary"

We can program the controller to cross 1 KB boundary on a burst and controller
can take care of this boundary condition by itself.

Following is the discussion with ARM Technical Support Guys (David):
[Viresh] Manual says: "Bursts do not cross the 1KB address boundary"

What does that actually mean? As, Maximum size transferable with a single LLI is
4095 * 4 =16380 ~ 16KB. So, if we don't have src/dest address aligned to burst
size, we can't use this big of an LLI.

[David] There is a difference between bursts describing the total data
transferred by the DMA controller and AHB bursts. Bursts described by the
programmable parameters in the PL080 have no direct connection with the bursts
that are seen on the AHB bus.

The statement that "Bursts do not cross the 1KB address boundary" in the TRM is
referring to AHB bursts, where this limitation is a requirement of the AHB spec.
You can still issue bursts within the PL080 that are in excess of 1KB. The
PL080 will make sure that its bursts are broken down into legal AHB bursts which
will be formatted to ensure that no AHB burst crosses a 1KB boundary.

Based on above discussion, this patch removes all code related to 1 KB boundary
as we are not required to handle this in driver.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c   |  141 +++++--------------------------------------
 include/linux/amba/pl08x.h |    2 -
 2 files changed, 17 insertions(+), 126 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6bba32e..be9a1c7 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -149,14 +149,6 @@ struct pl08x_driver_data {
  * PL08X specific defines
  */
 
-/*
- * Memory boundaries: the manual for PL08x says that the controller
- * cannot read past a 1KiB boundary, so these defines are used to
- * create transfer LLIs that do not cross such boundaries.
- */
-#define PL08X_BOUNDARY_SHIFT		(10)	/* 1KB 0x400 */
-#define PL08X_BOUNDARY_SIZE		(1 << PL08X_BOUNDARY_SHIFT)
-
 /* Size (bytes) of each LLI buffer allocated for one transfer */
 # define PL08X_LLI_TSFR_SIZE	0x2000
 
@@ -568,18 +560,6 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 }
 
 /*
- * Return number of bytes to fill to boundary, or len.
- * This calculation works for any value of addr.
- */
-static inline size_t pl08x_pre_boundary(u32 addr, size_t len)
-{
-	size_t boundary_len = PL08X_BOUNDARY_SIZE -
-			(addr & (PL08X_BOUNDARY_SIZE - 1));
-
-	return min(boundary_len, len);
-}
-
-/*
  * This fills in the table of LLIs for the transfer descriptor
  * Note that we assume we never have to change the burst sizes
  * Return 0 for error
@@ -685,118 +665,30 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		 * width left
 		 */
 		while (bd.remainder > (mbus->buswidth - 1)) {
-			size_t lli_len, target_len, tsize, odd_bytes;
+			size_t lli_len, tsize;
 
 			/*
 			 * If enough left try to send max possible,
 			 * otherwise try to send the remainder
 			 */
-			target_len = min(bd.remainder, max_bytes_per_lli);
-
+			lli_len = min(bd.remainder, max_bytes_per_lli);
 			/*
-			 * Set bus lengths for incrementing buses to the
-			 * number of bytes which fill to next memory boundary,
-			 * limiting on the target length calculated above.
+			 * Check against minimum bus alignment: Calculate actual
+			 * transfer size in relation to bus width and get a
+			 * maximum remainder of the smallest bus width - 1
 			 */
-			if (cctl & PL080_CONTROL_SRC_INCR)
-				bd.srcbus.fill_bytes =
-					pl08x_pre_boundary(bd.srcbus.addr,
-						target_len);
-			else
-				bd.srcbus.fill_bytes = target_len;
-
-			if (cctl & PL080_CONTROL_DST_INCR)
-				bd.dstbus.fill_bytes =
-					pl08x_pre_boundary(bd.dstbus.addr,
-						target_len);
-			else
-				bd.dstbus.fill_bytes = target_len;
-
-			/* Find the nearest */
-			lli_len	= min(bd.srcbus.fill_bytes,
-				      bd.dstbus.fill_bytes);
-
-			BUG_ON(lli_len > bd.remainder);
-
-			if (lli_len <= 0) {
-				dev_err(&pl08x->adev->dev,
-					"%s lli_len is %zu, <= 0\n",
-						__func__, lli_len);
-				return 0;
-			}
-
-			if (lli_len == target_len) {
-				/*
-				 * Can send what we wanted.
-				 * Maintain alignment
-				 */
-				lli_len	= (lli_len/mbus->buswidth) *
-							mbus->buswidth;
-				odd_bytes = 0;
-			} else {
-				/*
-				 * So now we know how many bytes to transfer
-				 * to get to the nearest boundary.  The next
-				 * LLI will past the boundary.  However, we
-				 * may be working to a boundary on the slave
-				 * bus.  We need to ensure the master stays
-				 * aligned, and that we are working in
-				 * multiples of the bus widths.
-				 */
-				odd_bytes = lli_len % mbus->buswidth;
-				lli_len -= odd_bytes;
-
-			}
-
-			if (lli_len) {
-				/*
-				 * Check against minimum bus alignment:
-				 * Calculate actual transfer size in relation
-				 * to bus width an get a maximum remainder of
-				 * the smallest bus width - 1
-				 */
-				/* FIXME: use round_down()? */
-				tsize = lli_len / min(mbus->buswidth,
-						      sbus->buswidth);
-				lli_len	= tsize * min(mbus->buswidth,
-						      sbus->buswidth);
-
-				if (target_len != lli_len) {
-					dev_vdbg(&pl08x->adev->dev,
-					"%s can't send what we want. Desired 0x%08zx, lli of 0x%08zx bytes in txd of 0x%08zx\n",
-					__func__, target_len, lli_len, txd->len);
-				}
-
-				cctl = pl08x_cctl_bits(cctl,
-						       bd.srcbus.buswidth,
-						       bd.dstbus.buswidth,
-						       tsize);
-
-				dev_vdbg(&pl08x->adev->dev,
-					"%s fill lli with single lli chunk of size 0x%08zx (remainder 0x%08zx)\n",
-					__func__, lli_len, bd.remainder);
-				pl08x_fill_lli_for_desc(&bd, num_llis++,
-					lli_len, cctl);
-				total_bytes += lli_len;
-			}
+			tsize = lli_len / min(mbus->buswidth, sbus->buswidth);
+			lli_len	= tsize * min(mbus->buswidth, sbus->buswidth);
 
-			if (odd_bytes) {
-				/*
-				 * Creep past the boundary, maintaining
-				 * master alignment
-				 */
-				int j;
-				for (j = 0; (j < mbus->buswidth)
-						&& (bd.remainder); j++) {
-					cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
-					dev_vdbg(&pl08x->adev->dev,
-						"%s align with boundary, single byte (remain 0x%08zx)\n",
-						__func__, bd.remainder);
-					pl08x_fill_lli_for_desc(&bd,
-						num_llis++, 1, cctl);
-					total_bytes++;
-				}
-			}
+			dev_vdbg(&pl08x->adev->dev,
+				"%s fill lli with single lli chunk of "
+				"size 0x%08zx (remainder 0x%08zx)\n",
+				__func__, lli_len, bd.remainder);
+
+			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
+					bd.dstbus.buswidth, tsize);
+			pl08x_fill_lli_for_desc(&bd, num_llis++, lli_len, cctl);
+			total_bytes += lli_len;
 		}
 
 		/*
@@ -811,6 +703,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			total_bytes++;
 		}
 	}
+
 	if (total_bytes != txd->len) {
 		dev_err(&pl08x->adev->dev,
 			"%s size of encoded lli:s don't match total txd, transferred 0x%08zx from size 0x%08zx\n",
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index cd8f629..ecd17f5 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -77,13 +77,11 @@ struct pl08x_channel_data {
  * @addr: current address
  * @maxwidth: the maximum width of a transfer on this bus
  * @buswidth: the width of this bus in bytes: 1, 2 or 4
- * @fill_bytes: bytes required to fill to the next bus memory boundary
  */
 struct pl08x_bus_data {
 	dma_addr_t addr;
 	u8 maxwidth;
 	u8 buswidth;
-	size_t fill_bytes;
 };
 
 /**
-- 
1.7.2.2

