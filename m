Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2E1D4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:56:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51814 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246Ab2E1D25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:57 -0400
Message-Id: <20120528031204.684195488@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Bottomley <JBottomley@Parallels.com>
Subject: [ 013/117] [PARISC] fix panic on prefetch(NULL) on PA7300LC
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit b3cb8674811d1851bbf1486a73d62b90c119b994 upstream.

Due to an errata, the PA7300LC generates a TLB miss interruption even on the
prefetch instruction.  This means that prefetch(NULL), which is supposed to be
a nop on linux actually generates a NULL deref fault.  Fix this by testing the
address of prefetch against NULL before doing the prefetch.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/include/asm/prefetch.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/prefetch.h b/arch/parisc/include/asm/prefetch.h
index c5edc60..1ee7c82 100644
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


