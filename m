Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab1J2OR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 10:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565Ab1J2OR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 10:17:58 -0400
Date: Sat, 29 Oct 2011 16:13:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@netsplit.com>
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] coredump: wait on the core pattern umh at least once
Message-ID: <20111029141323.GA7036@redhat.com>
References: <1319832688-30336-1-git-send-email-scott@netsplit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319832688-30336-1-git-send-email-scott@netsplit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Scott James Remnant wrote:
>
> If a thread crashes as a result of a signal on the thread group leader
> that signal can still be pending,

No. do_coredump() clears TIF_SIGPENDING.

The problem is, this is obviously not enough and should be fixed.

> While the helper obviously has to deal with that, tweaking this loop
> so it runs at least one iteration even in that case helps a lot.

I don't understand this patch. It doesn't look right at all.

> @@ -2030,11 +2030,11 @@ static void wait_for_dump_helpers(struct file *file)
>  	pipe->readers++;
>  	pipe->writers--;
>
> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	do {
>  		wake_up_interruptible_sync(&pipe->wait);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		pipe_wait(pipe);

This can hang forever. We didn't check pipe->readers, it it is zero
nobody can wakeup us.

> +	} while ((pipe->readers > 1) && (!signal_pending(current)));

And, it doesn't make any sense to call pipe_wait() with signal_pending(),
it won't block. Note that pipe_wait() schedules in TASK_INTERRUPTIBLE.



I already tried to explain why this signal_pending() was added, but
apparently I was not clear. I'll try again in the previous thread.

Oleg.

