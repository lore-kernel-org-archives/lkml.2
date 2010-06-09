Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0FIMUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:20:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54167 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab0FIMUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:20:53 -0400
From: naveen_jain@ti.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@ti.com, Naveen Jain <naveen_jain@ti.com>
Subject: [PATCH] drivers:staging: ti-st: fix protocol counting
Date: Wed,  9 Jun 2010 07:20:40 -0500
Message-Id: <1276086040-12726-1-git-send-email-naveen_jain@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Jain <naveen_jain@ti.com>

Older mechanism of counting the number of protocols
registered with ST was slow, in-efficient.
It used to check the protocol data for NULL for each
registration/unregistration.

With this change, counting protocols in maintained by
a single counter protos_registered.

Counting protocols is not just for debug purposes

Signed-off-by: Naveen Jain <naveen_jain@ti.com>
---
 drivers/staging/ti-st/st_core.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index 4e93694..a492369 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -584,10 +584,11 @@ void kim_st_list_protocols(struct st_data_s *st_gdata, char *buf)
 	}
 	sprintf(buf, "%s\n", buf);
 #else /* limited info */
-	sprintf(buf, "BT=%c\nFM=%c\nGPS=%c\n",
-		st_gdata->list[ST_BT] != NULL ? 'R' : 'U',
-		st_gdata->list[ST_FM] != NULL ? 'R' : 'U',
-		st_gdata->list[ST_GPS] != NULL ? 'R' : 'U');
+	sprintf(buf, "[%d]\nBT=%c\nFM=%c\nGPS=%c\n",
+			st_gdata->protos_registered,
+			st_gdata->list[ST_BT] != NULL ? 'R' : 'U',
+			st_gdata->list[ST_FM] != NULL ? 'R' : 'U',
+			st_gdata->list[ST_GPS] != NULL ? 'R' : 'U');
 #endif
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 }
@@ -630,6 +631,7 @@ long st_register(struct st_proto_s *new_proto)
 		st_kim_chip_toggle(new_proto->type, KIM_GPIO_ACTIVE);
 
 		st_gdata->list[new_proto->type] = new_proto;
+		st_gdata->protos_registered++;
 		new_proto->write = st_write;
 
 		set_bit(ST_REG_PENDING, &st_gdata->st_state);
@@ -673,7 +675,6 @@ long st_register(struct st_proto_s *new_proto)
 		if ((st_gdata->protos_registered != ST_EMPTY) &&
 		    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
 			pr_info(" call reg complete callback ");
-			st_gdata->protos_registered++;
 			st_reg_complete(st_gdata, ST_SUCCESS);
 		}
 		clear_bit(ST_REG_PENDING, &st_gdata->st_state);
@@ -689,6 +690,7 @@ long st_register(struct st_proto_s *new_proto)
 
 		spin_lock_irqsave(&st_gdata->lock, flags);
 		st_gdata->list[new_proto->type] = new_proto;
+		st_gdata->protos_registered++;
 		new_proto->write = st_write;
 		spin_unlock_irqrestore(&st_gdata->lock, flags);
 		return err;
@@ -712,6 +714,7 @@ long st_register(struct st_proto_s *new_proto)
 			break;
 		}
 		st_gdata->list[new_proto->type] = new_proto;
+		st_gdata->protos_registered++;
 		new_proto->write = st_write;
 
 		/* lock already held before entering else */
-- 
1.5.6.3

