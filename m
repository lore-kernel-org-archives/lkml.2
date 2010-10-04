Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0JDPrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab0JDPrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:47:03 -0400
Date: Mon, 4 Oct 2010 11:46:33 -0400
From: Jason Baron <jbaron@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@elte.hu
Subject: Re: Dynamic nop selection breaks boot on Geode LX
Message-ID: <20101004154633.GA2900@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 08:16:19PM +0100, Daniel Drake wrote:
> Hi,
> 
> linux-next fails to boot on OLPC's XO-1 laptop based on Geode LX processor.
> 
> This is because of
> 
> commit f49aa448561fe9215f43405cac6f31eb86317792
> Author: Jason Baron <jbaron@redhat.com>
> Date:   Fri Sep 17 11:08:51 2010 -0400
> 
>     jump label: Make dynamic no-op selection available outside of ftrace
> 
> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commitdiff;h=f49aa44
> 
> The Geode hangs inside the asm() statement inside arch_init_ideal_nop5.
> 
> Any thoughts?
> 
> I'm a bit out of my depth debugging assembly code, but will happily
> take pointers and patches to help diagnose.
> 
> cheers
> Daniel

Hi Daniel,

looks like I moved dynamic no-op selection way too early in the boot -
before the exception tables required to select invalid opcodes were
even set up. The patch belows moves them later and should resolve this
issue for you. thanks for narrowing it down!

thanks,

-Jason


move arch_init_ideal_nop5 later

arch_init_ideal_nop5() was being called from setup_arch() before
the exception table was setup. Move it later into
alternative_instructions().

Fixes a boot hang on OLPC's XO-1 laptop based on Geode LX
processor.


Reported-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/alternative.c |    5 +++++
 arch/x86/kernel/setup.c       |    6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index cb0e6d3..d8b5b21 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -454,6 +454,7 @@ extern struct paravirt_patch_site __start_parainstructions[],
 
 void __init alternative_instructions(void)
 {
+	unsigned long flags;
 	/* The patching is not fully atomic, so try to avoid local interruptions
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
@@ -508,6 +509,10 @@ void __init alternative_instructions(void)
 				(unsigned long)__smp_locks_end);
 
 	restart_nmi();
+
+	local_irq_save(flags);
+	arch_init_ideal_nop5();
+	local_irq_restore(flags);
 }
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 468ccd2..85b02b6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,7 +112,6 @@
 #include <asm/numa_64.h>
 #endif
 #include <asm/mce.h>
-#include <asm/alternative.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -690,7 +689,6 @@ void __init setup_arch(char **cmdline_p)
 {
 	int acpi = 0;
 	int k8 = 0;
-	unsigned long flags;
 
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
@@ -1038,10 +1036,6 @@ void __init setup_arch(char **cmdline_p)
 	x86_init.oem.banner();
 
 	mcheck_init();
-
-	local_irq_save(flags);
-	arch_init_ideal_nop5();
-	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.1

