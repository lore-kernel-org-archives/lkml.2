Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1FISFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:05:22 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:48457 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1FISFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:05:20 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mathias Krause <minipli@googlemail.com>
Subject: 
Date: Thu,  9 Jun 2011 20:05:18 +0200
Message-Id: <1307642718-22257-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
References: <4DEFD979.50405@tilera.com> <1307607243-5737-1-git-send-email-minipli@googlemail.com> <20110609104017.GW11521@ZenIV.linux.org.uk> <BANLkTimAR8ou0dwX_uB8g4pQQtu0+V5k5w@mail.gmail.com> <BANLkTimVZxa2pvBqzC3RCg+2o_HzHcwtVQ@mail.gmail.com> <D167BDC0-BB1A-41B8-A59D-DD60FFA027CE@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 7:03 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, Jun 9, 2011 at 9:40 AM, Mathias Krause <minipli@googlemail.com> wrote:
>>
>> So the only question left: Should it be one patch moving the set_fs() call to
>> flush_old_exec() and also removing the redundant calls in flush_thread() and
>> start_thread() or should that be split into one for the set_fs() move and
>> multiple ones for the arch specific set_fs() remove?
>
> I'd suggest one patch that moves the set_fs(), and then possibly
> removes the ones from architectures that who-ever wrote the patch can
> actively test.
>
> Doing random other architectures is not worth the effort or confusion, imho.

Successfully tested on i386 and x86_64.

Mathias

-- >8 --
Subject: [PATCH] exec: delay address limit change until point of no return

Unconditionally changing the address limit to USER_DS and not restoring
it to its old value in the error path is wrong because it prevents us
using kernel memory on repeated calls to this function. This, in fact,
breaks the fallback of hard coded paths to the init program from being
ever successful if the first candidate fails to load.

With this patch applied switching to USER_DS is delayed until the point
of no return is reached which makes it possible to have a multi-arch
rootfs with one arch specific init binary for each of the (hard coded)
probed paths.

Since the address limit is already set to USER_DS when start_thread()
will be invoked, this redundancy can be safely removed.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@kernel.org
---
 arch/x86/kernel/process_32.c |    1 -
 arch/x86/kernel/process_64.c |    1 -
 fs/exec.c                    |    5 +----
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8d12878..a3d0dc5 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -245,7 +245,6 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 {
 	set_user_gs(regs, 0);
 	regs->fs		= 0;
-	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
 	regs->es		= __USER_DS;
 	regs->ss		= __USER_DS;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6c9dd92..ca6f7ab 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -338,7 +338,6 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
-	set_fs(USER_DS);
 	/*
 	 * Free the old FP and other extended state
 	 */
diff --git a/fs/exec.c b/fs/exec.c
index ea5f748..97e0d52 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1093,6 +1093,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;		/* We're using it now */
 
+	set_fs(USER_DS);
 	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
@@ -1357,10 +1358,6 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
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

