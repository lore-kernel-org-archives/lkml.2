Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0H1QG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:06:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44080 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0H1QG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YM2fCp0HCk9xeR/kQgF/Qebk2C60mUlZ8gKU1D1klRQ7Gbr49Ub9QitzNTdi1NpHkS
         kgC2SQI7+NgL3apI+LyfHAkZ26s7OmqzTeKvaKCeQXIQrpqNAPgSn/53SQb6rHnKVeDC
         vwtV5VH54bmMv5mGW2Rjv1crcRjEAxnWFbb80=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] x86-64: Disable preemption when using TS_USEDFPU
Date: Sat, 28 Aug 2010 12:04:32 -0400
Message-Id: <1283011478-27237-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidates code and fixes the below race for 64-bit.

commit 9fa2f37bfeb798728241cc4a19578ce6e4258f25
Author: torvalds <torvalds>
Date:   Tue Sep 2 07:37:25 2003 +0000

    Be a lot more careful about TS_USEDFPU and preemption

    We had some races where we testecd (or set) TS_USEDFPU together
    with sequences that depended on the setting (like clearing or
    setting the TS flag in %cr0) and we could be preempted in between,
    which screws up the FPU state, since preemption will itself change
    USEDFPU and the TS flag.

    This makes it a lot more explicit: the "internal" low-level FPU
    functions ("__xxxx_fpu()") all require preemption to be disabled,
    and the exported "real" functions will make sure that is the case.

    One case - in __switch_to() - was switched to the non-preempt-safe
    internal version, since the scheduler itself has already disabled
    preemption.

    BKrev: 3f5448b5WRiQuyzAlbajs3qoQjSobw

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h  |   15 ---------------
 arch/x86/kernel/process_64.c |    2 +-
 2 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 88065e3..8b40a83 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -387,19 +387,6 @@ static inline void irq_ts_restore(int TS_state)
 		stts();
 }
 
-#ifdef CONFIG_X86_64
-
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	__save_init_fpu(tsk);
-	stts();
-}
-
-#define unlazy_fpu	__unlazy_fpu
-#define clear_fpu	__clear_fpu
-
-#else  /* CONFIG_X86_32 */
-
 /*
  * These disable preemption on their own and are safe
  */
@@ -425,8 +412,6 @@ static inline void clear_fpu(struct task_struct *tsk)
 	preempt_enable();
 }
 
-#endif	/* CONFIG_X86_64 */
-
 /*
  * i387 state interaction
  */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d9ea53..b3d7a3a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -424,7 +424,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	load_TLS(next, cpu);
 
 	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
+	__unlazy_fpu(prev_p);
 
 	/* Make sure cpu is ready for new context */
 	if (preload_fpu)
-- 
1.7.2.2

