Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3AJQDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:03:22 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55802 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3AJQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:03:19 -0500
Message-ID: <50EEE642.20608@suse.cz>
Date: Thu, 10 Jan 2013 17:03:14 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 43/44] tty/metag_da: Add metag DA TTY driver
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-44-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1357831872-29451-44-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, few comments/questions below.

On 01/10/2013 04:31 PM, James Hogan wrote:
> --- /dev/null
> +++ b/drivers/tty/metag_da.c
> @@ -0,0 +1,696 @@
...
> +struct dashtty_port {
> +	struct tty_port		 port;
> +	spinlock_t		 rx_lock;
> +	void			*rx_buf;
> +	struct mutex		 xmit_lock;
> +	unsigned int		 xmit_cnt;
> +	unsigned int		 xmit_head;
> +	unsigned int		 xmit_tail;
> +	struct completion	 xmit_empty;
> +};
> +
> +static struct dashtty_port dashtty_ports[NUM_TTY_CHANNELS];

> +static int chancall(int bios_function, int channel, int arg2, void *arg3,
> +			void *arg4)
> +{
> +	register int   bios_function__ __asm__("D1Ar1") = bios_function;
> +	register int   channel__       __asm__("D0Ar2") = channel;
> +	register int   arg2__          __asm__("D1Ar3") = arg2;
> +	register void *arg3__          __asm__("D0Ar4") = arg3;
> +	register void *arg4__          __asm__("D1Ar5") = arg4;
> +	register int   bios_call       __asm__("D0Ar6") = 3;
> +	register int   result          __asm__("D0Re0");

This is really ugly. Couldn't it be specified in the asm's constraints
below?

> +	__asm__ volatile (
> +		"SETL   [A0StP++], %6,%5\n\t"
> +		"SETL   [A0StP++], %4,%3\n\t"
> +		"SETL   [A0StP++], %2,%1\n\t"
> +		"ADD    A0StP, A0StP, #8\n\t"
> +		"SWITCH #0x0C30208\n\t"
> +		"GETD   %0, [A0StP+#-8]\n\t"
> +		"SUB    A0StP, A0StP, #(4*6)+8\n\t"
> +		: "=r" (result)/* outs */
> +		: "r" (bios_function__), "r" (channel__), "r" (arg2__),
> +		  "r" (arg3__), "r" (arg4__), "r" (bios_call) /* ins */
> +		: "memory");
> +
> +	return result;
> +}
...
> +static int dashtty_port_activate(struct tty_port *port, struct tty_struct *tty)
> +{
> +	struct dashtty_port *dport = container_of(port, struct dashtty_port,
> +						  port);
> +	void *rx_buf;
> +
> +	/* Allocate the buffer we use for writing data */
> +	if (tty_port_alloc_xmit_buf(port) < 0)
> +		goto err;
> +
> +	/* Allocate the buffer we use for reading data */
> +	rx_buf = kzalloc(RX_BUF_SIZE, GFP_KERNEL);
> +	if (!rx_buf)
> +		goto err_free_xmit;
> +
> +	spin_lock_bh(&dport->rx_lock);
> +	dport->rx_buf = rx_buf;
> +	spin_unlock_bh(&dport->rx_lock);
> +
> +	return 0;
> +err_free_xmit:
> +	tty_port_free_xmit_buf(port);
> +err:
> +	return -ENOMEM;
> +}
> +
> +static void dashtty_port_shutdown(struct tty_port *port)
> +{
> +	struct dashtty_port *dport = container_of(port, struct dashtty_port,
> +						  port);
> +	void *rx_buf;
> +	unsigned int count;
> +
> +	mutex_lock(&dport->xmit_lock);
> +	count = dport->xmit_cnt;
> +	mutex_unlock(&dport->xmit_lock);
> +	if (count) {
> +		/*
> +		 * There's still data to write out, so wake and wait for the
> +		 * writer thread to drain the buffer.
> +		 */
> +		del_timer(&put_timer);
> +		wake_up_interruptible(&dashtty_waitqueue);
> +		wait_for_completion(&dport->xmit_empty);
> +	}
> +
> +	/* Null the read buffer (timer could still be running!) */
> +	spin_lock_bh(&dport->rx_lock);
> +	rx_buf = dport->rx_buf;
> +	dport->rx_buf = NULL;
> +	spin_unlock_bh(&dport->rx_lock);
> +	/* Free the read buffer */
> +	kfree(rx_buf);
> +
> +	/* Free the write buffer */
> +	tty_port_free_xmit_buf(port);
> +}
> +
> +static const struct tty_port_operations dashtty_port_ops = {
> +	.activate	= dashtty_port_activate,
> +	.shutdown	= dashtty_port_shutdown,
> +};
> +
> +static int dashtty_install(struct tty_driver *driver, struct tty_struct *tty)
> +{
> +	struct dashtty_port *port;
> +	int ret, line;
> +
> +	if (!tty)
> +		return -ENODEV;

This will never happen.

> +	line = tty->index;
> +
> +	if (line < 0 || line >= NUM_TTY_CHANNELS)
> +		return -ENODEV;

Neither this.

> +	port = &dashtty_ports[line];
> +
> +	port->port.ops = &dashtty_port_ops;

You can do that along with tty_port_init in the module_init function.

> +	ret = tty_port_install(&port->port, driver, tty);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Don't add the poll timer if we're opening a console. This
> +	 * avoids the overhead of polling the Dash but means it is not
> +	 * possible to have a login on /dev/console.
> +	 *
> +	 */
> +	if (line != CONSOLE_CHANNEL)
> +		if (atomic_inc_return(&num_channels_need_poll) == 1)
> +			add_poll_timer(&poll_timer);

This should be in activate I suppose. You don't need install/cleanup at
all I beleive.

> +	return 0;
> +}
> +
> +static void dashtty_cleanup(struct tty_struct *tty)
> +{
> +	int line;
> +
> +	if (!tty)
> +		return;

The same as above.

> +	line = tty->index;
> +
> +	if (line < 0 || line >= NUM_TTY_CHANNELS)
> +		return;

Detto.

> +	if (line != CONSOLE_CHANNEL)
> +		if (atomic_dec_and_test(&num_channels_need_poll))
> +			del_timer_sync(&poll_timer);

To shutdown. No need for cleanup.

> +}
> +
> +static int dashtty_open(struct tty_struct *tty, struct file *filp)
> +{
> +	return tty_port_open(tty->port, tty, filp);
> +}
> +
> +static void dashtty_close(struct tty_struct *tty, struct file *filp)
> +{
> +	return tty_port_close(tty->port, tty, filp);
> +}
> +
> +static void dashtty_hangup(struct tty_struct *tty)
> +{
> +	int channel;
> +	struct dashtty_port *dport;
> +
> +	channel = FIRST_TTY_CHANNEL + tty->index;
> +	dport = &dashtty_ports[channel];
> +
> +	/* drop any data in the xmit buffer */
> +	mutex_lock(&dport->xmit_lock);
> +	if (dport->xmit_cnt) {
> +		atomic_sub(dport->xmit_cnt, &dashtty_xmit_cnt);
> +		dport->xmit_cnt = 0;
> +		dport->xmit_head = 0;
> +		dport->xmit_tail = 0;
> +		complete(&dport->xmit_empty);
> +	}
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	tty_port_hangup(tty->port);
> +}

