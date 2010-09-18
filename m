Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0IRStF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:49:05 -0400
Received: from kroah.org ([198.145.64.141]:38956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab0IRSsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:48:38 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:46:21 2010
Message-Id: <20100918184621.516962684@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:45:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Helge Deller <deller@gmx.de>, James Bottomley <jejb@parisc-linux.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [07/11] compat: Make compat_alloc_user_space() incorporate the access_ok()
In-Reply-To: <20100918184651.GA14224@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

commit c41d68a513c71e35a14f66d71782d27a79a81ea6 upstream.

compat_alloc_user_space() expects the caller to independently call
access_ok() to verify the returned area.  A missing call could
introduce problems on some architectures.

This patch incorporates the access_ok() check into
compat_alloc_user_space() and also adds a sanity check on the length.
The existing compat_alloc_user_space() implementations are renamed
arch_compat_alloc_user_space() and are used as part of the
implementation of the new global function.

This patch assumes NULL will cause __get_user()/__put_user() to either
fail or access userspace on all architectures.  This should be
followed by checking the return value of compat_access_user_space()
for NULL in the callers, at which time the access_ok() in the callers
can also be removed.

Reported-by: Ben Hawkes <hawkes@sota.gen.nz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/include/asm/compat.h    |    2 +-
 arch/powerpc/include/asm/compat.h |    2 +-
 arch/s390/include/asm/compat.h    |    2 +-
 arch/sparc/include/asm/compat.h   |    2 +-
 include/asm-mips/compat.h         |    2 +-
 include/asm-parisc/compat.h       |    2 +-
 include/asm-x86/compat.h          |    2 +-
 include/linux/compat.h            |    2 ++
 kernel/compat.c                   |   22 ++++++++++++++++++++++
 9 files changed, 31 insertions(+), 7 deletions(-)

--- a/arch/ia64/include/asm/compat.h
+++ b/arch/ia64/include/asm/compat.h
@@ -198,7 +198,7 @@ ptr_to_compat(void __user *uptr)
 }
 
 static __inline__ void __user *
-compat_alloc_user_space (long len)
+arch_compat_alloc_user_space (long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *) (((regs->r12 & 0xffffffff) & -16) - len);
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -133,7 +133,7 @@ static inline compat_uptr_t ptr_to_compa
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = current->thread.regs;
 	unsigned long usp = regs->gpr[1];
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -163,7 +163,7 @@ static inline compat_uptr_t ptr_to_compa
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	unsigned long stack;
 
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -166,7 +166,7 @@ static inline compat_uptr_t ptr_to_compa
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = current_thread_info()->kregs;
 	unsigned long usp = regs->u_regs[UREG_I6];
--- a/include/asm-mips/compat.h
+++ b/include/asm-mips/compat.h
@@ -145,7 +145,7 @@ static inline compat_uptr_t ptr_to_compa
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = (struct pt_regs *)
 		((unsigned long) current_thread_info() + THREAD_SIZE - 32) - 1;
--- a/include/asm-parisc/compat.h
+++ b/include/asm-parisc/compat.h
@@ -146,7 +146,7 @@ static inline compat_uptr_t ptr_to_compa
 	return (u32)(unsigned long)uptr;
 }
 
-static __inline__ void __user *compat_alloc_user_space(long len)
+static __inline__ void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = &current->thread.regs;
 	return (void __user *)regs->gr[30];
--- a/include/asm-x86/compat.h
+++ b/include/asm-x86/compat.h
@@ -204,7 +204,7 @@ static inline compat_uptr_t ptr_to_compa
 	return (u32)(unsigned long)uptr;
 }
 
-static inline void __user *compat_alloc_user_space(long len)
+static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *)regs->sp - len;
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -291,5 +291,7 @@ asmlinkage long compat_sys_newfstatat(un
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+extern void __user *compat_alloc_user_space(unsigned long len);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
@@ -1081,3 +1082,24 @@ compat_sys_sysinfo(struct compat_sysinfo
 
 	return 0;
 }
+
+/*
+ * Allocate user-space memory for the duration of a single system call,
+ * in order to marshall parameters inside a compat thunk.
+ */
+void __user *compat_alloc_user_space(unsigned long len)
+{
+	void __user *ptr;
+
+	/* If len would occupy more than half of the entire compat space... */
+	if (unlikely(len > (((compat_uptr_t)~0) >> 1)))
+		return NULL;
+
+	ptr = arch_compat_alloc_user_space(len);
+
+	if (unlikely(!access_ok(VERIFY_WRITE, ptr, len)))
+		return NULL;
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(compat_alloc_user_space);


