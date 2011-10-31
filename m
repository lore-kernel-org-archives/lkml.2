Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab1JaJ4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:56:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab1JaJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:56:00 -0400
Date: Mon, 31 Oct 2011 15:25:44 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] VirtioConsole support.
Message-ID: <20111031095544.GB3557@amit-x200.redhat.com>
References: <20111027173527.GA23839@phenom.dumpdata.com>
 <1319740793-2187-1-git-send-email-miche@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319740793-2187-1-git-send-email-miche@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 27 Oct 2011 [11:39:53], Miche Baker-Harvey wrote:
> Multiple HVC console terminals enabled.
> 
> Serialize device and port open and initialization.  Added a mutex
> which gates the handling of control messages in virtio_console.c.
> This includes adding and removing ports, and making opened ports be
> consoles.  Extended the use of the prvdata spinlock to cover some missed
> modifications to prvdata.next_vtermno.
> 
> I also added a mutex in hvc_console::hvc_alloc() to coordinate waiting
> for the driver to be ready, and for the one-time call to hvc_init().  It
> had been the case that this was sometimes being called mulitple times, and
> partially setup state was being used by the second caller of hvc_alloc().
> 
> Make separate struct console* for each new port.  There was a single static
> struct console* hvc_console, to be used for early printk.  We aren't doing
> early printk, but more importantly, there is no code to multiplex on that
> one console.  Multiple virtio_console ports were "sharing" this, which was
> disasterous since both the index and the flags for the console are stored
> there. The console struct is remembered in the hvc_struct, and it is
> deallocated when the hvc_struct is deallocated.
> 
> ------------------
> 
> Konrad, thanks for trying this out on Xen.
> This is working in my KVM environment, letting me start multiple
> virtio_consoles with getty's on them, but I'm really not sure how
> all the console pieces fit together yet.  Feedback is welcome.
> 
> Signed-off-by: Miche Baker-Harvey <miche@google.com>
> ---
>  drivers/char/virtio_console.c |   22 +++++++++++++++++++---
>  drivers/tty/hvc/hvc_console.c |   39 +++++++++++++++++++++++++++++++++------
>  drivers/tty/hvc/hvc_console.h |    1 +
>  3 files changed, 53 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index fb68b12..e819d46 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -24,6 +24,7 @@
>  #include <linux/fs.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
> +#include <linux/mutex.h>
>  #include <linux/poll.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -95,6 +96,11 @@ struct console {
>  	u32 vtermno;
>  };
>  
> +/* serialize the handling of control messages, which includes
> + * the initialization of the virtio_consoles.
> + */

Comments in this file are of the type

/*
 * ...
 */

(others below are fine.)

> +static DEFINE_MUTEX(virtio_console_mutex);
> +
>  struct port_buffer {
>  	char *buf;
>  
> @@ -979,8 +985,14 @@ int init_port_console(struct port *port)
>  	 * pointers.  The final argument is the output buffer size: we
>  	 * can do any size, so we put PAGE_SIZE here.
>  	 */
> -	port->cons.vtermno = pdrvdata.next_vtermno;
> +	spin_lock_irq(&pdrvdata_lock);
> +	port->cons.vtermno = pdrvdata.next_vtermno++;
> +	spin_unlock_irq(&pdrvdata_lock);

This needs to be decremented in case of an error below, or you just
need the locking around the existing usage.

>  
> +	/*
> +	 * xxx Use index 0 for now assuming there is no early HVC, since
> +	 * we don't support it.
> +	 */

correction: x86 doesn't have early HVC console support yet, but s390
(and likely ppc) use this today.

I think it's safe to use 0 for the early console, it's not likely we
have anything else using hvc consoles till this point.

>  	port->cons.hvc = hvc_alloc(port->cons.vtermno, 0, &hv_ops, PAGE_SIZE);
>  	if (IS_ERR(port->cons.hvc)) {
>  		ret = PTR_ERR(port->cons.hvc);
> @@ -990,7 +1002,6 @@ int init_port_console(struct port *port)
>  		return ret;
>  	}
>  	spin_lock_irq(&pdrvdata_lock);
> -	pdrvdata.next_vtermno++;
>  	list_add_tail(&port->cons.list, &pdrvdata.consoles);
>  	spin_unlock_irq(&pdrvdata_lock);
>  	port->guest_connected = true;
> @@ -1317,7 +1328,6 @@ static void handle_control_message(struct ports_device *portdev,
>  	int err;
>  
>  	cpkt = (struct virtio_console_control *)(buf->buf + buf->offset);
> -

unrelated, please drop.

>  	port = find_port_by_id(portdev, cpkt->id);
>  	if (!port && cpkt->event != VIRTIO_CONSOLE_PORT_ADD) {
>  		/* No valid header at start of buffer.  Drop it. */
> @@ -1326,6 +1336,11 @@ static void handle_control_message(struct ports_device *portdev,
>  		return;
>  	}
>  
> +	/*
> +	 * These are rare initialization-time events that should be
> +	 * serialized.
> +	 */
> +	mutex_lock(&virtio_console_mutex);
>  	switch (cpkt->event) {
>  	case VIRTIO_CONSOLE_PORT_ADD:
>  		if (port) {
> @@ -1429,6 +1444,7 @@ static void handle_control_message(struct ports_device *portdev,
>  		}
>  		break;
>  	}
> +	mutex_unlock(&virtio_console_mutex);

Not really rare init-time events; ports can be hot-plugged.

BTW what does serialising just these add events gain us?  I think if
this is necessary, the mutex might be necessary for other operations
too.

I'll leave the review of hvc_console bits to others.

Overall, I think you need to split this patch up into 3-4 parts, one
fixing the spinlock usage around next_vtermno above, another adding
the mutex, and the others dealing with hvc_console.c.

Thanks,
		Amit
