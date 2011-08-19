Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1HSXPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:15:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:4061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1HSXPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,253,1312182000"; 
   d="scan'208";a="41891149"
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Add a personality to report 2.6.x version numbers
Date: Fri, 19 Aug 2011 16:15:10 -0700
Message-Id: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Reposting due to popular demand. Several other people are running
into the same problem with all kinds of software.

Only change is rebase against current master.

-Andi

--

I ran into a couple of programs which broke with the new Linux 3.0 version.
Some of those were binary only. I tried to use LD_PRELOAD to work
around it, but it was quite difficult and in one case impossible
because of a mix of 32bit and 64bit executables.

This patch adds a UNAME26 personality that makes the kernel
report a 2.6.40+x version number instead. The x is the x in 3.x.

I know this is somewhat ugly, but I didn't find a better workaround,
and compatibility to existing programs is important.

Some programs also read /proc/sys/kernel/osrelease. This can be worked
around in user space with mount --bind (and a mount namespace)

To use:

wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
gcc -o uname26 uname26.c
./uname26 program

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/personality.h |    1 +
 kernel/sys.c                |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/personality.h b/include/linux/personality.h
index eec3bae..8fc7dd1a 100644
--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -22,6 +22,7 @@ extern int		__set_personality(unsigned int);
  * These occupy the top three bytes.
  */
 enum {
+	UNAME26	=               0x0020000,
 	ADDR_NO_RANDOMIZE = 	0x0040000,	/* disable randomization of VA space */
 	FDPIC_FUNCPTRS =	0x0080000,	/* userspace function ptrs point to descriptors
 						 * (signal handling)
diff --git a/kernel/sys.c b/kernel/sys.c
index a101ba3..bd6d142 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -37,6 +37,8 @@
 #include <linux/fs_struct.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
+#include <linux/version.h>
+#include <linux/ctype.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -44,6 +46,8 @@
 #include <linux/user_namespace.h>
 
 #include <linux/kmsg_dump.h>
+/* Move somewhere else to avoid recompiling? */
+#include <generated/utsrelease.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -1154,6 +1158,34 @@ DECLARE_RWSEM(uts_sem);
 #define override_architecture(name)	0
 #endif
 
+/* 
+ * Work around broken programs that cannot handle "Linux 3.0".
+ * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
+ */
+static int override_release(char __user *release, int len)
+{	
+	int ret = 0;
+	char buf[len];
+
+	if (current->personality & UNAME26) {
+		char *rest = UTS_RELEASE;
+		int ndots = 0;
+		unsigned v;
+
+		while (*rest) {
+			if (*rest == '.' && ++ndots >= 3)
+				break;
+			if (!isdigit(*rest) && *rest != '.')
+				break;
+			rest++;
+		}
+		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
+		snprintf(buf, len, "2.6.%u%s", v, rest);
+		ret = copy_to_user(release, buf, len);
+	}
+	return ret;
+}
+
 SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 {
 	int errno = 0;
@@ -1163,6 +1195,8 @@ SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 		errno = -EFAULT;
 	up_read(&uts_sem);
 
+	if (!errno && override_release(name->release, sizeof(name->release)))
+		errno = -EFAULT;
 	if (!errno && override_architecture(name))
 		errno = -EFAULT;
 	return errno;
@@ -1184,6 +1218,8 @@ SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
 		error = -EFAULT;
 	up_read(&uts_sem);
 
+	if (!error && override_release(name->release, sizeof(name->release)))
+		error = -EFAULT;
 	if (!error && override_architecture(name))
 		error = -EFAULT;
 	return error;
@@ -1218,6 +1254,8 @@ SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
 
 	if (!error && override_architecture(name))
 		error = -EFAULT;
+	if (!error && override_release(name->release, sizeof(name->release)))
+		error = -EFAULT;
 	return error ? -EFAULT : 0;
 }
 #endif
-- 
1.7.4.4

