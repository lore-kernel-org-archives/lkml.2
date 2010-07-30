Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab0G3PRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:17:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60961 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab0G3PRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:17:01 -0400
Date: Fri, 30 Jul 2010 17:16:58 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/serial/icom.c: Eliminate use after free
Message-ID: <Pine.LNX.4.64.1007301716250.17618@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Release_firmware has two definitions, one of which does nothing
(include/linux/firmware.h) and one of which always frees its argument
(drivers/base/firmware_class.c).  If the latter can be used, the access to
the size field inthe argument of writeb represents a use after free.  The
patch thus saves the size value before calling release_firmware and then
uses it afterwards.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E2;
@@

release_firmware(E)
...
(
  E = E2
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Another possibility would be to put the call to remove_firmware later.  One
could also wonder whether the first argument to writeb could be calculated
using DIV_ROUND_UP, even though the semantics is not exactly the same.

 drivers/serial/icom.c               |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 53a4682..f82e95a 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -360,6 +360,7 @@ static void load_code(struct icom_port *icom_port)
 	unsigned char *new_page = NULL;
 	unsigned char cable_id = NO_CABLE;
 	struct pci_dev *dev = icom_port->adapter->pci_dev;
+	size_t size;
 
 	/* Clear out any pending interrupts */
 	writew(0x3FFF, icom_port->int_reg);
@@ -454,9 +455,10 @@ static void load_code(struct icom_port *icom_port)
 	for (index = 0; index < fw->size; index++)
 		new_page[index] = fw->data[index];
 
+	size = fw->size;
 	release_firmware(fw);
 
-	writeb((char) ((fw->size + 16)/16), &icom_port->dram->mac_length);
+	writeb((char) ((size + 16)/16), &icom_port->dram->mac_length);
 	writel(temp_pci, &icom_port->dram->mac_load_addr);
 
 	/*Setting the syncReg to 0x80 causes adapter to start downloading
