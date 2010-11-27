Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0K0KTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:19:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:33206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0K0KT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:19:29 -0500
Message-ID: <4CF0DB05.5080606@kernel.org>
Date: Sat, 27 Nov 2010 11:18:45 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Robert Richter <robert.richter@amd.com>,
        Dan Carpenter <error27@gmail.com>, Avi Kivity <avi@redhat.com>,
        Bernd Machenschalk <Bernd.Machenschalk@aei.mpg.de>,
        Heinz-Bernd Eggenstein <hbeggenst@aol.com>,
        Oliver Bock <oliver.bock@aei.mpg.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: Possible FPU context corruption w/ CONFIG_PREEMPT
References: <4CEFD2BA.5090403@kernel.org> <AANLkTimidOhwXPNwrCCS0HqiOrmzeLC14+bCuWgKj0vJ@mail.gmail.com>
In-Reply-To: <AANLkTimidOhwXPNwrCCS0HqiOrmzeLC14+bCuWgKj0vJ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 10:18:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Brian.

On 11/27/2010 06:34 AM, Brian Gerst wrote:
> On Fri, Nov 26, 2010 at 10:31 AM, Tejun Heo <tj@kernel.org> wrote:
>> Hello, guys.
>>
>> Heinz-Bernd Eggenstein reports a possible FPU context corruption w/
>> CONFIG_PREEMPT.  Please take a look at the following forum post.
>>
>>  http://einstein.phys.uwm.edu/forum_thread.php?id=8516
>>
>> openSUSE 11.3 desktop kernel which has CONFIG_PREEMPT set is
>> triggering SIGFPE while the default kernel w/o preemption works fine.
>> He also notes that a similar bug was fixed in 2008 by commit 06c38d5e
>> (x86-64: fix FPU corruption with signals and preemption) from Suresh.
>> Does it ring anyone's bell?
>>
>> Heinz, is there a simple procedure to reproduce the problem, or would
>> it be possible to lure you into bisection?
> 
> This might be fixed by commit a4d4fbc7735bba6654b20f859135f9d3f8fe7f76
> (Disable preemption when using TS_USEDFPU).

Thanks for the pointer.  Can someone please verify whether the
following patch fixes the issue?  And, if so, this definitely should
go to -stable.

>From a4d4fbc7735bba6654b20f859135f9d3f8fe7f76 Mon Sep 17 00:00:00 2001
From: Brian Gerst <brgerst@gmail.com>
Date: Fri, 3 Sep 2010 21:17:12 -0400
Subject: [PATCH] x86-64, fpu: Disable preemption when using TS_USEDFPU

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
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-6-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
1.7.1

