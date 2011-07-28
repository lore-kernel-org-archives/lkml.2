Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1G1Xup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:50:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:62187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1G1Xod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552513"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: stefanr@s5r6.in-berlin.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [28/50] firewire: ohci: do not bind to Pinnacle cards, avert panic
Message-Id: <20110728234432.C78B62403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

[ upstream commit 7f7e37115a8b6724f26d0637a04e1d35e3c59717 ]

When firewire-ohci is bound to a Pinnacle MovieBoard, eventually a
"Register access failure" is logged and an interrupt storm or a kernel
panic happens.  https://bugzilla.kernel.org/show_bug.cgi?id=36622

Until this is sorted out (if that is going to succeed at all), let's
just prevent firewire-ohci from touching these devices.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/firewire/ohci.c
+++ linux-2.6.35.y/drivers/firewire/ohci.c
@@ -232,6 +232,7 @@ static inline struct fw_ohci *fw_ohci(st
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 
 #define QUIRK_CYCLE_TIMER		1
 #define QUIRK_RESET_PACKET		2
@@ -2480,6 +2481,11 @@ static int __devinit pci_probe(struct pc
 	int i, err, n_ir, n_it;
 	size_t size;
 
+	if (dev->vendor == PCI_VENDOR_ID_PINNACLE_SYSTEMS) {
+		dev_err(&dev->dev, "Pinnacle MovieBoard is not yet supported\n");
+		return -ENOSYS;
+	}
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		err = -ENOMEM;
