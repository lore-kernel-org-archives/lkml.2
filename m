Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1BNM0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:26:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab1BNM0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:26:07 -0500
Date: Mon, 14 Feb 2011 13:25:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] x86: fix section mismatch in reference from
 native_play_dead
Message-ID: <20110214122550.GA15860@elte.hu>
References: <20110203131333.GA4161@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203131333.GA4161@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Fix 
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0x19cde): Section mismatch in reference from 
> the function native_play_dead() to the function .cpuinit.text:mwait_usable()
> The function native_play_dead() references the function __cpuinit mwait_usable().
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  arch/x86/kernel/smpboot.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 0cbe8c0..0b8c6c9 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1467,7 +1467,7 @@ static inline void hlt_play_dead(void)
>  	}
>  }
>  
> -void native_play_dead(void)
> +void __cpuinit native_play_dead(void)
>  {
>  	play_dead_common();
>  	tboot_shutdown(TB_SHUTDOWN_WFS);

I think the right fix is Boris's fix below. Agreed?

Thanks,

	Ingo

>From 1c9d16e35911090dee3f9313e6af13af623d66ee Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@amd64.org>
Date: Fri, 11 Feb 2011 18:17:54 +0100
Subject: [PATCH] x86: Fix mwait_usable section mismatch

We use it in non __cpuinit code now too so drop marker.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20110211171754.GA21047@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cpu.h |    2 +-
 arch/x86/kernel/process.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 6e6e755..4564c8e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
+int mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e764fc0..3c189e9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -506,7 +506,7 @@ static void poll_idle(void)
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
