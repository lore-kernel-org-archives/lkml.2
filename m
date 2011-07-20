Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1GTSHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:07:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1GTSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:07:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=ETgDzFfkrARAZd7Eri8B8kjoAdcaHuy8GFkbE3/yYY1qxmW/j3w7uEYqUl3zpagyV
	0tSuzvJGbeLyCitZwIvgQ==
Date: Wed, 20 Jul 2011 11:06:55 -0700
From: Todd Poynor <toddpoynor@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Crash in schedule path after worker thread dies
Message-ID: <20110720180655.GA27115@google.com>
References: <20110720000738.GA18774@google.com>
 <20110720170717.GF9924@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720170717.GF9924@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On Wed, Jul 20, 2011 at 07:07:17PM +0200, Tejun Heo wrote:
> On Tue, Jul 19, 2011 at 05:07:38PM -0700, Todd Poynor wrote:
> > After a worker thread died due to a bug in a work function, a NULL
> > dereference was seen when schedule calls wq_worker_sleeping calls
> > kthread_data:
> > 
> >           return to_kthread(task)->data;
> > 
> > mm_release has apparently already set the task's vfork_done = NULL,
> > causing to_kthread to return a bad address (on 3.0-rc7 on ARM).
> > [...]
> 
> Hmmm... the scheduler code is oopsing after the worker already oopsed,
> escalating the failure mode, right?  Avoiding the scheduler oops can
> be done simply by clearing PF_WQ_WORKER in do_exit(); however, it
> would still leave workqueue code assuming the worker is busy running
> and may lead to workqueue stall.

Right, the worker oops took out that thread (don't know if
workqueue processing would have gracefully recovered if not for the
scheduler oops), but the scheduler oops was catastrophic.

> Cleaning that up would require more code but at that point it isn't
> really clear what we would be buying with the added complexity.
> Hmmm... maybe it would still be worthwhile to at least keep scheduler
> working.  Something like this?
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 6c7fbbe..412ead0 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -915,6 +915,7 @@ NORET_TYPE void do_exit(long code)
>  	 * kernel address.
>  	 */
>  	set_fs(USER_DS);
> +	tsk->flags &= ~PF_WQ_WORKER;
>  
>  	ptrace_event(PTRACE_EVENT_EXIT, code);

Sounds good to me, thanks!

Todd

>  
> -- 
> tejun
