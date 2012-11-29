Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2K2BFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:05:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46813 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab2K2BFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:05:19 -0500
Date: Wed, 28 Nov 2012 17:05:16 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 13/25] aio: Convert read_events() to hrtimers
Message-ID: <20121129010516.GB15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-14-git-send-email-koverstreet@google.com>
 <20121129002436.GI18574@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129002436.GI18574@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 04:24:36PM -0800, Zach Brown wrote:
> > -	int			i = 0;
> > +	DEFINE_WAIT(wait);
> > +	struct hrtimer_sleeper t;
> > +	size_t i = 0;
> 
> Changing i to size_t is kind of surprising.  Is that on purpose?

I doubt it matters due to limits on ringbuffer size elsewhere but size_t
is more correct, since we're counting objects in an array.

> > -		set_task_state(tsk, TASK_RUNNING);
> > -		remove_wait_queue(&ctx->wait, &wait);
> > -
> >  		if (unlikely(ret <= 0))
> >  			break;
> >  
> > @@ -879,11 +844,10 @@ static int read_events(struct kioctx *ctx,
> >  		event ++;
> >  		i ++;
> >  	}
> > -
> > -	if (timeout)
> > -		clear_timeout(&to);
> >  out:
> > -	destroy_timer_on_stack(&to.timer);
> > +	hrtimer_cancel(&t.timer);
> > +	destroy_hrtimer_on_stack(&t.timer);
> > +	finish_wait(&ctx->wait, &wait);
> 
> I'd move the finish_wait() up to where TASK_RUNNING was set previously
> so that we can't call copy_to_user() while still set to
> TASK_INTERRUPTIBLE.

Slightly less efficient, but yeah that's more correct and this code all
changes later anyways.
