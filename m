Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1FFUIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:08:04 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33805 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1FFUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:08:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] m68k/bitops: Make bitmap data pointer of atomic ops volatile
Date: Mon,  6 Jun 2011 22:07:53 +0200
Message-Id: <1307390873-29687-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a.o.

drivers/ide/ide-io.c: In function ‘ide_lock_host’:
drivers/ide/ide-io.c:415: warning: passing argument 2 of ‘__constant_test_and_set_bit’ discards qualifiers from pointer target type
drivers/ide/ide-io.c:415: warning: passing argument 2 of ‘__generic_test_and_set_bit’ discards qualifiers from pointer target type

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I'm not 100% sure whether all of these should be volatile.
We're only getting compiler warnings for calls to test_and_set_bit().

 arch/m68k/include/asm/bitops_mm.h |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 89cf5b8..2d31d5f 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -27,7 +27,8 @@
 
 #define __test_and_set_bit(nr,vaddr) test_and_set_bit(nr,vaddr)
 
-static inline int __constant_test_and_set_bit(int nr, unsigned long *vaddr)
+static inline int __constant_test_and_set_bit(int nr,
+					      volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	char retval;
@@ -39,7 +40,8 @@ static inline int __constant_test_and_set_bit(int nr, unsigned long *vaddr)
 	return retval;
 }
 
-static inline int __generic_test_and_set_bit(int nr, unsigned long *vaddr)
+static inline int __generic_test_and_set_bit(int nr,
+					     volatile unsigned long *vaddr)
 {
 	char retval;
 
@@ -76,7 +78,8 @@ static inline void __generic_set_bit(int nr, volatile unsigned long *vaddr)
 
 #define __test_and_clear_bit(nr,vaddr) test_and_clear_bit(nr,vaddr)
 
-static inline int __constant_test_and_clear_bit(int nr, unsigned long *vaddr)
+static inline int __constant_test_and_clear_bit(int nr,
+						volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	char retval;
@@ -88,7 +91,8 @@ static inline int __constant_test_and_clear_bit(int nr, unsigned long *vaddr)
 	return retval;
 }
 
-static inline int __generic_test_and_clear_bit(int nr, unsigned long *vaddr)
+static inline int __generic_test_and_clear_bit(int nr,
+					       volatile unsigned long *vaddr)
 {
 	char retval;
 
@@ -131,7 +135,8 @@ static inline void __generic_clear_bit(int nr, volatile unsigned long *vaddr)
 #define __test_and_change_bit(nr,vaddr) test_and_change_bit(nr,vaddr)
 #define __change_bit(nr,vaddr) change_bit(nr,vaddr)
 
-static inline int __constant_test_and_change_bit(int nr, unsigned long *vaddr)
+static inline int __constant_test_and_change_bit(int nr,
+						 volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	char retval;
@@ -143,7 +148,8 @@ static inline int __constant_test_and_change_bit(int nr, unsigned long *vaddr)
 	return retval;
 }
 
-static inline int __generic_test_and_change_bit(int nr, unsigned long *vaddr)
+static inline int __generic_test_and_change_bit(int nr,
+						volatile unsigned long *vaddr)
 {
 	char retval;
 
@@ -158,14 +164,14 @@ static inline int __generic_test_and_change_bit(int nr, unsigned long *vaddr)
    __constant_change_bit(nr, vaddr) : \
    __generic_change_bit(nr, vaddr))
 
-static inline void __constant_change_bit(int nr, unsigned long *vaddr)
+static inline void __constant_change_bit(int nr, volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	__asm__ __volatile__ ("bchg %1,%0"
 			: "+m" (*p) : "di" (nr & 7));
 }
 
-static inline void __generic_change_bit(int nr, unsigned long *vaddr)
+static inline void __generic_change_bit(int nr, volatile unsigned long *vaddr)
 {
 	__asm__ __volatile__ ("bfchg %1{%0:#1}"
 			: : "d" (nr^31), "o" (*vaddr) : "memory");
-- 
1.7.0.4

