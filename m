Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab1FWSFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:05:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:34791 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab1FWRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 146/247] r8169: disable ASPM
Date: Thu, 23 Jun 2011 13:33:34 -0400
Message-Id: <1308850515-15242-87-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/r8169.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 0fa0598..812d102 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -23,6 +23,7 @@
 #include <linux/tcp.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci-aspm.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -3024,6 +3025,11 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
-- 
1.7.4.4

