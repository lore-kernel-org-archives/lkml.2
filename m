Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965638Ab2E0BdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:33:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965554Ab2E0BPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:15:14 -0400
Message-Id: <20120527002509.906345158@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:20 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 14/91] RDMA/cxgb4: Always wake up waiters in c4iw_peer_abort_intr()
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 0f1dcfae6bc5563424346ad3a03282b8235a4c33 upstream.

This fixes a race where an ingress abort fails to wake up the thread
blocked in rdma_init() causing the app to hang.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/cxgb4/cm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2667,11 +2667,8 @@ static int peer_abort_intr(struct c4iw_d
 
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


