Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1HEKGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:06:10 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51881 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab1HEKD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:58 -0400
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
Subject: [PATCH V3 13/20] dmaengine/amba-pl08x: max_bytes_per_lli is TRANSFER_SIZE * src_width (not MIN(width))
Date: Fri, 5 Aug 2011 15:32:38 +0530
Message-ID: <825c3c3dce9dbb46097f66988c3b8517dc6d8407.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_bytes_per_lli = bd.srcbus.buswidth * PL080_CONTROL_TRANSFER_SIZE_MASK;
This is confirmed by ARM support guys.

Below is summary of mail exchange with them:

[Viresh] What is the total data to be transferred in case source and destination
bus widths are different. Suppose, source bus width is 2 bytes and destination
is 4 bytes. Now in order to transfer 80 bytes, what should be value of
TransferSize field in control reg: 40? or 20?.

[David from ARM] The value that is programmed into the TransferSize field should
be the number of <SourceWidth> transfers needed to achieve the required data
transfer.

So, to transfer 80 bytes, with a Source Width of 2, the TransferSize field =
should be programmed with:

        Total transfer size
        ------------------- = 40
          <source width>

[Viresh] Will this change if source is 4 bytes and dest is 2?

[David] Yes - the calculation then becomes:

        Total transfer size
        ------------------- =20
          <source width>

Also, max_bytes_per_lli must be calculated after fixing src and dest widths not
before that. So move this code to the correct place.

This patch also removes max_bytes_per_lli from earlier print message, as till
that point max_bytes_per_lli is unknown.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index be9a1c7..e5930d5 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -604,23 +604,17 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	bd.srcbus.buswidth = bd.srcbus.maxwidth;
 	bd.dstbus.buswidth = bd.dstbus.maxwidth;
 
-	/*
-	 * Bytes transferred == tsize * MIN(buswidths), not max(buswidths)
-	 */
-	max_bytes_per_lli = min(bd.srcbus.buswidth, bd.dstbus.buswidth) *
-		PL080_CONTROL_TRANSFER_SIZE_MASK;
-
 	/* We need to count this down to zero */
 	bd.remainder = txd->len;
 
 	pl08x_choose_master_bus(&bd, &mbus, &sbus, cctl);
 
-	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu llimax=%zu\n",
+	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu\n",
 		 bd.srcbus.addr, cctl & PL080_CONTROL_SRC_INCR ? "+" : "",
 		 bd.srcbus.buswidth,
 		 bd.dstbus.addr, cctl & PL080_CONTROL_DST_INCR ? "+" : "",
 		 bd.dstbus.buswidth,
-		 bd.remainder, max_bytes_per_lli);
+		 bd.remainder);
 	dev_vdbg(&pl08x->adev->dev, "mbus=%s sbus=%s\n",
 		 mbus == &bd.srcbus ? "src" : "dst",
 		 sbus == &bd.srcbus ? "src" : "dst");
@@ -660,6 +654,10 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			sbus->buswidth = 1;
 		}
 
+		/* Bytes transferred = tsize * src width, not MIN(buswidths) */
+		max_bytes_per_lli = bd.srcbus.buswidth *
+			PL080_CONTROL_TRANSFER_SIZE_MASK;
+
 		/*
 		 * Make largest possible LLIs until less than one bus
 		 * width left
-- 
1.7.2.2

