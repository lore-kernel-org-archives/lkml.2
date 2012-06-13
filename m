Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab2FMXo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:44:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33358 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2FMXo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:44:56 -0400
Date: Wed, 13 Jun 2012 16:44:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@linux.intel.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, rabin@rab.in
Subject: Re: [PATCH] vt: fix race in vt_waitactive()
Message-ID: <20120613234452.GA12764@kroah.com>
References: <20120518180628.GA27021@kroah.com>
 <1337587722-19809-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337587722-19809-1-git-send-email-rabin.vincent@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 01:38:42PM +0530, Rabin Vincent wrote:
> pm_restore_console() is called from the suspend/resume path, and this
> calls vt_move_to_console(), which calls vt_waitactive().
> 
> There's a race in this path which causes the process which requests the
> suspend to sleep indefinitely waiting for an event which already
> happened:
> 
> P1                                      P2
>  vt_move_to_console()
>   set_console()
>     schedule_console_callback()
>   vt_waitactive()
>     check n == fg_console +1
>                                        console_callback()
>                                          switch_screen()
>                                          vt_event_post() // no waiters
> 
>     vt_event_wait() // forever
> 
> Fix the race by ensuring we're registered for the event before we check
> if it's already completed.
> 
> Cc: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>  drivers/tty/vt/vt_ioctl.c |   47 ++++++++++++++++++++++++++++++++------------
>  1 files changed, 34 insertions(+), 13 deletions(-)

Alan, any thoughts on this patch?

thanks,

greg k-h

> 
> diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
> index ede2ef1..1d02e32 100644
> --- a/drivers/tty/vt/vt_ioctl.c
> +++ b/drivers/tty/vt/vt_ioctl.c
> @@ -110,16 +110,7 @@ void vt_event_post(unsigned int event, unsigned int old, unsigned int new)
>  		wake_up_interruptible(&vt_event_waitqueue);
>  }
>  
> -/**
> - *	vt_event_wait		-	wait for an event
> - *	@vw: our event
> - *
> - *	Waits for an event to occur which completes our vt_event_wait
> - *	structure. On return the structure has wv->done set to 1 for success
> - *	or 0 if some event such as a signal ended the wait.
> - */
> -
> -static void vt_event_wait(struct vt_event_wait *vw)
> +static void __vt_event_queue(struct vt_event_wait *vw)
>  {
>  	unsigned long flags;
>  	/* Prepare the event */
> @@ -129,8 +120,18 @@ static void vt_event_wait(struct vt_event_wait *vw)
>  	spin_lock_irqsave(&vt_event_lock, flags);
>  	list_add(&vw->list, &vt_events);
>  	spin_unlock_irqrestore(&vt_event_lock, flags);
> +}
> +
> +static void __vt_event_wait(struct vt_event_wait *vw)
> +{
>  	/* Wait for it to pass */
>  	wait_event_interruptible(vt_event_waitqueue, vw->done);
> +}
> +
> +static void __vt_event_dequeue(struct vt_event_wait *vw)
> +{
> +	unsigned long flags;
> +
>  	/* Dequeue it */
>  	spin_lock_irqsave(&vt_event_lock, flags);
>  	list_del(&vw->list);
> @@ -138,6 +139,22 @@ static void vt_event_wait(struct vt_event_wait *vw)
>  }
>  
>  /**
> + *	vt_event_wait		-	wait for an event
> + *	@vw: our event
> + *
> + *	Waits for an event to occur which completes our vt_event_wait
> + *	structure. On return the structure has wv->done set to 1 for success
> + *	or 0 if some event such as a signal ended the wait.
> + */
> +
> +static void vt_event_wait(struct vt_event_wait *vw)
> +{
> +	__vt_event_queue(vw);
> +	__vt_event_wait(vw);
> +	__vt_event_dequeue(vw);
> +}
> +
> +/**
>   *	vt_event_wait_ioctl	-	event ioctl handler
>   *	@arg: argument to ioctl
>   *
> @@ -177,10 +194,14 @@ int vt_waitactive(int n)
>  {
>  	struct vt_event_wait vw;
>  	do {
> -		if (n == fg_console + 1)
> -			break;
>  		vw.event.event = VT_EVENT_SWITCH;
> -		vt_event_wait(&vw);
> +		__vt_event_queue(&vw);
> +		if (n == fg_console + 1) {
> +			__vt_event_dequeue(&vw);
> +			break;
> +		}
> +		__vt_event_wait(&vw);
> +		__vt_event_dequeue(&vw);
>  		if (vw.done == 0)
>  			return -EINTR;
>  	} while (vw.event.newev != n);
> -- 
> 1.7.4.3
