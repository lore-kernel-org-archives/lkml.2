Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab1ITNPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:15:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55965 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1ITNPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:15:19 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH 1/3] lib: add error checking to hex2bin
Date: Tue, 20 Sep 2011 09:15:03 -0400
Message-Id: <1316524505-27272-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hex2bin converts a hexadecimal string to its binary representation.
The original version of hex2bin did not do any error checking.  This
patch adds error checking and returns the result.

Changelog:
- add __must_check compiler option (Andy Shevchenko's suggestion)
- change function API to return error checking result

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |   15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 46ac9a5..8eefcf7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -382,7 +382,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 extern int hex_to_bin(char ch);
-extern void hex2bin(u8 *dst, const char *src, size_t count);
+extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 
 /*
  * General tracing related utility functions - trace_printk(),
diff --git a/lib/hexdump.c b/lib/hexdump.c
index f5fe6ba..51d5ae2 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -38,14 +38,21 @@ EXPORT_SYMBOL(hex_to_bin);
  * @dst: binary result
  * @src: ascii hexadecimal string
  * @count: result length
+ *
+ * Return 0 on success, -1 in case of bad input.
  */
-void hex2bin(u8 *dst, const char *src, size_t count)
+int hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
-		*dst = hex_to_bin(*src++) << 4;
-		*dst += hex_to_bin(*src++);
-		dst++;
+		int hi = hex_to_bin(*src++);
+		int lo = hex_to_bin(*src++);
+
+		if ((hi < 0) || (lo < 0))
+			return -1;
+
+		*dst++ = (hi << 4) | lo;
 	}
+	return 0;
 }
 EXPORT_SYMBOL(hex2bin);
 
-- 
1.7.3.4

