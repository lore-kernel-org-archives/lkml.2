Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2EIGTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:19:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394Ab2EIFxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:24 -0400
Message-Id: <20120509055047.180843827@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Jackson <thomas.p.jackson@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 127/167] [PATCH] [SCSI] libsas: fix sas_find_bcast_phy() in the presence of
 vacant phys
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Jackson <thomas.p.jackson@intel.com>

commit 1699490db339e2c6b3037ea8e7dcd6b2755b688e upstream.

If an expander reports 'PHY VACANT' for a phy index prior to the one
that generated a BCN libsas fails rediscovery.  Since a vacant phy is
defined as a valid phy index that will never have an attached device
just continue the search.

Signed-off-by: Thomas Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/libsas/sas_expander.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 05acd9e..833bea0 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1718,9 +1718,17 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 		int phy_change_count = 0;
 
 		res = sas_get_phy_change_count(dev, i, &phy_change_count);
-		if (res)
-			goto out;
-		else if (phy_change_count != ex->ex_phy[i].phy_change_count) {
+		switch (res) {
+		case SMP_RESP_PHY_VACANT:
+		case SMP_RESP_NO_PHY:
+			continue;
+		case SMP_RESP_FUNC_ACC:
+			break;
+		default:
+			return res;
+		}
+
+		if (phy_change_count != ex->ex_phy[i].phy_change_count) {
 			if (update)
 				ex->ex_phy[i].phy_change_count =
 					phy_change_count;
@@ -1728,8 +1736,7 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 			return 0;
 		}
 	}
-out:
-	return res;
+	return 0;
 }
 
 static int sas_get_ex_change_count(struct domain_device *dev, int *ecc)
-- 
1.7.10



