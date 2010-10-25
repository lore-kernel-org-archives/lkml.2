Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0JYJ5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:57:12 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:8682 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0JYJ5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:57:10 -0400
Message-ID: <4CC55455.5060308@atmel.com>
Date: Mon, 25 Oct 2010 11:56:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH 2/2] AT91: pm: make sure that r0 is 0 when dealing with
 cache operations
References: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com> <86bb15f5a1aa3f21066ed13d7ee3f9f500d11087.1287767949.git.nicolas.ferre@atmel.com> <20101022164247.GB29119@n2100.arm.linux.org.uk>
In-Reply-To: <20101022164247.GB29119@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Le 22/10/2010 18:42, Russell King - ARM Linux :
> On Fri, Oct 22, 2010 at 07:29:00PM +0200, Nicolas Ferre wrote:
>> When using CP15 cache operations (c7), we make sure that Rd (r0)
>> is actually 0 as ARM 926 TRM is saying.
> 
> Err, no.  From the GCC manual:
> 
> |    Note that even a volatile `asm' instruction can be moved in ways
> | that appear insignificant to the compiler, such as across jump
> | instructions.  You can't expect a sequence of volatile `asm'
> | instructions to remain perfectly consecutive.  If you want consecutive
> | output, use a single `asm'.  Also, GCC will perform some optimizations
> | across a volatile `asm' instruction; GCC does not "forget everything"
> | when it encounters a volatile `asm' instruction the way some other
> | compilers do.
> 
> So:
> 
> 	asm volatile("foo");
> 	asm volatile("bar");
> 
> is not guaranteed to produce the following uninterrupted code sequence:
> 
> 	foo
> 	bar
> 
> The compiler is free to insert other instructions inbetween these two
> asm statements.
> 
> It's also not permitted to modify registers without telling gcc that
> they've been modified.
> 
>> +			asm("mov r0, #0");			/* clear r0 for CP15 accesses */
>>  			asm("b 1f; .align 5; 1:");
>>  			asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
> 
> That means the above is completely unacceptable.  It should be:
> 
> 	asm("mov r0, #0;"
> 	"b 1f;"
> 	".align 5;"
> 	"1: mcr p15, 0, r0, c7, c10, 4" : : : "r0");


Thanks a lot for your detailed explanation.

I modify my patch according to your comments:

--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -261,8 +261,13 @@ static int at91_pm_enter(suspend_state_t state)
                         * For ARM 926 based chips, this requirement is weaker
                         * as at91sam9 can access a RAM in self-refresh mode.
                         */
-                       asm("b 1f; .align 5; 1:");
-                       asm("mcr p15, 0, r0, c7, c10, 4");      /* drain write buffer */
+                       asm volatile (  "mov r0, #0\n\t"
+                                       "b 1f\n\t"
+                                       ".align 5\n\t"
+                                       "1: mcr p15, 0, r0, c7, c10, 4\n\t"
+                                       : /* no output */
+                                       : /* no input */
+                                       : "r0");
                        saved_lpr = sdram_selfrefresh_enable();
                        wait_for_interrupt_enable();
                        sdram_selfrefresh_disable(saved_lpr);


>> --- a/arch/arm/mach-at91/pm.h
>> +++ b/arch/arm/mach-at91/pm.h
>> @@ -21,7 +21,7 @@ static inline u32 sdram_selfrefresh_enable(void)
>>  }
>>  
>>  #define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
>> -#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4")
>> +#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4") /* r0 is 0 here */
> 
> No, r0 is not guaranteed to be zero here.  Use dsb() here instead which
> gets it right.

In fact it is Wait For Interrupt and not dsb... but anyway you are right: I modify it like this:

--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -21,7 +21,8 @@ static inline u32 sdram_selfrefresh_enable(void)
 }
 
 #define sdram_selfrefresh_disable(saved_lpr)   at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
-#define wait_for_interrupt_enable()            asm("mcr p15, 0, r0, c7, c0, 4")
+#define wait_for_interrupt_enable()            asm volatile ("mcr p15, 0, %0, c7, c0, 4" \
+                                                               : : "r" (0))
 
 #elif defined(CONFIG_ARCH_AT91CAP9)
 #include <mach/at91cap9_ddrsdr.h>

I repost this modified patch now...

Bye,
-- 
Nicolas Ferre

