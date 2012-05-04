Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2EDVLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:11:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab2EDUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:08 -0400
Message-Id: <20120504204228.063097620@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Jackson <thomas.p.jackson@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 43/75] SCSI: libsas: fix sas_find_bcast_phy() in the presence of vacant phys
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libsas/sas_expander.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1643,9 +1643,17 @@ static int sas_find_bcast_phy(struct dom
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
@@ -1653,8 +1661,7 @@ static int sas_find_bcast_phy(struct dom
 			return 0;
 		}
 	}
-out:
-	return res;
+	return 0;
 }
 
 static int sas_get_ex_change_count(struct domain_device *dev, int *ecc)


