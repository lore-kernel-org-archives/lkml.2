Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1C2S2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:28:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2S2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:28:48 -0400
Date: Tue, 29 Mar 2011 20:27:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 1/3] signal: Make signal_wake_up() take @sig_type
	instead of @resume
Message-ID: <20110329182741.GA9927@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329144603.GA29865@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Tejun Heo wrote:
>
> -void signal_wake_up(struct task_struct *t, int resume)
> +void signal_wake_up(struct task_struct *t, int sig_type)
>  {
> -	unsigned int mask;
> +	unsigned int uninitialized_var(mask);
>
>  	set_tsk_thread_flag(t, TIF_SIGPENDING);
> 
> -	/*
> -	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
> -	 * case. We don't check t->state here because there is a race with it
> -	 * executing another processor and just now entering stopped state.
> -	 * By using wake_up_state, we ensure the process will wake up and
> -	 * handle its death signal.
> -	 */
> -	mask = TASK_INTERRUPTIBLE;
> -	if (resume)
> -		mask |= TASK_WAKEKILL;
> +	switch (sig_type) {
> +	case 0:
> +		mask = TASK_INTERRUPTIBLE;
> +		break;
> +
> +	case SIGKILL:
> +		/*
> +		 * For SIGKILL, we want to wake it up in the stopped /
> +		 * traced / killable case.  We don't check t->state here
> +		 * because there is a race with it executing another
> +		 * processor and just now entering stopped state.  By using
> +		 * wake_up_state, we ensure the process will wake up and
> +		 * handle its death signal.
> +		 */
> +		mask |= TASK_INTERRUPTIBLE | TASK_WAKEKILL;
> +		break;

Interesting... Yes, I was thinking about changing signal_wake_up()
too, my intent was to pass TASK_* mask directly.

But your approach looks more clean. So, to me 1-2 look as the nice
cleanups in any case.

But let me think more about 3/3. I still think we do not want this.
But I need the fresh head to undestand what I actually have in mind.
Perhaps nothing, just the wrong feeling.

Oleg.

