Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab1LOQig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:38:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55139 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759053Ab1LOQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:38:30 -0500
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 1/3] drivers:misc: ti-st: protect registrations
Date: Thu, 15 Dec 2011 10:38:20 -0600
Message-ID: <1323967102-13380-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1323967102-13380-1-git-send-email-pavan_savoy@ti.com>
References: <1323967102-13380-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Concurrent access to UART2/combo-interface by multiple protocol drivers such
as BT, FM and GPS caused issues during firmware download failure cases or
cases when the firmware download took longer than usual.

This was because of un-safe access to protos_registered & st_states.
Protecting this will also make the registration complete callback un-safe for
sleep.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index ba168a7..2b62232 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -137,6 +137,8 @@ void st_send_frame(unsigned char chnl_id, struct st_data_s *st_gdata)
  * st_reg_complete -
  * to call registration complete callbacks
  * of all protocol stack drivers
+ * This function is being called with spin lock held, protocol drivers are
+ * only expected to complete their waits and do nothing more than that.
  */
 void st_reg_complete(struct st_data_s *st_gdata, char err)
 {
@@ -538,11 +540,12 @@ long st_register(struct st_proto_s *new_proto)
 		set_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
 		st_recv = st_kim_recv;
 
+		/* enable the ST LL - to set default chip state */
+		st_ll_enable(st_gdata);
+
 		/* release lock previously held - re-locked below */
 		spin_unlock_irqrestore(&st_gdata->lock, flags);
 
-		/* enable the ST LL - to set default chip state */
-		st_ll_enable(st_gdata);
 		/* this may take a while to complete
 		 * since it involves BT fw download
 		 */
@@ -553,10 +556,13 @@ long st_register(struct st_proto_s *new_proto)
 			    (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
 				pr_err(" KIM failure complete callback ");
 				st_reg_complete(st_gdata, err);
+				clear_bit(ST_REG_PENDING, &st_gdata->st_state);
 			}
 			return -EINVAL;
 		}
 
+		spin_lock_irqsave(&st_gdata->lock, flags);
+
 		clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
 		st_recv = st_int_recv;
 
@@ -576,10 +582,10 @@ long st_register(struct st_proto_s *new_proto)
 		if (st_gdata->is_registered[new_proto->chnl_id] == true) {
 			pr_err(" proto %d already registered ",
 				   new_proto->chnl_id);
+			spin_unlock_irqrestore(&st_gdata->lock, flags);
 			return -EALREADY;
 		}
 
-		spin_lock_irqsave(&st_gdata->lock, flags);
 		add_channel_to_table(st_gdata, new_proto);
 		st_gdata->protos_registered++;
 		new_proto->write = st_write;
@@ -619,7 +625,7 @@ long st_unregister(struct st_proto_s *proto)
 
 	spin_lock_irqsave(&st_gdata->lock, flags);
 
-	if (st_gdata->list[proto->chnl_id] == NULL) {
+	if (st_gdata->is_registered[proto->chnl_id] == false) {
 		pr_err(" chnl_id %d not registered", proto->chnl_id);
 		spin_unlock_irqrestore(&st_gdata->lock, flags);
 		return -EPROTONOSUPPORT;
@@ -629,6 +635,10 @@ long st_unregister(struct st_proto_s *proto)
 	remove_channel_from_table(st_gdata, proto);
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 
+	/* paranoid check */
+	if (st_gdata->protos_registered < ST_EMPTY)
+		st_gdata->protos_registered = ST_EMPTY;
+
 	if ((st_gdata->protos_registered == ST_EMPTY) &&
 	    (!test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
 		pr_info(" all chnl_ids unregistered ");
-- 
1.7.4.1

