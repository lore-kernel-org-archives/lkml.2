Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2HCFVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:21:18 -0400
Received: from science.horizon.com ([71.41.210.146]:14844 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751311Ab2HCFVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:21:13 -0400
From: George Spelvin <linux@horizon.com>
To: vda.linux@googlemail.com, mina86@mina86.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux@horizon.com
Subject: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
Date: Fri,  3 Aug 2012 01:21:10 -0400
Message-Id: <1343971271-13355-3-git-send-email-linux@horizon.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343971271-13355-1-git-send-email-linux@horizon.com>
References: <1343971271-13355-1-git-send-email-linux@horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're going to have a conditional branch after
each 32x32->64-bit multiply, might as well shrink the code
and make it a loop.

This also avoids using the long multiply for small integers.

(This leaves the comments in a confusing state, but that's a separate
patch to make review easier.)

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/vsprintf.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a8e7392..3ca77b8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -174,20 +174,12 @@ char *put_dec_trunc8(char *buf, unsigned r)
 	unsigned q;
 
 	/* Copy of previous function's body with added early returns */
-	q      = (r * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (r - 10 * q) + '0'; /* 2 */
-	if (q == 0)
-		return buf;
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 3 */
-	if (r == 0)
-		return buf;
-	q      = (r * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (r - 10 * q) + '0'; /* 4 */
-	if (q == 0)
-		return buf;
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 5 */
+	while (r >= 10000) {
+		q = r + '0';
+		r  = (r * (uint64_t)0x1999999a) >> 32;
+		*buf++ = q - 10*r;
+	}
+
 	if (r == 0)
 		return buf;
 	q      = (r * 0x199a) >> 16;
-- 
1.7.10.4

