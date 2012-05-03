Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2ECJM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:12:57 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57163 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2ECJMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:12:55 -0400
Date: Thu, 3 May 2012 10:15:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: ipack: add support for IP-OCTAL mezzanine
 board
Message-ID: <20120503101513.2b2915ef@pyramind.ukuu.org.uk>
In-Reply-To: <1336031267-10689-4-git-send-email-siglesias@igalia.com>
References: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
	<1336031267-10689-4-git-send-email-siglesias@igalia.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 May 2012 09:47:47 +0200
Samuel Iglesias Gonsalvez <siglesias@igalia.com> wrote:

> IP-OCTAL is a 8-channels serial port device. There are several models one per
> each standard: RS-232, RS-422, RS-485.
> 
> This driver can manage all of them.

What are the plans for cleaning up this set of patches ?


> +int ipoctal_open(struct tty_struct *tty, struct file *file)
> +{
> +	int channel = tty->index;
> +	int res = 0;
> +	struct ipoctal *ipoctal;
> +
> +	ipoctal = ipoctal_find_board(tty);
> +
> +	if (ipoctal == NULL) {
> +		printk(KERN_ERR PFX "Device not found. Major %d\n", tty->driver->major);
> +		return -ENODEV;
> +	}
> +
> +	ipoctal->open[channel]++;
> +	if (ipoctal->open[channel] > 1)
> +		return -EBUSY;
> +
> +	/* Save struct tty_struct for later */
> +	ipoctal->tty[channel] = tty;
> +	memcpy(&ipoctal->oldtermios[channel], tty->termios, sizeof(struct ktermios));
> +	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
> +			CR_ENABLE_RX);
> +
> +	/* Save struct ipoctal to facilitate future operations */
> +	tty->driver_data = ipoctal;
> +	return res;

Your tty handlers need to be using the tty_port struct and tty_port
helpers. You also need krefs for the tty from things like IRQ handlers.

See
	tty_port_open/tty_port_close

and friends.

As we are currently moving to making tty_port mandatory, and the kref
handling is required I believe that should be fixed before it hits
staging or it's going to cause build problems and work for us.


