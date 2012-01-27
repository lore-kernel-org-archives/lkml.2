Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2A0O0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:26:02 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38756 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2A0OZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:25:09 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH] mISDN: use memchr_inv
Date: Fri, 27 Jan 2012 23:24:55 +0900
Message-Id: <1327674295-3700-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv to check if the data contains all same bytes.  It is
faster than looping for each byte.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/mISDN/l1oip_core.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 22f8ec8..04f115a 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1112,7 +1112,7 @@ handle_bmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 	struct l1oip			*hc = bch->hw;
 	int			ret = -EINVAL;
 	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
-	int			l, ll, i;
+	int			l, ll;
 	unsigned char		*p;
 
 	switch (hh->prim) {
@@ -1128,13 +1128,8 @@ handle_bmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 			break;
 		}
 		/* check for AIS / ulaw-silence */
-		p = skb->data;
 		l = skb->len;
-		for (i = 0; i < l; i++) {
-			if (*p++ != 0xff)
-				break;
-		}
-		if (i == l) {
+		if (!memchr_inv(skb->data, 0xff, l)) {
 			if (debug & DEBUG_L1OIP_MSG)
 				printk(KERN_DEBUG "%s: got AIS, not sending, "
 					"but counting\n", __func__);
@@ -1144,13 +1139,8 @@ handle_bmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 			return 0;
 		}
 		/* check for silence */
-		p = skb->data;
 		l = skb->len;
-		for (i = 0; i < l; i++) {
-			if (*p++ != 0x2a)
-				break;
-		}
-		if (i == l) {
+		if (!memchr_inv(skb->data, 0x2a, l)) {
 			if (debug & DEBUG_L1OIP_MSG)
 				printk(KERN_DEBUG "%s: got silence, not sending"
 					", but counting\n", __func__);
-- 
1.7.4.4

