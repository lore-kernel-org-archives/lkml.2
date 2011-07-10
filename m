Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1GJXYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:24:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45824 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1GJXYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:24:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 11 Jul 2011 01:24:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Joel bourrigaud <joel@bourrigaud.info>,
        =?UTF-8?B?QmrDuHJu?= Forbord <bforbord@broadpark.no>,
        linux1394-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: ohci: do not bind to Pinnacle or Fujitsu HCI,
 prevent panic
Message-ID: <20110711012422.1e585783@stein>
In-Reply-To: <4E1A161D.1050304@ladisch.de>
References: <20110604002938.78c85881@stein>
	<20110604010625.1a37638e@stein>
	<4DEA697A.1090104@bourrigaud.info>
	<20110612145303.2099aa81@stein>
	<4DF4FF4F.4020607@bourrigaud.info>
	<20110612210111.3e979131@stein>
	<4DF528CF.50407@bourrigaud.info>
	<20110709235410.08004e5d@stein>
	<4E1A161D.1050304@ladisch.de>
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

This device with link layer PCI IDs 11bd:0015 and 1394 PHY IDs
00000e:086613 is apparently a Fujitsu MB86613 --- hence the PHY IDs.
Therefore, blacklist the MB86613 too (PCI IDs 10cf:200c).  We only check
the vendor ID because there is no other Fujitsu OHCI-1394 PCI device
known besides this one.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
---
Supersedes patch "firewire: ohci: do not bind to Pinnacle cards, prevent panic"

 drivers/firewire/ohci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -260,6 +260,8 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_VENDOR_ID_FUJITSU		0x10cf
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
@@ -3202,6 +3204,12 @@ static int __devinit pci_probe(struct pc
 	int i, err;
 	size_t size;
 
+	if (dev->vendor == PCI_VENDOR_ID_FUJITSU ||
+	    dev->vendor == PCI_VENDOR_ID_PINNACLE_SYSTEMS) {
+		dev_err(&dev->dev, "Controller type is not yet supported\n");
+		return -ENOSYS;
+	}
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		err = -ENOMEM;


-- 
Stefan Richter
-=====-==-== -=== -=-==
http://arcgraph.de/sr/
