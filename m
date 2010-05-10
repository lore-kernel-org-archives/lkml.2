Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab0EJXVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:21:09 -0400
Received: from kroah.org ([198.145.64.141]:51608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0EJW5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:32 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:35 2010
Message-Id: <20100510223535.427211037@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>
Subject: [11/98] core, x86: make LIST_POISON less deadly
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@qumranet.com>

commit a29815a333c6c6e677294bbe5958e771d0aad3fd upstream.

The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
pointers in order to trap erronous use of freed list_heads.  Unfortunately
userspace can arrange for those pointers to actually be dereferencable,
potentially turning an oops to an expolit.

To avoid this allow architectures (currently x86_64 only) to override
the default values for these pointers with truly-undereferencable values.
This is easy on x86_64 as the virtual address space is large and contains
areas that cannot be mapped.

Other 64-bit architectures will likely find similar unmapped ranges.

[ingo: switch to 0xdead000000000000 as the unmapped area]
[ingo: add comments, cleanup]
[jaswinder: eliminate sparse warnings]

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig       |    5 +++++
 include/linux/poison.h |   16 ++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1236,6 +1236,11 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0xdead000000000000 if X86_64
+
 source "mm/Kconfig"
 
 config HIGHPTE
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -2,13 +2,25 @@
 #define _LINUX_POISON_H
 
 /********** include/linux/list.h **********/
+
+/*
+ * Architectures might want to move the poison pointer offset
+ * into some well-recognized area such as 0xdead000000000000,
+ * that is also not mappable by user-space exploits:
+ */
+#ifdef CONFIG_ILLEGAL_POINTER_VALUE
+# define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
+#else
+# define POISON_POINTER_DELTA 0
+#endif
+
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
+#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*


