Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1H0O7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1H0O7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:56 2011
Message-Id: <20110826215056.501371688@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <ak@linux.intel.com>
Subject: [35/35] Add a personality to report 2.6.x version numbers
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit be27425dcc516fd08245b047ea57f83b8f6f0903 upstream.

I ran into a couple of programs which broke with the new Linux 3.0
version.  Some of those were binary only.  I tried to use LD_PRELOAD to
work around it, but it was quite difficult and in one case impossible
because of a mix of 32bit and 64bit executables.

For example, all kind of management software from HP doesnt work, unless
we pretend to run a 2.6 kernel.

  $ uname -a
  Linux svivoipvnx001 3.0.0-08107-g97cd98f #1062 SMP Fri Aug 12 18:11:45 CEST 2011 i686 i686 i386 GNU/Linux

  $ hpacucli ctrl all show

  Error: No controllers detected.

  $ rpm -qf /usr/sbin/hpacucli
  hpacucli-8.75-12.0

Another notable case is that Python now reports "linux3" from
sys.platform(); which in turn can break things that were checking
sys.platform() == "linux2":

  https://bugzilla.mozilla.org/show_bug.cgi?id=664564

It seems pretty clear to me though it's a bug in the apps that are using
'==' instead of .startswith(), but this allows us to unbreak broken
programs.

This patch adds a UNAME26 personality that makes the kernel report a
2.6.40+x version number instead.  The x is the x in 3.x.

I know this is somewhat ugly, but I didn't find a better workaround, and
compatibility to existing programs is important.

Some programs also read /proc/sys/kernel/osrelease.  This can be worked
around in user space with mount --bind (and a mount namespace)

To use:

  wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
  gcc -o uname26 uname26.c
  ./uname26 program

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/personality.h |    1 +
 kernel/sys.c                |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -22,6 +22,7 @@ extern int		__set_personality(unsigned i
  * These occupy the top three bytes.
  */
 enum {
+	UNAME26	=               0x0020000,
 	ADDR_NO_RANDOMIZE = 	0x0040000,	/* disable randomization of VA space */
 	FDPIC_FUNCPTRS =	0x0080000,	/* userspace function ptrs point to descriptors
 						 * (signal handling)
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -38,6 +38,8 @@
 #include <linux/fs_struct.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
+#include <linux/version.h>
+#include <linux/ctype.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -45,6 +47,8 @@
 #include <linux/user_namespace.h>
 
 #include <linux/kmsg_dump.h>
+/* Move somewhere else to avoid recompiling? */
+#include <generated/utsrelease.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -1124,6 +1128,34 @@ DECLARE_RWSEM(uts_sem);
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
@@ -1133,6 +1165,8 @@ SYSCALL_DEFINE1(newuname, struct new_uts
 		errno = -EFAULT;
 	up_read(&uts_sem);
 
+	if (!errno && override_release(name->release, sizeof(name->release)))
+		errno = -EFAULT;
 	if (!errno && override_architecture(name))
 		errno = -EFAULT;
 	return errno;
@@ -1154,6 +1188,8 @@ SYSCALL_DEFINE1(uname, struct old_utsnam
 		error = -EFAULT;
 	up_read(&uts_sem);
 
+	if (!error && override_release(name->release, sizeof(name->release)))
+		error = -EFAULT;
 	if (!error && override_architecture(name))
 		error = -EFAULT;
 	return error;
@@ -1188,6 +1224,8 @@ SYSCALL_DEFINE1(olduname, struct oldold_
 
 	if (!error && override_architecture(name))
 		error = -EFAULT;
+	if (!error && override_release(name->release, sizeof(name->release)))
+		error = -EFAULT;
 	return error ? -EFAULT : 0;
 }
 #endif


