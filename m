Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab0EUQym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:42 -0400
Received: from kroah.org ([198.145.64.141]:39113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934240Ab0EUQyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/38] firmware loader: split out builtin firmware handling
Date: Fri, 21 May 2010 09:53:44 -0700
Message-Id: <1274460848-11377-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Split builtin firmware handling into separate functions to clean up the
main body of code.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |   76 +++++++++++++++++++++++++++--------------
 1 files changed, 50 insertions(+), 26 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d351e77..c378a35 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -27,6 +27,52 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+/* Builtin firmware support */
+
+#ifdef CONFIG_FW_LOADER
+
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+
+static bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++) {
+		if (strcmp(name, b_fw->name) == 0) {
+			fw->size = b_fw->size;
+			fw->data = b_fw->data;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool fw_is_builtin_firmware(const struct firmware *fw)
+{
+	struct builtin_fw *b_fw;
+
+	for (b_fw = __start_builtin_fw; b_fw != __end_builtin_fw; b_fw++)
+		if (fw->data == b_fw->data)
+			return true;
+
+	return false;
+}
+
+#else /* Module case - no builtin firmware support */
+
+static inline bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+{
+	return false;
+}
+
+static inline bool fw_is_builtin_firmware(const struct firmware *fw)
+{
+	return false;
+}
+#endif
+
 enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
@@ -53,14 +99,6 @@ struct firmware_priv {
 	bool nowait;
 };
 
-#ifdef CONFIG_FW_LOADER
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
-#else /* Module case. Avoid ifdefs later; it'll all optimise out */
-static struct builtin_fw *__start_builtin_fw;
-static struct builtin_fw *__end_builtin_fw;
-#endif
-
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
@@ -497,7 +535,6 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	struct builtin_fw *builtin;
 	int retval;
 
 	if (!firmware_p)
@@ -511,13 +548,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
-	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-	     builtin++) {
-		if (strcmp(name, builtin->name))
-			continue;
+	if (fw_get_builtin_firmware(firmware, name)) {
 		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
-		firmware->size = builtin->size;
-		firmware->data = builtin->data;
 		return 0;
 	}
 
@@ -589,19 +621,11 @@ request_firmware(const struct firmware **firmware_p, const char *name,
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
-void
-release_firmware(const struct firmware *fw)
+void release_firmware(const struct firmware *fw)
 {
-	struct builtin_fw *builtin;
-
 	if (fw) {
-		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-		     builtin++) {
-			if (fw->data == builtin->data)
-				goto free_fw;
-		}
-		firmware_free_data(fw);
-	free_fw:
+		if (!fw_is_builtin_firmware(fw))
+			firmware_free_data(fw);
 		kfree(fw);
 	}
 }
-- 
1.7.0.3

