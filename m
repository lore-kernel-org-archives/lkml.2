Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1G2KwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:52:16 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:34437 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756298Ab1G2KwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:52:13 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH] dmaengine/dmatest: Terminate transfers on all channels in case of error or exit
Date: Fri, 29 Jul 2011 16:21:57 +0530
Message-ID: <4560606c5b6665b47d22c571cd60e526e551c639.1311935349.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case, some error occurs while doing memcpy transfers, we must terminate all
transfers physically too. This is achieved by calling device_control() routine
with TERMINATE_ALL as parameter.

This is also required to be done in case module is removed while we are in
middle of some transfers.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dmatest.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index b4f5c32..cd8ae03 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -476,6 +476,8 @@ err_srcs:
 	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
 			thread_name, total_tests, failed_tests, ret);
 
+	/* terminate all transfers on specified channels */
+	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
 			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
@@ -498,6 +500,10 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 		list_del(&thread->node);
 		kfree(thread);
 	}
+
+	/* terminate all transfers on specified channels */
+	dtc->chan->device->device_control(dtc->chan, DMA_TERMINATE_ALL, 0);
+
 	kfree(dtc);
 }
 
-- 
1.7.2.2

