Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0DKOcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 10:32:24 -0400
Received: from www.tglx.de ([62.245.132.106]:45041 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0DKOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 10:32:23 -0400
Date: Sun, 11 Apr 2010 16:31:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
cc: linux-usb@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/8] fs/timerfd.c: make use of
 wait_event_interruptible_locked_irq()
In-Reply-To: <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
Message-ID: <alpine.LFD.2.00.1004111618000.32352@localhost.localdomain>
References: <cover.1270835924.git.mina86@mina86.com> <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com> <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Michal Nazarewicz wrote:

> This patch modifies the fs/timerfd.c to use the newly created
> wait_event_interruptible_locked_irq() macro.  This replaces an open
> code implementation with a single macro call.

And thereby breaks the code. :(

> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  fs/timerfd.c |   22 ++--------------------
>  1 files changed, 2 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 1bfc95a..4d2c371 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -109,31 +109,13 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
>  	struct timerfd_ctx *ctx = file->private_data;
>  	ssize_t res;
>  	u64 ticks = 0;
> -	DECLARE_WAITQUEUE(wait, current);
>  
>  	if (count < sizeof(ticks))
>  		return -EINVAL;
>  	spin_lock_irq(&ctx->wqh.lock);
>  	res = -EAGAIN;
> -	if (!ctx->ticks && !(file->f_flags & O_NONBLOCK)) {
> -		__add_wait_queue(&ctx->wqh, &wait);
> -		for (res = 0;;) {
> -			set_current_state(TASK_INTERRUPTIBLE);
> -			if (ctx->ticks) {
> -				res = 0;
> -				break;
> -			}
> -			if (signal_pending(current)) {
> -				res = -ERESTARTSYS;
> -				break;
> -			}
> -			spin_unlock_irq(&ctx->wqh.lock);
> -			schedule();
> -			spin_lock_irq(&ctx->wqh.lock);
> -		}
> -		__remove_wait_queue(&ctx->wqh, &wait);
> -		__set_current_state(TASK_RUNNING);
> -	}
> +	if (!(file->f_flags & O_NONBLOCK))
> +		wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);

With this change we return -EAGAIN instead of -ERESTARTSYS when the
wait got interrupted by a signal. That means instead of restarting the
syscall we return -EAGAIN to user space.

You need to return that information from wait_event.....().

Thanks,

	tglx
