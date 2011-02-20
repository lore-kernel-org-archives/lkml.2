Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1BTOOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 09:14:33 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36271 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1BTOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 09:14:31 -0500
Date: Sun, 20 Feb 2011 15:14:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Carpenter <error27@gmail.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch -next] x86, microcode, AMD: signedness bug in
 generic_load_microcode()
Message-ID: <20110220141452.GA12127@aftab>
References: <20110218091716.GA4384@bicker>
 <20110220130214.GD25700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110220130214.GD25700@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 08:02:14AM -0500, Ingo Molnar wrote:
> 
> * Dan Carpenter <error27@gmail.com> wrote:
> 
> > install_equiv_cpu_table() returns type int.  It uses negative error
> > codes so using an unsigned type breaks the error handling.
> 
> How did you notice this btw - did GCC throw a warning?

Was wondering about the same thing too, I didn't see any warning during
my testing. Can GCC even check whether return types of functions are
"compatible" when assigned to variables?

--
#include <stdio.h>

int f() {
        return 0xa5a5a5a5;
}

int main()
{

        char ret = f();

        printf("ret = 0x%016x\n", ret);

        return 0;
} 
--

doesn't cause a warning and prints a sign extended 0x00000000ffffffa5
which is cast to the return type of the function. If ret is an unsigned
char, then we return a 0x00000000000000a5.

I found something about it in the C99 standard¹, section "6.5.16.1 Simple
assignment":

4.  EXAMPLE 1       In the program fragment

           int f(void);
           char c;
           /* ... */
           if ((c = f()) == -1)
                    /* ... */

the int value returned by the function may be truncated when stored in
the char, and then converted back to int width prior to the comparison.
In an implementation in which ‘‘plain’’ char has the same range
of values as unsigned char (and char is narrower than int), the result
of the conversion cannot be negative, so the operands of the comparison
can never compare equal. Therefore, for full portability, the variable c
should be declared as int."

so the whole "... may be truncated.. " could mean a lot of things. From
my example above, gcc does truncate the int return type to a byte-sized
char only when they differ in signedness.

In the original case where we assign an int return type of a function
(smaller size) to an unsigned long (greater size), the first gets
converted to an unsigned long without a warning because the unsigned
long is large enough to contain the int and so it is assumed the user
knows what he/she's doing.

However, the unsigned long type is later checked for < 0 which could
never hit so I guess this could be warned for but I'm not sure whether
this would make sense in all cases.

Wait a minute, there _actually_ is a gcc '-Wconversion' option which is
_very_ noisy but does catch it:

arch/x86/kernel/microcode_amd.c: In function ‘generic_load_microcode’:
arch/x86/kernel/microcode_amd.c:255: warning: conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result

Come to think of it, it might make sense to be able to enable it when doing
debug builds as a way to do some more checking on your code when prepping
patches, maybe something like this:

make W=1 arch/x86/kernel/microcode_amd.o

which enables all gcc warnings for that specific file only so that
you could verify whether the warnings are valid and fix them if so.
Something similar to perf's EXTRA_WARNINGS.

Let me see whether this can be easily done...

Thanks.

¹ http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1336.pdf


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
