Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab0FKVcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:32:17 -0400
Received: from t23.t-2.net ([84.255.209.102]:33092 "EHLO t23.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0FKVcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:32:16 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap> <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 11 Jun 2010 23:32:12 +0200
Message-Id: <1276291932.2154.45.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100611213213Z10334t23.t-2.net 1ONBpl-0002gg-Vk
X-SGG-RESULT: 20100611213213Z10334t23.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +#define	TPKRLEV	(('e'<<8) | 0) /* Wait for ttyprintk ratelimiting event*/
> > +static int tpk_ioctl(struct tty_struct *tty, struct file *file,
> > +			unsigned int cmd, unsigned long arg)
> > +{
> > +	struct ttyprintk_port *port;
> > +
> > +	port = tty->driver_data;
> > +
> > +	if (!port)
> > +		return -EINVAL;
> > +
> > +	switch (cmd) {
> > +	case TPKRLEV:
> > +		wait_event_interruptible(ttyprintk_ratelimit_wq,
> > +			(ttyprintk_ratelimit_event != 0));
> 
> Ok that wasn't quite what I had in mind. 
> 
> What I was thinking was needed was this
> 
> 	/* Stop TIOCCONS */
> 	case TIOCCONS:
> 		return -EOPNOTSUPP;
> 
> only it won't work that way. I'll sort that out in tty_io.c once the
> driver is happy. That way anything trying to mis-redirect the console
> will get stopped early which is probably more reliable than a ratelimit ?
> 
I'm thinking to leave the ratelimit support in for the time being. I had
in mind cases, when someone does
 "cat /proc/kmsg > dev/ttyprintk" or
suppose the console is redirected to ttyprintk (which i would like to be
able to do from user program) and then someone does:
 "cat /proc/kmsg > /dev/console"... or
if console is redirected after this command ?

Were you thinking of some other mis-redirection case?

Samo

