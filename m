Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2HCFVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:21:20 -0400
Received: from science.horizon.com ([71.41.210.146]:14834 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751334Ab2HCFVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:21:13 -0400
From: George Spelvin <linux@horizon.com>
To: vda.linux@googlemail.com, mina86@mina86.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org, linux@horizon.com
Subject: [PATCH 1/4] lib: vsprintf: Optimize division by 10 for small integers.
Date: Fri,  3 Aug 2012 01:21:08 -0400
Message-Id: <1343971271-13355-1-git-send-email-linux@horizon.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrink the reciprocal approximations used in put_dec_full4
based on the comments in put_dec_full9.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
---
 lib/vsprintf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

I was looking over the code and noticed that the constants could be smaller.

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c3f36d41..2f32fe8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -243,13 +243,14 @@ char *put_dec(char *buf, unsigned long long n)
 
 /* Second algorithm: valid only for 64-bit long longs */
 
+/* See comment in put_dec_full9 for choice of constants */
 static noinline_for_stack
 char *put_dec_full4(char *buf, unsigned q)
 {
 	unsigned r;
-	r      = (q * 0xcccd) >> 19;
+	r      = (q * 0xccd) >> 15;
 	*buf++ = (q - 10 * r) + '0';
-	q      = (r * 0x199a) >> 16;
+	q      = (r * 0xcd) >> 11;
 	*buf++ = (r - 10 * q)  + '0';
 	r      = (q * 0xcd) >> 11;
 	*buf++ = (q - 10 * r)  + '0';
-- 
1.7.10.4

