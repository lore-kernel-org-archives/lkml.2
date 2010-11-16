Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0KPP6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:58:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54653 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751375Ab0KPP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:58:34 -0500
Date: Tue, 16 Nov 2010 15:57:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116155717.6671e484@lxorguk.ukuu.org.uk>
In-Reply-To: <1289922400.1253.3.camel@yio.site>
References: <1289922400.1253.3.camel@yio.site>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 16:46:40 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> commit be0d5f02c9194fe41c1aad11d7282db117bda938
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Tue Nov 9 18:53:59 2010 +0100
> 
>     tty: add 'active' sysfs attribute to tty0 and console device

This is all somewhat weird.

>     Userspace can query the actual virtual console, and the configured
>     console devices behind /dev/tt0 and /dev/console.

All the other vt interface code is in the vt driver, the ioctls for it
are in the vt driver and a query about what is the active vt only has
meaning within that context as you need to post a waitevent first to
track changes during the query. So if you need a VT_GETACTIVE interface
put it in the tty ioctls where it can be properly locked and used.

> +What:		/sys/class/tty/tty0/active
> +Date:		Nov 2010
> +Contact:	Kay Sievers <kay.sievers@vrfy.org>
> +Description:
> +		 Shows the currently active virtual console
> +		 device, like 'tty1'.
> +		 The file supports poll() to detect virtual
> +		 console switches.

NAK this, its a nonsense interface

Seriously what use is an interface that tells you "what the console might
have been", this is why we have a proper event tracking interface instead.

> +static ssize_t show_cons_active(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct console *cs[16];
> +	int i = 0;
> +	struct console *c;
> +	ssize_t count = 0;
> +
> +	acquire_console_sem();
> +	for (c = console_drivers; c; c = c->next) {
> +		if (!c->device)
> +			continue;
> +		if (!c->write)
> +			continue;
> +		if ((c->flags & CON_ENABLED) == 0)
> +			continue;
> +		cs[i++] = c;
> +		if (i >= ARRAY_SIZE(cs))
> +			break;
> +	}
> +	while (i--)
> +		count += sprintf(buf + count, "%s%d%c",
> +				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
> +	release_console_sem();
> +
> +	return count;
> +}
> +static DEVICE_ATTR(active, S_IRUGO, show_cons_active, NULL);

This makes more sense.

> -	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL,
> -			      "tty");
> +	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");

Please keep unneccessary reformatting patches out of code changes, submit
them separately.

>  static ATOMIC_NOTIFIER_HEAD(vt_notifier_list);
> @@ -688,6 +696,8 @@ void redraw_screen(struct vc_data *vc, int is_switch)
>  			save_screen(old_vc);
>  			set_origin(old_vc);
>  		}
> +		if (tty0dev)
> +			sysfs_notify(&tty0dev->kobj, NULL, "active");

What is the locking on tty0dev at this point ? Wrong place anyway - we
have vt change notifiers that do this properly and can track other
changes like console sizes, add and remove. See the VT_WAITACTIVE stuff
etc.

> +static ssize_t show_tty_active(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "tty%d\n", fg_console + 1);
> +}
> +static DEVICE_ATTR(active, S_IRUGO, show_tty_active, NULL);

How do you ensure fg_console returned to user space is right when the
console can change during and after the call ?

