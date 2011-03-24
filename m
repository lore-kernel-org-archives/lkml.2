Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab1CXGCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:02:39 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:47231 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027Ab1CXGCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:02:37 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <jamie@jamieiles.com>
Cc: <shiraz.hashim@st.com>, <armando.visconti@st.com>,
        <ajay.khandelwal@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] dmaengine/dw_dmac fix: dwc_scan_descriptors must compare first desc address also with llp
Date: Thu, 24 Mar 2011 11:32:15 +0530
Message-ID: <d8ab376fabe638f25a66be559e64cc043e8d1dd4.1300946288.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dwc_scan_descriptors scans all descriptors from active_list in case transfer is
not completed.  It compares first_desc->lli.llp, and then all childrens of its
tx_list. But it doesn't compare its own address, i.e. first_desc->txd.phys, as
this is what we have initially programmed into the controller register. So this
causes dma to stop and finish a transfer, which was never started. And thus
fail.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index b95e6d3..1bd4803 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -304,6 +304,11 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
+		/* check first descriptors addr */
+		if (desc->txd.phys == llp)
+			return;
+
+		/* check first descriptors llp */
 		if (desc->lli.llp == llp)
 			/* This one is currently in progress */
 			return;
-- 
1.7.2.2

