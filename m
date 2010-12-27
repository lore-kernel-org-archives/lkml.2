Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0L0D5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 22:57:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0L0D5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 22:57:43 -0500
Date: Sun, 26 Dec 2010 20:57:56 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl and _get_icount functions
Message-ID: <20101226205756.78f4d21a@lembas.zaitcev.lan>
In-Reply-To: <342039.62488.qm@web65711.mail.ac4.yahoo.com>
References: <342039.62488.qm@web65711.mail.ac4.yahoo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Dec 2010 18:58:46 -0800 (PST)
Tsozik <tsozik@yahoo.com> wrote:

> Please let me know if there's anything else I need to correct before
> it can be rolled out,

I am hardly an expert here, but I looked it up as much as I could,
and this looks like a wrong way to do it:

> @@ -386,27 +396,41 @@ static int mct_u232_get_modem_stat(struc
>  	/* Translate Control Line states */
> +	if (msr & MCT_U232_MSR_DSR) {
>  		*control_state |=  TIOCM_DSR;
> +		icount->dsr++;
> +	} else {
>  		*control_state &= ~TIOCM_DSR;
> +	}

Unfortunately, Kerrisk's manpages do not seem to offer an authoritative
definition, but the expectations across the code seems that the counter
actually counts the changes. I know that some people talked about
counting "interrupts", but the way it's implemented in trustworthy
drivers suggests something like this:

	unsigned int old_ctl_state;

	old_ctl_state = *control_state;
	if (msr & MCT_U232_MSR_DSR)
		*control_state |=  TIOCM_DSR;
	else
		*control_state &= ~TIOCM_DSR;
	if (old_ctl_state != *control_state)
		icount->dsr++;
	...... repeat for all bits

E.g. for DSR going down too, although perhaps I'm not suggesting the
best way to do it. Could you re-implement it like the above and
check that your radiation counter works the same with it and
when driven by a built-in serial port?

Another thing, you should take priv->lock around fetching of
mct_u232_port->icount in mct_u232_ioctl. It seems superfluous,
I know, because the API itself is racy, but just to be nice
and doing the expected thing...

-- Pete
