Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0ESBqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:46:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:41131 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0ESBkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:08 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 16/25] kgdb: remove post_primary_code references
Date: Tue, 18 May 2010 20:39:26 -0500
Message-Id: <1274233175-3675-17-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:54.0797 (UTC) FILETIME=[2E9CEDD0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the references to the kgdb_post_primary_code.  This
function serves no useful purpose because you can obtain the same
information from the "struct kgdb_state *ks" from with in the
debugger, if for some reason you want the data.

Also remove the unintentional duplicate assignment for ks->ex_vector.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c    |   29 -----------------------------
 include/linux/kgdb.h      |   14 --------------
 kernel/debug/debug_core.c |    8 --------
 3 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index f95a2c0..acba571 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -47,20 +47,8 @@
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
 #include <asm/system.h>
-
 #include <asm/apic.h>
 
-/*
- * Put the error code here just in case the user cares:
- */
-static int gdb_x86errcode;
-
-/*
- * Likewise, the vector number here (since GDB only gets the signal
- * number through the usual means, and that's not very specific):
- */
-static int gdb_x86vector = -1;
-
 /**
  *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
  *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
@@ -399,23 +387,6 @@ void kgdb_disable_hw_debug(struct pt_regs *regs)
 	}
 }
 
-/**
- *	kgdb_post_primary_code - Save error vector/code numbers.
- *	@regs: Original pt_regs.
- *	@e_vector: Original error vector.
- *	@err_code: Original error code.
- *
- *	This is needed on architectures which support SMP and KGDB.
- *	This function is called after all the slave cpus have been put
- *	to a know spin state and the primary CPU has control over KGDB.
- */
-void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
-{
-	/* primary processor is completely in the debugger */
-	gdb_x86vector = e_vector;
-	gdb_x86errcode = err_code;
-}
-
 #ifdef CONFIG_SMP
 /**
  *	kgdb_roundup_cpus - Get other CPUs into a holding pattern
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 407edb1..406f6f9 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -36,20 +36,6 @@ struct pt_regs;
 extern int kgdb_skipexception(int exception, struct pt_regs *regs);
 
 /**
- *	kgdb_post_primary_code - (optional) Save error vector/code numbers.
- *	@regs: Original pt_regs.
- *	@e_vector: Original error vector.
- *	@err_code: Original error code.
- *
- *	This is usually needed on architectures which support SMP and
- *	KGDB.  This function is called after all the secondary cpus have
- *	been put to a know spin state and the primary CPU has control over
- *	KGDB.
- */
-extern void kgdb_post_primary_code(struct pt_regs *regs, int e_vector,
-				  int err_code);
-
-/**
  *	kgdb_disable_hw_debug - (optional) Disable hardware debugging hook
  *	@regs: Current &struct pt_regs.
  *
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1aed37b..88a83a2 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -203,12 +203,6 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
 	return 0;
 }
 
-void __weak
-kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
-{
-	return;
-}
-
 /**
  *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
  *	@regs: Current &struct pt_regs.
@@ -588,7 +582,6 @@ return_normal:
 	 * At this point the primary processor is completely
 	 * in the debugger and all secondary CPUs are quiescent
 	 */
-	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	dbg_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
@@ -678,7 +671,6 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
 	ks->signo		= signo;
-	ks->ex_vector		= evector;
 	ks->err_code		= ecode;
 	ks->kgdb_usethreadid	= 0;
 	ks->linux_regs		= regs;
-- 
1.6.3.3

