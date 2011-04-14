Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab1DNSGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:06:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:42221 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965006Ab1DNR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Krishna Gudipati <kgudipat@brocade.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 183/209] bfa: fix system crash when reading sysfs fc_host statistics
Date: Thu, 14 Apr 2011 13:55:41 -0400
Message-Id: <1302803767-9715-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Gudipati <kgudipat@brocade.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 7873ca4e4401f0ecd8868bf1543113467e6bae61 upstream.

The port data structure related to fc_host statistics collection is
not initialized. This causes system crash when reading the fc_host
statistics. The fix is to initialize port structure during driver
attach.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/bfa/bfa_core.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 0c08e18..3a7b3f8 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -84,11 +84,32 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->meminfo(cfg, &km_len, &dm_len);
 
+	dm_len += bfa_port_meminfo();
 
 	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_len = km_len;
 	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_len = dm_len;
 }
 
+static void
+bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi)
+{
+	struct bfa_port_s       *port = &bfa->modules.port;
+	uint32_t                dm_len;
+	uint8_t                 *dm_kva;
+	uint64_t                dm_pa;
+
+	dm_len = bfa_port_meminfo();
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa  = bfa_meminfo_dma_phys(mi);
+
+	memset(port, 0, sizeof(struct bfa_port_s));
+	bfa_port_attach(port, &bfa->ioc, bfa, bfa->trcmod, bfa->logm);
+	bfa_port_mem_claim(port, dm_kva, dm_pa);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva + dm_len;
+	bfa_meminfo_dma_phys(mi) = dm_pa + dm_len;
+}
+
 /**
  * Use this function to do attach the driver instance with the BFA
  * library. This function will not trigger any HW initialization
@@ -140,6 +161,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->attach(bfa, bfad, cfg, meminfo, pcidev);
 
+	bfa_com_port_attach(bfa, meminfo);
 }
 
 /**
-- 
1.7.4.4

