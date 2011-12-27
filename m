Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1L0HqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 02:46:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34744 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1L0HqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 02:46:19 -0500
Date: Tue, 27 Dec 2011 08:46:05 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] clock_gettime_ns and x86-64 optimizations
Message-ID: <20111227074605.GB2250@netboy.at.omicron.at>
References: <cover.1324831829.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 25, 2011 at 08:50:59AM -0800, Andy Lutomirski wrote:
> On x86-64, clock_gettime is so fast that the overhead converting to and
> from nanoseconds is non-negligible.  clock_gettime_ns is a different and
> faster interface.

But your data contradict this statement. See below.

> Patch 1 adds the syscall and wires it up on x86-64.  Patch 2 implements
> the corresponding vdso entry on x86-64.  Patch 3 optimizes the vdso
> call, and patch 4 is a trivial change that speeds up the vdso
> clock_gettime and clock_gettime_ns implementations.
> 
> The vdso timings are (on an 800MHz Sandy Bridge mobile):

It would be more informative to describe how you made the measurements
in more detail, for example, pseudo code, number of trials, min, max,
mean, std. dev.

> Basic implementation:
> 
> realtime 77.4ns
> monotonic 79.2ns
> realtime_coarse 18.1ns
> monotonic_coarse 22.0ns

In order to better understand what you are reporting, I arranged your
numbers into a table:

1. Basic implementation
2. Optimized implementation
3. Inlined (patch 4)

|---------------------+-------+-------+-------|
|                     |    1. |    2. |    3. |
|---------------------+-------+-------+-------|
| realtime            | 77.40 | 78.50 | 73.40 |
| realtime_ns         | 84.90 | 77.85 | 73.15 |
|---------------------+-------+-------+-------|
| monotonic           | 79.20 | 77.40 | 72.10 |
| monotonic_ns        | 85.10 | 77.75 | 72.10 |
|---------------------+-------+-------+-------|
| realtime_coarse     | 18.10 | 18.40 | 13.20 |
| realtime_coarse_ns  | 19.49 | 18.20 | 14.10 |
|---------------------+-------+-------+-------|
| monotonic_coarse    | 22.00 | 19.40 | 15.80 |
| monotonic_coarse_ns | 27.32 | 18.20 | 15.60 |
|---------------------+-------+-------+-------|

Looking down column 3, it appears that the _ns calls are no faster
than their plain counterparts.

So, while the inline patch does improve performance, the new _ns
functions do not really seem worth the trouble.

Thanks,
Richard


