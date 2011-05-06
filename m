Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1EFPdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:33:46 -0400
Received: from relay2.sgi.com ([192.48.179.30]:53310 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463Ab1EFPdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:33:45 -0400
Date: Fri, 6 May 2011 10:33:44 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: poll waiting for I/OAT DMA channel status
Message-ID: <20110506153344.GA16977@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For certain system configurations a 5 usec udelay before checking I/OAT DMA
channel status is sometimes not sufficient, resulting in a false failure
status and unnecessary freeing of channel resources.  Conversely, for many
configurations 5 usec is longer than necessary.

Loop for up to 20 usec waiting for successful status before failing.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
___

 drivers/dma/ioat/dma_v2.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/drivers/dma/ioat/dma_v2.c
===================================================================
--- linux.orig/drivers/dma/ioat/dma_v2.c
+++ linux/drivers/dma/ioat/dma_v2.c
@@ -507,6 +507,7 @@ int ioat2_alloc_chan_resources(struct dm
 	struct ioat_ring_ent **ring;
 	u64 status;
 	int order;
+	int i = 0;
 
 	/* have we already been set up? */
 	if (ioat->ring)
@@ -547,8 +548,11 @@ int ioat2_alloc_chan_resources(struct dm
 	ioat2_start_null_desc(ioat);
 
 	/* check that we got off the ground */
-	udelay(5);
-	status = ioat_chansts(chan);
+	do {
+		udelay(1);
+		status = ioat_chansts(chan);
+	} while (i++ < 20 && !is_ioat_active(status) && !is_ioat_idle(status));
+
 	if (is_ioat_active(status) || is_ioat_idle(status)) {
 		set_bit(IOAT_RUN, &chan->state);
 		return 1 << ioat->alloc_order;
