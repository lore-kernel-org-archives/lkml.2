Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab0HLPz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933864Ab0HLPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:55:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/6] MN10300: Don't try and #include <linux/slab.h> in
	lib/inflate.c from bootloader
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 12 Aug 2010 16:54:52 +0100
Message-ID: <20100812155452.17015.71783.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
References: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try and #include <linux/slab.h> in lib/inflate.c from the bootloader code
as linux/slab.h hauls in function defs that aren't available in the bootloader
code and may also haul in conflicting functions.

To fix this, make the inclusion of linux/slab.h contingent on NO_INFLATE_MALLOC
as are the usages of kmalloc() and kfree().

In MN10300, this causes the following errors:

In file included from include/linux/string.h:21,
                 from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:93,
                 from include/linux/mmzone.h:16,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:12,
                 from arch/mn10300/boot/compressed/../../../../lib/inflate.c:106,
                 from arch/mn10300/boot/compressed/misc.c:170:
/warthog/am33/linux-2.6-mn10300/arch/mn10300/include/asm/string.h:19: error: conflicting types for 'memset'
arch/mn10300/boot/compressed/misc.c:59: error: previous definition of 'memset' was here


Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/boot/compressed/misc.c |    1 +
 lib/inflate.c                       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/boot/compressed/misc.c b/arch/mn10300/boot/compressed/misc.c
index f673383..42cbd77 100644
--- a/arch/mn10300/boot/compressed/misc.c
+++ b/arch/mn10300/boot/compressed/misc.c
@@ -167,6 +167,7 @@ static uch *high_buffer_start /* = (uch *)(((ulg)&end) + HEAP_SIZE)*/;
 static char *vidmem = (char *)0xb8000;
 static int lines, cols;
 
+#define BOOTLOADER_INFLATE
 #include "../../../../lib/inflate.c"
 
 static inline void scroll(void)
diff --git a/lib/inflate.c b/lib/inflate.c
index 677b738..013a761 100644
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -103,7 +103,9 @@
       the two sets of lengths.
  */
 #include <linux/compiler.h>
+#ifdef NO_INFLATE_MALLOC
 #include <linux/slab.h>
+#endif
 
 #ifdef RCSID
 static char rcsid[] = "#Id: inflate.c,v 0.14 1993/06/10 13:27:04 jloup Exp #";

