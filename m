Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2HaR4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:56:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64383 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HaR4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120831174119.GA6690@amos.fritz.box>
References: <20120831040500.GA6090@amos.fritz.box> <CA+55aFxuruMmrhgz9OGZcxyJ_tSp5rj9gSfxTYkjirSO7nvoxQ@mail.gmail.com>
 <20120831174119.GA6690@amos.fritz.box>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 31 Aug 2012 10:56:29 -0700
X-Google-Sender-Auth: R1T7Dk9Bj_qRZqjOzjXp9_rH3Mg
Message-ID: <CA+55aFx6aW66E=cLsa6oYUD=EaV_0v+=4auEy7b6pbaYMifKxA@mail.gmail.com>
Subject: Re: [REGRESSION] Xorg doesn't like 4e8b14526 "time: Improve sanity
 checking of timekeeping inputs"
To: Andreas Bombe <aeb@debian.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 10:41 AM, Andreas Bombe <aeb@debian.org> wrote:
>
> It triggers on ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX).
> Looking at some straces (I could have thought of that earlier…) X does
> in fact call select with unreasonable timeouts:
>
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 20000}) = 1 (in [24], left {0, 19988})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 19000}) = 1 (in [24], left {0, 18988})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 19000}) = 1 (in [24], left {0, 16804})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 16000}) = 1 (in [24], left {0, 15988})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 16000}) = 1 (in [9], left {0, 3649})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 3000}) = 1 (in [24], left {0, 2988})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 2000}) = 1 (in [24], left {0, 1988})
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {0, 2000}) = 0 (Timeout)
> | 17:46:55 select(256, [1 3 6 9 10 11 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39], NULL, NULL, {18446744073709551, 615000}) = -1 EINVAL (Invalid argument)

Ok, X clearly *is* doing something wrong, and as you point out, it
looks like X has taken a negative milliseconds value, treated it as
positive, and then done a (unsigned) divide by 1000 on that to create
a large positive seconds value.

It's a fairly "natural" error to make if you keep timeouts as
milliseconds, and then convert those to a timeval or timespec.

At the same time, that value is not really "invalid". It's a
crazy-long timeout, but it's a valid timeout. The fact that it doesn't
happen to fit into our "jiffies" value is an internal kernel
implementation issue that we shouldn't be exposing to user space as an
error. Turning the crazy-long timeout into "forever" (or
alternatively, into the longest timeout we support) should be the
right fix.

Andreas, can you check whether John Stultz patch works for you? It
looks like it should.

Also, letting the X people know that they are doing something crazy
sounds like a good idea. Looking at that strace, I'm also struct by
the fact that always giving "256" as the number of fds is going to be
a performance thing. It would be much better if X actually knew how
many bits it really needs, as that means the kernel isn't going to
need to look at the bits. So opening a bugzilla for this sounds like a
good idea.

               Linus
