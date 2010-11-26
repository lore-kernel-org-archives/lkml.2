Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0KZQ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:28:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44932 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0KZQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:28:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Aje4n6fSoNXBUusBPUHCaGuYFocXWA6slAf1Goko4LsSIGDRyddVGwgiANuMSRiwzH
         YvYDrAHvOW1YaDzBc321ctvsSECxNO+Xy7Ie47ROwcwJsJvTIsxsPxCsayZbPrCTJBgu
         k2uY6ZR0YwPDQHfhcks8XCAIBPFMgTbH+f/oo=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] bitops: use find_first_zero_bit() instead of find_next_zero_bit(addr, size, 0)
Date: Sat, 27 Nov 2010 01:28:38 +0900
Message-Id: <1290788919-5057-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290788919-5057-1-git-send-email-akinobu.mita@gmail.com>
References: <1290788919-5057-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The little-endian bitops patch series introduced inefficiency to some
little-endian architectures.

include/asm-generic/bitops/le.h defines find_first_zero_le_bit() like this:

	#define find_first_zero_le_bit(addr, size) \
		find_next_zero_le_bit((addr), (size), 0)

All little-endian architectures include le.h and little-endian bitops
are just aliases for their native endian bitops. So above macro definision
is converted to:

	#define find_first_zero_le_bit(addr, size) \
		find_next_zero_bit(addr, size, 0)

This is inefficient for some architectures which have faster
find_first_zero_bit() than find_next_zero_bit(addr, size, 0).

Fix it by aliasing find_first_zero_bit() to find_first_zero_le_bit()
on little-endian architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/bitops/le.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 6ad46ce..17a7119 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -12,6 +12,8 @@
 	find_next_zero_bit(addr, size, offset)
 #define find_next_le_bit(addr, size, offset) \
 	find_next_bit(addr, size, offset)
+#define find_first_zero_le_bit(addr, size) \
+	find_first_zero_bit(addr, size)
 
 #elif defined(__BIG_ENDIAN)
 
@@ -22,6 +24,9 @@ extern unsigned long find_next_zero_le_bit(const unsigned long *addr,
 extern unsigned long find_next_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
+#define find_first_zero_le_bit(addr, size) \
+	find_next_zero_le_bit((addr), (size), 0)
+
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
@@ -43,7 +48,4 @@ extern unsigned long find_next_le_bit(const unsigned long *addr,
 #define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define find_first_zero_le_bit(addr, size) \
-	find_next_zero_le_bit((addr), (size), 0)
-
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
-- 
1.7.3.2

