Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2CNIlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:41:16 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:33440 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030705Ab2CNIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:41:10 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 04:41:10 EDT
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        khali@linux-fr.org, ben-linux@fluff.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>
Subject: [PATCH] i2c-algo-bit: Fix spurious SCL timeouts under heavy load
Date: Wed, 14 Mar 2012 10:32:52 +0200
Message-Id: <1331713973-7711-1-git-send-email-syrjala@sci.fi>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system is under heavy load, there can be a significant delay
between the getscl() and time_after() calls inside sclhi(). That delay
may cause the time_after() check to trigger after SCL has gone high,
causing sclhi() to return -ETIMEDOUT.

To fix the problem, double check that SCL is still low after the
timeout has been reached, before deciding to return -ETIMEDOUT.

Signed-off-by: Ville Syrjälä <syrjala@sci.fi>
---
I can easily reproduce these spurious timeouts on my HP-compaq nc6000
laptop with the radeon kms driver. It's enough to have a -j2 kernel
build running, and simultaneosly issue xrandr commands in a
terminal. Calling xrandr will cause the driver to re-read the EDID
from the display. A significant number of the EDID reads will fail.
With this fix I have yet to see any failed EDID reads.

 drivers/i2c/algos/i2c-algo-bit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
index 525c734..d25112e 100644
--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -104,9 +104,11 @@ static int sclhi(struct i2c_algo_bit_data *adap)
 		 * are processing data internally.
 		 */
 		if (time_after(jiffies, start + adap->timeout))
-			return -ETIMEDOUT;
+			break;
 		cond_resched();
 	}
+	if (!getscl(adap))
+		return -ETIMEDOUT;
 #ifdef DEBUG
 	if (jiffies != start && i2c_debug >= 3)
 		pr_debug("i2c-algo-bit: needed %ld jiffies for SCL to go "
-- 
1.7.3.4

