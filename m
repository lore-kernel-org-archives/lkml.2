Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2HLQkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 12:40:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33122 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2HLQkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 12:40:22 -0400
Message-ID: <1344789618.5128.5.camel@lorien2>
Subject: [PATCH v3] mm: Restructure kmem_cache_create() to move debug cache
 integrity checks into a new function
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: "Christoph Lameter (Open Source)" <cl@linux.com>
Cc: penberg@kernel.org, glommer@parallels.com, js1304@gmail.com,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, shuahkhan@gmail.com
Date: Sun, 12 Aug 2012 10:40:18 -0600
In-Reply-To: <1344540801.2393.42.camel@lorien2>
References: <1342221125.17464.8.camel@lorien2>
	 <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com>
	 <1344224494.3053.5.camel@lorien2> <1344266096.2486.17.camel@lorien2>
	 <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
	 <1344272614.2486.40.camel@lorien2> <1344287631.2486.57.camel@lorien2>
	 <alpine.DEB.2.02.1208090911100.15909@greybox.home>
	 <1344531695.2393.27.camel@lorien2>
	 <alpine.DEB.2.02.1208091406590.20908@greybox.home>
	 <1344540801.2393.42.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_create() does cache integrity checks when CONFIG_DEBUG_VM
is defined. These checks interspersed with the regular code path has
lead to compile time warnings when compiled without CONFIG_DEBUG_VM
defined. Restructuring the code to move the integrity checks in to a new
function would eliminate the current compile warning problem and also
will allow for future changes to the debug only code to evolve without
introducing new warnings in the regular path. This restructuring work
is based on the discussion in the following thread:

https://lkml.org/lkml/2012/7/13/424

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 mm/slab_common.c |   90 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 12637ce..44facdf 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -23,6 +23,52 @@ enum slab_state slab_state;
 LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 
+#ifdef CONFIG_DEBUG_VM
+static int kmem_cache_sanity_check(const char *name, size_t size)
+{
+	struct kmem_cache *s = NULL;
+
+	if (!name || in_interrupt() || size < sizeof(void *) ||
+		size > KMALLOC_MAX_SIZE) {
+		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
+		return -EINVAL;
+	}
+
+	list_for_each_entry(s, &slab_caches, list) {
+		char tmp;
+		int res;
+
+		/*
+		 * This happens when the module gets unloaded and doesn't
+		 * destroy its slab cache and no-one else reuses the vmalloc
+		 * area of the module.  Print a warning.
+		 */
+		res = probe_kernel_address(s->name, tmp);
+		if (res) {
+			pr_err("Slab cache with size %d has lost its name\n",
+			       s->object_size);
+			continue;
+		}
+
+		if (!strcmp(s->name, name)) {
+			pr_err("%s (%s): Cache name already exists.\n",
+			       __func__, name);
+			dump_stack();
+			s = NULL;
+			return -EINVAL;
+		}
+	}
+
+	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
+	return 0;
+}
+#else
+static inline int kmem_cache_sanity_check(const char *name, size_t size)
+{
+	return 0;
+}
+#endif
+
 /*
  * kmem_cache_create - Create a cache.
  * @name: A string which is used in /proc/slabinfo to identify this cache.
@@ -53,48 +99,11 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
 {
 	struct kmem_cache *s = NULL;
 
-#ifdef CONFIG_DEBUG_VM
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
-		printk(KERN_ERR "kmem_cache_create(%s) integrity check"
-			" failed\n", name);
-		goto out;
-	}
-#endif
-
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 
-#ifdef CONFIG_DEBUG_VM
-	list_for_each_entry(s, &slab_caches, list) {
-		char tmp;
-		int res;
-
-		/*
-		 * This happens when the module gets unloaded and doesn't
-		 * destroy its slab cache and no-one else reuses the vmalloc
-		 * area of the module.  Print a warning.
-		 */
-		res = probe_kernel_address(s->name, tmp);
-		if (res) {
-			printk(KERN_ERR
-			       "Slab cache with size %d has lost its name\n",
-			       s->object_size);
-			continue;
-		}
-
-		if (!strcmp(s->name, name)) {
-			printk(KERN_ERR "kmem_cache_create(%s): Cache name"
-				" already exists.\n",
-				name);
-			dump_stack();
-			s = NULL;
-			goto oops;
-		}
-	}
-
-	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
-#endif
+	if (kmem_cache_sanity_check(name, size))
+		goto oops;
 
 	s = __kmem_cache_create(name, size, align, flags, ctor);
 
@@ -102,9 +111,6 @@ oops:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-#ifdef CONFIG_DEBUG_VM
-out:
-#endif
 	if (!s && (flags & SLAB_PANIC))
 		panic("kmem_cache_create: Failed to create slab '%s'\n", name);
 
-- 
1.7.9.5



