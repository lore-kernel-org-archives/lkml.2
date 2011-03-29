Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1C2WZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:25:50 -0400
Received: from mail.perches.com ([173.55.12.10]:4371 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab1C2WW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:29 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/23] ibm_rtl: Use pr_fmt and pr_<level>
Date: Tue, 29 Mar 2011 15:21:42 -0700
Message-Id: <f74c57954974d0250a238f1224f1214f203fb1ea.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hard coded prefixes from logging messages.
Neaten RTL_DEBUG macro and uses.
Convert __FUNCTION__ to __func__.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/ibm_rtl.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index f0b0683..b9bf63f 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -22,6 +22,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/module.h>
@@ -69,9 +71,10 @@ struct ibm_rtl_table {
 #define RTL_SIGNATURE 0x0000005f4c54525fULL
 #define RTL_MASK      0x000000ffffffffffULL
 
-#define RTL_DEBUG(A, ...) do { \
-	if (debug) \
-		pr_info("ibm-rtl: " A, ##__VA_ARGS__ ); \
+#define RTL_DEBUG(fmt, ...)				\
+do {							\
+	if (debug)					\
+		pr_info(fmt, ##__VA_ARGS__);		\
 } while (0)
 
 static DEFINE_MUTEX(rtl_lock);
@@ -101,7 +104,7 @@ static int ibm_rtl_write(u8 value)
 	int ret = 0, count = 0;
 	static u32 cmd_port_val;
 
-	RTL_DEBUG("%s(%d)\n", __FUNCTION__, value);
+	RTL_DEBUG("%s(%d)\n", __func__, value);
 
 	value = value == 1 ? RTL_CMD_ENTER_PRTM : RTL_CMD_EXIT_PRTM;
 
@@ -131,8 +134,8 @@ static int ibm_rtl_write(u8 value)
 		while (ioread8(&rtl_table->command)) {
 			msleep(10);
 			if (count++ > 500) {
-				pr_err("ibm-rtl: Hardware not responding to "
-					"mode switch request\n");
+				pr_err("Hardware not responding to "
+				       "mode switch request\n");
 				ret = -EIO;
 				break;
 			}
@@ -237,7 +240,7 @@ static int __init ibm_rtl_init(void) {
 	int ret = -ENODEV, i;
 
 	if (force)
-		pr_warning("ibm-rtl: module loaded by force\n");
+		pr_warn("module loaded by force\n");
 	/* first ensure that we are running on IBM HW */
 	else if (efi_enabled || !dmi_check_system(ibm_rtl_dmi_table))
 		return -ENODEV;
@@ -282,7 +285,7 @@ static int __init ibm_rtl_init(void) {
 			rtl_cmd_width = ioread8(&rtl_table->cmd_granularity);
 			rtl_cmd_type = ioread8(&rtl_table->cmd_address_type);
 			RTL_DEBUG("rtl_cmd_width = %u, rtl_cmd_type = %u\n",
-			      rtl_cmd_width, rtl_cmd_type);
+				  rtl_cmd_width, rtl_cmd_type);
 			addr = ioread32(&rtl_table->cmd_port_address);
 			RTL_DEBUG("addr = %#llx\n", (unsigned long long)addr);
 			plen = rtl_cmd_width/sizeof(char);
-- 
1.7.4.2.g597a6.dirty

