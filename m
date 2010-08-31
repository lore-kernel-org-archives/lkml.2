Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0HaJrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:47:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:51930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab0HaJrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:47:00 -0400
Message-ID: <4C7CCF8F.6030600@kernel.org>
Date: Tue, 31 Aug 2010 11:46:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Huang Shijie <shijie8@gmail.com>
Subject: [GIT PULL] percpu: fixes for v2.6.36-rc3
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 09:46:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu fixes for
v2.6.36-rc3.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

The branch contains four patches.  A memory leak in
pcpu_extend_area_map() is fixed.  The other three are sparse
annotation and comment update.

Thanks.


Huang Shijie (1):
      percpu: fix a memory leak in pcpu_extend_area_map()

Namhyung Kim (3):
      percpu: handle __percpu notations in UP accessors
      percpu: add __percpu notations to UP allocator
      percpu: fix a mismatch between code and comment

 include/asm-generic/percpu.h |   15 ++++++++++-----
 include/linux/percpu.h       |    2 +-
 mm/percpu.c                  |    6 ++++--
 mm/percpu_up.c               |    4 ++--
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b5043a9..08923b6 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -70,11 +70,16 @@ extern void setup_per_cpu_areas(void);

 #else /* ! SMP */

-#define per_cpu(var, cpu)			(*((void)(cpu), &(var)))
-#define __get_cpu_var(var)			(var)
-#define __raw_get_cpu_var(var)			(var)
-#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
-#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
+#define VERIFY_PERCPU_PTR(__p) ({			\
+	__verify_pcpu_ptr((__p));			\
+	(typeof(*(__p)) __kernel __force *)(__p);	\
+})
+
+#define per_cpu(var, cpu)	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
+#define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
+#define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
+#define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
+#define __this_cpu_ptr(ptr)	this_cpu_ptr(ptr)

 #endif	/* SMP */

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index b8b9084..49466b1 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -149,7 +149,7 @@ extern void __init percpu_init_late(void);

 #else /* CONFIG_SMP */

-#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
+#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })

 /* can't distinguish from other static vars, always false */
 static inline bool is_kernel_percpu_address(unsigned long addr)
diff --git a/mm/percpu.c b/mm/percpu.c
index e61dc2c..58c572b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -393,7 +393,9 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk, int new_alloc)
 		goto out_unlock;

 	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
-	memcpy(new, chunk->map, old_size);
+	old = chunk->map;
+
+	memcpy(new, old, old_size);

 	chunk->map_alloc = new_alloc;
 	chunk->map = new;
@@ -1162,7 +1164,7 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 		}

 		/*
-		 * Don't accept if wastage is over 25%.  The
+		 * Don't accept if wastage is over 1/3.  The
 		 * greater-than comparison ensures upa==1 always
 		 * passes the following check.
 		 */
diff --git a/mm/percpu_up.c b/mm/percpu_up.c
index c4351c7..db884fa 100644
--- a/mm/percpu_up.c
+++ b/mm/percpu_up.c
@@ -14,13 +14,13 @@ void __percpu *__alloc_percpu(size_t size, size_t align)
 	 * percpu sections on SMP for which this path isn't used.
 	 */
 	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
+	return (void __percpu __force *)kzalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(__alloc_percpu);

 void free_percpu(void __percpu *p)
 {
-	kfree(p);
+	kfree(this_cpu_ptr(p));
 }
 EXPORT_SYMBOL_GPL(free_percpu);

