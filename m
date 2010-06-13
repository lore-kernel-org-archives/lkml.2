Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0FMSUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 14:20:25 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:42343 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab0FMSUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 14:20:24 -0400
Message-ID: <4C152166.4070106@msgid.tls.msk.ru>
Date: Sun, 13 Jun 2010 22:20:22 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ollie Wild <aaw@google.com>
Subject: Re: personality(ADDR_LIMIT_3GB) results in EFAULT
References: <4BFEA911.40600@msgid.tls.msk.ru> <874oht197o.fsf@basil.nowhere.org>
In-Reply-To: <874oht197o.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[replying to somewhat old email...]

27.05.2010 22:38, Andi Kleen wrote:
> Michael Tokarev<mjt@tls.msk.ru>  writes:
>
>> I noticed an.. interesting issue here.
>>
>> Running a 32bit executable on a 64bit kernel,
>> and doing
>>
>>    personality(ADDR_LIMIT_3GB);
>>
>> That call succedes, but any further execve()
>> and friends results in EFAULT, unless whole
>> argv[] and envp[] are copied to a malloc'ed
>> space.  alloca sometimes helps and sometimes
>> not.
>
> It worked when I wrote it originally.
>
> Sounds like a regression, perhaps related to
> b6a2fea39318e43fee84fa7b0b90d68bed92d2ba

This is this commit:

commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
Author: Ollie Wild <aaw@google.com>
Date:   Thu Jul 19 01:48:16 2007 -0700

     mm: variable length argument support

     Remove the arg+env limit of MAX_ARG_PAGES by copying the strings directly from
     the old mm into the new mm.

     We create the new mm before the binfmt code runs, and place the new stack at
     the very top of the address space.  Once the binfmt code runs and figures out
     where the stack should be, we move it downwards.

     It is a bit peculiar in that we have one task with two mm's, one of which is
     inactive.

     [a.p.zijlstra@chello.nl: limit stack size]
     Signed-off-by: Ollie Wild <aaw@google.com>
     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     Cc: <linux-arch@vger.kernel.org>
     Cc: Hugh Dickins <hugh@veritas.com>
     [bunk@stusta.de: unexport bprm_mm_init]
     Signed-off-by: Adrian Bunk <bunk@stusta.de>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

(Author of this commit CC'ed).


Folks, I really need some advise here.

Right now I've a 64 wrapper executable to run the legacy
database (which we didn't finish migrating from yet, it's
always long process).  It sets the necessary personality
and executes the real binary.  But the problem is that after
a recompile (I added something else to it), the whole thing
stopped working on a machine with 4Gb memory: the execve()
call, now when made from 64bit binary, immediately fails
with EFAULT.  Before, this were happening only when the
wrapper is 32bit code (try `setarch i686 -3 any_32bit_exe' --
it will fail if setarch itself is 32bit executable).  Now
it fails from 64bits too, even just recompiling the old
.c code (with single personality() call in it) now results
in non-working thing - apparently due to some gcc diff.

Can we restore this personality thing, please?.. :)
I'm not good at all this code, so I need someone who is
able to understand what's going on.... ;)

Thanks!

/mjt
