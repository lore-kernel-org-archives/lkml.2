Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2AQShS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:37:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49615 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750817Ab2AQShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:37:17 -0500
Message-ID: <1326825433.17202.6.camel@joe2Laptop>
Subject: [PATCH] vsprintf: Prevent NULL dereference using %pNF
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jan 2012 10:37:13 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing NULL to %pNF is done in skb_gso_segment
which could be dereferenced.

Add noinline_for_stack to function.
Make pointer argument the actual type.
Check pointer for NULL and use 0 when so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8e75003..0f1dfd9 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -777,16 +777,24 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
-static
-char *netdev_feature_string(char *buf, char *end, const u8 *addr,
-		      struct printf_spec spec)
+static noinline_for_stack
+char *netdev_feature_string(char *buf, char *end,
+			    const netdev_features_t *features,
+			    struct printf_spec spec)
 {
+	unsigned long long num;
+
+	if (features)
+		num = (unsigned long long)*features;
+	else
+		num = 0;
+
 	spec.flags |= SPECIAL | SMALL | ZEROPAD;
 	if (spec.field_width == -1)
 		spec.field_width = 2 + 2 * sizeof(netdev_features_t);
 	spec.base = 16;
 
-	return number(buf, end, *(const netdev_features_t *)addr, spec);
+	return number(buf, end, num, spec);
 }
 
 int kptr_restrict __read_mostly;


