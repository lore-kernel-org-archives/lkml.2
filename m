Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0EQO3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:29:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0EQO3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:29:51 -0400
Date: Mon, 17 May 2010 16:31:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelyanov <xemul@openvz.org>, Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH 2/3] posix_timer: fix error path in timer_create
Message-ID: <20100517163138.5a9b93af@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1274103704-11230-2-git-send-email-avagin@openvz.org>
References: <1274103704-11230-1-git-send-email-avagin@openvz.org>
	<1274103704-11230-2-git-send-email-avagin@openvz.org>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 17:41:43 +0400
Andrey Vagin <avagin@openvz.org> wrote:

> move CLOCK_DISPATCH(which_clock, timer_create, (new_timer)) after all
> possible EFAULT errors.
> 
> *_timer_create may allocate/get resources.
> (for example posix_cpu_timer_create does get_task_struct)
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  kernel/posix-timers.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 5555e7c..8393624 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -555,14 +555,6 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>  		goto out;
>  	}
>  
> -	it_id_set = IT_ID_SET;
> -	new_timer->it_id = (timer_t) new_timer_id;
> -	new_timer->it_clock = which_clock;
> -	new_timer->it_overrun = -1;
> -	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
> -	if (error)
> -		goto out;
> -
>  	if (copy_to_user(created_timer_id,
>  			 &new_timer_id, sizeof (new_timer_id))) {
>  		error = -EFAULT;
> @@ -593,6 +585,14 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>  	new_timer->sigq->info.si_tid   = new_timer->it_id;
>  	new_timer->sigq->info.si_code  = SI_TIMER;
>  
> +	it_id_set = IT_ID_SET;
> +	new_timer->it_id = (timer_t) new_timer_id;

This part should not be moved, this make possible leak of idr entry .

> +	new_timer->it_clock = which_clock;
> +	new_timer->it_overrun = -1;

I'm not so convenient of moving this as well.

> +	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
> +	if (error)
> +		goto out;
> +
>  	spin_lock_irq(&current->sighand->siglock);
>  	new_timer->it_signal = current->signal;
>  	list_add(&new_timer->list, &current->signal->posix_timers);

Thanks
Stanislaw
