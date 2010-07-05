Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0GELmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:42:03 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:36068 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0GELmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:42:00 -0400
Date: Mon, 5 Jul 2010 13:41:56 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: [PATCH] ib/ehca: init irq tasklet before irq can happen
Message-ID: <20100705134156.36803536@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize tasklet before interrupts are requested to prevent scheduling of
uninitialized tasklet.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
Hi Roland, please queue this fix for 2.6.36, thanks!

 drivers/infiniband/hw/ehca/ehca_eq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_eq.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -122,21 +122,21 @@ int ehca_create_eq(struct ehca_shca *shc
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
+		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
+
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
-
-		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
+		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
+
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
-
-		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
 	}
 
 	eq->is_initialized = 1;
