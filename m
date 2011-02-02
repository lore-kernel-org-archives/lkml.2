Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1BBJJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:09:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1BBJJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:09:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L2fbURzxhiks+XRMHGqUC3rdpcudX5L8y1sS8R339bgScFyzEZNgAqYCQvZ9GQrpMR
         TnXQ1CwQOsUPGeIBHvQ2iqu1BTKywUSwGVk/CTDVBbhdCDruYoRr3Qo5+Aa+t7rhgkZi
         DXjNtN9rNWZNNGnT6R0KyT5yLS23fhlfA28t0=
Date: Wed, 2 Feb 2011 10:09:22 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 12/28] posix-timers: Convert clock_gettime() to
 clockid_to_kclock()
Message-ID: <20110202090922.GD2747@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110201134418.611097203@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134418.611097203@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:51:50PM -0000, Thomas Gleixner wrote:
> --- linux-2.6-tip.orig/kernel/posix-timers.c
> +++ linux-2.6-tip/kernel/posix-timers.c

> @@ -956,18 +955,21 @@ SYSCALL_DEFINE2(clock_settime, const clo
>  SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
>  		struct timespec __user *,tp)
>  {
> +	struct k_clock *kc = clockid_to_kclock(which_clock);
>  	struct timespec kernel_tp;
>  	int error;
>  
> -	if (invalid_clockid(which_clock))
> +	if (!kc)
>  		return -EINVAL;
> -	error = CLOCK_DISPATCH(which_clock, clock_get,
> -			       (which_clock, &kernel_tp));
> +	if (!kc->clock_get)
> +		return -EOPNOTSUPP;

An unreadable clock?

I would think that we can require k_clocks to provide the read
function. This could be checked and enforced in register_posix_clock().

> +
> +	error = kc->clock_get(which_clock, &kernel_tp);
> +
>  	if (!error && copy_to_user(tp, &kernel_tp, sizeof (kernel_tp)))
>  		error = -EFAULT;
>  
>  	return error;
> -
>  }

Thanks,
Richard
