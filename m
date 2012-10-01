Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab2JAXOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:14:06 -0400
Received: from 1wt.eu ([62.212.114.60]:35499 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098Ab2JAXCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:08 -0400
Message-Id: <20121001225201.927003818@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 102/180] SCSI: libsas: fix sas_discover_devices return code handling
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit b17caa174a7e1fd2e17b26e210d4ee91c4c28b37 upstream.

commit 198439e4 [SCSI] libsas: do not set res = 0 in sas_ex_discover_dev()
commit 19252de6 [SCSI] libsas: fix wide port hotplug issues

The above commits seem to have confused the return value of
sas_ex_discover_dev which is non-zero on failure and
sas_ex_join_wide_port which just indicates short circuiting discovery on
already established ports.  The result is random discovery failures
depending on configuration.

Calls to sas_ex_join_wide_port are the source of the trouble as its
return value is errantly assigned to 'res'.  Convert it to bool and stop
returning its result up the stack.

Tested-by: Dan Melnic <dan.melnic@amd.com>
Reported-by: Dan Melnic <dan.melnic@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/libsas/sas_expander.c |   39 +++++++++++------------------------
 1 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index bac091d..1bdfde1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -754,7 +754,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 }
 
 /* See if this phy is part of a wide port */
-static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
+static bool sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 {
 	struct ex_phy *phy = &parent->ex_dev.ex_phy[phy_id];
 	int i;
@@ -770,11 +770,11 @@ static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 			sas_port_add_phy(ephy->port, phy->phy);
 			phy->port = ephy->port;
 			phy->phy_state = PHY_DEVICE_DISCOVERED;
-			return 0;
+			return true;
 		}
 	}
 
-	return -ENODEV;
+	return false;
 }
 
 static struct domain_device *sas_ex_discover_expander(
@@ -912,8 +912,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 		return res;
 	}
 
-	res = sas_ex_join_wide_port(dev, phy_id);
-	if (!res) {
+	if (sas_ex_join_wide_port(dev, phy_id)) {
 		SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
 			    phy_id, SAS_ADDR(ex_phy->attached_sas_addr));
 		return res;
@@ -958,8 +957,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
 			    SAS_ADDR(child->sas_addr)) {
 				ex->ex_phy[i].phy_state= PHY_DEVICE_DISCOVERED;
-				res = sas_ex_join_wide_port(dev, i);
-				if (!res)
+				if (sas_ex_join_wide_port(dev, i))
 					SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
 						    i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
 
@@ -1812,32 +1810,20 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
-	bool found = false;
-	int res, i;
+	int res;
 
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
 	res = sas_ex_phy_discover(dev, phy_id);
 	if (res)
-		goto out;
-	/* to support the wide port inserted */
-	for (i = 0; i < dev->ex_dev.num_phys; i++) {
-		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
-		if (i == phy_id)
-			continue;
-		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
-		    SAS_ADDR(ex_phy->attached_sas_addr)) {
-			found = true;
-			break;
-		}
-	}
-	if (found) {
-		sas_ex_join_wide_port(dev, phy_id);
+		return res;
+
+	if (sas_ex_join_wide_port(dev, phy_id))
 		return 0;
-	}
+
 	res = sas_ex_discover_devices(dev, phy_id);
-	if (!res)
-		goto out;
+	if (res)
+		return res;
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
 		    SAS_ADDR(ex_phy->attached_sas_addr)) {
@@ -1847,7 +1833,6 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 			break;
 		}
 	}
-out:
 	return res;
 }
 
-- 
1.7.2.1.45.g54fbc



