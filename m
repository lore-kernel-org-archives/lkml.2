Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2GYLE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:04:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37566 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2GYLE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:04:27 -0400
Message-ID: <500FD2D9.4050007@oracle.com>
Date: Wed, 25 Jul 2012 19:04:57 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: akpm@linux-foundation.org, khali@linux-fr.org
CC: linux-kernel@vger.kernel.org, Feng Jin <joe.jin@oracle.com>
Subject: [PATCH 1/2] Check dmi version when get system uuid
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of version 2.6 of the SMBIOS specification, the first 3
fields of the UUID are supposed to be encoded on little-endian.

Also a minor fix to match variable meaning and mute checkpatch.pl

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/firmware/dmi_scan.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 153980b..d8c804d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -15,6 +15,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
+static u16  __initdata dmi_ver;
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -158,8 +159,10 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 		return;
 
 	for (i = 0; i < 16 && (is_ff || is_00); i++) {
-		if(d[i] != 0x00) is_ff = 0;
-		if(d[i] != 0xFF) is_00 = 0;
+		if (d[i] != 0x00)
+			is_00 = 0;
+		if (d[i] != 0xFF)
+			is_ff = 0;
 	}
 
 	if (is_ff || is_00)
@@ -169,7 +172,16 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	if (!s)
 		return;
 
-	sprintf(s, "%pUB", d);
+	/*
+	 * As of version 2.6 of the SMBIOS specification, the first 3
+	 * fields of the UUID are supposed to be encoded on little-endian.
+	 * The specification says that this is the defacto standard,
+	 * update kernel code to match dmidecode data.
+	*/
+	if (dmi_ver >= 0x0206)
+		sprintf(s, "%pUL", d);
+	else
+		sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
@@ -411,6 +423,7 @@ static int __init dmi_present(const char __iomem *p)
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
+		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
 		if (buf[14] != 0)
 			printk(KERN_INFO "DMI %d.%d present.\n",
 			       buf[14] >> 4, buf[14] & 0xF);
-- 
1.7.3

