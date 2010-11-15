Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab0KOUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:22:43 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2481 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab0KOUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:22:42 -0500
Message-ID: <4CE1968D.3050706@xs4all.nl>
Date: Mon, 15 Nov 2010 21:22:37 +0100
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101106 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com> <4CE17C4B.1070305@xs4all.nl> <20101115185848.GI2583@sunsite.ms.mff.cuni.cz> <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
In-Reply-To: <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------040901080504060204070409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040901080504060204070409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/15/2010 08:51 PM, Jakub Jelinek wrote:
> On Mon, Nov 15, 2010 at 11:21:30AM -0800, Linus Torvalds wrote:
>> On Mon, Nov 15, 2010 at 11:12 AM, Jakub Jelinek <jakub@redhat.com> wrote:
>>>
>>> Ah, the problem is that memory_identifier_string is only initialized in
>>> ipa-reference.c's initialization, so it can be (and is in this case) NULL in
>>> ipa-pure-const.c.
>>
>> Ok. And I guess you can verify that all versions of gcc do this
>> correctly for "asm volatile"?
> 
> Yes, reading 4.1/4.2/4.3/4.4/4.5/4.6 code ipa-pure-const.c handles
> asm volatile correctly, in each case the function is no longer assumed to be
> pure or const in the discovery (of course, user can still say the
> function is const or pure). 4.0 and earlier didn't have ipa-pure-const.c.
> 
> Using the simplified
> 
> extern void abort (void);
> 
> __attribute__((noinline)) int
> foo (int *p)
> {
>   int r;
>   asm ("movl $6, (%1)\n\txorl %0, %0" : "=r" (r) : "r" (p) : "memory");
>   return r;
> }
> 
> int
> main (void)
> {
>   int p = 8;
>   if ((foo (&p) ? : p) != 6)
>     abort ();
>   return 0;
> }
> 
> testcase shows that in 4.1/4.2/4.3/4.4 this is miscompiled only when using
> -fno-ipa-reference, in 4.5 it is miscompiled always when optimizing
> unless -fno-ipa-pure-const (as 4.5 added local-pure-const pass which is run
> before ipa-reference) and in 4.6 this has been fixed by Honza when
> doing ipa cleanups.
> 
>> Because since we'll have to work around this problem in the kernel, I
>> suspect the simplest solution is to remove the "+m" that causes
>> register pressure problems, and then use "asm volatile" to work around
>> the const-function bug.
> 
> Yes.
> 
> 	Jakub
> 

Linus,

In case you didn't already fixed this, here's the follow-up patch.
---

The fix to work around the gcc miscompiling i8k.c to add "+m (*regs)"
caused register pressure problems. Changing the 'asm' statement to
'asm volatile' instead should prevent that and works around the gcc
bug as well.

Signed-off-by: Jim Bos <jim876@xs4all.nl>


--------------040901080504060204070409
Content-Type: text/plain;
 name="PATCH2.i8k.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="PATCH2.i8k.c"

--- linux/drivers/char/i8k.c.ORIG	2010-11-15 21:04:19.000000000 +0100
+++ linux/drivers/char/i8k.c	2010-11-15 21:02:32.000000000 +0100
@@ -119,7 +119,7 @@
 	int eax = regs->eax;
 
 #if defined(CONFIG_X86_64)
-	asm("pushq %%rax\n\t"
+	asm volatile("pushq %%rax\n\t"
 		"movl 0(%%rax),%%edx\n\t"
 		"pushq %%rdx\n\t"
 		"movl 4(%%rax),%%ebx\n\t"
@@ -141,11 +141,11 @@
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc), "+m" (*regs)
+		:"=a"(rc)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
-	asm("pushl %%eax\n\t"
+	asm volatile("pushl %%eax\n\t"
 	    "movl 0(%%eax),%%edx\n\t"
 	    "push %%edx\n\t"
 	    "movl 4(%%eax),%%ebx\n\t"
@@ -167,7 +167,7 @@
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
 	    "andl $1,%%eax\n"
-	    :"=a"(rc), "+m" (*regs)
+	    :"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif

--------------040901080504060204070409--
