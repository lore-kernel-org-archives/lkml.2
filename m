Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab0DPQK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:10:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:60936 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab0DPQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:10:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 16 Apr 2010 09:10:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] fs/timerfd.c: make use of
 wait_event_interruptible_locked_irq()
In-Reply-To: <7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com>
Message-ID: <alpine.DEB.2.00.1004160908510.16177@makko.or.mcafeemobile.com>
References: <cover.1271406290.git.mina86@mina86.com> <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com> <7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010, Michal Nazarewicz wrote:

> This patch modifies the fs/timerfd.c to use the newly created
> wait_event_interruptible_locked_irq() macro.  This replaces an open
> code implementation with a single macro call.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  fs/timerfd.c |   25 ++++---------------------
>  1 files changed, 4 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 98158de..b86ab8e 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -110,31 +110,14 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
>  	struct timerfd_ctx *ctx = file->private_data;
>  	ssize_t res;
>  	u64 ticks = 0;
> -	DECLARE_WAITQUEUE(wait, current);
>  
>  	if (count < sizeof(ticks))
>  		return -EINVAL;
>  	spin_lock_irq(&ctx->wqh.lock);
> -	res = -EAGAIN;
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
> +	if (file->f_flags & O_NONBLOCK)
> +		res = -EAGAIN;
> +	else
> +		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
>  	if (ctx->ticks) {
>  		ticks = ctx->ticks;
>  		if (ctx->expired && ctx->tintv.tv64) {

Looks clean to me.

Acked-By: Davide Libenzi <davidel@xmailserver.org>


- Davide


