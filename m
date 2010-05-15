Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0EOVOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:14:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59029 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab0EOVN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:13:58 -0400
Date: Sat, 15 May 2010 23:13:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/37] drivers/misc/iwmc3200top/log.c: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152313170.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/misc/iwmc3200top/log.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -u -p a/drivers/misc/iwmc3200top/log.c b/drivers/misc/iwmc3200top/log.c
--- a/drivers/misc/iwmc3200top/log.c
+++ b/drivers/misc/iwmc3200top/log.c
@@ -214,7 +214,7 @@ ssize_t store_iwmct_log_level(struct dev
 	if (!count)
 		goto exit;
 
-	str_buf = kzalloc(count, GFP_KERNEL);
+	str_buf = kmemdup(buf, count, GFP_KERNEL);
 	if (!str_buf) {
 		LOG_ERROR(priv, DEBUGFS,
 			"failed to allocate %zd bytes\n", count);
@@ -222,8 +222,6 @@ ssize_t store_iwmct_log_level(struct dev
 		goto exit;
 	}
 
-	memcpy(str_buf, buf, count);
-
 	while ((token = strsep(&str_buf, ",")) != NULL) {
 		while (isspace(*token))
 			++token;
@@ -291,7 +289,7 @@ ssize_t store_iwmct_log_level_fw(struct 
 	if (!count)
 		goto exit;
 
-	str_buf = kzalloc(count, GFP_KERNEL);
+	str_buf = kmemdup(buf, count, GFP_KERNEL);
 	if (!str_buf) {
 		LOG_ERROR(priv, DEBUGFS,
 			"failed to allocate %zd bytes\n", count);
@@ -299,8 +297,6 @@ ssize_t store_iwmct_log_level_fw(struct 
 		goto exit;
 	}
 
-	memcpy(str_buf, buf, count);
-
 	cmd.hdr.type = COMM_TYPE_H2D;
 	cmd.hdr.category = COMM_CATEGORY_DEBUG;
 	cmd.hdr.opcode = CMD_DBG_LOG_LEVEL;
