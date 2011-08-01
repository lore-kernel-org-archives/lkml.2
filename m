Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1HAJke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:40:34 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:59434 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644Ab1HAJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:45 -0400
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
Subject: [PATCH V2 20/20] dmaengine/amba-pl08x: Call pl08x_free_txd() instead of calling kfree() directly
Date: Mon, 1 Aug 2011 15:07:30 +0530
Message-ID: <149303ac0cac8dd5de5506b29d7a800a223bed79.1312190882.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pl08x_prep_channel_resources() is calling kfree() directly for txd(). To
maintain consistency in code call pl08x_free_txd() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 2667e0d..063970f 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1202,7 +1202,9 @@ static int pl08x_prep_channel_resources(struct pl08x_dma_chan *plchan,
 
 	num_llis = pl08x_fill_llis_for_desc(pl08x, txd);
 	if (!num_llis) {
-		kfree(txd);
+		spin_lock_irqsave(&plchan->lock, flags);
+		pl08x_free_txd(pl08x, txd);
+		spin_unlock_irqrestore(&plchan->lock, flags);
 		return -EINVAL;
 	}
 
-- 
1.7.2.2

