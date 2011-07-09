Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1GIWXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 18:23:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41175 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab1GIWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 18:23:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 10 Jul 2011 00:23:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: ohci: do not bind to Pinnacle cards, prevent
 panic
Message-ID: <20110710002303.2aeee41c@stein>
In-Reply-To: <20110709235410.08004e5d@stein>
References: <20110604002938.78c85881@stein>
	<20110604010625.1a37638e@stein>
	<4DEA697A.1090104@bourrigaud.info>
	<20110612145303.2099aa81@stein>
	<4DF4FF4F.4020607@bourrigaud.info>
	<20110612210111.3e979131@stein>
	<4DF528CF.50407@bourrigaud.info>
	<20110709235410.08004e5d@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When firewire-ohci is bound to a Pinnacle MovieBoard, eventually a
"Register access failure" is logged and an interrupt storm or a kernel
panic happens.  https://bugzilla.kernel.org/show_bug.cgi?id=36622

Until this is sorted out (if that is going to succeed at all), let's
just prevent firewire-ohci from touching these devices.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
---
 drivers/firewire/ohci.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -263,6 +263,7 @@ static char ohci_driver_name[] = KBUILD_
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 
 #define QUIRK_CYCLE_TIMER		1
 #define QUIRK_RESET_PACKET		2
@@ -3202,6 +3203,11 @@ static int __devinit pci_probe(struct pc
 	int i, err;
 	size_t size;
 
+	if (dev->vendor == PCI_VENDOR_ID_PINNACLE_SYSTEMS) {
+		dev_err(&dev->dev, "Pinnacle MovieBoard not yet supported\n");
+		return -ENOSYS;
+	}
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		err = -ENOMEM;



-- 
Stefan Richter
-=====-==-== -=== -=-=-
http://arcgraph.de/sr/
