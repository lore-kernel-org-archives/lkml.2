Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0INTkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:40:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0INTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] alpha: kill big kernel lock
Date: Tue, 14 Sep 2010 21:40:09 +0200
Message-Id: <1284493213-7263-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HvJ48oCKy6NqA4Lh3LGWnd6z1Lcc6Ycc94oZMtWlqTr
 1xsiWExdOEJvlL42P14Q0M138i+/UV2dAvya+Btx9/7iXVYg2h
 FVBFQ8nouVCl8P/CvgkzFAuBy5dgpAJ5SmOOHtKzAuBrIhGEGr
 +fcTTCXrBz27LOzkGSO//fBYwIqEFRki98tZQtrbm1DRViffVp
 XbmQRrfNoVg8FdS8i7ysg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of the BKL on alpha are totally bogus, nothing
is really protected by this. Remove the remaining users
so we don't have to mark alpha as 'depends on BKL'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/osf_sys.c |    5 -----
 arch/alpha/kernel/traps.c   |    3 ---
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 5d1e6d6..49225dd 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
@@ -69,7 +68,6 @@ SYSCALL_DEFINE4(osf_set_program_attributes, unsigned long, text_start,
 {
 	struct mm_struct *mm;
 
-	lock_kernel();
 	mm = current->mm;
 	mm->end_code = bss_start + bss_len;
 	mm->start_brk = bss_start + bss_len;
@@ -78,7 +76,6 @@ SYSCALL_DEFINE4(osf_set_program_attributes, unsigned long, text_start,
 	printk("set_program_attributes(%lx %lx %lx %lx)\n",
 		text_start, text_len, bss_start, bss_len);
 #endif
-	unlock_kernel();
 	return 0;
 }
 
@@ -517,7 +514,6 @@ SYSCALL_DEFINE2(osf_proplist_syscall, enum pl_code, code,
 	long error;
 	int __user *min_buf_size_ptr;
 
-	lock_kernel();
 	switch (code) {
 	case PL_SET:
 		if (get_user(error, &args->set.nbytes))
@@ -547,7 +543,6 @@ SYSCALL_DEFINE2(osf_proplist_syscall, enum pl_code, code,
 		error = -EOPNOTSUPP;
 		break;
 	};
-	unlock_kernel();
 	return error;
 }
 
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index b14f015..0414e02 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
@@ -623,7 +622,6 @@ do_entUna(void * va, unsigned long opcode, unsigned long reg,
 		return;
 	}
 
-	lock_kernel();
 	printk("Bad unaligned kernel access at %016lx: %p %lx %lu\n",
 		pc, va, opcode, reg);
 	do_exit(SIGSEGV);
@@ -646,7 +644,6 @@ got_exception:
 	 * Yikes!  No one to forward the exception to.
 	 * Since the registers are in a weird format, dump them ourselves.
  	 */
-	lock_kernel();
 
 	printk("%s(%d): unhandled unaligned exception\n",
 	       current->comm, task_pid_nr(current));
-- 
1.7.1

