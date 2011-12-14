Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab1LNQEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:04:49 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:50677 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab1LNQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:04:44 -0500
X-AuditID: c1b4fb39-b7b3eae00000252a-76-4ee8c91ae410
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <lucas.demarchi@profusion.mobi>, <borislav.petkov@amd.com>,
        <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH 1/4] edac: i5100 add sysfs nodes for fault injection
Date: Wed, 14 Dec 2011 17:04:27 +0100
Message-ID: <1323878670-26079-2-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
References: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs nodes to /sys/devices/system/edac/mc/mcX to control fault
injection.

Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 drivers/edac/i5100_edac.c |   94 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index bcbdeec..1319e59 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -338,6 +338,15 @@ struct i5100_priv {
 
 	struct delayed_work i5100_scrubbing;
 	int scrub_enable;
+
+	/* Error injection */
+	u32 inject_enable;
+	u32 inject_channel;
+	u32 inject_hlinesel;
+	u32 inject_deviceptr1;
+	u32 inject_deviceptr2;
+	u32 inject_eccmask1;
+	u32 inject_eccmask2;
 };
 
 /* map a rank/chan to a slot number on the mainboard */
@@ -879,6 +888,80 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 	}
 }
 
+#define DECLARE_INJECT_PARAM(param, limit_low, limit_high)		\
+static ssize_t i5100_inject_store_##param(				\
+		struct mem_ctl_info *mci,				\
+		const char *data,					\
+		size_t count)						\
+{									\
+	struct i5100_priv *priv = mci->pvt_info;			\
+	unsigned long value;						\
+	int rc;								\
+									\
+	rc = kstrtoul(data, 10, &value);				\
+	if (rc < 0 || value < limit_low || value > limit_high)		\
+		return -EIO;						\
+									\
+	priv->param = value;						\
+									\
+	return count;							\
+}									\
+									\
+static ssize_t i5100_inject_show_##param(				\
+		struct mem_ctl_info *mci,				\
+		char *data)						\
+{									\
+	struct i5100_priv *priv = mci->pvt_info;			\
+	return sprintf(data, "%d\n", priv->param);			\
+}
+
+#define ATTR_INJECT(param)						\
+	{								\
+		.attr = {						\
+			.name = #param,					\
+			.mode = (S_IRUGO | S_IWUSR)			\
+		},							\
+		.show  = i5100_inject_show_##param,			\
+		.store = i5100_inject_store_##param,			\
+	}
+
+DECLARE_INJECT_PARAM(inject_channel, 0, 1);
+DECLARE_INJECT_PARAM(inject_hlinesel, 1, 3);
+DECLARE_INJECT_PARAM(inject_deviceptr1, 0, 17);
+DECLARE_INJECT_PARAM(inject_deviceptr2, 0, 17);
+DECLARE_INJECT_PARAM(inject_eccmask1, 0, 0xFFFF);
+DECLARE_INJECT_PARAM(inject_eccmask2, 0, 0xFFFF);
+
+static ssize_t i5100_inject_store_inject_enable(struct mem_ctl_info *mci,
+		const char *data, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(data, 10, &value) < 0)
+		return -EIO;
+
+	return count;
+}
+
+static ssize_t i5100_inject_show_inject_enable(struct mem_ctl_info *mci,
+		char *data)
+{
+	struct i5100_priv *priv = mci->pvt_info;
+	return sprintf(data, "%d\n", priv->inject_enable);
+}
+
+static const struct mcidev_sysfs_attribute i5100_sysfs_attrs[] = {
+	ATTR_INJECT(inject_enable),
+	ATTR_INJECT(inject_channel),
+	ATTR_INJECT(inject_hlinesel),
+	ATTR_INJECT(inject_deviceptr1),
+	ATTR_INJECT(inject_deviceptr2),
+	ATTR_INJECT(inject_eccmask1),
+	ATTR_INJECT(inject_eccmask2),
+
+	{ } /* End of list */
+};
+
 static int __devinit i5100_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
@@ -984,6 +1067,17 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 	mci->set_sdram_scrub_rate = i5100_set_scrub_rate;
 	mci->get_sdram_scrub_rate = i5100_get_scrub_rate;
 
+	priv->inject_enable = 0;
+	priv->inject_channel = 0;
+	priv->inject_hlinesel = 1;
+	priv->inject_deviceptr1 = 0;
+	priv->inject_deviceptr2 = 0;
+	priv->inject_eccmask1 = 0;
+	priv->inject_eccmask2 = 0;
+
+	/* Configure sysfs */
+	mci->mc_driver_sysfs_attributes = i5100_sysfs_attrs;
+
 	i5100_init_csrows(mci);
 
 	/* this strange construction seems to be in every driver, dunno why */
-- 
1.7.7.3

