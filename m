Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2KHRfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:35:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab2KHRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:35:34 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH RFC v2 3/4] firmware: Add support for signature checks
Date: Thu,  8 Nov 2012 18:35:08 +0100
Message-Id: <1352396109-3989-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352396109-3989-1-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
 <1352396109-3989-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a feature to check the firmware signature, specified via Kconfig
CONFIG_FIRMWARE_SIG.

The signature check is performed only for the direct fw loading
without udev.  If sig_enforce is set but no firmware file is found in
fs, request_firmware*() returns an error for now.  It would be
possible to improve this situation, e.g. by adding an extra request of
signature via yet another uevent, but I'm too lazy to implement it and
also skeptical whether it's needed.

On a kernel with CONFIG_FIRMWARE_SIG=y and sig_enforce=1 set, when no
firmware signature is present or the signature doesn't match, the
kernel rejects such a firmware and proceeds to the next possible one.
With sig_enforce=0, a firmware is loaded even if no signature is found
or the signature doesn't match, but it taints the kernel with
TAINT_USER.  This behavior is similar like the signed module loading.

Last to be noted, in this version, the firmware signature support
depends on CONFIG_MODULE_SIG, that is, the system requires the module
support for now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/Kconfig          |  6 ++++
 drivers/base/firmware_class.c | 78 +++++++++++++++++++++++++++++++++++++++----
 include/linux/firmware.h      |  7 ++++
 kernel/module_signing.c       | 63 ++++++++++++++++++++++++++++++++++
 4 files changed, 147 insertions(+), 7 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index b34b5cd..3696fd7 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -145,6 +145,12 @@ config EXTRA_FIRMWARE_DIR
 	  this option you can point it elsewhere, such as /lib/firmware/ or
 	  some other directory containing the firmware files.
 
+config FIRMWARE_SIG
+	bool "Firmware signature verification"
+	depends on FW_LOADER && MODULE_SIG
+	help
+	  Enable firmware signature check.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..501cff4 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -36,6 +36,11 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_FIRMWARE_SIG
+static bool sig_enforce;
+module_param(sig_enforce, bool, 0644);
+#endif
+
 /* Builtin firmware support */
 
 #ifdef CONFIG_FW_LOADER
@@ -287,7 +292,7 @@ static noinline long fw_file_size(struct file *file)
 	return st.size;
 }
 
-static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
+static bool fw_read_file_contents(struct file *file, void **bufp, size_t *sizep)
 {
 	long size;
 	char *buf;
@@ -302,14 +307,42 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
 		vfree(buf);
 		return false;
 	}
-	fw_buf->data = buf;
-	fw_buf->size = size;
+	*bufp = buf;
+	*sizep = size;
 	return true;
 }
 
+#ifdef CONFIG_FIRMWARE_SIG
+static int verify_sig_file(struct firmware_buf *buf, const char *path)
+{
+	const unsigned long markerlen = sizeof(FIRMWARE_SIG_STRING) - 1;
+	struct file *file;
+	void *sig_data;
+	size_t sig_size;
+	int ret;
+
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file))
+		return -ENOKEY;
+
+	ret = fw_read_file_contents(file, &sig_data, &sig_size);
+	fput(file);
+	if (!ret)
+		return -ENOKEY;
+	if (sig_size <= markerlen ||
+	    memcmp(sig_data, FIRMWARE_SIG_STRING, markerlen))
+		return -EBADMSG;
+	ret = fw_verify_sig(buf->data, buf->size,
+			    sig_data + markerlen, sig_size - markerlen);
+	pr_debug("verified signature %s: %d\n", path, ret);
+	vfree(sig_data);
+	return ret;
+}
+#endif /* CONFIG_FIRMWARE_SIG */
+
 static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
 {
-	int i;
+	int i, ret;
 	bool success = false;
 	char *path = __getname();
 
@@ -320,10 +353,30 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
 		file = filp_open(path, O_RDONLY, 0);
 		if (IS_ERR(file))
 			continue;
-		success = fw_read_file_contents(file, buf);
+		success = fw_read_file_contents(file, &buf->data, &buf->size);
 		fput(file);
-		if (success)
-			break;
+		if (!success)
+			continue;
+#ifdef CONFIG_FIRMWARE_SIG
+		snprintf(path, PATH_MAX, "%s/%s.sig", fw_path[i], buf->fw_id);
+		ret = verify_sig_file(buf, path);
+		if (ret < 0) {
+			if (ret == -ENOENT)
+				pr_err("Cannot find firmware signature %s\n",
+				       path);
+			else
+				pr_err("Invalid firmware signature %s\n", path);
+			if (sig_enforce) {
+				vfree(buf->data);
+				buf->data = NULL;
+				buf->size = 0;
+				success = false;
+				continue;
+			}
+			add_taint(TAINT_USER);
+		}
+#endif /* CONFIG_FIRMWARE_SIG */
+		break;
 	}
 	__putname(path);
 	return success;
