Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0I1VMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:12:48 -0400
Received: from mail.lixom.net ([70.86.134.90]:52251 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0I1VMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:12:47 -0400
Date: Tue, 28 Sep 2010 16:12:46 -0500
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100928211246.GA20941@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found this quite useful since it allows dmidecode to run without
root privileges using --from-dump to read this file instead (note:
dmidecode needs a change to fall back from mmap to regular reads, since
debugfs exports can't be mmapped()).

It also changes the calling convention of dmi_present somewhat, since the
16-byte EPS header is needed in the exported file.

Signed-off-by: Olof Johansson <olof@lixom.net>

---
 drivers/firmware/dmi_scan.c |   94 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index d464672..26141e1 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -5,6 +5,7 @@
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
+#include <linux/debugfs.h>
 #include <asm/dmi.h>
 
 /*
@@ -99,6 +100,73 @@ static u32 dmi_base;
 static u16 dmi_len;
 static u16 dmi_num;
 
+#ifdef CONFIG_DEBUG_FS
+static struct debugfs_blob_wrapper dmi_blob;
+
+/* Export a copy of the DMI blob through debugfs. Just concatenate the
+ * header with the main blob, and make the pointer the file offset of the
+ * main blob (i.e. 32 bytes).
+ */
+static int __init dmi_debug_setup(const char __iomem *p)
+{
+	u8 *blob, *buf, tmp;
+	int i;
+
+	blob = dmi_alloc(dmi_len + 32);
+	if (!blob)
+		return -ENOMEM;
+
+	memcpy_fromio(blob, p, 32);
+
+	buf = dmi_ioremap(dmi_base, dmi_len);
+	memcpy_fromio(blob + 32, buf, dmi_len);
+	dmi_iounmap(buf, dmi_len);
+
+	/* 32 is the offset into the file  */
+	blob[24] = 32;
+	blob[25] = 0;
+	blob[26] = 0;
+	blob[27] = 0;
+
+	/* First checksum the IEPS */
+	blob[21] = 0;
+	tmp = 0;
+	for (i = 0x10; i < 0x1f; i++)
+		tmp += blob[i];
+	blob[21] = -tmp;
+
+	/* Then the EPS */
+	blob[4] = 0;
+	tmp = 0;
+	for (i = 0; i < blob[5]; i++)
+		tmp += blob[i];
+	blob[4] = -tmp;
+
+	dmi_blob.data = blob;
+	dmi_blob.size = dmi_len + 32;
+
+	return 0;
+}
+
+static int __init dmi_debugfs_create(void)
+{
+	void *ret = ERR_PTR(-ENODEV);
+
+	if (dmi_blob.data)
+		ret = debugfs_create_blob("dmidump", 0444, NULL, &dmi_blob);
+
+	return PTR_ERR(ret);
+}
+late_initcall(dmi_debugfs_create);
+
+#else
+
+static int __init dmi_debug_setup(const char __iomem *p)
+{
+	return 0;
+}
+#endif /* CONFIG_DEBUGFS */
+
 static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 		void *))
 {
@@ -338,26 +406,30 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 
 static int __init dmi_present(const char __iomem *p)
 {
-	u8 buf[15];
+	u8 buf[31];
 
-	memcpy_fromio(buf, p, 15);
-	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
-		dmi_num = (buf[13] << 8) | buf[12];
-		dmi_len = (buf[7] << 8) | buf[6];
-		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
-			(buf[9] << 8) | buf[8];
+	memcpy_fromio(buf, p, 31);
+	/* _DMI_ string starts 16 bytes in. */
+	if ((memcmp(buf+16, "_DMI_", 5) == 0) && dmi_checksum(buf+16)) {
+		dmi_num = (buf[29] << 8) | buf[28];
+		dmi_len = (buf[23] << 8) | buf[22];
+		dmi_base = (buf[27] << 24) | (buf[26] << 16) |
+			(buf[25] << 8) | buf[24];
 
 		/*
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
-		if (buf[14] != 0)
+		if (buf[30] != 0)
 			printk(KERN_INFO "DMI %d.%d present.\n",
-			       buf[14] >> 4, buf[14] & 0xF);
+			       buf[30] >> 4, buf[30] & 0xf);
 		else
 			printk(KERN_INFO "DMI present.\n");
-		if (dmi_walk_early(dmi_decode) == 0)
+		if (dmi_walk_early(dmi_decode) == 0) {
+			dmi_debug_setup(p);
+
 			return 0;
+		}
 	}
 	return 1;
 }
@@ -379,7 +451,7 @@ void __init dmi_scan_machine(void)
 		if (p == NULL)
 			goto error;
 
-		rc = dmi_present(p + 0x10); /* offset of _DMI_ string */
+		rc = dmi_present(p);
 		dmi_iounmap(p, 32);
 		if (!rc) {
 			dmi_available = 1;
-- 
1.7.0.4

