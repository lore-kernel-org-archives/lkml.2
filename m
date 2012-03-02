Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab2CBG7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:59:33 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:18512 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab2CBG7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:59:32 -0500
Date: Fri, 2 Mar 2012 09:59:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] iommu/amd: fix type bug in flush code
Message-ID: <20120302065919.GF24508@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F506FD0.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_file_bool() modifies 32 bits of data, so "amd_iommu_unmap_flush"
needs to be 32 bits as well or we'll corrupt memory.  Fortunately it
looks like the data is aligned with a gap after the declaration so this
is harmless in production.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 2452f3b..f0469e0 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -649,7 +649,7 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
  * If true, the addresses will be flushed on unmap time, not when
  * they are reused
  */
-extern bool amd_iommu_unmap_flush;
+extern u32 amd_iommu_unmap_flush;
 
 /* Smallest number of PASIDs supported by any IOMMU in the system */
 extern u32 amd_iommu_max_pasids;

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index daa333f..f5fbce2 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -402,7 +402,7 @@ static void amd_iommu_stats_init(void)
 		return;
 
 	de_fflush  = debugfs_create_bool("fullflush", 0444, stats_dir,
-					 (u32 *)&amd_iommu_unmap_flush);
+					 &amd_iommu_unmap_flush);
 
 	amd_iommu_stats_add(&compl_wait);
 	amd_iommu_stats_add(&cnt_map_single);
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index bdea288..7d159fc 100644
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
