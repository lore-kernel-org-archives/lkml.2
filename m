Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1AFAD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:03:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab1AFADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:03:54 -0500
Date: Wed, 5 Jan 2011 14:57:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Change wait_for_completion_*_timeout to return a signed
 long
Message-Id: <20110105145725.3fa6d659.akpm@linux-foundation.org>
In-Reply-To: <20110105125016.64ccab0e@notabene.brown>
References: <20110105125016.64ccab0e@notabene.brown>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011 12:50:16 +1100
NeilBrown <neilb@suse.de> wrote:

> 
> wait_for_completion_*_timeout can return:
> 
>  0 if the wait timed out
>  -ve if the wait was interrupted
>  +ve if the completion was completed.
> 
> As they currently return an 'unsigned long', the last two cases are not
> easily distinguished which can easily result in buggy code, as is the
> case for the recently added wait_for_completion_interruptible_timeout
> call in net/sunrpc/cache.c
> 
> So change them both to return 'long'.  As MAX_SCHEDULE_TIMEOUT is
> LONG_MAX, a large +ve return value should never overflow.
> 
> ...
>
> --- a/include/linux/completion.h
> +++ b/include/linux/completion.h
> @@ -80,11 +80,11 @@ extern void wait_for_completion(struct completion *);
>  extern int wait_for_completion_interruptible(struct completion *x);
>  extern int wait_for_completion_killable(struct completion *x);
>  extern unsigned long wait_for_completion_timeout(struct completion *x,
>  						   unsigned long timeout);
> -extern unsigned long wait_for_completion_interruptible_timeout(
> -			struct completion *x, unsigned long timeout);
> -extern unsigned long wait_for_completion_killable_timeout(
> -			struct completion *x, unsigned long timeout);
> +extern long wait_for_completion_interruptible_timeout(
> +	struct completion *x, unsigned long timeout);
> +extern long wait_for_completion_killable_timeout(
> +	struct completion *x, unsigned long timeout);
>  extern bool try_wait_for_completion(struct completion *x);
>  extern bool completion_done(struct completion *x);
>  

That's a half-patch, isn't it?  wait_for_completion_interruptible()
still incorrectly returns `int' and wait_for_completion_timeout() still
returns `unsigned long'.

