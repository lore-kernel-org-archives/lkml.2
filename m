Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2GXRBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:01:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58760 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2GXRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:01:28 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 09/13] driver core: firmware loader: store firmware name into devres list
Date: Wed, 25 Jul 2012 01:00:09 +0800
Message-Id: <1343149213-10160-10-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will store firmware name into devres list of the device
which is requesting firmware loading, so that we can implement
auto cache firmware for devices in need.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   66 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 540b2e1..c181e6d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -115,6 +115,11 @@ struct firmware_priv {
 	struct firmware *fw;
 };
 
+struct fw_name_devm {
+	unsigned long magic;
+	char name[];
+};
+
 #define to_fwbuf(d) container_of(d, struct firmware_buf, ref)
 
 /* fw_lock could be moved to 'struct firmware_priv' but since it is just
@@ -574,6 +579,56 @@ static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 	fw->priv = buf;
 }
 
+static void fw_name_devm_release(struct device *dev, void *res)
+{
+	struct fw_name_devm *fwn = res;
+
+	if (fwn->magic == (unsigned long)&fw_cache)
+		pr_debug("%s: fw_name-%s devm-%p released\n",
+				__func__, fwn->name, res);
+}
+
+static int fw_devm_match(struct device *dev, void *res,
+		void *match_data)
+{
+	struct fw_name_devm *fwn = res;
+
+	return (fwn->magic == (unsigned long)&fw_cache) &&
+		!strcmp(fwn->name, match_data);
+}
+
+static struct fw_name_devm *fw_find_devm_name(struct device *dev,
+		const char *name)
+{
+	struct fw_name_devm *fwn;
+
+	fwn = devres_find(dev, fw_name_devm_release,
+			fw_devm_match, (void *)name);
+	return fwn;
+}
+
+/* add firmware name into devres list */
+static int fw_add_devm_name(struct device *dev, const char *name)
+{
+	struct fw_name_devm *fwn;
+
+	fwn = fw_find_devm_name(dev, name);
+	if (fwn)
+		return 1;
+
+	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm) +
+			strlen(name) + 1, GFP_KERNEL);
+
+	if (!fwn)
+		return -ENOMEM;
+
+	fwn->magic = (unsigned long)&fw_cache;
+	strcpy(fwn->name, name);
+	devres_add(dev, fwn);
+
+	return 0;
+}
+
 static void _request_firmware_cleanup(const struct firmware **firmware_p)
 {
 	release_firmware(*firmware_p);
@@ -690,6 +745,17 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 
 	fw_set_page_data(buf, fw_priv->fw);
 
+	/*
+	 * add firmware name into devres list so that we can auto cache
+	 * firmware for device.
+	 *
+	 * f_dev->parent may has been deleted already, but the problem
+	 * should be fixed in devres.
+	 *
+	 */
+	if (!retval && f_dev->parent)
+		fw_add_devm_name(f_dev->parent, buf->fw_id);
+
 	fw_priv->buf = NULL;
 	mutex_unlock(&fw_lock);
 
-- 
1.7.9.5