Good.

> +static int dashtty_write_room(struct tty_struct *tty)
> +{
> +	struct dashtty_port *dport;
> +	int channel;
> +	int room;
> +
> +	channel = FIRST_TTY_CHANNEL + tty->index;

FIRST_TTY_CHANNEL doesn't make much sense. Better to be removed completely.

> +	dport = &dashtty_ports[channel];
> +
> +	/* report the space in the xmit buffer */
> +	mutex_lock(&dport->xmit_lock);
> +	room = SERIAL_XMIT_SIZE - dport->xmit_cnt;
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	return room;
> +}
...
> +static int __init dashtty_init(void)
> +{
> +	int ret;
> +	int nport;
> +	struct dashtty_port *dport;
> +
> +	if (!metag_da_enabled())
> +		return -ENODEV;
> +
> +	channel_driver = tty_alloc_driver(NUM_TTY_CHANNELS, 0);

This should be s/0/TTY_DRIVER_REAL_RAW/.

> +	if (IS_ERR(channel_driver))
> +		return PTR_ERR(channel_driver);
> +
> +	channel_driver->owner = THIS_MODULE;

No need to set this.

> +	channel_driver->driver_name = "ttyDA";

This should be rather "metag".

> +	channel_driver->name = "ttyDA";
> +	channel_driver->major = DA_TTY_MAJOR;
> +	channel_driver->minor_start = 0;
> +	channel_driver->type = TTY_DRIVER_TYPE_SERIAL;
> +	channel_driver->subtype = SERIAL_TYPE_NORMAL;
> +	channel_driver->init_termios = tty_std_termios;
> +	channel_driver->init_termios.c_cflag |= CLOCAL;
> +	channel_driver->flags = TTY_DRIVER_REAL_RAW;

And this is unnecessary now.

> +
> +	tty_set_operations(channel_driver, &dashtty_ops);
> +	for (nport = 0; nport < NUM_TTY_CHANNELS; nport++) {
> +		dport = &dashtty_ports[nport];
> +		tty_port_init(&dport->port);
> +		spin_lock_init(&dport->rx_lock);
> +		mutex_init(&dport->xmit_lock);
> +		/* the xmit buffer starts empty, i.e. completely written */
> +		init_completion(&dport->xmit_empty);
> +		complete(&dport->xmit_empty);
> +	}
> +
> +	init_timer(&put_timer);
> +	put_timer.function = dashtty_put_timer;

setup_timer()

> +	init_waitqueue_head(&dashtty_waitqueue);
> +	dashtty_thread = kthread_create(put_data, NULL, "ttyDA");
> +	if (IS_ERR(dashtty_thread)) {
> +		pr_err("Couldn't create dashtty thread\n");
> +		ret = PTR_ERR(dashtty_thread);
> +		goto err_free_driver;
> +	}
> +	kthread_bind(dashtty_thread, 0);

This deserves a comment why you bind it to CPU0...

> +	wake_up_process(dashtty_thread);
> +
> +	ret = tty_register_driver(channel_driver);
> +
> +	if (ret < 0) {
> +		pr_err("Couldn't install dashtty driver: err %d\n",
> +		       ret);
> +		goto err_stop_kthread;
> +	}
> +
> +	return 0;
> +
> +err_stop_kthread:
> +	kthread_stop(dashtty_thread);
> +err_free_driver:
> +	put_tty_driver(channel_driver);
> +	return ret;
> +}
> +
> +static void dashtty_exit(void)
> +{
> +	del_timer_sync(&put_timer);
> +	kthread_stop(dashtty_thread);
> +	del_timer_sync(&poll_timer);
> +	tty_unregister_driver(channel_driver);
> +	put_tty_driver(channel_driver);

No tty_port_destroy anywhere?

> +}
> +
> +module_init(dashtty_init);
> +module_exit(dashtty_exit);

thanks,
-- 
js
suse labs
