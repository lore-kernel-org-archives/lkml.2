Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2IACAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 22:00:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41948 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2IACAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 22:00:06 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: mchehab@infradead.org
Cc: paul.gortmaker@windriver.com, sfr@canb.auug.org.au,
        srinivas.kandagatla@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Du, Changbin" <changbin.du@gmail.com>
Subject: [RFC PATCH] [media] rc: filter out not allowed protocols when decoding
Date: Sat,  1 Sep 2012 09:57:09 +0800
Message-Id: <1346464629-22458-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

Each rc-raw device has a property "allowed_protos" stored in structure
ir_raw_event_ctrl. But it didn't work because all decoders would be
called when decoding. This path makes only allowed protocol decoders
been invoked.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 drivers/media/rc/ir-raw.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index a820251..198b6d8 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -63,8 +63,12 @@ static int ir_raw_event_thread(void *data)
 		spin_unlock_irq(&raw->lock);
 
 		mutex_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->dev, ev);
+		list_for_each_entry(handler, &ir_raw_handler_list, list) {
+			/* use all protocol by default */
+			if (raw->dev->allowed_protos == RC_TYPE_UNKNOWN ||
+			    raw->dev->allowed_protos & handler->protocols)
+				handler->decode(raw->dev, ev);
+		}
 		raw->prev_ev = ev;
 		mutex_unlock(&ir_raw_handler_lock);
 	}
-- 
1.7.9.5

