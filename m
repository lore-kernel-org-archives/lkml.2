Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0EZP6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:58:16 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46304 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab0EZP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:58:13 -0400
Date: Wed, 26 May 2010 17:58:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/17] drivers/message/i2o/exec-osm.c: Add missing mutex_unlock
Message-ID: <Pine.LNX.4.64.1005261757420.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error path.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/i2o/exec-osm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/message/i2o/exec-osm.c b/drivers/message/i2o/exec-osm.c
index 06c655c..a3970e5 100644
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -389,12 +389,16 @@ static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
 	dev = &c->pdev->dev;
 
 	if (i2o_dma_realloc(dev, &c->dlct,
-					le32_to_cpu(sb->expected_lct_size)))
+					le32_to_cpu(sb->expected_lct_size))) {
+		mutex_unlock(&c->lct_lock);
 		return -ENOMEM;
+	}
 
 	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg))
+	if (IS_ERR(msg)) {
+		mutex_unlock(&c->lct_lock);
 		return PTR_ERR(msg);
+	}
 
 	msg->u.head[0] = cpu_to_le32(EIGHT_WORD_MSG_SIZE | SGL_OFFSET_6);
 	msg->u.head[1] = cpu_to_le32(I2O_CMD_LCT_NOTIFY << 24 | HOST_TID << 12 |
