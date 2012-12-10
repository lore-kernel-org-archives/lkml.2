Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2LJTOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:14:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55678 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab2LJTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:58 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Will Deacon <will.deacon@arm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2 01/10] asm-generic: io: don't perform swab during {in,out} string functions
Date: Mon, 10 Dec 2012 19:12:33 +0000
Message-Id: <1355166762-15133-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The {in,out}s{b,w,l} functions are designed to operate on a stream of
bytes and therefore should not perform any byte-swapping, regardless of
the CPU byte order.

This patch fixes the generic IO header so that {in,out}s{b,w,l} call
the __raw_{read,write} functions directly rather than going via the
endian-correcting accessors.

Cc: Mike Frysinger <vapier@gentoo.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ben Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/io.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 448303b..b2600f3 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -148,7 +148,7 @@ static inline void insb(unsigned long addr, void *buffer, int count)
 	if (count) {
 		u8 *buf = buffer;
 		do {
-			u8 x = inb(addr);
+			u8 x = __raw_readb(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -161,7 +161,7 @@ static inline void insw(unsigned long addr, void *buffer, int count)
 	if (count) {
 		u16 *buf = buffer;
 		do {
-			u16 x = inw(addr);
+			u16 x = __raw_readw(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -174,7 +174,7 @@ static inline void insl(unsigned long addr, void *buffer, int count)
 	if (count) {
 		u32 *buf = buffer;
 		do {
-			u32 x = inl(addr);
+			u32 x = __raw_readl(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -187,7 +187,7 @@ static inline void outsb(unsigned long addr, const void *buffer, int count)
 	if (count) {
 		const u8 *buf = buffer;
 		do {
-			outb(*buf++, addr);
+			__raw_writeb(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
@@ -199,7 +199,7 @@ static inline void outsw(unsigned long addr, const void *buffer, int count)
 	if (count) {
 		const u16 *buf = buffer;
 		do {
-			outw(*buf++, addr);
+			__raw_writew(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
@@ -211,7 +211,7 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 	if (count) {
 		const u32 *buf = buffer;
 		do {
-			outl(*buf++, addr);
+			__raw_writel(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
-- 
1.8.0