@@ -864,6 +917,17 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		goto handle_fw;
 	}
 
+#ifdef CONFIG_FIRMWARE_SIG
+	/* FIXME: we don't handle signature check for fw loaded via udev */
+	if (sig_enforce) {
+		pr_err("Cannot find firmware file %s; aborting fw loading\n",
+		       buf->fw_id);
+		fw_load_abort(fw_priv);
+		direct_load = 1;
+		goto handle_fw;
+	}
+#endif
+
 	/* fall back on userspace loading */
 	buf->fmt = PAGE_BUF;
 
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index e4279fe..2e9e457 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -79,4 +79,11 @@ static inline int uncache_firmware(const char *name)
 }
 #endif
 
+#ifdef CONFIG_FIRMWARE_SIG
+#define FIRMWARE_SIG_STRING "~Linux firmware signature~\n"
+/* defined in kernel/module_signing.c */
+int fw_verify_sig(const void *fw_data, size_t fw_size,
+		  const void *sig_data, size_t sig_size);
+#endif
+
 #endif
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index ea1b1df..7994452 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <crypto/public_key.h>
 #include <crypto/hash.h>
 #include <keys/asymmetric-type.h>
@@ -247,3 +248,65 @@ error_put_key:
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;	
 }
+
+#ifdef CONFIG_FIRMWARE_SIG
+/*
+ * Verify the firmware signature, similar like module signature check
+ * but it's stored in a separate file
+ */
+int fw_verify_sig(const void *fw_data, size_t fw_size,
+		  const void *sig_data, size_t sig_size)
+{
+	struct public_key_signature *pks;
+	struct module_signature ms;
+	struct key *key;
+	size_t sig_len;
+	int ret;
+
+	if (sig_size <= sizeof(ms))
+		return -EBADMSG;
+
+	memcpy(&ms, sig_data, sizeof(ms));
+	sig_data += sizeof(ms);
+	sig_size -= sizeof(ms);
+
+	sig_len = be32_to_cpu(ms.sig_len);
+	if (sig_size < sig_len + (size_t)ms.signer_len + ms.key_id_len)
+		return -EBADMSG;
+
+	/* For the moment, only support RSA and X.509 identifiers */
+	if (ms.algo != PKEY_ALGO_RSA ||
+	    ms.id_type != PKEY_ID_X509)
+		return -ENOPKG;
+
+	if (ms.hash >= PKEY_HASH__LAST ||
+	    !pkey_hash_algo[ms.hash])
+		return -ENOPKG;
+
+	key = request_asymmetric_key(sig_data, ms.signer_len,
+				     sig_data + ms.signer_len, ms.key_id_len);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	pks = mod_make_digest(ms.hash, fw_data, fw_size);
+	if (IS_ERR(pks)) {
+		ret = PTR_ERR(pks);
+		goto error_put_key;
+	}
+
+	sig_data += ms.signer_len + ms.key_id_len;
+	ret = mod_extract_mpi_array(pks, sig_data, sig_len);
+	if (ret < 0)
+		goto error_free_pks;
+
+	ret = verify_signature(key, pks);
+
+error_free_pks:
+	mpi_free(pks->rsa.s);
+	kfree(pks);
+error_put_key:
+	key_put(key);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fw_verify_sig);
+#endif /* CONFIG_FIRMWARE_SIG */
-- 
1.8.0

