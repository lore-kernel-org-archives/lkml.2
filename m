Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0H0F6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:58:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59077 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab0H0F5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:57:44 -0400
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/dma: Remove potential NULL dereference
Date: Fri, 27 Aug 2010 07:57:19 +0200
Message-Id: <1282888640-27042-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282888640-27042-1-git-send-email-julia@diku.dk>
References: <1282888640-27042-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each case, it appears that the NULL test is not necessary.  In the first
case, the function pl08x_fill_llis_for_desc is only called in a case where
its argument is computed using container_of.  In the second case, the
function pl08x_tasklet is only used as the second argument of tasklet_init,
from which its argument should be the third argument of tasklet_init.  But
that value is not NULL at the point of calling tasklet_init, in
pl08x_dma_init_virtual_channels.

The sematic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/dma/amba-pl08x.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index fc5aaeb..ac675d2 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -626,11 +626,6 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	struct lli *llis_va;
 	struct lli *llis_bus;
 
-	if (!txd) {
-		dev_err(&pl08x->adev->dev, "%s no descriptor\n", __func__);
-		return 0;
-	}
-
 	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_KERNEL,
 				      &txd->llis_bus);
 	if (!txd->llis_va) {
@@ -1033,9 +1028,6 @@ static void pl08x_tasklet(unsigned long data)
 	struct pl08x_driver_data *pl08x = plchan->host;
 	unsigned long flags;
 
-	if (!plchan)
-		BUG();
-
 	spin_lock_irqsave(&plchan->lock, flags);
 
 	if (plchan->at) {

