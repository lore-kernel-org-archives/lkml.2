Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919Ab0LaFGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:06:09 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42161 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0LaFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:06:07 -0500
Subject: [PATCH] cx23885, cimax2.c: Fix case of two CAM insertion irq.
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        Abylai Ospan <aospan@netup.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 31 Dec 2010 07:04:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012310704.38591.liplianin@me.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example  boot up with two CAM inserted.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/video/cx23885/cimax2.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx23885/cimax2.c b/drivers/media/video/cx23885/cimax2.c
index c95e7bc..209b971 100644
--- a/drivers/media/video/cx23885/cimax2.c
+++ b/drivers/media/video/cx23885/cimax2.c
@@ -368,7 +368,7 @@ static void netup_read_ci_status(struct work_struct *work)
 				DVB_CA_EN50221_POLL_CAM_READY;
 		else
 			state->status = 0;
-	};
+	}
 }
 
 /* CI irq handler */
@@ -377,16 +377,24 @@ int netup_ci_slot_status(struct cx23885_dev *dev, u32 pci_status)
 	struct cx23885_tsport *port = NULL;
 	struct netup_ci_state *state = NULL;
 
-	if (pci_status & PCI_MSK_GPIO0)
-		port = &dev->ts1;
-	else if (pci_status & PCI_MSK_GPIO1)
-		port = &dev->ts2;
-	else /* who calls ? */
+	ci_dbg_print("%s:\n", __func__);
+
+	if (0 == (pci_status & (PCI_MSK_GPIO0 | PCI_MSK_GPIO1)))
 		return 0;
 
-	state = port->port_priv;
+	if (pci_status & PCI_MSK_GPIO0) {
+		port = &dev->ts1;
+		state = port->port_priv;
+		schedule_work(&state->work);
+		ci_dbg_print("%s: Wakeup CI0\n", __func__);
+	}
 
-	schedule_work(&state->work);
+	if (pci_status & PCI_MSK_GPIO1) {
+		port = &dev->ts2;
+		state = port->port_priv;
+		schedule_work(&state->work);
+		ci_dbg_print("%s: Wakeup CI1\n", __func__);
+	}
 
 	return 1;
 }
-- 
1.7.1

