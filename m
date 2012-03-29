Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2C2RJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759656Ab2C2RHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:07:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: [PATCH 07/14] edac: add a sysfs node to report the maximum location for the system
Date: Thu, 29 Mar 2012 14:06:54 -0300
Message-Id: <1333040821-6253-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace tools need to know what's the maximum location on each
system, as it helps to create nice maps showing how the memory was
filled at the system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index b0cd5d5..bdd81b4 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -769,6 +769,23 @@ static ssize_t mci_size_mb_show(struct device *dev,
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
+static ssize_t mci_max_location_show(struct device *dev,
+				     struct device_attribute *mattr,
+				     char *data)
+{
+	struct mem_ctl_info *mci = to_mci(dev);
+	int i;
+	char *p = data;
+
+	for (i = 0; i < mci->n_layers; i++) {
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     mci->layers[i].size - 1);
+	}
+
+	return p - data;
+}
+
 /* default Control file */
 DEVICE_ATTR(reset_counters, S_IWUSR, NULL, mci_reset_counters_store);
 
@@ -780,6 +797,7 @@ DEVICE_ATTR(ue_noinfo_count, S_IRUGO, mci_ue_noinfo_show, NULL);
 DEVICE_ATTR(ce_noinfo_count, S_IRUGO, mci_ce_noinfo_show, NULL);
 DEVICE_ATTR(ue_count, S_IRUGO, mci_ue_count_show, NULL);
 DEVICE_ATTR(ce_count, S_IRUGO, mci_ce_count_show, NULL);
+DEVICE_ATTR(max_location, S_IRUGO, mci_max_location_show, NULL);
 
 /* memory scrubber attribute file */
 DEVICE_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
@@ -795,6 +813,7 @@ static struct attribute *mci_attrs[] = {
 	&dev_attr_ue_count.attr,
 	&dev_attr_ce_count.attr,
 	&dev_attr_sdram_scrub_rate.attr,
+	&dev_attr_max_location.attr,
 	NULL
 };
 
-- 
1.7.8

