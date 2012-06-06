Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2FFSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab2FFSJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:09:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC] e752x_edac: Fix the driver to report the right type on i3100
Date: Wed,  6 Jun 2012 14:57:38 -0300
Message-Id: <7e119b9b0dead22d3964c071ade4a900160e9348.1339005427.git.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i3100 datasheet is clear[1]:
	"A Intel® 3100 Chipset system implementation consists of:
	 ...
	 . One to four DDR2-400 DIMMs (a maximum of 4 ranks are supported)"

[1] ftp://download.intel.com/design/intarch/datashts/31345803.pdf

So, the only supported memory type is DDR2, and not DDR, as the ones
at the older cuipsets.

Fix it to report the proper information for userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/e752x_edac.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index a5ed6b7..a88eaba 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1066,7 +1066,7 @@ static inline int remap_csrow_index(struct mem_ctl_info *mci, int index)
 }
 
 static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-			u16 ddrcsr)
+			      u16 ddrcsr, enum e752x_chips dev_idx)
 {
 	struct csrow_info *csrow;
 	enum edac_type edac_mode;
@@ -1131,7 +1131,10 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			edac_dbg(3, "Initializing rank at (%i,%i)\n", index, i);
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
-			dimm->mtype = MEM_RDDR;	/* only one type supported */
+			if (dev_idx == I3100)
+				dimm->mtype = MEM_DDR2;
+			else
+				dimm->mtype = MEM_RDDR;
 			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
 			dimm->edac_mode = edac_mode;
 		}
@@ -1301,7 +1304,10 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENOMEM;
 
 	edac_dbg(3, "init mci\n");
-	mci->mtype_cap = MEM_FLAG_RDDR;
+	if (dev_idx == I3100)
+		mci->mtype_cap = MEM_FLAG_DDR2;
+	else
+		mci->mtype_cap = MEM_FLAG_RDDR;
 	/* 3100 IMCH supports SECDEC only */
 	mci->edac_ctl_cap = (dev_idx == I3100) ? EDAC_FLAG_SECDED :
 		(EDAC_FLAG_NONE | EDAC_FLAG_SECDED | EDAC_FLAG_S4ECD4ED);
@@ -1335,7 +1341,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	pci_read_config_byte(pdev, E752X_DRM, &stat8);
 	pvt->map_type = ((stat8 & 0x0f) > ((stat8 >> 4) & 0x0f));
 
-	e752x_init_csrows(mci, pdev, ddrcsr);
+	e752x_init_csrows(mci, pdev, ddrcsr, dev_idx);
 	e752x_init_mem_map_table(pdev, pvt);
 
 	if (dev_idx == I3100)
-- 
1.7.10.2

