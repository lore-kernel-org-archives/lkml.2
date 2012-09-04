Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab2IDXNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:13:11 -0400
Received: from smtp.riverbed.com ([208.70.196.45]:18969 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab2IDXNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:13:09 -0400
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: clala@riverbed.com, Francis.St.Amant@riverbed.com,
        Jiang Wang <Jiang.Wang@riverbed.com>, Jiang Wang <jwang@riverbed.com>
Subject: [PATCH 1/1] pci-iov: Fix warnings when CONFIG_PCI_IOV is enabled
Date: Tue,  4 Sep 2012 16:11:47 -0700
Message-Id: <1346800307-11041-1-git-send-email-Jiang.Wang@riverbed.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PCI_IOV is enabled, the kernel will call sriov_init().
This function tries to allocate virtual resources even if the
virtual function of a PCI devive is not enabled by the BIOS.

This sometimes causes following warning messages during boot up:
pci 0000:02:00.0: BAR 9: can't allocate mem resource [0x000000-0x3fffff]
pci 0000:02:00.0: BAR 7: can't allocate mem resource [0x000000-0x03ffff]

Tested on three Mitac motherboards.

Signed-off-by: Jiang Wang <jwang@riverbed.com>
---
 drivers/pci/iov.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 6554e1a..0ca8cb2 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -441,7 +441,8 @@ static int sriov_init(struct pci_dev *dev, int pos)
 	if (ctrl & PCI_SRIOV_CTRL_VFE) {
 		pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
 		ssleep(1);
-	}
+	} else
+		return 0;
 
 	pci_read_config_word(dev, pos + PCI_SRIOV_TOTAL_VF, &total);
 	if (!total)
-- 
1.7.1

