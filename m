Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1AGT2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:28:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab1AGT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:28:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Dario Faggioli <raistlin@linux.it>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        oleg <oleg@redhat.com>, john.stultz@linaro.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
In-Reply-To: Dario Faggioli's message of  Thursday, 23 December 2010 17:21:43 +0100 <1293121303.3390.185.camel@Palantir>
References: <1293121303.3390.185.camel@Palantir>
X-Shopping-List: (1) Vigilant confirmation holidays
   (2) Scratch 'n' Snot Eruption bogs
   (3) Automated cretinous aluminum
Message-Id: <20110107192809.05CFF40467@magilla.sf.frob.com>
Date: Fri,  7 Jan 2011 11:28:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock_getcpuclockid is the POSIX interface for using a process-wide CPU
clock.  pthread_getcpuclockid is the POSIX interface for using a
thread-specific CPU clock.  There is no POSIX interface for using the
thread-specific clock of a thread in a different process because POSIX does
not have the notion of global identification of threads at all.  The very
idea that you could know anything about an individual thread in a different
process is a Linuxism.  If you want to do something like that, then there
is no reason to use the POSIX standard interfaces rather than just using
the Linux-specific clockid_t generation macros in the first place.

When the CPU clock interfaces were introduced to the kernel, it was
considered a potential security issue (information leak) to be able to
access the thread clocks of another process, because there had never been a
way for one process to access such information from another process before.
We took the conservative route of permitting it only within the same
process.  

This can certainly be enhanced, but it opens some cans of worms about the
security question.  It is probably still considered an unsafe information
leak to let every process examine every other process's thread clocks.
I'll leave that judgement to security folks.  The intermediate route of
conversatism is to allow it only for processes owned by the same user,
which has some complexities with races between UID changes and clock/timer
calls.

As well as the information leak, it is most certainly a DoS attack vector
to allow one process to set CPU timers an another process or its threads.
Setting timers causes the timed thread itself to do work proportional to
the number of timers set.


Thanks,
Roland
