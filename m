Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab2JKVSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:18:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2JKVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:18:47 -0400
Date: Thu, 11 Oct 2012 14:18:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qing Zhu <qzhu@marvell.com>
Cc: mingo@kernel.org, ben@decadent.org.uk, markivx@codeaurora.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, cxie4@marvell.com,
        binw@marvell.com, wwang27@marvell.com, njun@marvell.com
Subject: Re: [PATCH] panic: fix incomplete panic log in panic()
Message-Id: <20121011141845.1ed347df.akpm@linux-foundation.org>
In-Reply-To: <1349942587-16134-1-git-send-email-qzhu@marvell.com>
References: <1349942587-16134-1-git-send-email-qzhu@marvell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012 16:03:07 +0800
Qing Zhu <qzhu@marvell.com> wrote:

> Panic log should be printed on the console, but if someone lock the
> console when panic, console won't print out panic log.
> 
> The incomplete panic log issue will happen in below scenarios:
> 1. One task call console_lock(), then panic happend before it call
> console_unlock(). No panic log can be printed.
> 2. Cpu 0 call panic()->Cpu 1 call console_lock()->Cpu 0 call
> smp_send_stop()
> Cpu 1 will be stopped and can't unlock console,only top part of panic log
> will be printed.
> 
> So unlock console anyway in panic() to keep panic log printed.
> 
> Signed-off-by: Qing Zhu <qzhu@marvell.com>
> ---
>  kernel/panic.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index e1b2822..3924d25 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/nmi.h>
>  #include <linux/dmi.h>
> +#include <linux/console.h>
>  
>  #define PANIC_TIMER_STEP 100
>  #define PANIC_BLINK_SPD 18
> @@ -127,6 +128,13 @@ void panic(const char *fmt, ...)
>  
>  	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>  
> +	/*
> +	 * Unlock the console anyway here, in case it's occupied by another
> +	 * one which has no chance to unlock the console thus prevents the
> +	 * panic log prints on the console.
> +	 */
> +	console_unlock();
> +
>  	bust_spinlocks(0);
>  
>  	if (!panic_blink)

hm.  console_unlock() does a large amount of work, and it seems risky
to do all of that when the system is in a bad-and-getting-worse state.

Is there some more modest thing we could do here, for example,

	if (console_locked) {
		up(&console_sem);
		console_locked = 0;
	}

or something along those lines?

Also, perhaps this operation should be moved into bust_spinlocks(). 
What would have happened if your code had triggered an oops, rather
than called panic()?


