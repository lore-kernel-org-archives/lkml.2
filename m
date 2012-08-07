Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab2HGW1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:27:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57002 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab2HGW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 011/122] SCSI: libsas: continue revalidation
Date: Tue,  7 Aug 2012 15:24:59 -0700
Message-Id: <20120807221949.258395066@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 26f2f199ff150d8876b2641c41e60d1c92d2fb81 upstream.

Continue running revalidation until no more broadcast devices are
discovered.  Fixes cases where re-discovery completes too early in a
domain with multiple expanders with pending re-discovery events.
Servicing BCNs can get backed up behind error recovery.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libsas/sas_expander.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2109,9 +2109,7 @@ int sas_ex_revalidate_domain(struct doma
 	struct domain_device *dev = NULL;
 
 	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res)
-		goto out;
-	if (dev) {
+	while (res == 0 && dev) {
 		struct expander_device *ex = &dev->ex_dev;
 		int i = 0, phy_id;
 
@@ -2123,8 +2121,10 @@ int sas_ex_revalidate_domain(struct doma
 			res = sas_rediscover(dev, phy_id);
 			i = phy_id + 1;
 		} while (i < ex->num_phys);
+
+		dev = NULL;
+		res = sas_find_bcast_dev(port_dev, &dev);
 	}
-out:
 	return res;
 }
 


