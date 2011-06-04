Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1FDTf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 15:35:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36017 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1FDTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 15:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PCCV47FtqwQZsfWIDfGU/L+peg6F8ykGgqL+eejyqEIbznVE7k6H5ubS9Q+hRv6Akf
         ghXs2Sf1hNa/x77B/QrPNpgsqN9+u3pzj9dzo8xxKJ+7eWt1ohGDUeCXqtCF5ugkYTku
         WmjWtIi6ZGnmONR+RHWcwvCyEaLtxX879M7Dc=
From: Andre Bartke <andre.bartke@googlemail.com>
To: dbrownell@users.sourceforge.net
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] drivers/usb/gadget: add missing kfree calls
Date: Sat,  4 Jun 2011 21:34:54 +0200
Message-Id: <1307216094-13570-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that there are several memory leaks
due to missing kfree() calls. Also fixed
some coding style issues.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/usb/gadget/rndis.c |   59 ++++++++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index d3cdffe..1e3cc06 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -31,8 +31,8 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/netdevice.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/system.h>
 #include <asm/unaligned.h>
@@ -71,8 +71,7 @@ static rndis_resp_t *rndis_add_response(int configNr, u32 length);
 
 
 /* supported OIDs */
-static const u32 oid_supported_list[] =
-{
+static const u32 oid_supported_list[] = {
 	/* the general stuff */
 	OID_GEN_SUPPORTED_LIST,
 	OID_GEN_HARDWARE_STATUS,
@@ -173,10 +172,12 @@ static int gen_ndis_query_resp(int configNr, u32 OID, u8 *buf,
 	struct rtnl_link_stats64 temp;
 	const struct rtnl_link_stats64 *stats;
 
-	if (!r) return -ENOMEM;
+	if (!r)
+		return -ENOMEM;
 	resp = (rndis_query_cmplt_type *)r->buf;
 
-	if (!resp) return -ENOMEM;
+	if (!resp)
+		return -ENOMEM;
 
 	if (buf_len && rndis_debug > 1) {
 		pr_debug("query OID %08x value, len %d:\n", OID, buf_len);
@@ -425,7 +426,7 @@ static int gen_ndis_query_resp(int configNr, u32 OID, u8 *buf,
 		if (rndis_per_dev_params[configNr].dev) {
 			length = ETH_ALEN;
 			memcpy(outbuf,
-				rndis_per_dev_params [configNr].host_mac,
+				rndis_per_dev_params[configNr].host_mac,
 				length);
 			retval = 0;
 		}
@@ -597,6 +598,7 @@ static int rndis_init_response(int configNr, rndis_init_msg_type *buf)
 	resp->AFListSize = cpu_to_le32(0);
 
 	params->resp_avail(params->v);
+	kfree(r);
 	return 0;
 }
 
@@ -662,9 +664,8 @@ static int rndis_set_response(int configNr, rndis_set_msg_type *buf)
 	pr_debug("%s: Offset: %d\n", __func__, BufOffset);
 	pr_debug("%s: InfoBuffer: ", __func__);
 
-	for (i = 0; i < BufLength; i++) {
+	for (i = 0; i < BufLength; i++)
 		pr_debug("%02x ", *(((u8 *) buf) + i + 8 + BufOffset));
-	}
 
 	pr_debug("\n");
 #endif
@@ -700,6 +701,7 @@ static int rndis_reset_response(int configNr, rndis_reset_msg_type *buf)
 	resp->AddressingReset = cpu_to_le32(1);
 
 	params->resp_avail(params->v);
+	kfree(r);
 	return 0;
 }
 
@@ -724,6 +726,7 @@ static int rndis_keepalive_response(int configNr,
 	resp->Status = cpu_to_le32(RNDIS_STATUS_SUCCESS);
 
 	params->resp_avail(params->v);
+	kfree(r);
 	return 0;
 }
 
@@ -753,6 +756,7 @@ static int rndis_indicate_status_msg(int configNr, u32 status)
 	resp->StatusBufferOffset = cpu_to_le32(0);
 
 	params->resp_avail(params->v);
+	kfree(r);
 	return 0;
 }
 
@@ -875,13 +879,13 @@ int rndis_msg_parser(u8 configNr, u8 *buf)
 					" %02x %02x %02x %02x"
 					"\n",
 					i,
-					buf[i], buf [i+1],
+					buf[i], buf[i+1],
 						buf[i+2], buf[i+3],
-					buf[i+4], buf [i+5],
+					buf[i+4], buf[i+5],
 						buf[i+6], buf[i+7],
-					buf[i+8], buf [i+9],
+					buf[i+8], buf[i+9],
 						buf[i+10], buf[i+11],
-					buf[i+12], buf [i+13],
+					buf[i+12], buf[i+13],
 						buf[i+14], buf[i+15]);
 			}
 		}
