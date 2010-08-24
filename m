Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0HXWC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0HXWC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:02:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Blackfin: Fix hamming weight functions
To: vapier@gentoo.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Aug 2010 23:02:41 +0100
Message-ID: <20100824220241.25661.22127.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the hamming weight functions to support the const variants in
asm-generic/bitops/const_hweight.h.

To this end, the arch specific hweightN() functions are renamed to
__arch_hweightN() and the generic header file included which will use them as
appropriate.

Without this, I see the following error:

fs/fcntl.c: In function 'fcntl_init':
fs/fcntl.c:773: error: implicit declaration of function 'HWEIGHT32'
fs/fcntl.c:773: error: bit-field '<anonymous>' width not an integer constant

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/blackfin/include/asm/bitops.h |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index d5872cd..5f259a9 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -115,7 +115,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
  * of bits set) of a N-bit word
  */
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
 
@@ -125,19 +125,22 @@ static inline unsigned int hweight32(unsigned int w)
 	return res;
 }
 
-static inline unsigned int hweight64(__u64 w)
+static inline unsigned int __arch_hweight64(__u64 w)
 {
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+	return __arch_hweight32((unsigned int)(w >> 32)) +
+		__arch_hweight32((unsigned int)w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
-	return hweight32(w & 0xffff);
+	return __arch_hweight32(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
-	return hweight32(w & 0xff);
+	return __arch_hweight32(w & 0xff);
 }
 
+#include <asm-generic/bitops/const_hweight.h>
+
 #endif				/* _BLACKFIN_BITOPS_H */

