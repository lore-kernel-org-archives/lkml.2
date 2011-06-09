Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1FIIOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:14:08 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:46531 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab1FIIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:14:05 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mathias Krause <minipli@googlemail.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Date: Thu,  9 Jun 2011 10:14:03 +0200
Message-Id: <1307607243-5737-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4DEFD979.50405@tilera.com>
References: <4DEFD979.50405@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 10:20 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 6/8/2011 8:14 AM, Mathias Krause wrote:
>> On Wed, Jun 8, 2011 at 12:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Tue, Jun 07, 2011 at 07:00:24PM -0700, Linus Torvalds wrote:
>>>> That said, that commit (it's commit ID 4095b99c09e3d in tglx's tree)
>>>> predates the "real" BK history too: it's part of the (limited) 2.4.x
>>>> history that was imported from the release patches into BK at the
>>>> beginning of the use of BK. So at that point we didn't do indivual
>>>> commits, it's just the import of the v2.4.3.7 -> v2.4.3.8 patch.
>>>>
>>>> But yeah, it's old and crufty. And I agree that usually the correct
>>>> fix is to remove the set_fs() calls entirely.
>>> I think these days its job is done by start_thread(), which is where we
>>> switch to USER_DS; it's called by ->load_binary() when it decides it's past
>>> the point of no return.  However, it would be a good idea to verify that
>>> all architectures do it there properly and we are not exposing a hole by
>>> removal of this set_fs()...
>> I've checked all implementations of start_thread() and found some candidates:
>>
>> SPARC, TILE and Xtensa don't call set_fs(USER_DS), albeit have
>> different definitions for USER_DS and KERNEL_DS. So those might need
>> fixing. I'm not familiar with those architectures, so someone else has
>> to answer this.
>
> TILE relies on the set_fs() in search_binary_handler(), but adding
> set_fs(USER_DS) in in start_thread() should be a valid change if the
> set_fs() is removed from search_binary_handler().

To shortcut the decision for the other architectures I've adapted the patch
and added a set_fs() call to the start_thread() implementations in question.
They where running under USER_DS before so calling set_fs() in
start_thread() is safe by any means.

> I'm happy to ack the
> obvious change for tile, or I can put the change to tile's start_thread()
> in my tree for inclusion in 3.1, either way.

Since this patch contains changes for multiple architectures I guess, this
one has to go in by Linus directly.

Mathias

-- >8 --
Subject: [PATCH v3] exec: keep address limit on exec errors

Unconditionally changing the address limit to USER_DS and not restoring
it to its old value in the error path is wrong because it prevents us
using kernel memory on repeated calls to this function. This, in fact,
breaks the fallback of hard coded paths to the init program from being
ever successful if the first candidate fails to load.

With this patch applied switching to USER_DS is delayed until the point
of no return is reached which makes it possible to have a multi-arch
rootfs with one arch specific init binary for each of the (hard coded)
probed paths.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Zankel <chris@zankel.net>
---
v1 was actually the alternative solution in run_init_process()
v2 was missing the set_fs() calls for SPARC, TILE and Xtensa

 arch/sparc/include/asm/processor_64.h |    2 ++
 arch/tile/include/asm/processor.h     |    1 +
 arch/xtensa/include/asm/processor.h   |    1 +
 arch/xtensa/kernel/signal.c           |    7 +------
 fs/exec.c                             |    4 ----
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index 59fcebb..eb6b334 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -105,6 +105,7 @@ extern unsigned long thread_saved_pc(struct task_struct *);
 #define start_thread(regs, pc, sp) \
 do { \
 	unsigned long __asi = ASI_PNF; \
+	set_fs(USER_DS); \
 	regs->tstate = (regs->tstate & (TSTATE_CWP)) | (TSTATE_INITIAL_MM|TSTATE_IE) | (__asi << 24UL); \
 	regs->tpc = ((pc & (~3)) - 4); \
 	regs->tnpc = regs->tpc + 4; \
@@ -143,6 +144,7 @@ do { \
 #define start_thread32(regs, pc, sp) \
 do { \
 	unsigned long __asi = ASI_PNF; \
+	set_fs(USER_DS); \
 	pc &= 0x00000000ffffffffUL; \
 	sp &= 0x00000000ffffffffUL; \
 	regs->tstate = (regs->tstate & (TSTATE_CWP))|(TSTATE_INITIAL_MM|TSTATE_IE|TSTATE_AM) | (__asi << 24UL); \
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 34c1e01..0890524 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -200,6 +200,7 @@ DECLARE_PER_CPU(unsigned long, boot_pc);
 static inline void start_thread(struct pt_regs *regs,
 				unsigned long pc, unsigned long usp)
 {
+	set_fs(USER_DS);
 	regs->pc = pc;
 	regs->sp = usp;
 }
diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index 3acb26e..d87a1ee 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -152,6 +152,7 @@ struct thread_struct {
 
 /* Clearing a0 terminates the backtrace. */
 #define start_thread(regs, new_pc, new_sp) \
+	set_fs(USER_DS); \
 	regs->pc = new_pc; \
 	regs->ps = USER_PS_VALUE; \
 	regs->areg[1] = new_sp; \
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index f2220b5..8a41e69 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -400,7 +400,7 @@ static void setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * Return context not modified until this point.
 	 */
 
-	/* Set up registers for signal handler */
+	/* Set up registers and access mode for signal handler */
 	start_thread(regs, (unsigned long) ka->sa.sa_handler, 
 		     (unsigned long) frame);
 
@@ -412,11 +412,6 @@ static void setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->areg[7] = (unsigned long) &frame->info;
 	regs->areg[8] = (unsigned long) &frame->uc;
 
-	/* Set access mode to USER_DS.  Nomenclature is outdated, but
-	 * functionality is used in uaccess.h
-	 */
-	set_fs(USER_DS);
-
 #if DEBUG_SIG
 	printk("SIG rt deliver (%s:%d): signal=%d sp=%p pc=%08x\n",
 		current->comm, current->pid, signal, frame, regs->pc);
diff --git a/fs/exec.c b/fs/exec.c
index ea5f748..31df75f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1357,10 +1357,6 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	if (retval)
 		return retval;
 
-	/* kernel module loader fixup */
-	/* so we don't try to load run modprobe in kernel space. */
-	set_fs(USER_DS);
-
 	retval = audit_bprm(bprm);
 	if (retval)
 		return retval;
-- 
1.5.6.5

