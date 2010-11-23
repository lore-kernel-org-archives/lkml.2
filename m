Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0KWNkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:40:35 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39926 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0KWNkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BTbRmpmven34OJx0eb+gGnrxEWKYKJqkx8WfVv25MD9v9P6+BaxtIzfaG9K5mOwwmS
         o040Pu1Zy9mF4YzKu1grigOobW6oCADb794fN9SnhMMNJQFLI304XMXMv7tc++bbM/uN
         Pl6OqL3oTwJeoc9b+t1DfLx/lP+nj8R+8vPRY=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH v3 21/22] m68k: remove inline asm from minix_find_first_zero_bit
Date: Tue, 23 Nov 2010 22:38:23 +0900
Message-Id: <1290519504-3958-22-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for moving minix bit operations from asm/bitops.h
to architecture independent code in minix file system, this removes
inline asm from minix_find_first_zero_bit() for m68k.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
No change from previous submission
 arch/m68k/include/asm/bitops_mm.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 831d626..f31ed5a 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -330,23 +330,19 @@ static inline int __fls(int x)
 static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
 {
 	const unsigned short *p = vaddr, *addr = vaddr;
-	int res;
 	unsigned short num;
 
 	if (!size)
 		return 0;
 
 	size = (size >> 4) + ((size & 15) > 0);
-	while (*p++ == 0xffff)
-	{
+	while (*p++ == 0xffff) {
 		if (--size == 0)
 			return (p - addr) << 4;
 	}
 
-	num = ~*--p;
-	__asm__ __volatile__ ("bfffo %1{#16,#16},%0"
-			      : "=d" (res) : "d" (num & -num));
-	return ((p - addr) << 4) + (res ^ 31);
+	num = *--p;
+	return ((p - addr) << 4) + ffz(num);
 }
 
 #define minix_test_and_set_bit(nr, addr)	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
-- 
1.7.3.2

