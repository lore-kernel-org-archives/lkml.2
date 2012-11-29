Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2K2AH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab2K2AH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:07:57 -0500
Date: Wed, 28 Nov 2012 16:07:53 -0800
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 07/25] aio: kiocb_cancel()
Message-ID: <20121129000753.GG18574@lenny.home.zabbo.net>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-8-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354121029-1376-8-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:43:31AM -0800, Kent Overstreet wrote:
> Minor refactoring, to get rid of some duplicated code

A minor nit:

>  	spin_lock_irq(&ctx->ctx_lock);
> -	ret = -EAGAIN;
> +
>  	kiocb = lookup_kiocb(ctx, iocb, key);
> -	if (kiocb && kiocb->ki_cancel) {
> -		cancel = kiocb->ki_cancel;
> -		kiocb->ki_users ++;
> -		kiocbSetCancelled(kiocb);
> -	} else
> -		cancel = NULL;
 ...
> -	if (NULL != cancel) {
> -	} else
> -		ret = -EINVAL;

In the old code it'd return -EINVAL for a NULL kiocb, despite that
misleading unused EAGAIN.

> +	if (kiocb)
> +		ret = kiocb_cancel(ctx, kiocb, &res);
> +	else
> +		ret = -EAGAIN;

But now it returns -EAGAIN.

I bet we want to err on the side of caution and maintain behaviour, no
matter how funky.

- z
