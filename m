Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0E0MdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:33:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48511 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0E0MdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:33:23 -0400
Date: Thu, 27 May 2010 14:33:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/11] drivers/dma: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271433000.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If td_desc is NULL, just skip both kfrees.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/dma/timb_dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 0172fa3..c4eb96a 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -382,7 +382,7 @@ static struct timb_dma_desc *td_alloc_init_desc(struct timb_dma_chan *td_chan)
 	td_desc = kzalloc(sizeof(struct timb_dma_desc), GFP_KERNEL);
 	if (!td_desc) {
 		dev_err(chan2dev(chan), "Failed to alloc descriptor\n");
-		goto err;
+		goto out;
 	}
 
 	td_desc->desc_list_len = td_chan->desc_elems * TIMB_DMA_DESC_SIZE;
@@ -410,7 +410,7 @@ static struct timb_dma_desc *td_alloc_init_desc(struct timb_dma_chan *td_chan)
 err:
 	kfree(td_desc->desc_list);
 	kfree(td_desc);
-
+out:
 	return NULL;
 
 }
