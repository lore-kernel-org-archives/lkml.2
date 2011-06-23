Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab1FWO0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:26:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab1FWO0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:26:39 -0400
Subject: Re: [PATCH] events: Ensure that timers are updated without
 requiring read() call
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric B Munson <emunson@mgebm.net>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com
In-Reply-To: <1308838537-6682-1-git-send-email-emunson@mgebm.net>
References: <1308838537-6682-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 16:25:50 +0200
Message-ID: <1308839150.1022.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 10:15 -0400, Eric B Munson wrote:
> The event tracing infrastructure exposes two timers which should be updated
> each time the value of the counter is updated.  Currently, these counters are
> only updated when userspace calls read() on the fd associated with an event.
> This means that counters which are read via the mmap'd page exclusively never
> have their timers updated.  This patch adds ensures that the timers are updated
> each time the values in the mmap'd page are updated.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
>  kernel/events/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9efe710..3dd4ebe 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3369,6 +3369,7 @@ void perf_event_update_userpage(struct perf_event *event)
>  	struct perf_buffer *buffer;
>  
>  	rcu_read_lock();
> +	update_event_times(event);
>  	buffer = rcu_dereference(event->buffer);
>  	if (!buffer)
>  		goto unlock;

Not that easy, perf_event_update_userpage() can happen from NMI context,
and update_event_times() needs to be done under ctx->lock.
