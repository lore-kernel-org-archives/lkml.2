Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab2LAAkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2LAAkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:40:03 -0500
Date: Fri, 30 Nov 2012 16:39:51 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-a5c2a893dbd4956a72fb261e8790d19f67b52c99@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354132230-21854-7-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-7-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal: Remove CONFIG_X86_WP_WORKS_OK
Git-Commit-ID: a5c2a893dbd4956a72fb261e8790d19f67b52c99
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:39:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5c2a893dbd4956a72fb261e8790d19f67b52c99
Gitweb:     http://git.kernel.org/tip/a5c2a893dbd4956a72fb261e8790d19f67b52c99
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:28 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:23:03 -0800

x86, 386 removal: Remove CONFIG_X86_WP_WORKS_OK

All 486+ CPUs support WP in supervisor mode, so remove the fallback
386 support code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-7-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig.cpu           |  3 ---
 arch/x86/include/asm/uaccess.h | 42 -------------------------------
 arch/x86/lib/usercopy_32.c     | 57 ------------------------------------------
 arch/x86/mm/init_32.c          |  5 +---
 4 files changed, 1 insertion(+), 106 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index d3bdc18..159ee9c 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -325,9 +325,6 @@ config X86_INVD_BUG
 	def_bool y
 	depends on M486
 
-config X86_WP_WORKS_OK
-	def_bool y
-
 config X86_POPAD_OK
 	def_bool y
 	depends on X86_32
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 7ccf8d1..1709801 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -237,8 +237,6 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
-#ifdef CONFIG_X86_WP_WORKS_OK
-
 /**
  * put_user: - Write a simple value into user space.
  * @x:   Value to copy to user space.
@@ -326,29 +324,6 @@ do {									\
 	}								\
 } while (0)
 
-#else
-
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	__typeof__(*(ptr))__pus_tmp = x;				\
-	retval = 0;							\
-									\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
-		retval = errret;					\
-} while (0)
-
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr))__pus_tmp = x;			\
-	__ret_pu = 0;						\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
-				       sizeof(*(ptr))) != 0))	\
-		__ret_pu = -EFAULT;				\
-	__ret_pu;						\
-})
-#endif
-
 #ifdef CONFIG_X86_32
 #define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
 #define __get_user_asm_ex_u64(x, ptr)			(x) = __get_user_bad()
@@ -543,29 +518,12 @@ struct __large_struct { unsigned long buf[100]; };
 	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
 } while (0)
 
-#ifdef CONFIG_X86_WP_WORKS_OK
-
 #define put_user_try		uaccess_try
 #define put_user_catch(err)	uaccess_catch(err)
 
 #define put_user_ex(x, ptr)						\
 	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-#else /* !CONFIG_X86_WP_WORKS_OK */
-
-#define put_user_try		do {		\
-	int __uaccess_err = 0;
-
-#define put_user_catch(err)			\
-	(err) |= __uaccess_err;			\
-} while (0)
-
-#define put_user_ex(x, ptr)	do {		\
-	__uaccess_err |= __put_user(x, ptr);	\
-} while (0)
-
-#endif /* CONFIG_X86_WP_WORKS_OK */
-
 extern unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
 extern __must_check long
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 98f6d6b6..f0312d7 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -570,63 +570,6 @@ do {									\
 unsigned long __copy_to_user_ll(void __user *to, const void *from,
 				unsigned long n)
 {
-#ifndef CONFIG_X86_WP_WORKS_OK
-	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
-			((unsigned long)to) < TASK_SIZE) {
-		/*
-		 * When we are in an atomic section (see
-		 * mm/filemap.c:file_read_actor), return the full
-		 * length to take the slow path.
-		 */
-		if (in_atomic())
-			return n;
-
-		/*
-		 * CPU does not honor the WP bit when writing
-		 * from supervisory mode, and due to preemption or SMP,
-		 * the page tables can change at any time.
-		 * Do it manually.	Manfred <manfred@colorfullife.com>
-		 */
-		while (n) {
-			unsigned long offset = ((unsigned long)to)%PAGE_SIZE;
-			unsigned long len = PAGE_SIZE - offset;
-			int retval;
-			struct page *pg;
-			void *maddr;
-
-			if (len > n)
-				len = n;
-
-survive:
-			down_read(&current->mm->mmap_sem);
-			retval = get_user_pages(current, current->mm,
-					(unsigned long)to, 1, 1, 0, &pg, NULL);
-
-			if (retval == -ENOMEM && is_global_init(current)) {
-				up_read(&current->mm->mmap_sem);
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
-				goto survive;
-			}
-
-			if (retval != 1) {
-				up_read(&current->mm->mmap_sem);
-				break;
-			}
-
-			maddr = kmap_atomic(pg);
-			memcpy(maddr + offset, from, len);
-			kunmap_atomic(maddr);
-			set_page_dirty_lock(pg);
-			put_page(pg);
-			up_read(&current->mm->mmap_sem);
-
-			from += len;
-			to += len;
-			n -= len;
-		}
-		return n;
-	}
-#endif
 	stac();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..745d66b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -715,10 +715,7 @@ static void __init test_wp_bit(void)
 
 	if (!boot_cpu_data.wp_works_ok) {
 		printk(KERN_CONT "No.\n");
-#ifdef CONFIG_X86_WP_WORKS_OK
-		panic(
-  "This kernel doesn't support CPU's with broken WP. Recompile it for a 386!");
-#endif
+		panic("Linux doesn't support CPUs with broken WP.");
 	} else {
 		printk(KERN_CONT "Ok.\n");
 	}
