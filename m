Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab2JZPUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:20:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52079 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630Ab2JZPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:20:11 -0400
Date: Fri, 26 Oct 2012 08:20:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guillaume Juan <guillaume.juan@sagemcom.com>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: prevent crash due to dereferencing NULL gsm->tty
Message-ID: <20121026152052.GA15840@kroah.com>
References: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:11:45AM +0200, Guillaume Juan wrote:
> From: Guillaume Juan <guillaume.juan@sagemcom.com>
> 
> If gsm->tty happens to be NULL in gsmld_output, avoid crashing the kernel (the crash is replaced by a warning dump).

How can ->tty be NULL here?

> Prevent at earlier level such situation:
> - gsmtty_hangup does no longer call gsm_dlci_begin_close when called synchronously from gsm_cleanup_mux, because this would arm a timer that will asynchronously lead to use gms->tty, potentially after it is nullified.
> - in gsm_cleanup_mux, release DLCIs (other than DLCI#0 which is the control one) before closing mux. Else, it can happen that the T2 timer is rearmed by another thread scheduled between del_timer_sync and gsm_dlci release
> (for example by the following call-stack: fput => tty_release => tty_port_close_start => tty_port_lower_dtr_rts => gsm_dtr_rts => gsmtty_modem_update)

Please wrap your changelog comments at 72 columns.

> 
> Signed-off-by: Guillaume Juan <guillaume.juan@sagemcom.com>
> ---
>  drivers/tty/n_gsm.c |   35 ++++++++++++++++++++++++++---------
>  1 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 1e8e8ce..fe3c6ad 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -1510,8 +1510,8 @@ static void gsm_dlci_begin_open(struct gsm_dlci *dlci)
>  }
>  
>  /**
> - *	gsm_dlci_begin_close	-	start channel open procedure
> - *	@dlci: DLCI to open
> + *	gsm_dlci_begin_close	-	start channel close procedure
> + *	@dlci: DLCI to close
>   *
>   *	Commence closing a DLCI from the Linux side. We issue DISC messages
>   *	to the modem which should then reply with a UA, at which point we
> @@ -2031,6 +2031,13 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
>  	spin_unlock(&gsm_mux_lock);
>  	WARN_ON(i == MAX_MUX);
>  
> +	/* Free up any link layer users */
> +	if (dlci)
> +		dlci->dead = 1;
> +	for (i = 1; i < NUM_DLCI; i++)
> +		if (gsm->dlci[i])
> +			gsm_dlci_release(gsm->dlci[i]);
> +
>  	/* In theory disconnecting DLCI 0 is sufficient but for some
>  	   modems this is apparently not the case. */
>  	if (dlci) {
> @@ -2041,15 +2048,11 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
>  	del_timer_sync(&gsm->t2_timer);
>  	/* Now we are sure T2 has stopped */
>  	if (dlci) {
> -		dlci->dead = 1;
>  		gsm_dlci_begin_close(dlci);
>  		wait_event_interruptible(gsm->event,
>  					dlci->state == DLCI_CLOSED);
> +		gsm_dlci_release(dlci);
>  	}
> -	/* Free up any link layer users */
> -	for (i = 0; i < NUM_DLCI; i++)
> -		if (gsm->dlci[i])
> -			gsm_dlci_release(gsm->dlci[i]);
>  	/* Now wipe the queues */
>  	list_for_each_entry_safe(txq, ntxq, &gsm->tx_list, list)
>  		kfree(txq);
> @@ -2192,6 +2195,10 @@ EXPORT_SYMBOL_GPL(gsm_alloc_mux);
>  
>  static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
>  {
> +	if (gsm->tty == NULL) {
> +		WARN(1, "NULL gsm->tty pointer in gsmld_output\n");
> +		return -EINVAL;
> +	}
>  	if (tty_write_room(gsm->tty) < len) {
>  		set_bit(TTY_DO_WRITE_WAKEUP, &gsm->tty->flags);
>  		return -ENOSPC;
> @@ -2323,7 +2330,7 @@ static void gsmld_flush_buffer(struct tty_struct *tty)
>   *	@tty: device
>   *
>   *	Called from the terminal layer when this line discipline is
> - *	being shut down, either because of a close or becsuse of a
> + *	being shut down, either because of a close or because of a
>   *	discipline change. The function will not be called while other
>   *	ldisc methods are in progress.
>   */
> @@ -2954,6 +2961,15 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
>  	gsm = dlci->gsm;
>  	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
>  		goto out;
> +	/* Should not happen because the DLCI ttys are hung up (which causes
> +	   tty_port_close_start to return 0) by gsm_dlci_release before setting
> +	   gsm->tty to NULL */
> +	if (gsm->tty == NULL) {
> +		WARN(1, "NULL gsm->tty pointer in gsmtty_close for %s\n",
> +			tty->name);
> +		goto out;
> +	}
> +
>  	gsm_dlci_begin_close(dlci);
>  	tty_port_close_end(&dlci->port, tty);
>  	tty_port_tty_set(&dlci->port, NULL);
> @@ -2967,7 +2983,8 @@ static void gsmtty_hangup(struct tty_struct *tty)
>  {
>  	struct gsm_dlci *dlci = tty->driver_data;
>  	tty_port_hangup(&dlci->port);
> -	gsm_dlci_begin_close(dlci);
> +	if (!dlci->gsm->dead)
> +		gsm_dlci_begin_close(dlci);
>  }
>  
>  static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
> -- 
> 1.7.0.4
> 
> 
> 
> #
> " Ce courriel et les documents qui lui sont joints peuvent contenir des
> informations confidentielles ou ayant un caractère privé. S'ils ne vous sont
> pas destinés, nous vous signalons qu'il est strictement interdit de les
> divulguer, de les reproduire ou d'en utiliser de quelque manière que ce
> soit le contenu. Si ce message vous a été transmis par erreur, merci d'en
> informer l'expéditeur et de supprimer immédiatement de votre système
> informatique ce courriel ainsi que tous les documents qui y sont attachés."
> 
> 
>                                ******
> 
> " This e-mail and any attached documents may contain confidential or
> proprietary information. If you are not the intended recipient, you are
> notified that any dissemination, copying of this e-mail and any attachments
> thereto or use of their contents by any means whatsoever is strictly
> prohibited. If you have received this e-mail in error, please advise the
> sender immediately and delete this e-mail and all attached documents
> from your computer system."
> #

Because of that footer, I am not allowed to accept this patch at all.
Please remove it and resend.

thanks,

greg k-h
