Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab1KQJ4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:56:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:44689 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab1KQJ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:56:19 -0500
Message-ID: <4EC4DA3E.5020904@parallels.com>
Date: Thu, 17 Nov 2011 13:56:14 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] Routine for generating a safe ID for kernel pointer
References: <4EC4DA15.7090106@parallels.com>
In-Reply-To: <4EC4DA15.7090106@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The routine XORs the given pointer with a random value thus producing
an ID (32 or 64 bit, depending on the arch) which can be shown even to
unprivileged user space processes without risking of leaking kernel
information.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 include/linux/mm.h |   13 +++++++++++++
 mm/Kconfig         |    7 +++++++
 mm/util.c          |   28 ++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7438071..80ea327 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1627,5 +1627,18 @@ extern void copy_user_huge_page(struct page *dst, struct page *src,
 				unsigned int pages_per_huge_page);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+enum {
+	GEN_OBJ_ID_TYPES,
+};
+
+#ifdef CONFIG_GENERIC_OBJECT_IDS
+unsigned long gen_object_id(void *ptr, int type);
+#else
+static inline unsigned long gen_object_id(void *ptr, int type)
+{
+	return 0;
+}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index f2f1ca1..1480cbf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -370,3 +370,10 @@ config CLEANCACHE
 	  in a negligible performance hit.
 
 	  If unsure, say Y to enable cleancache
+
+config GENERIC_OBJECT_IDS
+	bool "Enable generic object ids infrastructure"
+	default n
+	help
+	  Turn on the (quite simple) funtionality that can generate IDs for
+	  kernel objects which is safe to export to the userspace.
diff --git a/mm/util.c b/mm/util.c
index 88ea1bd..1bcde18 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -307,3 +308,30 @@ EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
+
+#ifdef CONFIG_GENERIC_OBJECT_IDS
+static unsigned long ptr_poison[GEN_OBJ_ID_TYPES] __read_mostly;
+
+unsigned long gen_object_id(void *ptr, int type)
+{
+	if (!ptr)
+		return 0;
+
+	BUG_ON(type >= GEN_OBJ_ID_TYPES);
+	WARN_ON_ONCE(ptr_poison[type] == 0);
+
+	return ((unsigned long)ptr) ^ ptr_poison[type];
+}
+
+static int gen_object_poison_init(void)
+{
+	int i;
+
+	for (i = 0; i < GEN_OBJ_ID_TYPES; i++)
+		get_random_bytes(&ptr_poison[i], sizeof(unsigned long));
+
+	return 0;
+}
+
+late_initcall(gen_object_poison_init);
+#endif
-- 
1.5.5.6
