Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2KCJsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:48:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37117 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2KCJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:48:10 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] firmware loader: introduce module parameter to customize(v4) fw search path
Date: Sat,  3 Nov 2012 17:47:58 +0800
Message-Id: <1351936078-13288-1-git-send-email-ming.lei@canonical.com>
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
v4:
	- fix one comment and rebase on the latest next tree
v3:
	- fix one mistake on checking unset firmware path
v2:
	- take a cleaner approach suggested by Linus
	- mark the path array as const because it needn't be changed
	- fix one error in Document about the module name
v1:
	- remove kernel boot parameter and only support the feature by
	module parameter as suggested by Greg
---
 Documentation/firmware_class/README |    5 +++++
 drivers/base/firmware_class.c       |   17 ++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index 815b711..e9fce78 100644
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
+	than 256, user should pass 'firmware_class.path=$CUSTOMIZED_PATH'
+	if firmware_class is built in kernel(the general situation)
+
  2), userspace:
  	- /sys/class/firmware/xxx/{loading,data} appear.
 	- hotplug gets called with a firmware identifier in $FIRMWARE
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 620b876..2067514 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -267,13 +267,23 @@ static void fw_free_buf(struct firmware_buf *buf)
 }
 
 /* direct firmware loading support */
-static const char *fw_path[] = {
+static char fw_path_para[256];
+static const char * const fw_path[] = {
+	fw_path_para,
 	"/lib/firmware/updates/" UTS_RELEASE,
 	"/lib/firmware/updates",
 	"/lib/firmware/" UTS_RELEASE,
 	"/lib/firmware"
 };
 
+/*
+ * Typical usage is that passing 'firmware_class.path=$CUSTOMIZED_PATH'
+ * from kernel command line because firmware_class is generally built in
+ * kernel instead of module.
+ */
+module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
+MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
+
 /* Don't inline this: 'struct kstat' is biggish */
 static noinline_for_stack long fw_file_size(struct file *file)
 {
@@ -315,6 +325,11 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
 		struct file *file;
+
+		/* skip the unset customized path */
+		if (!fw_path[i][0])
+			continue;
+
 		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
 
 		file = filp_open(path, O_RDONLY, 0);
-- 
1.7.9.5

