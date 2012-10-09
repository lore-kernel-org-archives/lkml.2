Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2JIEBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:01:55 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62129 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2JIEBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:01:50 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] firmware loader: let direct loading back on 'firmware_buf'
Date: Tue,  9 Oct 2012 12:01:03 +0800
Message-Id: <1349755264-23876-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
References: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly 'firmware_buf' is introduced to make all loading requests
to share one firmware kernel buffer, so firmware_buf should
be used in direct loading for saving memory and speedup firmware
loading.

Secondly, the commit below

	abb139e75c2cdbb955e840d6331cb5863e409d0e(firmware:teach
	the kernel to load firmware files directly from the filesystem)

introduces direct loading for fixing udev regression, but it
bypasses the firmware cache meachnism, so this patch enables
caching firmware for direct loading case since it is still needed
to solve drivers' dependency during system resume.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |  171 ++++++++++++++++++++++++-----------------
 1 file changed, 100 insertions(+), 71 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index f288251..a095d84 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -36,68 +36,6 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
-static const char *fw_path[] = {
-	"/lib/firmware/updates/" UTS_RELEASE,
-	"/lib/firmware/updates",
-	"/lib/firmware/" UTS_RELEASE,
-	"/lib/firmware"
-};
-
-/* Don't inline this: 'struct kstat' is biggish */
-static noinline long fw_file_size(struct file *file)
-{
-	struct kstat st;
-	if (vfs_getattr(file->f_path.mnt, file->f_path.dentry, &st))
-		return -1;
-	if (!S_ISREG(st.mode))
-		return -1;
-	if (st.size != (long)st.size)
-		return -1;
-	return st.size;
-}
-
-static bool fw_read_file_contents(struct file *file, struct firmware *fw)
-{
-	long size;
-	char *buf;
-
-	size = fw_file_size(file);
-	if (size < 0)
-		return false;
-	buf = vmalloc(size);
-	if (!buf)
-		return false;
-	if (kernel_read(file, 0, buf, size) != size) {
-		vfree(buf);
-		return false;
-	}
-	fw->data = buf;
-	fw->size = size;
-	return true;
-}
-
-static bool fw_get_filesystem_firmware(struct firmware *fw, const char *name)
-{
-	int i;
-	bool success = false;
-	char *path = __getname();
-
-	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
-		struct file *file;
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], name);
-
-		file = filp_open(path, O_RDONLY, 0);
-		if (IS_ERR(file))
-			continue;
-		success = fw_read_file_contents(file, fw);
-		fput(file);
-		if (success)
-			break;
-	}
-	__putname(path);
-	return success;
-}
-
 /* Builtin firmware support */
 
 #ifdef CONFIG_FW_LOADER
@@ -150,6 +88,11 @@ enum {
 	FW_STATUS_ABORT,
 };
 
+enum fw_buf_fmt {
+	VMALLOC_BUF,	/* used in direct loading */
+	PAGE_BUF,	/* used in loading via userspace */
+};
+
 static int loading_timeout = 60;	/* In seconds */
 
 static inline long firmware_loading_timeout(void)
@@ -187,6 +130,7 @@ struct firmware_buf {
 	struct completion completion;
 	struct firmware_cache *fwc;
 	unsigned long status;
+	enum fw_buf_fmt fmt;
 	void *data;
 	size_t size;
 	struct page **pages;
@@ -240,6 +184,7 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
+	buf->fmt = VMALLOC_BUF;
 
 	pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
 
@@ -307,10 +252,14 @@ static void __fw_free_buf(struct kref *ref)
 	list_del(&buf->list);
 	spin_unlock(&fwc->lock);
 
-	vunmap(buf->data);
-	for (i = 0; i < buf->nr_pages; i++)
-		__free_page(buf->pages[i]);
-	kfree(buf->pages);
+
+	if (buf->fmt == PAGE_BUF) {
+		vunmap(buf->data);
+		for (i = 0; i < buf->nr_pages; i++)
+			__free_page(buf->pages[i]);
+		kfree(buf->pages);
+	} else
+		vfree(buf->data);
 	kfree(buf);
 }
 
