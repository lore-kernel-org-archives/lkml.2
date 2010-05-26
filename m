Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0EZP4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:56:01 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:45758 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0EZPzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:55:18 -0400
Date: Wed, 26 May 2010 17:55:10 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/17] drivers/isdn/hardware/mISDN: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261754560.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  The return value of write_reg
seems to be completely ignored, so it seems that the lock should be
released in every case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hardware/mISDN/hfcsusb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index b3b7e28..8700474 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -97,8 +97,10 @@ static int write_reg(struct hfcsusb *hw, __u8 reg, __u8 val)
 			hw->name, __func__, reg, val);
 
 	spin_lock(&hw->ctrl_lock);
-	if (hw->ctrl_cnt >= HFC_CTRL_BUFSIZE)
+	if (hw->ctrl_cnt >= HFC_CTRL_BUFSIZE) {
+		spin_unlock(&hw->ctrl_lock);
 		return 1;
+	}
 	buf = &hw->ctrl_buff[hw->ctrl_in_idx];
 	buf->hfcs_reg = reg;
 	buf->reg_val = val;
