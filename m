Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2CNIdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:33:06 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:45823 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab2CNIdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:33:01 -0400
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        khali@linux-fr.org, ben-linux@fluff.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>
Subject: [DEBUG PATCH] Print a message when a spurious i2c SCL timeout  occurs.
Date: Wed, 14 Mar 2012 10:32:53 +0200
Message-Id: <1331713973-7711-2-git-send-email-syrjala@sci.fi>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331713973-7711-1-git-send-email-syrjala@sci.fi>
References: <1331713973-7711-1-git-send-email-syrjala@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick hack to verify that the fix works as intended...

Do not apply.

---
 drivers/i2c/algos/i2c-algo-bit.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
index d25112e..3f547b5 100644
--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -89,6 +89,7 @@ static inline void scllo(struct i2c_algo_bit_data *adap)
 static int sclhi(struct i2c_algo_bit_data *adap)
 {
 	unsigned long start;
+	bool timeout = false;
 
 	setscl(adap, 1);
 
@@ -104,11 +105,16 @@ static int sclhi(struct i2c_algo_bit_data *adap)
 		 * are processing data internally.
 		 */
 		if (time_after(jiffies, start + adap->timeout))
+		{
+			timeout = true;
 			break;
+		}
 		cond_resched();
 	}
 	if (!getscl(adap))
 		return -ETIMEDOUT;
+	if (timeout)
+		printk(KERN_CRIT "spurious i2c scl timeout\n");
 #ifdef DEBUG
 	if (jiffies != start && i2c_debug >= 3)
 		pr_debug("i2c-algo-bit: needed %ld jiffies for SCL to go "
-- 
1.7.3.4

