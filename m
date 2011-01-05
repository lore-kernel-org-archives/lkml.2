Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1AEXpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:45:16 -0500
Received: from kroah.org ([198.145.64.141]:41026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab1AEXpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:13 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:26 2011
Message-Id: <20110105230326.777061856@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Krishna Gudipati <kgudipat@brocade.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [33/49] [SCSI] bfa: fix system crash when reading sysfs fc_host statistics
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Krishna Gudipati <kgudipat@brocade.com>

commit 7873ca4e4401f0ecd8868bf1543113467e6bae61 upstream.

The port data structure related to fc_host statistics collection is
not initialized. This causes system crash when reading the fc_host
statistics. The fix is to initialize port structure during driver
attach.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/bfa/bfa_core.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -84,11 +84,32 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg
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
@@ -140,6 +161,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->attach(bfa, bfad, cfg, meminfo, pcidev);
 
+	bfa_com_port_attach(bfa, meminfo);
 }
 
 /**


