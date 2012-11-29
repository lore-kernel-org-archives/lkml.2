Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945991Ab2K2AYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:24:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945929Ab2K2AYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:24:41 -0500
Date: Wed, 28 Nov 2012 16:24:36 -0800
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 13/25] aio: Convert read_events() to hrtimers
Message-ID: <20121129002436.GI18574@lenny.home.zabbo.net>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-14-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354121029-1376-14-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	int			i = 0;
> +	DEFINE_WAIT(wait);
> +	struct hrtimer_sleeper t;
> +	size_t i = 0;

Changing i to size_t is kind of surprising.  Is that on purpose?

> -		set_task_state(tsk, TASK_RUNNING);
> -		remove_wait_queue(&ctx->wait, &wait);
> -
>  		if (unlikely(ret <= 0))
>  			break;
>  
> @@ -879,11 +844,10 @@ static int read_events(struct kioctx *ctx,
>  		event ++;
>  		i ++;
>  	}
> -
> -	if (timeout)
> -		clear_timeout(&to);
>  out:
> -	destroy_timer_on_stack(&to.timer);
> +	hrtimer_cancel(&t.timer);
> +	destroy_hrtimer_on_stack(&t.timer);
> +	finish_wait(&ctx->wait, &wait);

I'd move the finish_wait() up to where TASK_RUNNING was set previously
so that we can't call copy_to_user() while still set to
TASK_INTERRUPTIBLE.

- z
