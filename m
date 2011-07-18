Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1GRI1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:27:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:15657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab1GRI1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="28833303"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: [PATCH] net: can: remove custom hex_to_bin()
Date: Mon, 18 Jul 2011 11:26:37 +0300
Message-Id: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
---
 drivers/net/can/slcan.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index aa8ad73..65e54fd 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -56,6 +56,7 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/can.h>
 
 static __initdata const char banner[] =
@@ -142,21 +143,6 @@ static struct net_device **slcan_devs;
   *			STANDARD SLCAN DECAPSULATION			 *
   ************************************************************************/
 
-static int asc2nibble(char c)
-{
-
-	if ((c >= '0') && (c <= '9'))
-		return c - '0';
-
-	if ((c >= 'A') && (c <= 'F'))
-		return c - 'A' + 10;
-
-	if ((c >= 'a') && (c <= 'f'))
-		return c - 'a' + 10;
-
-	return 16; /* error */
-}
-
 /* Send one completely decapsulated can_frame to the network layer */
 static void slc_bump(struct slcan *sl)
 {
@@ -195,18 +181,16 @@ static void slc_bump(struct slcan *sl)
 	*(u64 *) (&cf.data) = 0; /* clear payload */
 
 	for (i = 0, dlc_pos++; i < cf.can_dlc; i++) {
-
-		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
-		if (tmp > 0x0F)
+		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
+		if (tmp < 0)
 			return;
 		cf.data[i] = (tmp << 4);
-		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
-		if (tmp > 0x0F)
+		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
+		if (tmp < 0)
 			return;
 		cf.data[i] |= tmp;
 	}
 
-
 	skb = dev_alloc_skb(sizeof(struct can_frame));
 	if (!skb)
 		return;
-- 
1.7.5.4

