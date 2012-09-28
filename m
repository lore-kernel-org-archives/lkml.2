Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423342Ab2I1Vda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:33:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51449 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422688Ab2I1U1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 113/218] DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_req()
Date: Fri, 28 Sep 2012 13:15:30 -0700
Message-Id: <20120928201514.475549626@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 2e2c682becb20416c140aa0d6d3137b51a5c76da upstream.

'r->cfg' is being checked for NULL. However, it is dereferenced
in the previous statements. Thus moving those statements within
the check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/pl330.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1568,17 +1568,19 @@ static int pl330_submit_req(void *ch_id,
 		goto xfer_exit;
 	}
 
-	/* Prefer Secure Channel */
-	if (!_manager_ns(thrd))
-		r->cfg->nonsecure = 0;
-	else
-		r->cfg->nonsecure = 1;
 
 	/* Use last settings, if not provided */
-	if (r->cfg)
+	if (r->cfg) {
+		/* Prefer Secure Channel */
+		if (!_manager_ns(thrd))
+			r->cfg->nonsecure = 0;
+		else
+			r->cfg->nonsecure = 1;
+
 		ccr = _prepare_ccr(r->cfg);
-	else
+	} else {
 		ccr = readl(regs + CC(thrd->id));
+	}
 
 	/* If this req doesn't have valid xfer settings */
 	if (!_is_valid(ccr)) {


