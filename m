Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1G1L2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:28:50 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57115 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab1G1L2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:28:44 -0400
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 1/2] PCI: make pci_claim_resource() work with conflict resources as appropriate
Date: Thu, 28 Jul 2011 19:28:31 +0800
Message-Id: <1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In resolving a network driver issue with the MIPS Malta platform, the root
cause was traced into pci_claim_resource():

MIPS System Controller's PCI I/O resources stay in 0x1000-0xffffff. When
PCI quirks start claiming resources using request_resource_conflict(),
collisions happen and -EBUSY is returned, thereby rendering the onboard AMD
PCnet32 NIC unaware of quirks' region and preventing the NIC from functioning.
For PCI quirks, PIIX4 ACPI is expected to claim 0x1000-0x103f, and PIIX4 SMB to
claim 0x1100-0x110f, both of which fall into the MSC I/O range. Certainly, we
can increase the start point of this range in arch/mips/mti-malta/malta-pci.c to
avoid the collisions. But a fix in here looks more justified, though it seems to
have a wider impact. Using insert_xxx as opposed to request_xxx will register
PCI quirks' resources as children of MSC I/O and return OK, instead of seeing
collisions which are actually resolvable.

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 drivers/pci/setup-res.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index bc0e6ee..40d767e 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -102,7 +102,7 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 		return -EINVAL;
 	}
 
-	conflict = request_resource_conflict(root, res);
+	conflict = insert_resource_conflict(root, res);
 	if (conflict) {
 		dev_info(&dev->dev,
 			 "address space collision: %pR conflicts with %s %pR\n",
-- 
1.7.1

