Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0GLPtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:49:47 -0400
Received: from mxout-07.mxes.net ([216.86.168.182]:35966 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab0GLPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:49:45 -0400
From: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Bri=C3=A8re?= <fbriere@fbriere.net>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, linux-parport@lists.infradead.org
Subject: [PATCH 1/2] serial: 8250_pci: add .probe member to struct pci_serial_quirk
Date: Mon, 12 Jul 2010 11:49:42 -0400
Message-Id: <1278949783-2820-1-git-send-email-fbriere@fbriere.net>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100712154448.GA2558@toroia.fbriere.dyndns.org>
References: <20100712154448.GA2558@toroia.fbriere.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function, if present, is called early on by the 8250_pci probe; it
can be used to reject devices meant for parport_serial.  (The .init
function cannot be used for this purpose, as it is also called by
parport_serial.)

Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
---
 drivers/serial/8250_pci.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 01c012d..d9b9a63 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -41,6 +41,7 @@ struct pci_serial_quirk {
 	u32	device;
 	u32	subvendor;
 	u32	subdevice;
+	int	(*probe)(struct pci_dev *dev);
 	int	(*init)(struct pci_dev *dev);
 	int	(*setup)(struct serial_private *,
 			 const struct pciserial_board *,
@@ -2470,11 +2471,19 @@ EXPORT_SYMBOL_GPL(pciserial_resume_ports);
 static int __devinit
 pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
 {
+	struct pci_serial_quirk *quirk;
 	struct serial_private *priv;
 	const struct pciserial_board *board;
 	struct pciserial_board tmp;
 	int rc;
 
+	quirk = find_quirk(dev);
+	if (quirk->probe) {
+		rc = quirk->probe(dev);
+		if (rc)
+			return rc;
+	}
+
 	if (ent->driver_data >= ARRAY_SIZE(pci_boards)) {
 		printk(KERN_ERR "pci_init_one: invalid driver_data: %ld\n",
 			ent->driver_data);
-- 
1.7.1

