Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0KFLVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:21:33 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4334 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0KFLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:21:32 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Nov 2010 07:21:32 EDT
Message-ID: <4CD538CA.8010901@xs4all.nl>
Date: Sat, 06 Nov 2010 12:15:22 +0100
From: Jim <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: gcc 4.5.1 / as 2.20.51.0.11 miscompiling  drivers/char/i8k.c ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After upgrading my Dell laptop, both OS+kernel the i8k interface was giving
nonsensical output. As it turned out it's not the kernel but compiler
upgrade which broke this.

Guys at Archlinux have found the underlying cause (but don't seem to have
submitted a patch yet):
  https://bbs.archlinux.org/viewtopic.php?pid=780692#p780692
gcc seems to optimize the assembly statements away.

And indeed, applying this patch makes the i8k interface work again,
i.e. replacing the asm(..) construct by  asm volatile(..)

--- i8k.c.ORIG  2010-08-02 17:20:46.000000000 +0200
+++ i8k.c       2010-10-30 13:03:07.000000000 +0200
@@ -119,7 +119,7 @@
        int eax = regs->eax;

 #if defined(CONFIG_X86_64)
-       asm("pushq %%rax\n\t"
+       asm volatile("pushq %%rax\n\t"
                "movl 0(%%rax),%%edx\n\t"
                "pushq %%rdx\n\t"
                "movl 4(%%rax),%%ebx\n\t"
@@ -145,7 +145,7 @@
                :    "a"(regs)
                :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
-       asm("pushl %%eax\n\t"
+       asm volatile("pushl %%eax\n\t"
            "movl 0(%%eax),%%edx\n\t"
            "push %%edx\n\t"
            "movl 4(%%eax),%%ebx\n\t"


gcc version:
Reading specs from /usr/lib/gcc/i486-slackware-linux/4.5.1/specs
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/i486-slackware-linux/4.5.1/lto-wrapper
Target: i486-slackware-linux
Configured with: ../gcc-4.5.1/configure --prefix=/usr --libdir=/usr/lib
--mandir=/usr/man --infodir=/usr/info --enable-shared --enable-bootstrap
--enable-languages=ada,c,c++,fortran,java,objc --enable-threads=posix
--enable-checking=release --with-system-zlib
--with-python-dir=/lib/python2.6/site-packages
--disable-libunwind-exceptions --enable-__cxa_atexit --enable-libssp
--with-gnu-ld --verbose --with-arch=i486 --target=i486-slackware-linux
--build=i486-slackware-linux --host=i486-slackware-linux
Thread model: posix
gcc version 4.5.1 (GCC)

as version:
GNU assembler (Linux/GNU Binutils) 2.20.51.0.11.20100810
Copyright 2010 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or later.
This program has absolutely no warranty.
This assembler was configured for a target of `i486-slackware-linux'.

I would be happy to submit a proper patch if I new this is actually the
correct fix, also there might be other places in the kernel source
suffering from this ??

Thanks,
  Jim Bos

