Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1BPAVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:22 -0500
Received: from kroah.org ([198.145.64.141]:39254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab1BPAVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:36 2011
Message-Id: <20110216001436.594083033@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>
Subject: [115/272] RDMA/cxgb4: Dont re-init wait object in init/fini paths
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit db8b10167126d72829653690f57b9c7ca53c4d54 upstream.

Re-initializing the wait object in rdma_init()/rdma_fini() causes a
timing window which can lead to a deadlock during close.  Once this
deadlock hits, all RDMA activity over the T4 device will be stuck.

There's no need to re-init the wait object, so remove it.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/cxgb4/qp.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1029,7 +1029,6 @@ static int rdma_fini(struct c4iw_dev *rh
 	wqe->cookie = (unsigned long) &ep->com.wr_wait;
 
 	wqe->u.fini.type = FW_RI_TYPE_FINI;
-	c4iw_init_wr_wait(&ep->com.wr_wait);
 	ret = c4iw_ofld_send(&rhp->rdev, skb);
 	if (ret)
 		goto out;
@@ -1125,7 +1124,6 @@ static int rdma_init(struct c4iw_dev *rh
 	if (qhp->attr.mpa_attr.initiator)
 		build_rtr_msg(qhp->attr.mpa_attr.p2p_type, &wqe->u.init);
 
-	c4iw_init_wr_wait(&qhp->ep->com.wr_wait);
 	ret = c4iw_ofld_send(&rhp->rdev, skb);
 	if (ret)
 		goto out;


