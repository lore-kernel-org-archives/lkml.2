Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0KMLOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:14:14 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1814 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0KMLOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:14:12 -0500
Message-ID: <4CDE72F1.80008@xs4all.nl>
Date: Sat, 13 Nov 2010 12:13:53 +0100
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: [PATCH] i8k: Tell gcc that *regs gets clobbered
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>	<m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>	<877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com>	<Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>	<20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl>
In-Reply-To: <4CD97A3D.1040602@xs4all.nl>
Content-Type: multipart/mixed;
 boundary="------------090900080400020209060006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090900080400020209060006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



More recent GCC caused the i8k driver to stop working, on Slackware
compiler was upgraded from gcc-4.4.4 to gcc-4.5.1 after which it
didn't work anymore, meaning the driver didn't load or gave total
nonsensical output.
As it turned out the asm(..) statement forgot to mention it modifies
the *regs variable.
Credits to Andi Kleen <andi@firstfloor.org> and Andreas Schwab
<schwab@linux-m68k.org> for providing the fix.

Signed-off-by: Jim Bos <jim876@xs4all.nl>


--------------090900080400020209060006
Content-Type: text/plain;
 name="PATCH.i8k.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="PATCH.i8k.c"

--- linux-2.6.36/drivers/char/i8k.c.ORIG	2010-08-02 17:20:46.000000000 +0200
+++ linux-2.6.36/drivers/char/i8k.c	2010-11-13 11:35:11.000000000 +0100
@@ -141,7 +141,7 @@
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "+m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -166,7 +166,8 @@
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n"
+	    :"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif

--------------090900080400020209060006--
