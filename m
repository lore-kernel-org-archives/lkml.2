Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2E1DwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:52:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51924 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530Ab2E1D3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:12 -0400
Message-Id: <20120528031206.762344541@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 028/117] RDMA/cxgb4: Always wake up waiters in c4iw_peer_abort_intr()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 0f1dcfae6bc5563424346ad3a03282b8235a4c33 upstream.

This fixes a race where an ingress abort fails to wake up the thread
blocked in rdma_init() causing the app to hang.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/cxgb4/cm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 86542cd..b770a044 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2667,11 +2667,8 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	/*
 	 * Wake up any threads in rdma_init() or rdma_fini().
-	 * However, this is not needed if com state is just
-	 * MPA_REQ_SENT
 	 */
-	if (ep->com.state != MPA_REQ_SENT)
-		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 	sched(dev, skb);
 	return 0;
 }


