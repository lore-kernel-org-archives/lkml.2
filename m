Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1CBKAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:00:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50483 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab1CBKAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:00:03 -0500
From: pavan_savoy@ti.com
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:misc: ti-st: fix debugging code
Date: Wed,  2 Mar 2011 03:59:56 -0600
Message-Id: <1299059996-21267-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

debug code in TI-ST driver can be enabled by #defining
DEBUG in the first line of the code and in case debugfs
is mounted, the 2 entries in /sys/kernel/debug/ti-st/ will
also provide useful information.
These 2 were broken because of the recent changes to the parsing
logic and the registration mechanism of the protocol drivers,
this patch fixes them.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 1847c47..486117f 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -475,9 +475,9 @@ void kim_st_list_protocols(struct st_data_s *st_gdata, void *buf)
 {
 	seq_printf(buf, "[%d]\nBT=%c\nFM=%c\nGPS=%c\n",
 			st_gdata->protos_registered,
-			st_gdata->list[ST_BT] != NULL ? 'R' : 'U',
-			st_gdata->list[ST_FM] != NULL ? 'R' : 'U',
-			st_gdata->list[ST_GPS] != NULL ? 'R' : 'U');
+			st_gdata->list[0x04] != NULL ? 'R' : 'U',
+			st_gdata->list[0x08] != NULL ? 'R' : 'U',
+			st_gdata->list[0x09] != NULL ? 'R' : 'U');
 }
 
 /********************************************************************/
@@ -644,9 +644,6 @@ long st_unregister(struct st_proto_s *proto)
 long st_write(struct sk_buff *skb)
 {
 	struct st_data_s *st_gdata;
-#ifdef DEBUG
-	unsigned char chnl_id = ST_MAX_CHANNELS;
-#endif
 	long len;
 
 	st_kim_ref(&st_gdata, 0);
@@ -655,14 +652,7 @@ long st_write(struct sk_buff *skb)
 		pr_err("data/tty unavailable to perform write");
 		return -EINVAL;
 	}
-#ifdef DEBUG			/* open-up skb to read the 1st byte */
-	chnl_id = skb->data[0];
-	if (unlikely(st_gdata->list[chnl_id] == NULL)) {
-		pr_err(" chnl_id %d not registered, and writing? ",
-			   chnl_id);
-		return -EINVAL;
-	}
-#endif
+
 	pr_debug("%d to be written", skb->len);
 	len = skb->len;
 
-- 
1.7.0.4

