Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1FXJpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:45:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:55627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1FXJpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:45:11 -0400
Subject: Re: [PATCH 3/3] events: Ensure that timers are updated without
 requiring read() call
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric B Munson <emunson@mgebm.net>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com
In-Reply-To: <1308861279-15216-3-git-send-email-emunson@mgebm.net>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
	 <1308861279-15216-3-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jun 2011 11:44:16 +0200
Message-ID: <1308908656.27849.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 16:34 -0400, Eric B Munson wrote:
> The event tracing infrastructure exposes two timers which should be updated
> each time the value of the counter is updated.  Currently, these counters are
> only updated when userspace calls read() on the fd associated with an event.
> This means that counters which are read via the mmap'd page exclusively never
> have their timers updated.  This patch adds ensures that the timers are updated
> each time the values in the mmap'd page are updated.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
>  kernel/events/core.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9e9a7fa..e3be175 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3382,6 +3382,18 @@ void perf_event_update_userpage(struct perf_event *event)
>  	struct perf_buffer *buffer;
>  
>  	rcu_read_lock();
> +	/*
> +	 * compute total_time_enabled, total_time_running
> +	 * based on snapshot values taken when the event
> +	 * was last scheduled in.
> +	 *
> +	 * we cannot simply called update_context_time()
> +	 * because of locking issue as we are called in

s/are/can be/

> +	 * NMI context
> +	 */
> +	calc_timer_values(event,
> +				&event->total_time_enabled,
> +				&event->total_time_running);

I'm not sure writing those from NMI context is a sane thing to do, best
is to compute the values into a local variable and use that variable
below.

Took the first two patches.

>  	buffer = rcu_dereference(event->buffer);
>  	if (!buffer)
>  		goto unlock;

