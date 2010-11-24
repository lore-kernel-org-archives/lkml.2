Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0KXTFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:05:22 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:12907 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0KXTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:05:20 -0500
Message-Id: <201011241905.oAOJ5KoT028910@farm-0013.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 24 Nov 2010 13:57:42 -0500
Subject: [PATCH] arch/tile: fix memchr() not to dereference memory for zero length
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 24 Nov 2010 19:05:20.0137 (UTC) FILETIME=[89E6FF90:01CB8C0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes a bug that memchr() will read the first word
of the source even if the length is zero.  Ironically, the code
was originally written with a test to avoid exactly this problem,
but to make the code conform to Linux coding standards with all
declarations preceding all statements, the first load from memory
was moved up above that test as the initial value for a variable.

The change just moves all the variable declarations to the top
of the file, with no initializers, so that the test can also be
at the top of the file.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/memchr_32.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/tile/lib/memchr_32.c b/arch/tile/lib/memchr_32.c
index 6235283..cc3d9ba 100644
--- a/arch/tile/lib/memchr_32.c
+++ b/arch/tile/lib/memchr_32.c
@@ -18,12 +18,24 @@
 
 void *memchr(const void *s, int c, size_t n)
 {
+	const uint32_t *last_word_ptr;
+	const uint32_t *p;
+	const char *last_byte_ptr;
+	uintptr_t s_int;
+	uint32_t goal, before_mask, v, bits;
+	char *ret;
+
+	if (__builtin_expect(n == 0, 0)) {
+		/* Don't dereference any memory if the array is empty. */
+		return NULL;
+	}
+
 	/* Get an aligned pointer. */
-	const uintptr_t s_int = (uintptr_t) s;
-	const uint32_t *p = (const uint32_t *)(s_int & -4);
+	s_int = (uintptr_t) s;
+	p = (const uint32_t *)(s_int & -4);
 
 	/* Create four copies of the byte for which we are looking. */
-	const uint32_t goal = 0x01010101 * (uint8_t) c;
+	goal = 0x01010101 * (uint8_t) c;
 
 	/* Read the first word, but munge it so that bytes before the array
 	 * will not match goal.
@@ -31,23 +43,14 @@ void *memchr(const void *s, int c, size_t n)
 	 * Note that this shift count expression works because we know
 	 * shift counts are taken mod 32.
 	 */
-	const uint32_t before_mask = (1 << (s_int << 3)) - 1;
-	uint32_t v = (*p | before_mask) ^ (goal & before_mask);
+	before_mask = (1 << (s_int << 3)) - 1;
+	v = (*p | before_mask) ^ (goal & before_mask);
 
 	/* Compute the address of the last byte. */
-	const char *const last_byte_ptr = (const char *)s + n - 1;
+	last_byte_ptr = (const char *)s + n - 1;
 
 	/* Compute the address of the word containing the last byte. */
-	const uint32_t *const last_word_ptr =
-	    (const uint32_t *)((uintptr_t) last_byte_ptr & -4);
-
-	uint32_t bits;
-	char *ret;
-
-	if (__builtin_expect(n == 0, 0)) {
-		/* Don't dereference any memory if the array is empty. */
-		return NULL;
-	}
+	last_word_ptr = (const uint32_t *)((uintptr_t) last_byte_ptr & -4);
 
 	while ((bits = __insn_seqb(v, goal)) == 0) {
 		if (__builtin_expect(p == last_word_ptr, 0)) {
-- 
1.6.5.2

