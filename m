Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2LERTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:19:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53743 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2LERTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:19:30 -0500
Date: Wed, 5 Dec 2012 17:24:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 43/44] tty/metag_da: Add metag DA TTY driver
Message-ID: <20121205172446.41aa464e@pyramind.ukuu.org.uk>
In-Reply-To: <1354723742-6195-44-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
	<1354723742-6195-44-git-send-email-james.hogan@imgtec.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> +/* One struct dashtty exists per open channel. */
> +struct dashtty {
> +	struct tty_struct *tty;
> +	struct tty_port *port;
> +};

We have tty->port as of 3.7 so you shouldn't need this any more

> +
> +static struct tty_port dashtty_ports[NUM_TTY_CHANNELS];
> +
> +struct dashbuf {
> +	struct list_head entry;
> +	struct dashtty *tty;
> +	unsigned char *buf;
> +	int count;
> +	int chan;
> +};

> +/*
> + * Attempts to fetch count bytes from channel channel and returns actual count.
> + */
> +static int fetch_data(int channel)
> +{
> +	struct dashtty *dashtty = dashtty_ttys[channel];

krefs for the tty ?, what if the tty is closing at the same moment ?

> +
> +static int put_data(void *arg)
> +{
> +	struct dashbuf *dbuf;
> +	int number_written;
> +
> +	__set_current_state(TASK_RUNNING);
> +	while (!kthread_should_stop()) {
> +		/*
> +		 * Pick up all the output buffers and write them out.
> +		 *
> +		 * FIXME: should we check with ASE how much room we have?
> +		 * Ideally, this will already have been done by write_room ??
> +		 */


No because your writer is asynchronous to your query so you need to
manage the difference yourself. You also need to get it right on the
queue length for close to work right.

> +
> +/*
> + *	This gets called every DA_TTY_POLL and polls the channels for data
> + */
> +static void dashtty_timer(unsigned long ignored)
> +{
> +	struct dashtty *dtty;
> +	int this_channel;
> +
> +	/* If there are no ports open do nothing and don't poll again. */

Why are we polling - is this just an architectural limit ?

> +}
> +
> +static int dashtty_open(struct tty_struct *tty, struct file *filp)
> +{
> +	struct dashtty *dashtty;

No - use the full helpers - your sematics are wrong otherwise.

> +static void dashtty_close(struct tty_struct *tty, struct file *filp)

No.. we have helpers - use them.

> +	if (num_channels_need_poll <= 0)
> +		del_timer(&poll_timer);

_sync 

This seems to be a repeated error so it may be worth checking your other
drivers.
> +}
> +
> +static int dashtty_write(struct tty_struct *tty, const unsigned char *buf,
> +			 int count)
> +{
> +	struct dashtty *dtty;
> +	struct dashbuf *dbuf;
> +	int channel;
> +
> +	if (count <= 0)
> +		return 0;

How can it be <= 0 ?

> +	/* Determine the channel */
> +	channel = FIRST_TTY_CHANNEL + tty->index;
> +	dtty = dashtty_ttys[channel];
> +	BUG_ON(!dtty);

What is your locking model to prevent this ?
What is your reference counting model for the ttys - I don't see one.

> +
> +	dbuf = kzalloc(sizeof(*dbuf), GFP_KERNEL);
> +	if (!dbuf)
> +		return 0;
> +
> +	dbuf->buf = kzalloc(count, GFP_KERNEL);
> +	if (!dbuf->buf) {
> +		kfree(dbuf);
> +		return 0;
> +	}
> +
> +	memcpy(dbuf->buf, buf, count);

So you'll spend all your CPU time doing itty bitty allocations. Just
allocate a buffer at open (there's even a tty_port helper for buffer
management), free it when you've finished using the port. (and don't
report > the buffer size is write room)

> +	/*
> +	 * FIXME: This is slightly optimistic. Because we're deferring
> +	 * the output until later it is impossible to predict whether we
> +	 * will actually write "count" bytes.
> +	 */
> +	return count;

Fair enough but is then your chars_in_buffer and write_room methods are
both wrong (you need to avoid offering space you've queued into).

> +}

> +static const struct tty_operations dashtty_ops = {
> +	.open = dashtty_open,
> +	.close = dashtty_close,
> +	.write = dashtty_write,

You need a hangup method. You may need a termios method.

> +	.write_room = dashtty_write_room,
> +	.chars_in_buffer = dashtty_chars_in_buffer,
> +};
> +
> +static int __init dashtty_init(void)
> +{
> +	int ret;
> +	int nport;
> +
> +	if (!metag_da_enabled())
> +		return -ENODEV;
> +
> +	channel_driver = tty_alloc_driver(NUM_TTY_CHANNELS, 0);
> +	if (IS_ERR(channel_driver))
> +		return PTR_ERR(channel_driver);
> +
> +	channel_driver->owner = THIS_MODULE;
> +	channel_driver->driver_name = "ttyDA";
> +	channel_driver->name = "ttyDA";
> +	channel_driver->major = DA_TTY_MAJOR;
> +	channel_driver->minor_start = 0;
> +	channel_driver->type = TTY_DRIVER_TYPE_SERIAL;
> +	channel_driver->subtype = SERIAL_TYPE_NORMAL;
> +	channel_driver->init_termios = tty_std_termios;
> +	channel_driver->init_termios.c_cflag =
> +	    B38400 | CS8 | CREAD | HUPCL | CLOCAL;
> +	channel_driver->flags = TTY_DRIVER_REAL_RAW;

Need to set the speed flags

> +static void dashtty_exit(void)
> +{
> +	kthread_stop(dashtty_thread);
> +	del_timer(&poll_timer);


del_timer_sync or your box will sometimes crash on exit as the timer is
still running on another thread
