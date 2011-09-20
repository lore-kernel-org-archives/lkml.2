Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab1ITTxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:53:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60815 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab1ITTxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:53:14 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v1 1/4] lib: add error checking to hex2bin
Date: Tue, 20 Sep 2011 15:52:50 -0400
Message-Id: <1316548373-8782-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hex2bin converts a hexadecimal string to its binary representation.
The original version of hex2bin did not do any error checking.  This
patch adds error checking and returns the result.

Changelog v1:
- removed unpack_hex_byte()
- changed return code from boolean to int

Changelog:
- use the new unpack_hex_byte()
- add __must_check compiler option (Andy Shevchenko's suggestion)
- change function API to return error checking result
  (based on Tetsuo Handa's initial patch)

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

