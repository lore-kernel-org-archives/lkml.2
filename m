Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1HWTxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:53:55 -0400
Received: from claw.goop.org ([74.207.240.146]:50729 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab1HWTxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:53:49 -0400
Message-ID: <4E540548.4080402@goop.org>
Date: Tue, 23 Aug 2011 12:53:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home>
In-Reply-To: <alpine.DEB.2.00.1108231355380.26421@router.home>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 12:01 PM, Christoph Lameter wrote:
> On Mon, 22 Aug 2011, Jeremy Fitzhardinge wrote:
>
>> Most callers of cmpxchg() direcly compare RETURN with OLD to see if it was
>> successful.  This results in unnecessary conditional comparisons
>> and conditionals since the cmpxchg instruction directly sets the flags
>> to indicate success/failure.
>> Add cmpxchg_flag() variants which return a boolean flag directly indicating
>> success.  Unfortunately an asm() statement can't directly export status
>> status flags, but sete isn't too bad.
> And so what happens through this patch is that a cmp with a value that is
> likely in a register is replaced by a sete. Is there really a benefit?

There's definitely a benefit for functions which return a bool resulting
from cmpxchg, which occurs in a few places.

> What I wish we would have is the actual use of the processor flag.
>
> if (cmpxchg_flags(....)) {
> }
>
> where the cmpxchg is followed immediately by a jump. I tried in the past
> to pass a goto label to cmpxchg but that did not work.

Yes, that would ideal.  The closest you can get is asm goto(), but the
syntax for that would be awful; something like:

#define cmpxchg_jump(ptr, old, new, fail)\
	asm goto (...)


:
:

again:
	old = *thingp;
	new = frobulate(old);
	cmpxchg_jump(thingp, old, new, again);
	/* worked */


Would this be useful enough?

Also, cmpxchg_flag() is limited to arch/x86; I hadn't looked into what
it would take to make it a generic part of the cmpxchg API for the rest
of the kernel.

    J
