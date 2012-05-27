Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2E0A6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:58:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab2E0A55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:57:57 -0400
Message-Id: <20120527002615.793188413@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:26 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 13/55] RDMA/cxgb4: Drop peer_abort when no endpoint found
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2316,6 +2316,12 @@ static int peer_abort_intr(struct c4iw_d
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


