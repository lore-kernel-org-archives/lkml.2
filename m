Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1FIUHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:07:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab1FIUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:07:20 -0400
Date: Thu, 9 Jun 2011 13:06:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-Id: <20110609130617.f8aca966.akpm@linux-foundation.org>
In-Reply-To: <20110609131307.493181962@chello.nl>
References: <20110609130647.937204592@chello.nl>
	<20110609131307.493181962@chello.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jun 2011 15:06:48 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Release console_sem after unlocking the logbuf_lock so that we don't
> generate wakeups while holding logbuf_lock. This avoids some lock
> inversion troubles once we remove the lockdep_off bits between
> logbuf_lock and rq->lock (prints while holding rq->lock vs doing
> wakeups while holding logbuf_lock).
> 
> There's of course still an actual deadlock where the printk()s under
> rq->lock will issue a wakeup from the up() call.
> 
> ...
>
> @@ -1271,8 +1273,8 @@ void console_unlock(void)
>  	if (unlikely(exclusive_console))
>  		exclusive_console = NULL;
>  
> -	up(&console_sem);
>  	spin_unlock_irqrestore(&logbuf_lock, flags);
> +	up(&console_sem);
>  	if (wake_klogd)
>  		wake_up_klogd();
>  }

I have a horrible feeling that I put the up() inside logbuf_lock for
Special And Cunning Reasons.  But I'm struggling to work out what they
might have been and my archives only go back to October 2000(!).

Hate it when that happens.
