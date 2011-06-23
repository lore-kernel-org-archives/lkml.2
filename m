Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab1FWRhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:35194 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547Ab1FWRhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 188/247] PCI: sysfs: Fix failure path for addition of "vpd" attribute
Date: Thu, 23 Jun 2011 13:34:16 -0400
Message-Id: <1308850515-15242-129-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0f12a4e29368a9476076515881d9ef4e5876c6e2 upstream.

Commit 280c73d ("PCI: centralize the capabilities code in
pci-sysfs.c") changed the initialisation of the "rom" and "vpd"
attributes, and made the failure path for the "vpd" attribute
incorrect.  We must free the new attribute structure (attr), but
instead we currently free dev->vpd->attr.  That will normally be NULL,
resulting in a memory leak, but it might be a stale pointer, resulting
in a double-free.

Found by inspection; compile-tested only.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f5cd68c..e1783bb 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -995,7 +995,7 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
 		attr->write = write_vpd_attr;
 		retval = sysfs_create_bin_file(&dev->dev.kobj, attr);
 		if (retval) {
-			kfree(dev->vpd->attr);
+			kfree(attr);
 			return retval;
 		}
 		dev->vpd->attr = attr;
-- 
1.7.4.4

