Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2E1Dvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:51:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51926 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532Ab2E1D3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:13 -0400
Message-Id: <20120528031206.893744346@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 029/117] RDMA/cxgb4: Drop peer_abort when no endpoint found
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

commit 14b9222808bb8bfefc71f72bc0dbdcf3b2f0140f upstream.

Log a warning and drop the abort message.  Otherwise we will do a
bogus wake_up() and crash.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/cxgb4/cm.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b770a044..4c7c62f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2656,6 +2656,12 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 	unsigned int tid = GET_TID(req);
 
 	ep = lookup_tid(t, tid);
+	if (!ep) {
+		printk(KERN_WARNING MOD
+		       "Abort on non-existent endpoint, tid %d\n", tid);
+		kfree_skb(skb);
+		return 0;
+	}
 	if (is_neg_adv_abort(req->status)) {
 		PDBG("%s neg_adv_abort ep %p tid %u\n", __func__, ep,
 		     ep->hwtid);


