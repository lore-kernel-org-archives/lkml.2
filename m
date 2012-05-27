Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2E0BGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:06:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2E0BGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:06:12 -0400
Message-Id: <20120527010424.777377541@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:30 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Bottomley <JBottomley@Parallels.com>
Subject: [ 07/94] PARISC: fix panic on prefetch(NULL) on PA7300LC
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit b3cb8674811d1851bbf1486a73d62b90c119b994 upstream.

Due to an errata, the PA7300LC generates a TLB miss interruption even on the
prefetch instruction.  This means that prefetch(NULL), which is supposed to be
a nop on linux actually generates a NULL deref fault.  Fix this by testing the
address of prefetch against NULL before doing the prefetch.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/prefetch.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/prefetch.h
+++ b/arch/parisc/include/asm/prefetch.h
@@ -21,7 +21,12 @@
 #define ARCH_HAS_PREFETCH
 static inline void prefetch(const void *addr)
 {
-	__asm__("ldw 0(%0), %%r0" : : "r" (addr));
+	__asm__(
+#ifndef CONFIG_PA20
+		/* Need to avoid prefetch of NULL on PA7300LC */
+		"	extrw,u,= %0,31,32,%%r0\n"
+#endif
+		"	ldw 0(%0), %%r0" : : "r" (addr));
 }
 
 /* LDD is a PA2.0 addition. */


