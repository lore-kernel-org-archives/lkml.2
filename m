Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1L2OYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 09:24:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33044 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1L2OYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 09:24:45 -0500
Date: Thu, 29 Dec 2011 18:24:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111229142438.GI4460@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com>
 <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com>
 <20111228171419.GA19321@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228171419.GA19321@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 09:14:19PM +0400, Cyrill Gorcunov wrote:
> 
> Yeah, indeed.
> 
> > > which means I really would prefer to limit access to such
> > > features (ie root-only). If (as I said) for other cases there is simply no way to
> > > _not_ use crypto, our case might be the one where using crypto is redundant.
> > 
> > Limiting it to root and just exporting printer (or maybe XOR with a
> > randomish value) may be good enough.  I don't know.  However, we no
> > longer consider exporting pointers to unpriviliedged userland safe and
> > this can be useful in many circumstances, so if it's not too
> > difficult, I think trying to use proper hash would be nide.
> 
> OK, Tejun, I'll try, but no promises :) Thanks!
> 

Tejun, I've tried to use crypto engine here but it produced a warning
about being used in non-sleepable context (which takes place when we
read /proc/<pid>/fdinfo/* files). So I used lib/sha1.c instead. The
final result is below, please review.

The output as expected is sha1 hash but note I still placed root-only
access here since I prefer security guys to confirm if such production
is indeed safe to be exported for regular users.

| [root@localhost ~]# cat /proc/2/ns/net 
| id:	ebfc829fc16a466c9c02b031ceab65c277040c02

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Add routine for generating an ID for kernel pointer v2

The routine XORs the given pointer with a random value,
expands the production to sha1 message block and compute
the sha1 hash producing an ID.

Util confirmed that the production is a safe one to be
exported for the unprivileged users CAP_SYS_ADMIN guird
is used.

Because the routine might be used in non-sleepable context
built-in realization of sha1 is chosen instead of crypto
manager and its helpers.

v1:
 - Tejun worried about the single poison value was a weak side -
   leaking one makes all the IDs vulnerable. To address this
   several poison values - one per object type - are introduced.
   They are stored in a plain array.
 - Pekka proposed to initialized poison values in the late_initcall callback
 - ... and move the code to mm/util.c, but eventually it's moved
   to an own file.

v2:
 - Tejun suggested to use crypto engine instead of plain XOR and
   provide hashes to unprivilege users as well.
 - A number of fixes for Kconfig prompt from Valdis
 - Andrew pointed more #incclude's are needed

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
CC: Valdis.Kletnieks@vt.edu
---
 include/linux/gen_obj_id.h |   26 ++++++++++++++
 mm/Kconfig                 |   18 ++++++++++
 mm/Makefile                |    1 
 mm/gen_obj_id.c            |   81 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+)

Index: linux-2.6.git/include/linux/gen_obj_id.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/linux/gen_obj_id.h
@@ -0,0 +1,26 @@
+#ifndef _LINUX_GEN_OBJ_ID_H
+#define _LINUX_GEN_OBJ_ID_H
+
+#include <linux/cryptohash.h>
+#include <linux/err.h>
+
+#ifdef __KERNEL__
+
+enum {
+	GEN_OBJ_ID_TYPES,
+};
+
+#define GEN_OBJ_ID_DIGEST_SIZE	(SHA_DIGEST_WORDS * sizeof(__u32))
+#define GEN_OBJ_ID_BUF_SIZE	(GEN_OBJ_ID_DIGEST_SIZE * 2)
+
+#ifdef CONFIG_GENERIC_OBJECT_ID
+extern int gen_obj_id(void *ptr, int type, char *dst, unsigned long size);
+#else
+static inline int gen_obj_id(void *ptr, int type, char *dst, unsigned long size)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_GEN_OBJ_ID_H */
Index: linux-2.6.git/mm/Kconfig
===================================================================
--- linux-2.6.git.orig/mm/Kconfig
+++ linux-2.6.git/mm/Kconfig
@@ -373,3 +373,21 @@ config CLEANCACHE
 	  in a negligible performance hit.
 
 	  If unsure, say Y to enable cleancache
+
+config GENERIC_OBJECT_ID
+	bool "Enable generic object ID infrastructure"
+	depends on CHECKPOINT_RESTORE
+	depends on CRYPTO_SHA1
+	default n
+	help
+	  Turn on functionality that can generate IDs for kernel
+	  objects, which are exported to the userspace via /proc
+	  filesystem.
+
+	  It is useful if you need to examine kernel objects and test
+	  if they are shared between several tasks. These IDs should never
+	  be used for anything but the "sameness" test. The IDs are dynamic
+	  and valid only while object is alive. Once it get freed or kernel
+	  is rebooted, the IDs will be changed.
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
@@ -0,0 +1,81 @@
+#include <linux/kernel.h>
+#include <linux/capability.h>
+#include <linux/cryptohash.h>
+#include <linux/string.h>
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cache.h>
+#include <linux/bug.h>
+#include <linux/err.h>
+
+#include <linux/gen_obj_id.h>
+
+static unsigned long gen_obj_cookie[GEN_OBJ_ID_TYPES] __read_mostly;
+
+int gen_obj_id(void *ptr, int type, char *dst, unsigned long size)
+{
+	__u32 hash[SHA_DIGEST_WORDS];
+	__u32 workspace[SHA_WORKSPACE_WORDS];
+	__u8 extract[SHA_MESSAGE_BYTES];
+	__u8 *t = (__u8 *)hash;
+	unsigned long id;
+	int i;
+
+	BUG_ON(type >= GEN_OBJ_ID_TYPES);
+
+	if (!capable(CAP_SYS_ADMIN) ||
+	    size < GEN_OBJ_ID_BUF_SIZE) {
+		memset(dst, '0', size);
+		return -EINVAL;
+	}
+
+	id = ((unsigned long)ptr) ^ gen_obj_cookie[type];
+
+	BUILD_BUG_ON(SHA_MESSAGE_BYTES % sizeof(long));
+
+	/*
+	 * Expand the ID to the whole message block.
+	 */
+	for (i = 0; i < (SHA_MESSAGE_BYTES / sizeof(long)); i++)
+		((long *)extract)[i] = id;
+
+	sha_init(hash);
+	sha_transform(hash, extract, workspace);
+
+	snprintf(dst, size,
+		 "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
+		 "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
+		 t[ 0], t[ 1], t[ 2], t[ 3], t[ 4],
+		 t[ 5], t[ 6], t[ 7], t[ 8], t[ 9],
+		 t[10], t[11], t[12], t[13], t[14],
+		 t[15], t[16], t[17], t[18], t[19]);
+
+	return 0;
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
