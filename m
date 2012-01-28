Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2A1Pd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab2A1Pc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 14/16] edac: Add per-dimm sysfs show nodes
Date: Sat, 28 Jan 2012 13:32:49 -0200
Message-Id: <1327764771-28649-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs nodes to describe DIMM properties: size, memory type,
dev type and edac mode.

With this change, the physical memory characteristics should
be presented, as detected by the memory controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   44 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 62b5029..d175e48 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -144,7 +144,13 @@ static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
 static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->channels[0].dimm->nr_pages));
+	int i;
+	u32 nr_pages = 0;
+
+	for (i = 0; i < csrow->nr_channels; i++)
+		nr_pages += csrow->channels[i].dimm->nr_pages;
+
+	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
 }
 
 static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
@@ -497,14 +503,42 @@ static ssize_t dimmdev_label_store(struct dimm_info *dimm,
 	return max_size;
 }
 
+static ssize_t dimmdev_size_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%u\n", PAGES_TO_MiB(dimm->nr_pages));
+}
+
+static ssize_t dimmdev_mem_type_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%s\n", mem_types[dimm->mtype]);
+}
+
+static ssize_t dimmdev_dev_type_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%s\n", dev_types[dimm->dtype]);
+}
+
+static ssize_t dimmdev_edac_mode_show(struct dimm_info *dimm, char *data)
+{
+	return sprintf(data, "%s\n", edac_caps[dimm->edac_mode]);
+}
+
 /* default cwrow<id>/attribute files */
-DIMMDEV_ATTR(label, S_IRUGO | S_IWUSR, dimmdev_label_show, dimmdev_label_store);
-DIMMDEV_ATTR(location, S_IRUGO, dimmdev_location_show, NULL);
+DIMMDEV_ATTR(dimm_label, S_IRUGO | S_IWUSR, dimmdev_label_show, dimmdev_label_store);
+DIMMDEV_ATTR(dimm_location, S_IRUGO, dimmdev_location_show, NULL);
+DIMMDEV_ATTR(dimm_size, S_IRUGO, dimmdev_size_show, NULL);
+DIMMDEV_ATTR(dimm_mem_type, S_IRUGO, dimmdev_mem_type_show, NULL);
+DIMMDEV_ATTR(dimm_dev_type, S_IRUGO, dimmdev_dev_type_show, NULL);
+DIMMDEV_ATTR(dimm_edac_mode, S_IRUGO, dimmdev_edac_mode_show, NULL);
 
 /* default attributes of the DIMM<id> object */
 static struct dimmdev_attribute *default_dimm_attr[] = {
-	&attr_label,
-	&attr_location,
+	&attr_dimm_label,
+	&attr_dimm_location,
+	&attr_dimm_size,
+	&attr_dimm_mem_type,
+	&attr_dimm_dev_type,
+	&attr_dimm_edac_mode,
 	NULL,
 };
 
-- 
1.7.8

