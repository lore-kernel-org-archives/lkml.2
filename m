Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2E0BHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:07:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab2E0BHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:07:24 -0400
Message-Id: <20120527010426.734018249@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:44 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 21/94] RDMA/cxgb4: Drop peer_abort when no endpoint found
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 14b9222808bb8bfefc71f72bc0dbdcf3b2f0140f upstream.

Log a warning and drop the abort message.  Otherwise we will do a
bogus wake_up() and crash.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/cxgb4/cm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2654,6 +2654,12 @@ static int peer_abort_intr(struct c4iw_d
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


