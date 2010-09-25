Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0IYTSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 15:18:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57838 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0IYTSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 15:18:45 -0400
Date: Sat, 25 Sep 2010 20:18:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100925191836.GW19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 11:42:41AM -0700, Linus Torvalds wrote:
> Ok, so it's been absolutely ages since I touched the HAE stuff, but I
> think the logic was that interrupts will always restore HAE to the
> pre-interrupt state on exit, so reading it was always supposedly
> race-free and didn't need any protection from normal code.
> 
> But yes, any actual _changes_ to HAE had better protect against
> interrupts, so that they don't see the half-done state.
> 
> So yes, I think you found a bug.
> 
> I also don't see why that crazy RESTORE_ALL code does that reload of
> $0 and $1 when it updates HAE. Is that just legacy from it having
> _used_ to do the swipl PAL-call and that trashed those registers?

Looks like...  swpipl takes argument in $16 and returns value in $0;
trashes $1, $16, $22--$25.  Out of those, RESTORE_ALL deals with $22--$25
later in the sequence and $16 it handled by rti.

> Anyway, I think the fix should be that we really always do have
> interrupts disabled in RESTORE_ALL, rather than re-introduce the swipl
> into the RESTORE_ALL sequence. A lot of the critical sequences already
> do that - notably the normal return-to-user space code sequence that
> is the really critical one.

Agreed.  There are only two places that need change (return to kernel path
in ret_from_syscall and kernel_thread essentially jumping to the same path),
so I'll just add
ret_to_kernel:
        lda     $16, 7
        call_pal PAL_swpipl
	br	restore_all
and make these two places go to ret_to_kernel instead of restore_all.

BTW, another bug on alpha: coredump puts rdusp() result into regsets for
_all_ threads.  Should be ti->pcb.usp for everything except current, a-la
KSTK_ESP logics...

I'll send fixes shortly