@@ -916,7 +920,8 @@ void rndis_deregister(int configNr)
 {
 	pr_debug("%s:\n", __func__);
 
-	if (configNr >= RNDIS_MAX_CONFIGS) return;
+	if (configNr >= RNDIS_MAX_CONFIGS)
+		return;
 	rndis_per_dev_params[configNr].used = 0;
 }
 
@@ -925,7 +930,8 @@ int rndis_set_param_dev(u8 configNr, struct net_device *dev, u16 *cdc_filter)
 	pr_debug("%s:\n", __func__);
 	if (!dev)
 		return -EINVAL;
-	if (configNr >= RNDIS_MAX_CONFIGS) return -1;
+	if (configNr >= RNDIS_MAX_CONFIGS)
+		return -1;
 
 	rndis_per_dev_params[configNr].dev = dev;
 	rndis_per_dev_params[configNr].filter = cdc_filter;
@@ -936,8 +942,10 @@ int rndis_set_param_dev(u8 configNr, struct net_device *dev, u16 *cdc_filter)
 int rndis_set_param_vendor(u8 configNr, u32 vendorID, const char *vendorDescr)
 {
 	pr_debug("%s:\n", __func__);
-	if (!vendorDescr) return -1;
-	if (configNr >= RNDIS_MAX_CONFIGS) return -1;
+	if (!vendorDescr)
+		return -1;
+	if (configNr >= RNDIS_MAX_CONFIGS)
+		return -1;
 
 	rndis_per_dev_params[configNr].vendorID = vendorID;
 	rndis_per_dev_params[configNr].vendorDescr = vendorDescr;
@@ -948,7 +956,8 @@ int rndis_set_param_vendor(u8 configNr, u32 vendorID, const char *vendorDescr)
 int rndis_set_param_medium(u8 configNr, u32 medium, u32 speed)
 {
 	pr_debug("%s: %u %u\n", __func__, medium, speed);
-	if (configNr >= RNDIS_MAX_CONFIGS) return -1;
+	if (configNr >= RNDIS_MAX_CONFIGS)
+		return -1;
 
 	rndis_per_dev_params[configNr].medium = medium;
 	rndis_per_dev_params[configNr].speed = speed;
@@ -991,7 +1000,8 @@ u8 *rndis_get_next_response(int configNr, u32 *length)
 	rndis_resp_t *r;
 	struct list_head *act, *tmp;
 
-	if (!length) return NULL;
+	if (!length)
+		return NULL;
 
 	list_for_each_safe(act, tmp,
 			&(rndis_per_dev_params[configNr].resp_queue))
@@ -1013,7 +1023,8 @@ static rndis_resp_t *rndis_add_response(int configNr, u32 length)
 
 	/* NOTE: this gets copied into ether.c USB_BUFSIZ bytes ... */
 	r = kmalloc(sizeof(rndis_resp_t) + length, GFP_ATOMIC);
-	if (!r) return NULL;
+	if (!r)
+		return NULL;
 
 	r->buf = (u8 *)(r + 1);
 	r->length = length;
@@ -1116,8 +1127,10 @@ static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 			rndis_signal_disconnect(p->confignr);
 			break;
 		default:
-			if (fl_speed) p->speed = speed;
-			else pr_debug("%c is not valid\n", c);
+			if (fl_speed)
+				p->speed = speed;
+			else
+				pr_debug("%c is not valid\n", c);
 			break;
 		}
 
@@ -1143,7 +1156,7 @@ static const struct file_operations rndis_proc_fops = {
 
 #define	NAME_TEMPLATE "driver/rndis-%03d"
 
-static struct proc_dir_entry *rndis_connect_state [RNDIS_MAX_CONFIGS];
+static struct proc_dir_entry *rndis_connect_state[RNDIS_MAX_CONFIGS];
 
 #endif /* CONFIG_USB_GADGET_DEBUG_FILES */
 
@@ -1154,7 +1167,7 @@ int rndis_init(void)
 
 	for (i = 0; i < RNDIS_MAX_CONFIGS; i++) {
 #ifdef	CONFIG_USB_GADGET_DEBUG_FILES
-		char name [20];
+		char name[20];
 
 		sprintf(name, NAME_TEMPLATE, i);
 		rndis_connect_state[i] = proc_create_data(name, 0660, NULL,
-- 
1.7.5.2

