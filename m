Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0IYSnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:43:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab0IYSnF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <20100925181304.GV19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Sep 2010 11:42:41 -0700
Message-ID: <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 11:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        What happens if we get to RESTORE_ALL with interrupts enabled,
> find that we want to restore HAE, get to
>        stq     $21, HAE_CACHE($19);    \
> and get hit by an interrupt right after that assignment?

Ok, so it's been absolutely ages since I touched the HAE stuff, but I
think the logic was that interrupts will always restore HAE to the
pre-interrupt state on exit, so reading it was always supposedly
race-free and didn't need any protection from normal code.

But yes, any actual _changes_ to HAE had better protect against
interrupts, so that they don't see the half-done state.

So yes, I think you found a bug.

I also don't see why that crazy RESTORE_ALL code does that reload of
$0 and $1 when it updates HAE. Is that just legacy from it having
_used_ to do the swipl PAL-call and that trashed those registers?

Anyway, I think the fix should be that we really always do have
interrupts disabled in RESTORE_ALL, rather than re-introduce the swipl
into the RESTORE_ALL sequence. A lot of the critical sequences already
do that - notably the normal return-to-user space code sequence that
is the really critical one.

                                          Linus
