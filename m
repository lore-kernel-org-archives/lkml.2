Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1LWMvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:51:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34073 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab1LWMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:50:31 -0500
Message-Id: <20111223124920.661126615@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Dec 2011 16:47:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/4] Add routine for generating an ID for kernel pointer
References: <20111223124741.711871189@openvz.org>
Content-Disposition: inline; filename=1-introduce-gen_obj_id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The routine XORs the given pointer with a random value
producing an ID (32 or 64 bit, depending on the arch).

Since it's a valuable information -- only CAP_SYS_ADMIN
is allowed to obtain it.

 - Tejun worried about the single poison value was a weak side -
   leaking one makes all the IDs vulnerable. To address this
   several poison values - one per object type - are introduced.
   They are stored in a plain array.
 - Pekka proposed to initialized poison values in the late_initcall callback
 - ... and move the code to mm/util.c

Based-on-patch-from: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Glauber Costa <glommer@parallels.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/gen_obj_id.h |   20 +++++++++++++++++
 mm/Kconfig                 |   16 ++++++++++++++
 mm/Makefile                |    1 
 mm/gen_obj_id.c            |   51 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)

Index: linux-2.6.git/include/linux/gen_obj_id.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/linux/gen_obj_id.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_GEN_OBJ_ID_H
+#define _LINUX_GEN_OBJ_ID_H
+
+#ifdef __KERNEL__
+
+enum {
+	GEN_OBJ_ID_TYPES,
+};
+
+#ifdef CONFIG_GENERIC_OBJECT_ID
+extern unsigned long gen_obj_id(void *ptr, int type);
+#else
+static inline unsigned long gen_obj_id(void *ptr, int type)
+{
+	return 0;
+}
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_GEN_OBJ_ID_H */
Index: linux-2.6.git/mm/Kconfig
===================================================================
--- linux-2.6.git.orig/mm/Kconfig
+++ linux-2.6.git/mm/Kconfig
@@ -373,3 +373,19 @@ config CLEANCACHE
 	  in a negligible performance hit.
 
 	  If unsure, say Y to enable cleancache
+
+config GENERIC_OBJECT_ID
+	bool "Enable generic object ID infrastructure"
+	depends on CHECKPOINT_RESTORE
+	default n
+	help
+	  Turn on the functionality that can generate IDs for kernel
+	  objects, which are exported to userspace via /proc filesystem.
+
+	  It is useful if you need to examinate kernel objects and test
+	  if they are shared between several tasks. These IDs should never
+	  be used for anything but the "sameness" test. Besides, the IDs are
+	  dynamic and valid only while object is alive, once it get freed or
+	  kernel is rebooted -- the IDs will be changed.
+
+	  If unsure, say N here.
Index: linux-2.6.git/mm/Makefile
===================================================================
--- linux-2.6.git.orig/mm/Makefile
+++ linux-2.6.git/mm/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoiso
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
+obj-$(CONFIG_GENERIC_OBJECT_ID) += gen_obj_id.o
Index: linux-2.6.git/mm/gen_obj_id.c
===================================================================
--- /dev/null
+++ linux-2.6.git/mm/gen_obj_id.c
@@ -0,0 +1,51 @@
+#include <linux/kernel.h>
+#include <linux/capability.h>
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/gen_obj_id.h>
+
+static unsigned long gen_obj_cookie[GEN_OBJ_ID_TYPES] __read_mostly;
+
+unsigned long gen_obj_id(void *ptr, int type)
+{
+	if (!capable(CAP_SYS_ADMIN) || !ptr)
+		return 0;
+
+	BUG_ON(type >= GEN_OBJ_ID_TYPES);
+
+	/*
+	 * Note the simple XOR is used here not in a sake
+	 * of security by any means, but rather to break
+	 * an "impression" that such IDs means something
+	 * other than a number which can be used for comparison
+	 * with another number generated by this helper only.
+	 */
+	return ((unsigned long)ptr) ^ gen_obj_cookie[type];
+}
+
+static __init int gen_obj_cookie_init(void)
+{
+#if BITS_PER_LONG == 64
+	const unsigned long emergency_cookie = 0xefcdab8967452301;
+#else
+	const unsigned long emergency_cookie = 0x98badcf9;
+#endif
+	int i;
+
+	for (i = 0; i < GEN_OBJ_ID_TYPES; i++) {
+		get_random_bytes(&gen_obj_cookie[i],
+				 sizeof(unsigned long));
+		/*
+		 * In 'impossible' case of random-bytes = 0
+		 * we still would have non-zero value.
+		 */
+		gen_obj_cookie[i] =
+			(gen_obj_cookie[i] & __PAGE_OFFSET) +
+			(emergency_cookie & ~__PAGE_OFFSET);
+	}
+
+	return 0;
+}
+
+late_initcall(gen_obj_cookie_init);

