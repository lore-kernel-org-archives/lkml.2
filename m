Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1ERM7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:59:10 -0400
Received: from investici.nine.ch ([217.150.252.179]:25212 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab1ERM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:59:08 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 May 2011 08:59:08 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 confino.investici.org BD13D8445C
From: Antonio Quartulli <ordex@autistici.org>
To: linux-kernel@vger.kernel.org
Cc: Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] net: add seq_before/seq_after functions
Date: Wed, 18 May 2011 14:38:39 +0200
Message-Id: <1305722319-8315-1-git-send-email-ordex@autistici.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two operations to handle comparison between packet sequence
numbers taking into account overflow/wraparound. Batman-adv uses
these functions already to check for successor packet even in case of
overflow.
---

I added this two functions in net.h because I didn't really know where
best placement is. I saw several modules that redefine their own functions
for the same purpose.

 include/linux/net.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 94de83c..c7bc9bf 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -295,4 +295,21 @@ extern struct ratelimit_state net_ratelimit_state;
 #endif
 
 #endif /* __KERNEL__ */
+
+/* Returns the smallest signed integer in two's complement with the sizeof x */
+#define smallest_signed_int(x) (1u << (7u + 8u * (sizeof(x) - 1u)))
+
+/* Checks if a sequence number x is a predecessor/successor of y.
+ * they handle overflows/underflows and can correctly check for a
+ * predecessor/successor unless the variable sequence number has grown by
+ * more then 2**(bitwidth(x)-1)-1.
+ * This means that for a uint8_t with the maximum value 255, it would think:
+ *  - when adding nothing - it is neither a predecessor nor a successor
+ *  - before adding more than 127 to the starting value - it is a predecessor,
+ *  - when adding 128 - it is neither a predecessor nor a successor,
+ *  - after adding more than 127 to the starting value - it is a successor */
+#define seq_before(x, y) ({typeof(x) _dummy = (x - y); \
+			_dummy > smallest_signed_int(_dummy); })
+#define seq_after(x, y) seq_before(y, x)
+
 #endif	/* _LINUX_NET_H */
-- 
1.7.3.4

