Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2HWMJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:09:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2HWMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:09:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tixy <tixy@yxit.co.uk>
Subject: Re: [PATCHv4 4/4] ARM: kprobes: make more tests conditional
Date: Thu, 23 Aug 2012 12:09:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@arm.com>, linux-kernel@vger.kernel.org
References: <1345645780-2749-1-git-send-email-arnd@arndb.de> <201208221841.29645.arnd@arndb.de> <1345679461.3601.20.camel@computer5.home>
In-Reply-To: <1345679461.3601.20.camel@computer5.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231209.26707.arnd@arndb.de>
X-Provags-ID: V02:K0:Kc5Y3QkBKq1xOaTe8FsokOy8L59YwSs0Z/JoijWZuVl
 YOJcPdOlCV5wsKxBVtE4ZEF734VcQnxwUVdLcvTyMXhsJqt8Vv
 2HVxNlWE/BXgXY52hgzQe2GQ1Nypn39eZJx6moNb7xfARRlzVY
 yndvS++USuQYtg+LWC6h+bYRoMqAzWBiTwhS3+tbobxbO33eWb
 NUYpky3fWZjqD73KU3WBv5+AiND3MKT+SkeS6jKAnc4MPXph0J
 SCPGpnOIFLtAaY2A7aGgMJSdjRP0oFFE/4998TuZSE3fSkB8hk
 onLtn4aW8iL11jdHViJy5yh0XhD8dn13dh6qvCh6m9zRYOjvIa
 i5u0Vmgz1StzksPLlCSE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Tixy wrote:

> If you do feel so inclined for a v4 however ;-) you could also make the
> mls part of the patch tidier by moving the added #endif to instead
> terminate the preceding "#if __LINUX_ARM_ARCH__ >= 6", i.e.
> 
> @@ -367,8 +367,10 @@ void kprobe_arm_test_cases(void)
>  	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
>  	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
> +#endif
>  
> +#if __LINUX_ARM_ARCH__ >= 7
>  	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
>  	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
>  	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")
> 
> 
> this looks funny in patch form, but the resulting source file is more
> consistent with other conditional tests.

Ok, here we go.

	Arnd


commit abfef4db8731591fbb721262bd4712662aaa6d14
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Aug 16 07:49:31 2012 +0000

    ARM: kprobes: make more tests conditional
    
    The mls instruction is not available in ARMv6K or below, so we
    should make the test conditional on at least ARMv7. ldrexd/strexd
    are available in ARMv6K or ARMv7, which we can test by checking
    the CONFIG_CPU_32v6K symbol.
    
    /tmp/ccuMTZ8D.s: Assembler messages:
    /tmp/ccuMTZ8D.s:22188: Error: selected processor does not support ARM mode `mls r0,r1,r2,r3'
    /tmp/ccuMTZ8D.s:22222: Error: selected processor does not support ARM mode `mlshi r7,r8,r9,r10'
    /tmp/ccuMTZ8D.s:22252: Error: selected processor does not support ARM mode `mls lr,r1,r2,r13'
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Jon Medhurst <tixy@yxit.co.uk>
    Cc: Russell King <rmk+kernel@arm.linux.org.uk>
    Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
    Cc: Leif Lindholm <leif.lindholm@arm.com>

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 38c1a3b..8393129 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -366,7 +366,9 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word 0xe04f0392 @ umaal r0, pc, r2, r3")
 	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
 	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
+#endif
 
+#if __LINUX_ARM_ARCH__ >= 7
 	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
 	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
 	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")
@@ -456,6 +458,8 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word	0xe1700090") /* Unallocated space */
 #if __LINUX_ARM_ARCH__ >= 6
 	TEST_UNSUPPORTED("ldrex	r2, [sp]")
+#endif
+#if (__LINUX_ARM_ARCH__ >= 7) || defined(CONFIG_CPU_32v6K)
 	TEST_UNSUPPORTED("strexd	r0, r2, r3, [sp]")
 	TEST_UNSUPPORTED("ldrexd	r2, r3, [sp]")
 	TEST_UNSUPPORTED("strexb	r0, r2, [sp]")
