Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0JOJoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:44:54 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37662 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755532Ab0JOJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:51 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 21/22] m68k: convert minix bitops to use little endian bitops
Date: Fri, 15 Oct 2010 18:46:20 +0900
Message-Id: <1287135981-17604-22-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode and block bitmap for minix filesystem is little endian
byte order on m68k. This converts them to use little endian bit
operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/include/asm/bitops_mm.h |   38 ++++++++----------------------------
 1 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index e2cc3be..2451f7f 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -327,37 +327,17 @@ static inline int __fls(int x)
 
 /* Bitmap functions for the minix filesystem */
 
-static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
-{
-	const unsigned short *p = vaddr, *addr = vaddr;
-	int res;
-	unsigned short num;
-
-	if (!size)
-		return 0;
-
-	size = (size >> 4) + ((size & 15) > 0);
-	while (*p++ == 0xffff)
-	{
-		if (--size == 0)
-			return (p - addr) << 4;
-	}
+#define minix_find_first_zero_bit(vaddr, size)	\
+	find_first_zero_le_bit(vaddr, (size))
 
-	num = ~*--p;
-	__asm__ __volatile__ ("bfffo %1{#16,#16},%0"
-			      : "=d" (res) : "d" (num & -num));
-	return ((p - addr) << 4) + (res ^ 31);
-}
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)	\
+	__set_le_bit((nr), (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 
-#define minix_test_and_set_bit(nr, addr)	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_set_bit(nr,addr)			__set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr, addr)	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
-
-static inline int minix_test_bit(int nr, const void *vaddr)
-{
-	const unsigned short *p = vaddr;
-	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
-}
+#define minix_test_bit(nr, addr)	test_le_bit(nr, addr)
 
 /* Bitmap functions for little endian. */
 
-- 
1.7.1.231.gd0b16

