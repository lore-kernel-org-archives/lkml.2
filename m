Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab2HWRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:30:29 -0400
Received: from queue03.mail.zen.net.uk ([212.23.3.237]:50509 "EHLO
	queue03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2HWRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:30:04 -0400
Message-ID: <1345742934.2586.6.camel@computer5.home>
Subject: Re: [PATCHv4 4/4] ARM: kprobes: make more tests conditional
From: Tixy <tixy@yxit.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@arm.com>, linux-kernel@vger.kernel.org
Date: Thu, 23 Aug 2012 18:28:54 +0100
In-Reply-To: <201208231209.26707.arnd@arndb.de>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
	 <201208221841.29645.arnd@arndb.de>
	 <1345679461.3601.20.camel@computer5.home>
	 <201208231209.26707.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost04-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 12:09 +0000, Arnd Bergmann wrote:
> commit abfef4db8731591fbb721262bd4712662aaa6d14
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Thu Aug 16 07:49:31 2012 +0000
> 
>     ARM: kprobes: make more tests conditional
>     
>     The mls instruction is not available in ARMv6K or below, so we
>     should make the test conditional on at least ARMv7. ldrexd/strexd
>     are available in ARMv6K or ARMv7, which we can test by checking
>     the CONFIG_CPU_32v6K symbol.
>     
>     /tmp/ccuMTZ8D.s: Assembler messages:
>     /tmp/ccuMTZ8D.s:22188: Error: selected processor does not support ARM mode `mls r0,r1,r2,r3'
>     /tmp/ccuMTZ8D.s:22222: Error: selected processor does not support ARM mode `mlshi r7,r8,r9,r10'
>     /tmp/ccuMTZ8D.s:22252: Error: selected processor does not support ARM mode `mls lr,r1,r2,r13'
>     
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>     Cc: Jon Medhurst <tixy@yxit.co.uk>
>     Cc: Russell King <rmk+kernel@arm.linux.org.uk>
>     Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
>     Cc: Leif Lindholm <leif.lindholm@arm.com>

Thanks for your indulgence :-) With the white-space damage fixed...

Acked-by: Jon Medhurst <tixy@yxit.co.uk>

I test built this for v6, v6k and v7 before and after applying the patch
to verify if behaves as expected, so you can add my Tested-by if you
want.

I also tried a v4 platform (forgot we supported those) and there will be
a patch coming to fix that...


> diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
> index 38c1a3b..8393129 100644
> --- a/arch/arm/kernel/kprobes-test-arm.c
> +++ b/arch/arm/kernel/kprobes-test-arm.c
> @@ -366,7 +366,9 @@ void kprobe_arm_test_cases(void)
>  	TEST_UNSUPPORTED(".word 0xe04f0392 @ umaal r0, pc, r2, r3")
>  	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
>  	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
> +#endif
>  
> +#if __LINUX_ARM_ARCH__ >= 7
>  	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
>  	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
>  	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")
> @@ -456,6 +458,8 @@ void kprobe_arm_test_cases(void)
>  	TEST_UNSUPPORTED(".word	0xe1700090") /* Unallocated space */
>  #if __LINUX_ARM_ARCH__ >= 6
>  	TEST_UNSUPPORTED("ldrex	r2, [sp]")
> +#endif
> +#if (__LINUX_ARM_ARCH__ >= 7) || defined(CONFIG_CPU_32v6K)
>  	TEST_UNSUPPORTED("strexd	r0, r2, r3, [sp]")
>  	TEST_UNSUPPORTED("ldrexd	r2, r3, [sp]")
>  	TEST_UNSUPPORTED("strexb	r0, r2, [sp]")


