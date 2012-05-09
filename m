Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2EIGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:16:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756513Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055047.312541440@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        Andrzej Jakowski <andrzej.jakowski@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 128/167] [PATCH] [SCSI] libsas: fix false positive device attached
 conditions
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 7d1d865181185bdf1316d236b1b4bd02c9020729 upstream.

Normalize phy->attached_sas_addr to return a zero-address in the case
when device-type == NO_DEVICE or the linkrate is invalid to handle
expanders that put non-zero sas addresses in the discovery response:

 sas: ex 5001b4da000f903f phy02:U:0 attached: 0100000000000000 (no device)
 sas: ex 5001b4da000f903f phy01:U:0 attached: 0100000000000000 (no device)
 sas: ex 5001b4da000f903f phy03:U:0 attached: 0100000000000000 (no device)
 sas: ex 5001b4da000f903f phy00:U:0 attached: 0100000000000000 (no device)

Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/libsas/sas_expander.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 75247a1..caa0525 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -245,7 +245,14 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->attached_sata_ps   = dr->attached_sata_ps;
 	phy->attached_iproto = dr->iproto << 1;
 	phy->attached_tproto = dr->tproto << 1;
-	memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
+	/* help some expanders that fail to zero sas_address in the 'no
+	 * device' case
+	 */
+	if (phy->attached_dev_type == NO_DEVICE ||
+	    phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	else
+		memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
 	phy->attached_phy_id = dr->attached_phy_id;
 	phy->phy_change_count = dr->change_count;
 	phy->routing_attr = dr->routing_attr;
-- 
1.7.10



