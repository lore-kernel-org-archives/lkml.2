Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab2EDUqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:46:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab2EDUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:12 -0400
Message-Id: <20120504204228.144125133@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Andrzej Jakowski <andrzej.jakowski@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 44/75] SCSI: libsas: fix false positive device attached conditions
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libsas/sas_expander.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -192,7 +192,14 @@ static void sas_set_ex_phy(struct domain
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


