Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1A0N4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:56:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53846 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1A0N4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R8mhCBs7i2NSISIn2CQMrXgLJT3+3NUYPeAW33zZnFMJqmdKqzPvo9ve0RtmesVAtd
         5tqyBM7TjWL91HE/NO3CikPBDexPGHDVSenxMgxXooPUtPhp/6fVUmvCGYiuDt6FYxfR
         H+Ldnr1PV2xHviXwyytTZydXh9O1UWOJn5iCg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH -mm 5/6] m68k: convert little-endian bitops macros to static inline functions
Date: Thu, 27 Jan 2011 22:56:22 +0900
Message-Id: <1296136583-13815-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296136583-13815-1-git-send-email-akinobu.mita@gmail.com>
References: <1296136583-13815-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch is intended to be folded into the patch in -mm:
m68k-introduce-little-endian-bitops.patch)

The little-endian bitops on m68k are written as preprocessor
macros with the cast to "unsigned long *".
This means that even non-pointers will be accepted without an error, and
that is a Very Bad Thing.

This converts the little-endian bitops macros to static inline functions
with proper prototypes.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/m68k/include/asm/bitops_mm.h |   41 ++++++++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 1177a48..9d69f6e 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -327,18 +327,35 @@ static inline int __fls(int x)
 
 /* Bitmap functions for the little endian bitmap. */
 
-#define __set_bit_le(nr, addr)	\
-	__set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define __clear_bit_le(nr, addr)	\
-	__clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define __test_and_set_bit_le(nr, addr)	\
-	__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define test_and_set_bit_le(nr, addr)	\
-	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define __test_and_clear_bit_le(nr, addr)	\
-	__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define test_and_clear_bit_le(nr, addr)	\
-	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ 24, addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ 24, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ 24, addr);
+}
+
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(nr ^ 24, addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ 24, addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ 24, addr);
+}
 
 static inline int test_bit_le(int nr, const void *vaddr)
 {
-- 
1.7.3.4

