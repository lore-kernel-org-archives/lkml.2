Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1HXNcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:32:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:40339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1HXNcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:32:43 -0400
Subject: [PATCH] microblaze: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW usage
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Wed, 24 Aug 2011 15:32:31 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314192751.6925.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell the only reason microblaze has
__ARCH_WANT_INTERRUPTS_ON_CTXSW is because it initializes new task state
with interrupts enabled so that on switch_to() interrupts get enabled.

So change copy_thread() to clear MSR_IE instead of set it, this will
ensure switch_to() will always keep IRQs disabled.

The scheduler will disable IRQs when taking rq->lock in schedule() and
enable IRQs in finish_lock_switch() after its done its magic.

This leaves ARM the only __ARCH_WANT_INTERRUPTS_ON_CTXSW user.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/microblaze/include/asm/system.h |    2 --
 arch/microblaze/kernel/process.c     |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
index e6a2284..ec4f3d0 100644
--- a/arch/microblaze/include/asm/system.h
+++ b/arch/microblaze/include/asm/system.h
@@ -17,8 +17,6 @@
 #include <asm-generic/cmpxchg.h>
 #include <asm-generic/cmpxchg-local.h>
 
-#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
-
 struct task_struct;
 struct thread_info;
 
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index dbb8124..c72d044 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -172,7 +172,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	 * right now MSR is a copy of parent one */
 	childregs->msr |= MSR_BIP;
 	childregs->msr &= ~MSR_EIP;
-	childregs->msr |= MSR_IE;
+	childregs->msr &= ~MSR_IE;
 	childregs->msr &= ~MSR_VM;
 	childregs->msr |= MSR_VMS;
 	childregs->msr |= MSR_EE; /* exceptions will be enabled*/

