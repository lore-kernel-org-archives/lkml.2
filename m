Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1HWHQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:16:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1HWHQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:16:53 -0400
Date: Tue, 23 Aug 2011 09:16:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] apm-emulation: use wait_event_freezable() instead of
 freezer_[do_not_]count()
In-Reply-To: <20110818080653.GF13572@htj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1108230916370.13644@pobox.suse.cz>
References: <20110818080653.GF13572@htj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Tejun Heo wrote:

> vfork is moving away from freezer_[do_not_]count() one way or the
> other leaving apm_ioctl() as the only user.  apm_ioctl() just wants to
> wait for suspend/resume cycle to complete without hindering the
> freezer.  Use wait_event_freezable() instead.
> 
> The only annoyance is that wait_event_freezable() wakes up with
> -ERESTART if there are pending signals while apm_ioctl() wants to
> ignore all signals until suspend is complete.  We can play with
> @current->[real_]blocked but this is hardly a performance or latency
> critical path - simply chill a bit on each iteration until
> SUSPEND_DONE for unlikely cases where there are pending signals.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
> Compile tested only.  It would be great if someone w/ affected
> configuraiton can test this.
> 
> Thank you.
> 
>  drivers/char/apm-emulation.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> Index: work/drivers/char/apm-emulation.c
> ===================================================================
> --- work.orig/drivers/char/apm-emulation.c
> +++ work/drivers/char/apm-emulation.c
> @@ -300,17 +300,13 @@ apm_ioctl(struct file *filp, u_int cmd, 
>  			/*
>  			 * Wait for the suspend/resume to complete.  If there
>  			 * are pending acknowledges, we wait here for them.
> +			 * wait_event_freezable() is interruptible and pending
> +			 * signal can cause busy looping.  We aren't doing
> +			 * anything critical, chill a bit on each iteration.
>  			 */
> -			freezer_do_not_count();
> -
> -			wait_event(apm_suspend_waitqueue,
> -				   as->suspend_state == SUSPEND_DONE);
> -
> -			/*
> -			 * Since we are waiting until the suspend is done, the
> -			 * try_to_freeze() in freezer_count() will not trigger
> -			 */
> -			freezer_count();
> +			while (wait_event_freezable(apm_suspend_waitqueue,
> +					as->suspend_state == SUSPEND_DONE))
> +				msleep(10);
>  			break;
>  		case SUSPEND_ACKTO:
>  			as->suspend_result = -ETIMEDOUT;

Applied, thanks Tejun.

-- 
Jiri Kosina
SUSE Labs