> +void ipoctal_close(struct tty_struct *tty, struct file *filp)
> +{
> +	int channel = tty->index;
> +	struct ipoctal *ipoctal = tty->driver_data;
> +
> +	ipoctal->open[channel]--;
> +
> +	if (!ipoctal->open[channel]) {

You seem to have no locking on open[channel] counters so this looks
exploitable and quite bad.

> +		ipoctal_free_channel(tty);
> +		ipoctal->tty[channel] = NULL;
> +	}
> +}
> +
> +static int ipoctal_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
> +{
> +	void __user *user_arg = (void __user *)arg;
> +	struct ipoctal *ipoctal = tty->driver_data;
> +	int channel = tty->index;
> +	int res = -ENOIOCTLCMD;
> +
> +	if (ipoctal == NULL)
> +		return -ENODEV;
> +
> +	switch (cmd) {
> +	case TIOCGICOUNT:
> +	{
> +		struct serial_icounter_struct icount;
> +
> +		if (channel < 0) {
> +			res = channel;
> +			goto out_ioctl;
> +		}
> +
> +		/* Give the stats to the user */
> +		icount.cts = 0;
> +		icount.dsr = 0;
> +		icount.rng = 0;
> +		icount.dcd = 0;
> +		icount.rx = ipoctal->chan_stats[channel].rx;
> +		icount.tx = ipoctal->chan_stats[channel].tx;
> +		icount.frame = ipoctal->chan_stats[channel].framing_err;
> +		icount.parity = ipoctal->chan_stats[channel].parity_err;
> +		icount.brk = ipoctal->chan_stats[channel].rcv_break;
> +
> +		if (copy_to_user(user_arg, &icount, sizeof(icount))) {
> +			printk(KERN_ERR PFX "Slot [%d:%d] Channel %c :"
> +			       " Error during data copy to user space !\n",
> +			       ipoctal->dev->bus_nr,
> +			       ipoctal->dev->slot, channel);
> +			res = -EFAULT;
> +			goto out_ioctl;
> +		}

This won't actually work - we have a get_icount operation for the tty
these days which you need instead


> +			value = ipoctal_read_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.r.rhr);
> +			tty_insert_flip_char(ipoctal->tty[channel], value, TTY_NORMAL);
> +			tty_flip_buffer_push(ipoctal->tty[channel]);

You have no kref here to ensure the tty doesn't go away. You also don't
want to push each character.


> +static int ipoctal_write_tty(struct tty_struct *tty, const unsigned char *buf, int count)
> +{
> +	unsigned int channel = tty->index;
> +	struct ipoctal *ipoctal = tty->driver_data;
> +	int ret = 0;
> +
> +	if (mutex_lock_interruptible(&ipoctal->lock_write[channel]))
> +		return -ERESTARTSYS;
> +
> +	ret = ipoctal_write(ipoctal, channel, buf, count);
> +	mutex_unlock(&ipoctal->lock_write[channel]);

this can be called in IRQ context so a mutex won't do the trick, nor can
it wait.

> +int ipoctal_write_room(struct tty_struct *tty)
> +{
> +	int channel = tty->index;
> +	struct ipoctal *ipoctal = tty->driver_data;
> +
> +	return MAX_CHAR - ipoctal->nb_bytes[channel];
> +}

These are very small buffers. I guess it depends on the data rate of the
hardware but we've generally used dynamically allocated 4K buffers for
the tty drivers.


> +void ipoctal_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
> +{
> +	unsigned int cflag;
> +	unsigned char mr1 = 0;
> +	unsigned char mr2 = 0;
> +	unsigned char csr = 0;
> +	unsigned int channel = tty->index;
> +	struct ipoctal *ipoctal = tty->driver_data;
> +
> +	cflag = tty->termios->c_cflag;
> +
> +	if (old_termios) {
> +		if ((cflag == old_termios->c_cflag) &&
> +				(RELEVANT_IFLAG(tty->termios->c_iflag) ==
> +				 RELEVANT_IFLAG(old_termios->c_iflag)))
> +			return;

This breaks on speed changes where both speed sets are non standard (ie
BOTHER)

> +	}
> +
> +	/* Disable and reset everything before change the setup */
> +	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
> +			CR_DISABLE_RX | CR_DISABLE_TX);
> +	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
> +			CR_CMD_RESET_RX);
> +	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
> +			CR_CMD_RESET_TX);
> +	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
> +			CR_CMD_RESET_ERR_STATUS);
> +	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
> +			CR_CMD_RESET_MR);
> +
> +	/* Set Bits per chars */
> +	switch (cflag & CSIZE) {
> +	case CS6:
> +		mr1 |= MR1_CHRL_6_BITS;
> +		break;
> +	case CS7:
> +		mr1 |= MR1_CHRL_7_BITS;
> +		break;
> +	case CS8:
> +	default:
> +		mr1 |= MR1_CHRL_8_BITS;

Should set the actual termios c_flag to reflect the setting chosen if
it's not the one asked for ... ie CS5

> +		break;
> +	}
> +
> +	/* Set Parity */
> +	if (cflag & PARENB)
> +		if (cflag & PARODD)
> +			mr1 |= MR1_PARITY_ON | MR1_PARITY_ODD;
> +		else
> +			mr1 |= MR1_PARITY_ON | MR1_PARITY_EVEN;
> +	else
> +		mr1 |= MR1_PARITY_OFF;

And if you don't support mark/space that bit should also be cleared in
the termios struct if it is set in the request


> +	default:
> +		printk(KERN_INFO PFX
> +		       "Slot [%d:%d] Channel %d : illegal baud rate value: %d\n",
> +		       ipoctal->dev->bus_nr,
> +		       ipoctal->dev->slot,
> +		       channel,
> +		       tty_get_baud_rate(tty));
> +		return;

So any user can fill the logs with crud .. not a good idea.

What is expected is you pick a rate and you return that rate in the
tty->termios structure. It's up to the caller what they do about it.

tty_termios_encode_baudrate()


> +const struct tty_operations ipoctal_fops = {
> +	.ioctl =		ipoctal_ioctl,
> +	.open =			ipoctal_open,
> +	.close =		ipoctal_close,
> +	.write =		ipoctal_write_tty,
> +	.set_termios =		ipoctal_set_termios,
> +	.write_room =		ipoctal_write_room,
> +	.chars_in_buffer =	ipoctal_chars_in_buffer,
> +};

You ought to have a hangup method really - and if you are using tty_port
you'll get bit for free basically.



Can't really comment on the bus stuff, but the tty driver looks mostly
ok. It just needs a bit of modernising, and apart from that, and the
locking issue on write looks pretty good.


Alan
