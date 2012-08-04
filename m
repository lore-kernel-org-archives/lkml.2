Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2HDEC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:02:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2HDECx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:02:53 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 10/15] firmware loader: store firmware name into devres list
Date: Sat,  4 Aug 2012 12:01:25 +0800
Message-Id: <1344052890-31935-11-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will store firmware name into devres list of the device
which is requesting firmware loading, so that we can implement
auto cache and uncache firmware for devices in need.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index a47266c..65c6066 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -114,6 +114,11 @@ struct firmware_priv {
 	struct firmware *fw;
 };
 
+struct fw_name_devm {
+	unsigned long magic;
+	char name[];
+};
+
 #define to_fwbuf(d) container_of(d, struct firmware_buf, ref)
 
 /* fw_lock could be moved to 'struct firmware_priv' but since it is just
@@ -590,6 +595,55 @@ static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 		 (unsigned int)buf->size);
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
+			  fw_devm_match, (void *)name);
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
+			   strlen(name) + 1, GFP_KERNEL);
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
@@ -709,6 +763,16 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
 		retval = -ENOENT;
 
+	/*
+	 * add firmware name into devres list so that we can auto cache
+	 * and uncache firmware for device.
+	 *
+	 * f_dev->parent may has been deleted already, but the problem
+	 * should be fixed in devres or driver core.
+	 */
+	if (!retval && f_dev->parent)
+		fw_add_devm_name(f_dev->parent, buf->fw_id);
+
 	if (!retval)
 		retval = fw_map_pages_buf(buf);
 
-- 
1.7.9.5

