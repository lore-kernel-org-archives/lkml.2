Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2BGHzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:55:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40289 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2BGHzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:55:04 -0500
Subject: [PATCH 1/4] bitops: implement "optimized" __find_next_bit()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Tue, 07 Feb 2012 11:55:00 +0400
Message-ID: <20120207075500.29797.95376.stgit@zurg>
In-Reply-To: <20120207074905.29797.60353.stgit@zurg>
References: <20120207074905.29797.60353.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds  __find_next_bit() -- static-inline variant of find_next_bit()
optimized for small constant size arrays, because find_next_bit() is too heavy
for searching in an array with one/two long elements.
And unlike to find_next_bit() it does not mask tail bits.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/asm-generic/bitops/find.h |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bitops/find.h b/include/asm-generic/bitops/find.h
index 71c7780..1dd2495 100644
--- a/include/asm-generic/bitops/find.h
+++ b/include/asm-generic/bitops/find.h
@@ -12,6 +12,42 @@ extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
 #endif
 
+#ifndef __find_next_bit
+/**
+ * __find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Unrollable variant of find_next_bit() for constant size arrays.
+ * Tail bits starting from size to roundup(size, BITS_PER_LONG) must be zero.
+ * Returns next bit offset, or size if nothing found.
+ */
+static inline unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
+{
+	if (!__builtin_constant_p(size))
+		return find_next_bit(addr, size, offset);
+
+	if (offset < size) {
+		unsigned long tmp;
+
+		addr += offset / BITS_PER_LONG;
+		tmp = *addr >> (offset % BITS_PER_LONG);
+		if (tmp)
+			return __ffs(tmp) + offset;
+		offset = (offset + BITS_PER_LONG) & ~(BITS_PER_LONG - 1);
+		while (offset < size) {
+			tmp = *++addr;
+			if (tmp)
+				return __ffs(tmp) + offset;
+			offset += BITS_PER_LONG;
+		}
+	}
+	return size;
+}
+#endif
+
 #ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region

