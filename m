Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134Ab2BJXeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:34:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:27177 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2BJXeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:34:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/7] PCI: Disable cardbus bridge MEM1 pref CTL
Date: Fri, 10 Feb 2012 15:33:46 -0800
Message-Id: <1328916832-6588-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
References: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F35A972.00E6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOS enable both pref for MEM0 and MEM1.

but we assume MEM1 is non-pref...

Discussion could be found at:
	https://lkml.org/lkml/2012/1/12/1
	https://bugzilla.kernel.org/show_bug.cgi?id=41622#c23

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pci/setup-bus.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 090217a..d5897c3 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -914,6 +914,14 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
 	if (realloc_head)
 		add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
 
+	/* MEM1 must not be pref mmio */
+	pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
+	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM1) {
+		ctrl &= ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM1;
+		pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
+		pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
+	}
+
 	/*
 	 * Check whether prefetchable memory is supported
 	 * by this bridge.
-- 
1.7.7