@@ -319,6 +268,69 @@ static void fw_free_buf(struct firmware_buf *buf)
 	kref_put(&buf->ref, __fw_free_buf);
 }
 
+/* direct firmware loading support */
+static const char *fw_path[] = {
+	"/lib/firmware/updates/" UTS_RELEASE,
+	"/lib/firmware/updates",
+	"/lib/firmware/" UTS_RELEASE,
+	"/lib/firmware"
+};
+
+/* Don't inline this: 'struct kstat' is biggish */
+static noinline long fw_file_size(struct file *file)
+{
+	struct kstat st;
+	if (vfs_getattr(file->f_path.mnt, file->f_path.dentry, &st))
+		return -1;
+	if (!S_ISREG(st.mode))
+		return -1;
+	if (st.size != (long)st.size)
+		return -1;
+	return st.size;
+}
+
+static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
+{
+	long size;
+	char *buf;
+
+	size = fw_file_size(file);
+	if (size < 0)
+		return false;
+	buf = vmalloc(size);
+	if (!buf)
+		return false;
+	if (kernel_read(file, 0, buf, size) != size) {
+		vfree(buf);
+		return false;
+	}
+	fw_buf->data = buf;
+	fw_buf->size = size;
+	return true;
+}
+
+static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
+{
+	int i;
+	bool success = false;
+	char *path = __getname();
+
+	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+		struct file *file;
+		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
+
+		file = filp_open(path, O_RDONLY, 0);
+		if (IS_ERR(file))
+			continue;
+		success = fw_read_file_contents(file, buf);
+		fput(file);
+		if (success)
+			break;
+	}
+	__putname(path);
+	return success;
+}
+
 static struct firmware_priv *to_firmware_priv(struct device *dev)
 {
 	return container_of(dev, struct firmware_priv, dev);
@@ -427,6 +439,9 @@ static void firmware_free_data(const struct firmware *fw)
 /* one pages buffer should be mapped/unmapped only once */
 static int fw_map_pages_buf(struct firmware_buf *buf)
 {
+	if (buf->fmt != PAGE_BUF)
+		return 0;
+
 	if (buf->data)
 		vunmap(buf->data);
 	buf->data = vmap(buf->pages, buf->nr_pages, 0, PAGE_KERNEL_RO);
@@ -789,11 +804,6 @@ _request_firmware_prepare(const struct firmware **firmware_p, const char *name,
 		return NULL;
 	}
 
-	if (fw_get_filesystem_firmware(firmware, name)) {
-		dev_dbg(device, "firmware: direct-loading firmware %s\n", name);
-		return NULL;
-	}
-
 	ret = fw_lookup_and_allocate_buf(name, &fw_cache, &buf);
 	if (!ret)
 		fw_priv = fw_create_instance(firmware, name, device,
@@ -843,6 +853,21 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	struct device *f_dev = &fw_priv->dev;
 	struct firmware_buf *buf = fw_priv->buf;
 	struct firmware_cache *fwc = &fw_cache;
+	int direct_load = 0;
+
+	/* try direct loading from fs first */
+	if (fw_get_filesystem_firmware(buf)) {
+		dev_dbg(f_dev->parent, "firmware: direct-loading"
+			" firmware %s\n", buf->fw_id);
+
+		set_bit(FW_STATUS_DONE, &buf->status);
+		complete_all(&buf->completion);
+		direct_load = 1;
+		goto handle_fw;
+	}
+
+	/* fall back on userspace loading */
+	buf->fmt = PAGE_BUF;
 
 	dev_set_uevent_suppress(f_dev, true);
 
@@ -881,6 +906,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 
 	del_timer_sync(&fw_priv->timeout);
 
+handle_fw:
 	mutex_lock(&fw_lock);
 	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
 		retval = -ENOENT;
@@ -910,6 +936,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	fw_priv->buf = NULL;
 	mutex_unlock(&fw_lock);
 
+	if (direct_load)
+		goto err_put_dev;
+
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
 	device_remove_bin_file(f_dev, &firmware_attr_data);
-- 
1.7.9.5

