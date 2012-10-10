Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2JJWFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:05:13 -0400
Received: from adoakley.name ([46.4.104.242]:50267 "EHLO ado.is-a-geek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab2JJWFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:05:10 -0400
From: andrew@ado.is-a-geek.net
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Oakley <andrew@ado.is-a-geek.net>
Subject: [PATCH] iommu/amd: Workaround wrong IOAPIC devid in IVRS.
Date: Wed, 10 Oct 2012 23:05:09 +0100
Message-Id: <1349906709-5846-1-git-send-email-andrew@ado.is-a-geek.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20121010230231.2fb3c3b9@ado-amd-gentoo.moore.slainvet.net>
References: <20121010230231.2fb3c3b9@ado-amd-gentoo.moore.slainvet.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Oakley <andrew@ado.is-a-geek.net>

The IOAPIC always has the same device id but is sometimes reported in
the IVRS table with a different id.  This patch allows interrupt
remapping to work on devices with this bug.
---
 drivers/iommu/amd_iommu_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 18b0d99..ca266b9 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -751,6 +751,9 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 	}
 }
 
+/* SB IOAPIC is always on this device in AMD systems */
+#define IOAPIC_SB_DEVID		((0x00 << 8) | PCI_DEVFN(0x14, 0))
+
 /*
  * Takes a pointer to an AMD IOMMU entry in the ACPI table and
  * initializes the hardware and our data structures with it.
@@ -928,6 +931,12 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 				    PCI_SLOT(devid),
 				    PCI_FUNC(devid));
 
+			if (type == IVHD_SPECIAL_IOAPIC &&
+			    devid != IOAPIC_SB_DEVID) {
+				pr_err(FW_BUG "AMD-Vi: wrong IOAPIC devid\n");
+				devid = IOAPIC_SB_DEVID;
+			}
+
 			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
 			ret = add_special_device(type, handle, devid);
 			if (ret)
-- 
1.7.8.6

