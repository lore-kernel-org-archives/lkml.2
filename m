Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2CZSMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab2CZSMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:12:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] dmi, Use little-endian for sysfs PRODUCT UUID
Date: Mon, 26 Mar 2012 14:12:51 -0400
Message-Id: <1332785571-1475-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this discrepancy between the output of 'dmidecode -t 1 | grep
UUID' and the output of /sys/class/dmi/id/product_uuid:

[root@intel-mahobay-01 ~]# cat /sys/class/dmi/id/product_uuid
001320FB-4C2D-0013-20FB-4C2D001320FB
[root@intel-mahobay-01 ~]# dmidecode | grep UUID
        UUID: FB201300-2D4C-1300-20FB-4C2D001320FB

Section 7.2.1, "System -- UUID" of the SMBIOS Specification (version
2.7.1) states:

Although RFC 4122 recommends network byte order for all fields, the PC
industry (including the ACPI, UEFI, and Microsoft specifications) has
consistently used little-endian byte encoding for the first three
fields: time_low, time_mid, time_hi_and_version. The same encoding, also
known as wire format, should also be used for the SMBIOS representation of
the UUID.

The UUID {00112233-4455-6677-8899-AABBCCDDEEFF} would thus be
represented as:

33 22 11 00 55 44 77 66 88 99 AA BB CC DD EE FF.

However, A comment in the dmidecode utility contains the following warning:

	 * As of version 2.6 of the SMBIOS specification, the first 3
	 * fields of the UUID are supposed to be encoded on little-endian.
	 * The specification says that this is the defacto standard,
	 * however I've seen systems following RFC 4122 instead and use
	 * network byte order, so I am reluctant to apply the byte-swapping
	 * for older versions.

Apply this same logic to the output of the kernel's representation for SMBIOS
Product UUID.

After the patch is applied on a system with SMBIOS version 2.6,

[root@intel-mahobay-01 ~]# cat /sys/class/dmi/id/product_uuid
FB201300-2D4C-1300-20FB-4C2D001320FB
[root@intel-mahobay-01 ~]# dmidecode | grep UUID
	UUID: FB201300-2D4C-1300-20FB-4C2D001320FB

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/firmware/dmi_scan.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 153980b..ef41d90 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -15,6 +15,9 @@
  */
 static char dmi_empty_string[] = "        ";
 
+/* SMBIOS version in MMmm format */
+static u16 smbios_version;
+
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -169,7 +172,18 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	if (!s)
 		return;
 
-	sprintf(s, "%pUB", d);
+	/*
+	 * As of version 2.6 of the SMBIOS specification, the first 3
+	 * fields of the UUID are supposed to be encoded on little-endian.
+	 * The specification says that this is the defacto standard,
+	 * however we've seen systems following RFC 4122 instead and use
+	 * network byte order, so do not apply the byte-swapping
+	 * for older versions.
+	 */
+	if (smbios_version >= 0x0206)
+		sprintf(s, "%pUL", d);
+	else
+		sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
@@ -411,9 +425,12 @@ static int __init dmi_present(const char __iomem *p)
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
-		if (buf[14] != 0)
+		if (buf[14] != 0){
 			printk(KERN_INFO "DMI %d.%d present.\n",
 			       buf[14] >> 4, buf[14] & 0xF);
+			smbios_version = (((buf[14] >> 4) << 8) +
+					  (buf[14] & 0xF));
+		}
 		else
 			printk(KERN_INFO "DMI present.\n");
 		if (dmi_walk_early(dmi_decode) == 0) {
-- 
1.7.1

