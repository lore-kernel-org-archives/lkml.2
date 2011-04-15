Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1DOJ16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:27:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52172 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1DOJ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wUDVdcQHeM4G+mdS4w6blN5ov1fsUJYyaao8kLTqMy+PCTeI9xwaETWN9lqVtlxngu
         IyU4fGMo6zKAFzIdwy1s7y95P9xYeUgGZQ5vxILy4ww8JtlKBjFvpjL+ZhcLXOLdnmHp
         s1sur4eHR1YqIdREH19IOsmMR23TE3B88ZVCA=
Subject: Re: [PATCH V5] futex: set FLAGS_HAS_TIMEOUT during futex_wait
 restart setup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org
In-Reply-To: <alpine.LFD.2.00.1104151027260.2744@localhost6.localdomain6>
References: <daac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart@linux.intel.com>
	 <alpine.LFD.2.00.1104151027260.2744@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 11:27:51 +0200
Message-ID: <1302859671.5374.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 15 avril 2011 à 10:33 +0200, Thomas Gleixner a écrit :
> On Thu, 14 Apr 2011, Darren Hart wrote:
> 
> > The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> > restart futex_wait() without a timeout after a signal.
> > 
> > Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
> > removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
> > of the restart block. Restore the originaly behavior.
> > 
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
> > 
> > V2: Added references to commit message.
> > V3: Set flag during restart block instead of do_futex()
> > V4: Correct stupid order of assignment mistake pointed out by Eric
> > V5: Correct subject to match implementation, correct stable submission
> > 
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Reported-by: Tim Smith <tsmith201104@yahoo.com>
> > Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: John Kacur <jkacur@redhat.com>
> > Cc: stable@kernel.org
> > ---
> >  kernel/futex.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index bda4157..abd5324 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -1886,7 +1886,7 @@ retry:
> >  	restart->futex.val = val;
> >  	restart->futex.time = abs_time->tv64;
> >  	restart->futex.bitset = bitset;
> > -	restart->futex.flags = flags;
> > +	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
> 
> We only get here when a timeout is pending. So why don't we just do
> the obvious:
> 
> --- linux-2.6.orig/kernel/futex.c
> +++ linux-2.6/kernel/futex.c
> @@ -1902,16 +1902,13 @@ out:
>  static long futex_wait_restart(struct restart_block *restart)
>  {
>  	u32 __user *uaddr = restart->futex.uaddr;
> -	ktime_t t, *tp = NULL;
> +	ktime_t t;
>  
> -	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
> -		t.tv64 = restart->futex.time;
> -		tp = &t;
> -	}
> +	t.tv64 = restart->futex.time;
>  	restart->fn = do_no_restart_syscall;
>  
>  	return (long)futex_wait(uaddr, restart->futex.flags,
> -				restart->futex.val, tp, restart->futex.bitset);
> +				restart->futex.val, &t, restart->futex.bitset);
>  }
>  

Because its not suitable for stable ?

This is basically reverting a72188d8a64ebe74, so why do you keep
FUTEX_HAS_TIMEOUT definition ?



