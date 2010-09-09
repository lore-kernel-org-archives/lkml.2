Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0IIKtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 06:49:43 -0400
Received: from www.tglx.de ([62.245.132.106]:54159 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0IIKtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 06:49:41 -0400
Date: Thu, 9 Sep 2010 12:49:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] posix clocks: introduce a syscall for clock
 tuning.
In-Reply-To: <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1009091159260.2477@localhost6.localdomain6>
References: <cover.1283504065.git.richard.cochran@omicron.at> <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Richard Cochran wrote:

This patch needs to be split in pieces. The syscall change is totally
unrelated to the dynamic clock id creation. Though I do not like
either of them. :)

> A new syscall is introduced that allows tuning of a POSIX clock. The
> syscall is implemented for four architectures: arm, blackfin, powerpc,
> and x86.
> 
> The new syscall, clock_adjtime, takes two parameters, the clock ID,
> and a pointer to a struct timex. The semantics of the timex struct
> have been expanded by one additional mode flag, which allows an
> absolute offset correction. When specificied, the clock offset is
> immediately corrected by skipping to the new time value.

And why do we need a separate syscall for this?

> In addition, the POSIX clock code has been augmented to offer a
> dynamic clock creation method. Instead of registering a hard
> coded clock ID, modules may call create_posix_clock(), which
> returns a new clock ID.

This has been discussed for years and I still fail to see the
requirement for this. The only result is that it allows folks to
create their special purpose clock stuff and keep it out of tree
instead of fixing the problems they have with the existing clock
infrastructure in the kernel.

As far as I understood from the previous discussions, the final goal
is to provide PTP support, right?

But what I see is an approach which tries to implement disconnected
special purpose clocks which have the ability to be adjusted
independently. What's the purpose of this ? Why can't we just use the
existing clocks and make PTP work on them ?

I know that lots of embedded folks think that they need their special
timers and extra magic to make stuff work, but that's the wrong
approach.

What's wrong with the existing clocks? Nothing, except that we have no
way to sync CLOCK_MONOTONIC across several machines. And that's what
you really want if you try to do distributed control and data
acquisition stuff.

That's a single CLOCK_MONOTONIC_GLOBAL and not a bunch of completely
disconnected clock implementations with random clock ids and random
feature sets.

Thoughts ?


	 tglx
