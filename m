Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1CJLGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:06:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41662 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285Ab1CJLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:06:54 -0500
Date: Thu, 10 Mar 2011 11:06:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?TeFyaW8=?= Isidoro <marioisidoro@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH n_gsm] GSM Mux in non-transparent mode
Message-ID: <20110310110658.0a46d19d@lxorguk.ukuu.org.uk>
In-Reply-To: <1299724790.1800.135.camel@Paio>
References: <1299724790.1800.135.camel@Paio>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These alterations allow the usage of the non-transparent mode of the gsm
> mux, it works well enough to establish a ppp session using pppd. The
> increased buffer size allows the usage of the default MRU and MTU sizes
> in pppd.

In the tty like adaption layers the buffer size and PPP sizes are not
linked, because stuff is diced and packetised. Ok it's probably a
performance win. Really it needs network support for best results. There
is some prototype code for the network type ones but there are some
*horrid* and quite hard to fix races in it that need fixing before that
goes upstream

> There is a problem that happens if the process that is holding the
> attached line discipline tries to detach it before a process using a
> virtual com manages to close it. Both processes end up dealocked. I
> think this has to do with the tty lock. I don't have the backtrace with
> me

That one is a known recent breakage caused by Arnd's big kernel lock
removal. Needs looking at but it looks 'interesting' to fix.

>  	gsm->output(gsm, cbuf, len);
> -	gsm_print_packet("-->", addr, cr, control, NULL, 0);
> +	gsm_print_packet("->-", addr, cr, control, NULL, 0);

Why ? It's important not to put in gratuitious changes.

>  }
>  
>  /**
> @@ -999,22 +1023,25 @@ static void gsm_control_reply(struct gsm_mux
> *gsm, int cmd, u8 *data,
>  static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci
> *dlci,
>  							u32 modem)
>  {
> -	int  mlines = 0;
> +	int  mlines = dlci->modem_tx;
>  	u8 brk = modem >> 6;
>  
> +	modem = modem >> 1 ;
> +

This seems ot be a symptom of an earlier bug (see below) - plus if you
did that you'd need to fix the brk flag ?

>  	/* Flow control/ready to communicate */
>  	if (modem & MDM_FC) {
> +		pr_debug("Flux throttled\n");
>  		/* Need to throttle our output on this device */
>  		dlci->constipated = 1;
>  	}
>  	if (modem & MDM_RTC) {
> -		mlines |= TIOCM_DSR | TIOCM_DTR;
> +		mlines |= TIOCM_DSR ;
>  		dlci->constipated = 0;
>  		gsm_dlci_data_kick(dlci);
>  	}
>  	/* Map modem bits */
>  	if (modem & MDM_RTR)
> -		mlines |= TIOCM_RTS | TIOCM_CTS;
> +		mlines |= TIOCM_CTS;
>  	if (modem & MDM_IC)
>  		mlines |= TIOCM_RI;
>  	if (modem & MDM_DV)
> @@ -1068,18 +1095,25 @@ static void gsm_control_modem(struct gsm_mux
> *gsm, u8 *data, int clen)
>  		return;
>  	dlci = gsm->dlci[addr];
>  
> -	while (gsm_read_ea(&modem, *dp++) == 0) {
> -		len--;
> -		if (len == 0)
> -			return;
> +
> +	/* Signals frame comes with EA = 0 in GE863-PRO3*/
> +	if (len == 1) {
> +		modem = *dp ;

Probably worth checking the standard here. If not your workaround seems
reasonable but buggy - surely you need to shift the bits here not in the
modem processing where you otherwise overdo the shifts on the gsm_read_ea
path. In fact would it be better to simply be more robust and do

			if (len == 0)
				break;	/* No EA, try what we have*/

?

> +		while (gsm_read_ea(&modem, *dp++) == 0) {
> +			len--;
> +			if (len == 0)
> +				return;

>  	tty = tty_port_tty_get(&dlci->port);
>  	gsm_process_modem(tty, dlci, modem);
>  	if (tty) {
>  		tty_wakeup(tty);
>  		tty_kref_put(tty);
>  	}
> -	gsm_control_reply(gsm, CMD_MSC, data, clen);
> +	/*gsm_control_reply(gsm, CMD_MSC, data, clen);*/

We need to reply to control messages in all cases as far as I can see
from the specification ? Is there a reason for this tweak ?

> +		if (command == CMD_MSC) {
> +			/* Out of band modem line change indicator for a DLCI */
> +			gsm_control_modem(gsm, data, clen);
> +		}

Ah I see what you are trying to do with that - if we get a modem status
command we need to reply, if we get a response we need not to - but
doesn't the modem line handling have to be different in each case anyway ?

>  	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 1,
> -							gsm->ftype|PF);
> +							gsm->ftype/*|PF*/);

Correct - and recently committed fix.


>  	case UA:
>  	case UA|PF:
> -		if (cr == 0 || dlci == NULL)
> +		if (dlci == NULL)
>  			break;

A UA without C/R set is not valid, this change seems wrong ?

> +	/* At least Siemens/Cinterion and Telit modems require that the
> control
> +	   channel be open within 5 seconds of starting the cmux mode */
> +	gsm_dlci_begin_open(dlci);

Correct - which is easy to do from user space, however if we are being
run as the modem end (we do both) we cannot start sending SABM(P) messages
at this point as the user has no ability to specify which way they want
it.

The LDISC doesn't really use write so you've got a pass through after
setting the ldisc if need be, but 5 seconds to set an ldisc, and issue
two ioctls isn't hard even in perl...

> @@ -2583,8 +2632,18 @@ static int gsmtty_open(struct tty_struct *tty,
> struct file *filp)
>  	/* We could in theory open and close before we wait - eg if we get
>  	   a DM straight back. This is ok as that will have caused a hangup */
>  	set_bit(ASYNCB_INITIALIZED, &port->flags);
> +
> +	if (debug & 16)
> +		pr_debug("Request to open DLCI %d\n", dlci->addr);
> +
>  	/* Start sending off SABM messages */
>  	gsm_dlci_begin_open(dlci);
> +
> +	/* Wait for the modem to send a acknowledge to the open command */
> +	ret = wait_event_interruptible(gsm->event, dlci->state == DLCI_OPEN);
> +	if (ret < 0)
> +		return -ERESTARTSYS;

No - we don't want to do this, there are cases where waiting is bad, the
current code uses the modem responses of the other end to do open
completion management. Think about O_NDELAY and a failed modem, or think
about being the modem end.

> @@ -2661,9 +2725,12 @@ static int gsmtty_tiocmset(struct tty_struct
> *tty, struct file *filp,
>  	struct gsm_dlci *dlci = tty->driver_data;
>  	unsigned int modem_tx = dlci->modem_tx;
>  
> -	modem_tx &= clear;
> +	modem_tx &= ~clear;
>  	modem_tx |= set;

Eep

I think what would be a useful starting point would be to submit several
*small* patches that each fix one of the things you've touched

eg

- Allow for the missing EA
- Bracketing on the shifts (stylewise it does look clearer)
- TIOCMSET fix

then drop out the various random --> to ->- type changes and see what is
left that needs discussion, checking with the spec and submitting.

Alan
