Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1KOLgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:36:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:21176 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1KOLgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:36:52 -0500
Message-ID: <4EC24EC1.7060203@parallels.com>
Date: Tue, 15 Nov 2011 15:36:33 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: [PATCH 1/4] Routine for generating an safe ID for kernel pointer
References: <4EC24E9E.8040502@parallels.com>
In-Reply-To: <4EC24E9E.8040502@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The routine XORs the given pointer with a random value thus producing
an ID (32 or 64 bit, depending on the arch) which can be shown even to
unprivileged user space processes without risking of leaking kernel
information.

It implies that it gets called when the random pool is ready for providing
a random long value.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 include/linux/gen_object_ids.h |   12 ++++++++++++
 mm/Kconfig                     |    7 +++++++
 mm/Makefile                    |    1 +
 mm/gen_object_ids.c            |   21 +++++++++++++++++++++
 4 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/gen_object_ids.h
 create mode 100644 mm/gen_object_ids.c

diff --git a/include/linux/gen_object_ids.h b/include/linux/gen_object_ids.h
new file mode 100644
index 0000000..17981ae
--- /dev/null
+++ b/include/linux/gen_object_ids.h
@@ -0,0 +1,12 @@
+#ifndef __GEN_OBJECT_IDS_H__
+#define __GEN_OBJECT_IDS_H__
+
+#ifdef CONFIG_GENERIC_OBJECT_IDS
+unsigned long gen_object_id(void *ptr);
+#else
+static inline unsigned long gen_object_id(void *ptr)
+{
+	return 0;
+}
+#endif
+#endif
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
diff --git a/mm/Makefile b/mm/Makefile
index 836e416..155797a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -50,3 +50,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
+obj-$(CONFIG_GENERIC_OBJECT_IDS) += gen_object_ids.o
diff --git a/mm/gen_object_ids.c b/mm/gen_object_ids.c
new file mode 100644
index 0000000..a75119b
--- /dev/null
+++ b/mm/gen_object_ids.c
@@ -0,0 +1,21 @@
+#include <linux/gen_object_ids.h>
+#include <linux/spinlock.h>
+#include <linux/random.h>
+
+static unsigned long ptr_poison __read_mostly;
+static DEFINE_SPINLOCK(ptr_poison_lock);
+
+unsigned long gen_object_id(void *ptr)
+{
+	if (!ptr)
+		return 0;
+
+	if (unlikely(!ptr_poison)) {
+		spin_lock(&ptr_poison_lock);
+		if (!ptr_poison)
+			get_random_bytes(&ptr_poison, sizeof(ptr_poison));
+		spin_unlock(&ptr_poison_lock);
+	}
+
+	return ((unsigned long)ptr) ^ ptr_poison;
+}
-- 
1.5.5.6
