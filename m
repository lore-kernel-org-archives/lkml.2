Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab1DYLD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:03:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52420 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab1DYLD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dsGW5pA6AcJXJ6DVtcc2RThebZKJF+fe0eaKhyOefscaBtx/lKd0vFexjfoKiyKfMg
         usuD94j85La7wQ86xRDVWfv1vOI6UrLfIdgdGcWv6qcqgGOvcyu9XDkibZSKLTKmkofC
         Q5PgJTjFrpCyn4xcZrr4gNEAtAyanr7mVGy70=
Date: Mon, 25 Apr 2011 13:03:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] signal: retarget_shared_pending: optimize
 while_each_thread() loop
Message-ID: <20110425110321.GF17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134518.GD15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134518.GD15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

More nitpicks.

On Mon, Apr 18, 2011 at 03:45:18PM +0200, Oleg Nesterov wrote:
> --- sigprocmask/kernel/signal.c~3_optimize_retarget_loop	2011-04-17 21:08:05.000000000 +0200
> +++ sigprocmask/kernel/signal.c	2011-04-17 21:28:21.000000000 +0200
> @@ -2033,8 +2033,18 @@ static void retarget_shared_pending(stru
>  
>  	t = tsk;
>  	while_each_thread(tsk, t) {
> -		if (!signal_pending(t) && !(t->flags & PF_EXITING))
> -			recalc_sigpending_and_wake(t);
> +		if ((t->flags & PF_EXITING))

Inner () unnecessary.

> +			continue;
> +		if (!has_pending_signals(&shared_pending, &t->blocked))
> +			continue;
> +
> +		sigandsets(&shared_pending, &shared_pending, &t->blocked);
> +
> +		if (!signal_pending(t))
> +			signal_wake_up(t, 0);
> +
> +		if (sigisemptyset(&shared_pending))
> +			break;

More comments, please.  Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
