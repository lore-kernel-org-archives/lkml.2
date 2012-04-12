Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab2DLXJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:09:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab2DLXJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:09:14 -0400
Date: Thu, 12 Apr 2012 16:09:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: handai.szj@gmail.com
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] eventfd: change int to __u64 in eventfd_signal()
Message-Id: <20120412160912.ee326702.akpm@linux-foundation.org>
In-Reply-To: <4f86a805.473f440a.2915.0cf3@mx.google.com>
References: <4f86a805.473f440a.2915.0cf3@mx.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 18:01:20 +0800
handai.szj@gmail.com wrote:

> From: Sha Zhengju <handai.szj@taobao.com>
> 
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> eventfd_ctx->count is an __u64 counter which is allowed to reach ULLONG_MAX.
> Now eventfd_write() add an __u64 value to "count", but kernel side 
> eventfd_signal() only add an int value to it. So make them consistent here.  
> 
> ...
>
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -51,7 +51,7 @@ struct eventfd_ctx {
>   *
>   * -EINVAL    : The value of @n is negative.
>   */
> -int eventfd_signal(struct eventfd_ctx *ctx, int n)
> +__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>  {
>  	unsigned long flags;
>  
> @@ -59,7 +59,7 @@ int eventfd_signal(struct eventfd_ctx *ctx, int n)
>  		return -EINVAL;
>  	spin_lock_irqsave(&ctx->wqh.lock, flags);
>  	if (ULLONG_MAX - ctx->count < n)
> -		n = (int) (ULLONG_MAX - ctx->count);
> +		n = ULLONG_MAX - ctx->count;
>  	ctx->count += n;
>  	if (waitqueue_active(&ctx->wqh))
>  		wake_up_locked_poll(&ctx->wqh, POLLIN);

Changing `n' to an unsigned type makes the "if (n < 0)" test a no-op.

Every in-kernel caller of eventfd_signal() passes n=1.  All of them. 
Perhaps we can just remove that argument and hard-wire the +1
assumption into eventfd_signal().

