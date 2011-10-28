Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab1J1UW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:22:29 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46726 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1J1UW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:22:28 -0400
Date: Fri, 28 Oct 2011 16:22:16 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Scott James Remnant <scott@netsplit.com>
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] coredump: wait on the core pattern umh at least once
Message-ID: <20111028202216.GA21504@hmsreliant.think-freely.org>
References: <1319832688-30336-1-git-send-email-scott@netsplit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319832688-30336-1-git-send-email-scott@netsplit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 01:11:28PM -0700, Scott James Remnant wrote:
> If a thread crashes as a result of a signal on the thread group leader
> that signal can still be pending, which means the loop in
> wait_for_dump_helpers() falls straight though.
> 
> This can mean that the crashing process is reaped before any core
> pattern user-mode helper is run, leaving it without entries in /proc
> to look through.
> 
> While the helper obviously has to deal with that, tweaking this loop
> so it runs at least one iteration even in that case helps a lot.
> 
> Signed-off-by: Scott James Remnant <scott@netsplit.com>
> ---
>  fs/exec.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 25dcbe5..8959d304 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2030,11 +2030,11 @@ static void wait_for_dump_helpers(struct file *file)
>  	pipe->readers++;
>  	pipe->writers--;
>  
> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	do {
>  		wake_up_interruptible_sync(&pipe->wait);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		pipe_wait(pipe);
> -	}
> +	} while ((pipe->readers > 1) && (!signal_pending(current)));
>  
>  	pipe->readers--;
>  	pipe->writers++;
> -- 
> 1.7.3.1
> 
> 
Seems reasonable to me.
Acked-by: Neil Horman <nhorman@tuxdriver.com>

