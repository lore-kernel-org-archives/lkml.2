Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2HaRl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:41:28 -0400
Received: from infernal.debian.net ([176.28.9.132]:56149 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2HaRl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:41:27 -0400
Date: Fri, 31 Aug 2012 19:41:19 +0200
From: Andreas Bombe <aeb@debian.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION] Xorg doesn't like 4e8b14526 "time: Improve sanity
 checking of timekeeping inputs"
Message-ID: <20120831174119.GA6690@amos.fritz.box>
References: <20120831040500.GA6090@amos.fritz.box>
 <CA+55aFxuruMmrhgz9OGZcxyJ_tSp5rj9gSfxTYkjirSO7nvoxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxuruMmrhgz9OGZcxyJ_tSp5rj9gSfxTYkjirSO7nvoxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:25:52PM -0700, Linus Torvalds wrote:
> On Thu, Aug 30, 2012 at 9:05 PM, Andreas Bombe <aeb@debian.org> wrote:
> >
> > With that somewhat easy test I bisected it down to 4e8b14526 "time:
> > Improve sanity checking of timekeeping inputs". The latest Linus git
> > (155e36d40) with a revert of the bisected commit does not show the
> > problem.
> 
> Ok, I guess we need to revert it. Although it might be interesting to
> add a WARN_ON_ONCE() for the case of timespec_valid() returning false,
> to just see exactly *where* that thing triggers. Could you do that? In
> fact, do it with separate WARN_ON_ONCE's for each of the reasons that
> function returns false, so that we also see which check it is that
> triggers. Ok?

It triggers on ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX).
Looking at some straces (I could have thought of that earlier…) X does
in fact call select with unreasonable timeouts:

| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 20000}) = 1 (in [24], left {0, 19988})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 19000}) = 1 (in [24], left {0, 18988})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 19000}) = 1 (in [24], left {0, 16804})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 16000}) = 1 (in [24], left {0, 15988})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 16000}) = 1 (in [9], left {0, 3649})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 3000}) = 1 (in [24], left {0, 2988})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 2000}) = 1 (in [24], left {0, 1988})
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 2000}) = 0 (Timeout)
| 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {18446744073709551, 615000}) = -1 EINVAL (Invalid argument)

The time values are actually decreasing from 90 seconds to this. That
seconds value is actually (0ULL - 1) / 1000, so something is
decrementing the timeout beyond zero. I don't see how it could happen
directly in WaitForSomething in the X server sources[1], it's probably
in the BlockHandler callbacks somewhere.

Have to dig deeper to see if that is a long standing issue.

[1] http://cgit.freedesktop.org/xorg/xserver/tree/os/WaitFor.c?h=mpx&id=xorg-server-1.12.3.902#n145

-- 
Andreas Bombe
