Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab1DLSdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:33:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55630 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319Ab1DLSdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cj6dqKaKUQZTz2Ii4JbzougDIcices8HXGdswVHbPopHnXB7A+PNENEQJp66ADsxKV
         7+Umqv63EJuyaiYvTnHblv7ADCWZQM3nHDS7y7oW0YsNKezTtJ/KfoEy4SL3UfGTa+W0
         IDKh/eYAxnUSwzEtdOg85xbenL/thGGIzkC3s=
Date: Wed, 13 Apr 2011 03:33:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] signal: sigprocmask() should do
 retarget_shared_pending()
Message-ID: <20110412183314.GA16342@mtj.dyndns.org>
References: <20110411171957.GA32469@redhat.com>
 <20110411172137.GE32469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411172137.GE32469@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Apr 11, 2011 at 07:21:37PM +0200, Oleg Nesterov wrote:
> --- sigprocmask/include/linux/signal.h~4_sigprocmask_retarget	2011-04-06 21:33:50.000000000 +0200
> +++ sigprocmask/include/linux/signal.h	2011-04-11 18:16:51.000000000 +0200
> @@ -126,10 +126,14 @@ _SIG_SET_BINOP(sigandsets, _sig_and)
>  #define _sig_nand(x,y)	((x) & ~(y))
>  _SIG_SET_BINOP(signandsets, _sig_nand)
>  
> +#define _sig_nor(x,y)	((x) | ~(y))
> +_SIG_SET_BINOP(signorsets, _sig_nor)
> +
>  #undef _SIG_SET_BINOP
>  #undef _sig_or
>  #undef _sig_and
>  #undef _sig_nand
> +#undef _sig_nor

I'm confused.  Isn't nand ^(A&B) and nor ^(A|B)?

>  #define _SIG_SET_OP(name, op)						\
>  static inline void name(sigset_t *set)					\
> --- sigprocmask/kernel/signal.c~4_sigprocmask_retarget	2011-04-10 21:57:42.000000000 +0200
> +++ sigprocmask/kernel/signal.c	2011-04-11 18:02:22.000000000 +0200
> @@ -2131,6 +2131,11 @@ int sigprocmask(int how, sigset_t *set, 
>  	}
>  
>  	spin_lock_irq(&tsk->sighand->siglock);
> +	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
> +		sigset_t not_newblocked;
> +		signorsets(&not_newblocked, &current->blocked, &newset);
> +		retarget_shared_pending(tsk, &not_newblocked);

I think it would be much easier to follow the logic if
retarget_shared_pending() took target mask instead of blocked
(ie. negation of blocked) and there were more comments.  Combined with
the confusing definition of nor, I had to spend quite some time trying
to wrap my head around it but the logic here isn't all that complex
and it should have been easier.

Other than that, I agree with the proposed changes, but I think we
really need to do retargeting (and the initial targeting too) more
efficiently as you noted in the earlier commit message.  Altering
signal mask is far hotter path than actual signal delivery.  Although
the thread walking code wouldn't get activated unless signal is
already pending, I still think we better avoid looping threads
unnecessarily.

Thanks.

-- 
tejun
