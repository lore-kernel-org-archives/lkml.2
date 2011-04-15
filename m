Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1DOIdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:33:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:40146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1DOIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:33:04 -0400
Date: Fri, 15 Apr 2011 10:33:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org
Subject: Re: [PATCH V5] futex: set FLAGS_HAS_TIMEOUT during futex_wait restart
 setup
In-Reply-To: <daac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1104151027260.2744@localhost6.localdomain6>
References: <daac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Darren Hart wrote:

> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> restart futex_wait() without a timeout after a signal.
> 
> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
> of the restart block. Restore the originaly behavior.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
> 
> V2: Added references to commit message.
> V3: Set flag during restart block instead of do_futex()
> V4: Correct stupid order of assignment mistake pointed out by Eric
> V5: Correct subject to match implementation, correct stable submission
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: Tim Smith <tsmith201104@yahoo.com>
> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: stable@kernel.org
> ---
>  kernel/futex.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index bda4157..abd5324 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1886,7 +1886,7 @@ retry:
>  	restart->futex.val = val;
>  	restart->futex.time = abs_time->tv64;
>  	restart->futex.bitset = bitset;
> -	restart->futex.flags = flags;
> +	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;

We only get here when a timeout is pending. So why don't we just do
the obvious:

--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1902,16 +1902,13 @@ out:
 static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = restart->futex.uaddr;
-	ktime_t t, *tp = NULL;
+	ktime_t t;
 
-	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
-		t.tv64 = restart->futex.time;
-		tp = &t;
-	}
+	t.tv64 = restart->futex.time;
 	restart->fn = do_no_restart_syscall;
 
 	return (long)futex_wait(uaddr, restart->futex.flags,
-				restart->futex.val, tp, restart->futex.bitset);
+				restart->futex.val, &t, restart->futex.bitset);
 }
 
Thanks,

	tglx
