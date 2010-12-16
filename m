Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0LPUuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:50:20 -0500
Received: from mail-bw0-f42.google.com ([209.85.214.42]:41647 "EHLO
	mail-bw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0LPUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:50:16 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 15:50:16 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZwoufP/XE807rj3r1ANerrrV30sEgtDlHyGvxwMwtAdvYMxLOQvVK0BKSIHZ4WLiIa
         trsgwrmq6QM+CAUpBSkckDmcFFO3qGn3+Pf5TEcQ/awuyA0Onjv7eKsRsgHxH1AQy00w
         ZlNbcq0S4zxi3Gt2DITrYZiCprIPLtAIMqn84=
Subject: Re: [patch] make pipes use event aware wakeups
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1012161228530.25094@davide-lnx1>
References: <alpine.DEB.2.00.1012161228530.25094@davide-lnx1>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 21:45:01 +0100
Message-ID: <1292532301.2655.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 16 décembre 2010 à 12:32 -0800, Davide Libenzi a écrit :
> I thought this was alreay merged, but this thread brought to my attention 
> it wasn't:
> 
> https://lkml.org/lkml/2010/12/15/234
> 
> This patch sends the events the wakeup refers to, so that epoll, and even 
> the new poll code in fs/select.c can avoid wakeups in events are not 
> matching the requested set.
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> ---
>  fs/pipe.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.mod/fs/pipe.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/pipe.c	2010-12-15 20:49:48.000000000 -0800
> +++ linux-2.6.mod/fs/pipe.c	2010-12-15 20:51:42.000000000 -0800
> @@ -441,7 +441,7 @@
>  			break;
>  		}
>  		if (do_wakeup) {
> -			wake_up_interruptible_sync(&pipe->wait);
> +			wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
>   			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>  		}
>  		pipe_wait(pipe);
> @@ -450,7 +450,7 @@
>  
>  	/* Signal writers asynchronously that there is more room. */
>  	if (do_wakeup) {
> -		wake_up_interruptible_sync(&pipe->wait);
> +		wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
>  		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>  	}
>  	if (ret > 0)
> @@ -612,7 +612,7 @@
>  			break;
>  		}
>  		if (do_wakeup) {
> -			wake_up_interruptible_sync(&pipe->wait);
> +			wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
>  			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  			do_wakeup = 0;
>  		}
> @@ -623,7 +623,7 @@
>  out:
>  	mutex_unlock(&inode->i_mutex);
>  	if (do_wakeup) {
> -		wake_up_interruptible_sync(&pipe->wait);
> +		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  	}
>  	if (ret > 0)
> @@ -715,7 +715,7 @@
>  	if (!pipe->readers && !pipe->writers) {
>  		free_pipe_info(inode);
>  	} else {
> -		wake_up_interruptible_sync(&pipe->wait);
> +		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLOUT);
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>  	}

Indeed ;)

I am not sure the last bit is needed, but it should not matter.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



