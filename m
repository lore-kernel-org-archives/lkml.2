Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241Ab0FKMgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:36:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42154 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760167Ab0FKMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:36:03 -0400
Date: Fri, 11 Jun 2010 13:44:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
In-Reply-To: <1276123020.16010.97.camel@itpsd6lap>
References: <1273918658.2341.17.camel@itpsd6lap>
	<1275171436.2122.29.camel@itpsd6lap>
	<20100529235402.296406d9@lxorguk.ukuu.org.uk>
	<1275175983.2122.42.camel@itpsd6lap>
	<1276123020.16010.97.camel@itpsd6lap>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +/*
> + * TTY operations open function.
> + */
> +static int tpk_open(struct tty_struct *tty, struct file *filp)
> +{
> +	struct ttyprintk_port *port = &tpk_port;

You can replace the rest with

	return tty_port_open(port, tty, filp);
}

> + * TTY operations close function.
> + */
> +static void tpk_close(struct tty_struct *tty, struct file *filp)
> +{
> +	struct ttyprintk_port *port = tty->driver_data;

and
	tty_port_close(port, tty, filp);

> +}

which saves a lot of work

> +
> +/*
> + * TTY operations write function.
> + */
> +int tpk_write(struct tty_struct *tty,
> +		const unsigned char *buf, int count)
> +{
> +	struct ttyprintk_port *port;
> +	int ret;
> +
> +	port = tty->driver_data;
> +
> +	if (!port)
> +		return 0;
> +
> +	if (!(port->port.flags & ASYNC_INITIALIZED))
> +		return 0;

These two can't happen if you use tty_port_* so it is better to blow up.
If you think you may be seeing it occur then use WARN_ON() or similar

> +
> +	/* exclusive use of tpk_printk within this tty */
> +	mutex_lock(&port->port_write_mutex);
> +	ret = tpk_printk(buf, count);
> +	mutex_unlock(&port->port_write_mutex);

And this is serialized by the caller (not that having your own lock is
any harm)


> +#define	TPKRLEV	(('e'<<8) | 0) /* Wait for ttyprintk ratelimiting event*/
> +static int tpk_ioctl(struct tty_struct *tty, struct file *file,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	struct ttyprintk_port *port;
> +
> +	port = tty->driver_data;
> +
> +	if (!port)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case TPKRLEV:
> +		wait_event_interruptible(ttyprintk_ratelimit_wq,
> +			(ttyprintk_ratelimit_event != 0));

Ok that wasn't quite what I had in mind. 

What I was thinking was needed was this

	/* Stop TIOCCONS */
	case TIOCCONS:
		return -EOPNOTSUPP;

only it won't work that way. I'll sort that out in tty_io.c once the
driver is happy. That way anything trying to mis-redirect the console
will get stopped early which is probably more reliable than a ratelimit ?


> +	memset(&tpk_port, 0, sizeof(tpk_port));

It's static so that isn't needed

> +	tty_port_init(&tpk_port.port);
> +	spin_lock_init(&tpk_port.lock);

The one other bit you will need to use the helpers is

struct tty_port_operations null_ops = { };

	tpk_port.port->ops = &null_ops;


Alan
