Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0DWBwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:52:17 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:39604 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab0DWBwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:52:15 -0400
Date: Fri, 23 Apr 2010 10:55:57 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: arnd@arndb.de
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, fernando@oss.ntt.co.jp
Subject: [RFC PATCH] asm-generic: bitops: introduce le bit offset macro
Message-Id: <20100423105557.b6128879.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although we can use *_le_bit() helpers to treat bitmaps le arranged,
having le bit offset calculation as a seperate macro gives us more freedom.

For example, KVM has le arranged dirty bitmaps for VGA, live-migration,
etc. and we use them in user space too. To avoid bitmap copies between
kernel and user space, we want to update the bitmaps in user space directly.

To achive this, le bit offset with *_user() functions help us a lot.

So let us use the le bit offset calculation part by defining it as a new
macro: generic_le_bit_offset() .

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 include/asm-generic/bitops/le.h |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 80e3bf1..6af2e54 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -9,6 +9,8 @@
 
 #if defined(__LITTLE_ENDIAN)
 
+#define generic_le_bit_offset(nr)	(nr)
+
 #define generic_test_le_bit(nr, addr) test_bit(nr, addr)
 #define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
 #define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
@@ -25,22 +27,24 @@
 
 #elif defined(__BIG_ENDIAN)
 
+#define generic_le_bit_offset(nr)	((nr) ^ BITOP_LE_SWIZZLE)
+
 #define generic_test_le_bit(nr, addr) \
-	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_bit(generic_le_bit_offset(nr), (addr))
 #define generic___set_le_bit(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__set_bit(generic_le_bit_offset(nr), (addr))
 #define generic___clear_le_bit(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__clear_bit(generic_le_bit_offset(nr), (addr))
 
 #define generic_test_and_set_le_bit(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_and_set_bit(generic_le_bit_offset(nr), (addr))
 #define generic_test_and_clear_le_bit(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_and_clear_bit(generic_le_bit_offset(nr), (addr))
 
 #define generic___test_and_set_le_bit(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__test_and_set_bit(generic_le_bit_offset(nr), (addr))
 #define generic___test_and_clear_le_bit(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__test_and_clear_bit(generic_le_bit_offset(nr), (addr))
 
 extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
-- 
1.6.3.3

