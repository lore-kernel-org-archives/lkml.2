Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0E2WqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 18:46:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52251 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756984Ab0E2WqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 18:46:10 -0400
Date: Sat, 29 May 2010 23:54:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] detour TTY driver
Message-ID: <20100529235402.296406d9@lxorguk.ukuu.org.uk>
In-Reply-To: <1275171436.2122.29.camel@itpsd6lap>
References: <1273918658.2341.17.camel@itpsd6lap>
	<1275171436.2122.29.camel@itpsd6lap>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Randy, Alan: Would you be so kind to comment on usability and
> acceptability of this tty driver approach? Thanks.

Not sure the naming is ideal (detour what where, simply calling it
'/dev/ttyprintk' might be clearer - but this is detail

> +void set_console_detour(void)
> +{
> +	console_detour = 1;
> +}
> +EXPORT_SYMBOL(set_console_detour);

module parameters can be set compiled in with modulename.option=foo so
there are easier ways to do that.

> + * Our simple preformatting:
> + * - every cr is replaced by '^'nl combination
> + * - every non cr or nl ended write is padded with '\'nl combination
> + * - adds a detour source tag in front of each line

This seems to make it more ambiguous


> +/*
> + *	Dummy tty ops open for succesfull terminal device open.
> + */
> +static int dty_open(struct tty_struct *tty, struct file *filp)
> +{
> +	return 0;

The kernel really expects posix behaviour but I'm not sure how much it
really matters in this case. Fixing that isn't hard though (use tty_port
helpers and basically no supporting functions)


> +	/* register our fops write function */
> +	tty_default_fops(&detour_fops);
> +	detour_fops.write = detour_write;

No. The behaviour of a tty is very precisely defined by the standards and
stomping over things you shouldn't is not good at all. Remember your tty
sets its own initial termios settings so you can set those to give the
initial behaviour you want. You need the tty layer here in your case
anyway as you don't have sufficient locking otherwise !

Also I'd provide a write_room method which always answers 'lots'

Do you need a recursion check. Suppose I open this device and capture
printk console messages to it ? Alternatively maybe you need an ioctl
handler to trap that case and reject it as a stupidity filter (or both ?)

> +	cdev_init(&dty_driver->cdev, &detour_fops);
> +
> +	/* create our unnumbered device */
> +	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 3), NULL,
> +		dty_driver->name);

These need to check for failures.


> +static void initial_console_redirect(void)
> +{
> +	long ret;
> +
> +	/* re-register our fops write function */
> +	detour_fops.write = detour_write;
> +
> +	detour_file.f_dentry = &detour_dentry;
> +	detour_file.f_dentry->d_inode = &detour_inode;
> +	detour_file.f_op = &detour_fops;
> +	detour_file.f_mode |= FMODE_WRITE;
> +	security_file_alloc(&detour_file);
> +	INIT_LIST_HEAD(&detour_file.f_u.fu_list);
> +
> +	detour_inode.i_rdev = MKDEV(TTYAUX_MAJOR, 3);
> +	security_inode_alloc(&detour_inode);
> +	INIT_LIST_HEAD(&detour_inode.inotify_watches);
> +
> +	ret = detour_fops.open(&detour_inode, &detour_file);
> +	printk(KERN_INFO "detour_fops.open() returned %ld\n", ret);
> +	ret = detour_fops.unlocked_ioctl(&detour_file, TIOCCONS, 0);
> +	printk(KERN_INFO "detour_fops.ioctl() returned %ld\n", ret);
> +}

Bletch.. I'm really opposed to this kind of hackery. Fix your userspace a
tiny bit.

So
- Write only tty that uses printk: Looks good to me, implementation
  quibbles only
- Magic kernel hacks to shuffle things around in the initial console
  logic - hideous. I still really think you need to fix your userspace

