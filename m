Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0CXRNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab0CXRND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:13:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix kernel/user segment handling in NOMMU mode
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 24 Mar 2010 17:12:17 +0000
Message-ID: <20100324171217.11089.15339.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In NOMMU mode, the FRV segment handling is broken because KERNEL_DS == USER_DS.
This causes tests of the following sort:

	/* don't pin down non-user-based iovecs */
	if (segment_eq(get_fs(), KERNEL_DS))
		return NULL;

to malfunction.

To fix this, make USER_DS the top of RAM instead of the top of the non-IO
address space, and make KERNEL_DS one more than the top of the non-IO address
space.

Also get rid of FRV's __addr_ok() as nothing uses it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/segment.h |    6 +++---
 arch/frv/include/asm/uaccess.h |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)


diff --git a/arch/frv/include/asm/segment.h b/arch/frv/include/asm/segment.h
index e3616a6..a2320a4 100644
--- a/arch/frv/include/asm/segment.h
+++ b/arch/frv/include/asm/segment.h
@@ -21,12 +21,12 @@ typedef struct {
 
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
 
-#define KERNEL_DS		MAKE_MM_SEG(0xdfffffffUL)
-
 #ifdef CONFIG_MMU
 #define USER_DS			MAKE_MM_SEG(TASK_SIZE - 1)
+#define KERNEL_DS		MAKE_MM_SEG(0xdfffffffUL)
 #else
-#define USER_DS			KERNEL_DS
+#define USER_DS			MAKE_MM_SEG(memory_end)
+#define KERNEL_DS		MAKE_MM_SEG(0xe0000000UL)
 #endif
 
 #define get_ds()		(KERNEL_DS)
diff --git a/arch/frv/include/asm/uaccess.h b/arch/frv/include/asm/uaccess.h
index 53650c9..0b67ec5 100644
--- a/arch/frv/include/asm/uaccess.h
+++ b/arch/frv/include/asm/uaccess.h
@@ -27,8 +27,6 @@
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
 
-#define __addr_ok(addr) ((unsigned long)(addr) < get_addr_limit())
-
 /*
  * check that a range of addresses falls within the current address limit
  */

