Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0KINAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:00:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:34993 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0KINAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:00:18 -0500
Date: Tue, 9 Nov 2010 14:00:12 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Dave Korn <dave.korn.cygwin@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Richard Guenther <richard.guenther@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
In-Reply-To: <4CD843DC.10106@gmail.com>
Message-ID: <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
 <m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
 <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
 <877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 8 Nov 2010, Dave Korn wrote:

> void foo (void)
> {
>   int x, y, z;
>   x = 23;
>   asm ("do something" : "=r" (y) : "r" (x) );
>   z = y + 1;
> }

The case in i8k.c really is different.  It does use the value by 
influencing the return value and the callers use the returned value in 
conditionals and the like.  It really, really _is_ used :-) and if GCC 
removes the asm (which up to now is only speculation) then it's a GCC bug.

The code outlines like so:

int i8k_smm (regs) {
  int rc;
  asm (... : "=r"(rc) ...);
  if (rc != 0 || ...)
    return -EINVAL;
  return 0;
}

...
  struct regs regs = {.eax = ...}
  return i8k_smm(regs) ?: regs.eax;
...

My speculation is, that the asm is not removed but rather that regs.eax 
isn't reloaded after the asm because the memory clobber doesn't clobber 
automatic variables.


Ciao,
Michael.
