Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1ANFqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:46:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:32967 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1ANFqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:46:05 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] staging: tidspbridge: configure full L1 MMU range
Date: Thu, 13 Jan 2011 23:34:52 -0600
Message-Id: <1294983293-10177-2-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
References: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guzman Lugo, Fernando <fernando.lugo@ti.com>

IVA MMU can manage up to 4GB of address space through its page tables,
given that it's L1 is divided into 1MB sections it requires at least
16KB for its table which represents 4096 entries of 32 bits each.

Previously, only 1GB was being handled by setting the page table size
to 4KB, any virtual address beyond of the L1 size used, would fall
into memory that does not belong to L1 translation tables, leading to
unpredictable results.

So, set the L1 table size to cover the entire MMU range (4GB) whether
is meant to be used or not.

Reported-by: Felipe Contreras <felipe.contreras@nokia.com>
Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 1be081f..d6f333e 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -786,10 +786,7 @@ static int bridge_dev_create(struct bridge_dev_context
 
 	pt_attrs = kzalloc(sizeof(struct pg_table_attrs), GFP_KERNEL);
 	if (pt_attrs != NULL) {
-		/* Assuming that we use only DSP's memory map
-		 * until 0x4000:0000 , we would need only 1024
-		 * L1 enties i.e L1 size = 4K */
-		pt_attrs->l1_size = 0x1000;
+		pt_attrs->l1_size = SZ_16K; /* 4096 entries of 32 bits */
 		align_size = pt_attrs->l1_size;
 		/* Align sizes are expected to be power of 2 */
 		/* we like to get aligned on L1 table size */
-- 
1.7.1

