Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1J1M1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:27:10 -0400
Received: from mx11.lb01.inode.at ([62.99.145.13]:24351 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753397Ab1J1M1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:27:08 -0400
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 08:27:08 EDT
Message-ID: <4EAA9FD5.4070202@hale.at>
Date: Fri, 28 Oct 2011 14:28:05 +0200
From: Michael Thalmeier <michael.thalmeier@hale.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: rt <linux-rt-users@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Michael Thalmeier <michael@thalmeier.at>
Subject: Re: [PATCH] USB: g_serial: fix deadlock with PREEMPT_RT enabled
References: <1319804185-18559-1-git-send-email-michael.thalmeier@hale.at>
In-Reply-To: <1319804185-18559-1-git-send-email-michael.thalmeier@hale.at>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: p9SCR6qp031367
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1320409627.59221@muxiuHvd3eGDbs8vMe3/2w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-28 14:16, Michael Thalmeier wrote:

> In commit 44a0c0190b500ee6bcfc0976fe540f65dee2cd67 unlocking of spin_locks has
> been removed. This patch party restores this functionality.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
> ---
>  drivers/usb/gadget/u_serial.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index 40f7716..a925b9e 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -553,7 +553,16 @@ recycle:
>  	 * a workqueue, so we won't get callbacks and can hold port_lock
>  	 */
>  	if (tty && do_push) {
> +		/*
> +		 * Drop the lock here since it might end up calling
> +		 * gs_flush_chars, which takes the lock.
> +		 */
> +		spin_unlock_irq(&port->port_lock);
>  		tty_flip_buffer_push(tty);
> +		spin_lock_irq(&port->port_lock);
> +
> +		/* tty may have been closed */
> +		tty = port->port_tty;
>  	}
>  
>  

In the function tty_flip_buffer_push the PRREMPT_RT patch changes the
behaviour. Most serial drivers (those that don't set low_latency) assume
that work is only scheduled and not executed immediately in current context.
This patch only fixes this driver but other serial drivers likely have
similar problems.

Michael



--
Scanned by MailScanner.

