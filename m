Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2F0JJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:09:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46413 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab2F0JJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:09:30 -0400
Date: Wed, 27 Jun 2012 12:09:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2 -resend] iommu/amd: fix type bug in flush code
Message-ID: <20120627090918.GT31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_file_bool() modifies 32 bits of data, so "amd_iommu_unmap_flush"
needs to be 32 bits as well or we'll corrupt memory.  Fortunately it
looks like the data is aligned with a gap after the declaration so this
is harmless in production.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Fri, 2 Mar 2012.  This is the other patch where I
guess I was supposed to modify debugfs_create_bool() to take bool
pointers.

diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 2435555..c1b1d48 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -652,7 +652,7 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
  * If true, the addresses will be flushed on unmap time, not when
  * they are reused
  */
-extern bool amd_iommu_unmap_flush;
+extern u32 amd_iommu_unmap_flush;
 
 /* Smallest number of PASIDs supported by any IOMMU in the system */
 extern u32 amd_iommu_max_pasids;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4127b56..92b9267 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -451,7 +451,7 @@ static void amd_iommu_stats_init(void)
 		return;
 
 	de_fflush  = debugfs_create_bool("fullflush", 0444, stats_dir,
-					 (u32 *)&amd_iommu_unmap_flush);
+					 &amd_iommu_unmap_flush);
 
 	amd_iommu_stats_add(&compl_wait);
 	amd_iommu_stats_add(&cnt_map_single);
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index c04ddca..a33612f 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -129,7 +129,7 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
-bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
+u32 amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
