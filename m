Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2KHC5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:57:01 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53799 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754966Ab2KHC46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:56:58 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Aaron Sierra <asierra@xes-inc.com>, Peter Tyser <ptyser@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 5/5] drivers: mfd: Fix resource request for [mem 0x00000000]
Date: Wed,  7 Nov 2012 21:55:56 -0500
Message-Id: <1352343356-4006-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
References: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The older southbridges supported by the lpc_ich driver do not
provide memory-mapped space of the root complex. The driver
correctly avoids computing the iomem address in this case, yet
submits a zeroed resource request anyway (via mfd_add_devices()).

Remove the iomem resource from the resource array submitted to the
mfd core for the older southbridges.

Cc: Aaron Sierra <asierra@xes-inc.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/mfd/lpc_ich.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index a22544f..a46095b 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -842,6 +842,9 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 		res = wdt_mem_res(ICH_RES_MEM_GCS);
 		res->start = base_addr + ACPIBASE_GCS_OFF;
 		res->end = base_addr + ACPIBASE_GCS_END;
+	} else {
+		/* So don't register iomem for TCO ver 1 */
+		--lpc_ich_cells[LPC_WDT].num_resources;
 	}
 
 	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
-- 
1.7.12.3

