Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2GYLEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:04:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37641 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2GYLEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:04:36 -0400
Message-ID: <500FD2E5.3010307@oracle.com>
Date: Wed, 25 Jul 2012 19:05:09 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org, khali@linux-fr.org
CC: linux-kernel@vger.kernel.org, Feng Jin <joe.jin@oracle.com>
Subject: [PATCH 2/2] Fetch dmi version from SMBIOS if it exist
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The right dmi version is in SMBIOS if it's zero in DMI region

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/firmware/dmi_scan.c |   63 ++++++++++++++++++++++++++++++++----------
 1 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index d8c804d..bedefbf 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -116,12 +116,12 @@ static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 	return 0;
 }
 
-static int __init dmi_checksum(const u8 *buf)
+static int __init dmi_checksum(const u8 *buf, u8 len)
 {
 	u8 sum = 0;
 	int a;
 
-	for (a = 0; a < 15; a++)
+	for (a = 0; a < len; a++)
 		sum += buf[a];
 
 	return sum == 0;
@@ -413,30 +413,58 @@ static int __init dmi_present(const char __iomem *p)
 	u8 buf[15];
 
 	memcpy_fromio(buf, p, 15);
-	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
+	if (dmi_checksum(buf, 15)) {
 		dmi_num = (buf[13] << 8) | buf[12];
 		dmi_len = (buf[7] << 8) | buf[6];
 		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
 
-		/*
-		 * DMI version 0.0 means that the real version is taken from
-		 * the SMBIOS version, which we don't know at this point.
-		 */
-		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
-		if (buf[14] != 0)
-			printk(KERN_INFO "DMI %d.%d present.\n",
-			       buf[14] >> 4, buf[14] & 0xF);
-		else
-			printk(KERN_INFO "DMI present.\n");
 		if (dmi_walk_early(dmi_decode) == 0) {
+			if (dmi_ver)
+				printk(KERN_INFO "SMBIOS %d.%d present.\n",
+				       dmi_ver >> 8, dmi_ver & 0xFF);
+			else {
+				dmi_ver = (buf[14] & 0xF0) << 4 |
+					   (buf[14] & 0x0F);
+				printk(KERN_INFO "Legacy DMI %d.%d present.\n",
+				       dmi_ver >> 8, dmi_ver & 0xFF);
+			}
 			dmi_dump_ids();
 			return 0;
 		}
 	}
+	dmi_ver = 0;
 	return 1;
 }
 
+static int __init smbios_present(const char __iomem *p)
+{
+	u8 buf[32];
+	int offset = 0;
+
+	memcpy_fromio(buf, p, 32);
+	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
+		dmi_ver = (buf[6] << 8) + buf[7];
+
+		/* Some BIOS report weird SMBIOS version, fix that up */
+		switch (dmi_ver) {
+		case 0x021F:
+		case 0x0221:
+			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",
+			       dmi_ver & 0xFF, 3);
+			dmi_ver = 0x0203;
+			break;
+		case 0x0233:
+			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",
+			       51, 6);
+			dmi_ver = 0x0206;
+			break;
+		}
+		offset = 16;
+	}
+	return dmi_present(buf + offset);
+}
+
 void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
@@ -454,7 +482,7 @@ void __init dmi_scan_machine(void)
 		if (p == NULL)
 			goto error;
 
-		rc = dmi_present(p + 0x10); /* offset of _DMI_ string */
+		rc = smbios_present(p);
 		dmi_iounmap(p, 32);
 		if (!rc) {
 			dmi_available = 1;
@@ -472,7 +500,12 @@ void __init dmi_scan_machine(void)
 			goto error;
 
 		for (q = p; q < p + 0x10000; q += 16) {
-			rc = dmi_present(q);
+			if (memcmp(q, "_SM_", 4) == 0 && q - p <= 0xFFE0)
+				rc = smbios_present(q);
+			else if (memcmp(q, "_DMI_", 5) == 0)
+				rc = dmi_present(q);
+			else
+				continue;
 			if (!rc) {
 				dmi_available = 1;
 				dmi_iounmap(p, 0x10000);
-- 
1.7.3

