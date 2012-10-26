Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2JZAqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:46:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2JZAqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:46:31 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v1] firmware loader: introduce module parameter to customize fw search path
Date: Fri, 26 Oct 2012 08:46:19 +0800
Message-Id: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces one module parameter of 'path' in firmware_class
to support customizing firmware image search path, so that people can
use its own firmware path if the default built-in paths can't meet their
demand[1], and the typical usage is passing the below from kernel command
parameter when 'firmware_class' is built in kernel:

	firmware_class.path=$CUSTOMIZED_PATH

[1], https://lkml.org/lkml/2012/10/11/337

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
V1:
	- remove kernel boot parameter and only support the feature by
	module parameter as suggested by Greg

 Documentation/firmware_class/README |    5 +++++
 drivers/base/firmware_class.c       |   23 +++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index 815b711..ce02744 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -22,12 +22,17 @@
 	- calls request_firmware(&fw_entry, $FIRMWARE, device)
 	- kernel searchs the fimware image with name $FIRMWARE directly
 	in the below search path of root filesystem:
+		User customized search path by module parameter 'path'[1]
 		"/lib/firmware/updates/" UTS_RELEASE,
 		"/lib/firmware/updates",
 		"/lib/firmware/" UTS_RELEASE,
 		"/lib/firmware"
 	- If found, goto 7), else goto 2)
 
+	[1], the 'path' is a string parameter which length should be less
+	than 256, user should pass 'firmware.path=$CUSTOMIZED_PATH' if
+	firmware_class is built in kernel(the general situation)
+
  2), userspace:
  	- /sys/class/firmware/xxx/{loading,data} appear.
 	- hotplug gets called with a firmware identifier in $FIRMWARE
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..b363103 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -274,6 +274,16 @@ static const char *fw_path[] = {
 	"/lib/firmware"
 };
 
+static char fw_path_para[256];
+
+/*
+ * Typical usage is that passing 'firmware_class.path=$CUSTOMIZED_PATH'
+ * from kernel command because firmware_class is generally built in
+ * kernel instead of module.
+ */
+module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
+MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
+
 /* Don't inline this: 'struct kstat' is biggish */
 static noinline long fw_file_size(struct file *file)
 {
@@ -313,9 +323,18 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
 	bool success = false;
 	char *path = __getname();
 
-	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+	for (i = -1; i < ARRAY_SIZE(fw_path); i++) {
 		struct file *file;
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
+
+		if (i < 0) {
+			if (!fw_path_para[0])	/* No customized path */
+				continue;
+			snprintf(path, PATH_MAX, "%s/%s", fw_path_para,
+				 buf->fw_id);
+		} else {
+			snprintf(path, PATH_MAX, "%s/%s", fw_path[i],
+				 buf->fw_id);
+		}
 
 		file = filp_open(path, O_RDONLY, 0);
 		if (IS_ERR(file))
-- 
1.7.9.5

