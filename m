Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab1C3VIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:49299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964940Ab1C3VIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278295"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sgruszka@redhat.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [169/275] r8169: disable ASPM
Message-Id: <20110330210651.A8F843E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>

commit ba04c7c93bbcb48ce880cf75b6e9dffcd79d4c7b upstream.

For some time is known that ASPM is causing troubles on r8169, i.e. make
device randomly stop working without any errors in dmesg.

Currently Tomi Leppikangas reports that system with r8169 device hangs
with MCE errors when ASPM is enabled:
https://bugzilla.redhat.com/show_bug.cgi?id=642861#c4

Lets disable ASPM for r8169 devices at all, to avoid problems with
r8169 PCIe devices at least for some users.

Reported-by: Tomi Leppikangas <tomi.leppikangas@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/r8169.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.35.y/drivers/net/r8169.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/r8169.c	2011-03-29 22:50:56.827804337 -0700
+++ linux-2.6.35.y/drivers/net/r8169.c	2011-03-29 23:54:22.174435038 -0700
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
+#include <linux/pci-aspm.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -3040,6 +3041,11 @@
 	mii->reg_num_mask = 0x1f;
 	mii->supports_gmii = !!(cfg->features & RTL_FEATURE_GMII);
 
+	/* disable ASPM completely as that cause random device stop working
+	 * problems as well as full system hangs for some PCIe devices users */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				     PCIE_LINK_STATE_CLKPM);
+
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pci_enable_device(pdev);
 	if (rc < 0) {
