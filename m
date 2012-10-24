Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab2JXCuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:50:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51134 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXCuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:50:09 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] firmware loader: introduce kernel parameter to customize fw search path
Date: Wed, 24 Oct 2012 10:49:53 +0800
Message-Id: <1351046993-2220-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces one kernel parameter of 'fw_path' to support
customizing firmware image search path, so that people can use its
own firmware path if the default built-in paths can't meet their demand[1].

[1], https://lkml.org/lkml/2012/10/11/337

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 Documentation/firmware_class/README |    1 +
 Documentation/kernel-parameters.txt |    9 +++++++++
 drivers/base/firmware_class.c       |   24 ++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index 815b711..af63ad3 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -22,6 +22,7 @@
 	- calls request_firmware(&fw_entry, $FIRMWARE, device)
 	- kernel searchs the fimware image with name $FIRMWARE directly
 	in the below search path of root filesystem:
+		User customized search path by kernel parameter of 'fw_path'
 		"/lib/firmware/updates/" UTS_RELEASE,
 		"/lib/firmware/updates",
 		"/lib/firmware/" UTS_RELEASE,
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..d1125c5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -52,6 +52,7 @@ parameter is applicable:
 	EVM	Extended Verification Module
 	FB	The frame buffer device is enabled.
 	FTRACE	Function tracing enabled.
+	FW      The firmware loader is enabled.
 	GCOV	GCOV profiling is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
@@ -843,6 +844,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <interval>,<probability>,<space>,<times>
 			See also Documentation/fault-injection/.
 
+	fw_path=	[FW]
+			Customized firmware image search path for kernel
+			direct loading, which has higher priority than
+			built-in default search path.
+			Format: <string>, length < 256
+				direcory path, such as /lib/firmware.
+			See Documentation/firmware_class/README.
+
 	floppy=		[HW]
 			See Documentation/blockdev/floppy.txt.
 
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..e7db931 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -274,6 +274,17 @@ static const char *fw_path[] = {
 	"/lib/firmware"
 };
 
+static char fw_path_para[256];
+static int __init customized_path(char *str)
+{
+	if (strlen(str) < 256)
+		strlcpy(fw_path_para, str, sizeof(fw_path_para));
+	return 1;
+}
+__setup("fw_path=", customized_path);
+module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
+MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
+
 /* Don't inline this: 'struct kstat' is biggish */
 static noinline long fw_file_size(struct file *file)
 {
@@ -313,9 +324,18 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
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

