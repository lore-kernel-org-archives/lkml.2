Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2DYJv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:51:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36005 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2DYJvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:51:25 -0400
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 17:51:24 +0800
Message-ID: <CAFNq8R6YvR6-ejXJDxbW3ZTZ3EORPeH7kZd+czHAFkrAtn6dNA@mail.gmail.com>
Subject: For ARM Kernel, machine id is not be checked with mach-id passed from
 boot loader ?
From: Li Haifeng <omycle@gmail.com>
To: linux-kernel@vger.kernel.org, ERIC MIAO <eric.y.miao@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, each mach is identified by a number in
arch/arm/tools/mach-types. If the mach-id is not same with the id
passed by boot loader while running on hardware platform, an exception
will be throw and the system halt.

>From 2.6.39, this limitation may be cancelled by official Kernel?

For Kernel before 2.6.39, When the kernel run at the entry stext of
arch/arm/kernel/head.S. R1 register hold the machine id passed by boot
loader. Function of __lookup_machine_type will check the machin id. So
the machine id at arch/arm/tools/mach-types must be same with the
machine id defined in boot loader.

>From 2.6.39, the __lookup_machine_type is deleted.

$:~/Offical_Kernel$ git diff v2.6.38.8..v2.6.39 arch/arm/kernel/head.S
…
#ifdef CONFIG_XIP_KERNEL
@@ -87,25 +80,33 @@ ENTRY(stext)
        movs    r10, r5                         @ invalid processor (r5=0)?
  THUMB( it     eq )            @ force fixup-able long branch encoding
        beq     __error_p                       @ yes, error 'p'
-       bl      __lookup_machine_type           @ r5=machinfo
-       movs    r8, r5                          @ invalid machine (r5=0)?
- THUMB( it     eq )            @ force fixup-able long branch encoding
-       beq     __error_a                       @ yes, error 'a'
+
+#ifndef CONFIG_XIP_KERNEL
+       adr     r3, 2f
+       ldmia   r3, {r4, r8}
+       sub     r4, r3, r4                      @ (PHYS_OFFSET - PAGE_OFFSET)
+       add     r8, r8, r4                      @ PHYS_OFFSET
+#else
+       ldr     r8, =PLAT_PHYS_OFFSET
+#endif
….
And, if we define a random number for machine id at
arch/arm/tools/mach-types, the machine setup at start_kernel function
is not be influenced too.

So, to a new machine, if we do porting kernel on them ,the machine id
should be ok as a number now.

is it right?
