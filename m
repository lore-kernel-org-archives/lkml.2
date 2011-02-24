Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1BXTUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:20:47 -0500
Received: from www.tglx.de ([62.245.132.106]:56847 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab1BXTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:20:46 -0500
Date: Thu, 24 Feb 2011 20:20:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: james_p_freyensee@linux.intel.com
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 09/10] n_tracerouter ldisc driver.
In-Reply-To: <1298570824-26085-10-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1102242002410.2701@localhost6.localdomain6>
References: <james_p_freyensee@linux.intel.com> <1298570824-26085-10-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, james_p_freyensee@linux.intel.com wrote:
> +
> +/**
> + * tracerouter_alloc
> + *
> + * Allocates the structure needed for this ldisc.
> + */
> +static struct tracerouter_data *tracerouter_alloc(void)
> +{
> +	struct tracerouter_data *tptr = kzalloc(
> +					sizeof(struct tracerouter_data),
> +					GFP_KERNEL);
> +	if (tptr == NULL)
> +		return NULL;
> +	tptr->opencalled = 0;

Wheeee!

You first alloc it with kzalloc and then clear the already zero member
again ?

That whole crap condenses down to:

     return kzalloc(sizeof(*tptr), GFP_KERNEL);

Which hardly justfies a separate function

> +	return tptr;
> +}
> +
> +/**
> + * n_tracerouter_open() - Called when a tty is opened by a SW entity.
> + * @tty: terminal device to the ldisc.
> + *
> + * Return:
> + *      0 for success.
> + *
> + * Caveats: This should only be opened one time per SW entity.
> + */
> +static int n_tracerouter_open(struct tty_struct *tty)
> +{
> +	int retval = -EEXIST;
> +
> +	mutex_lock(&routelock);
> +	if (tr_data->opencalled == 0) {
> +
> +		tr_data->kref_tty = tty_kref_get(tty);
> +		if (tr_data->kref_tty == NULL)
> +			retval = -EFAULT;
> +		else {

Please use braces for the if as well. It's just irritating not to have
them before the else.

> +			tr_data->opencalled = 1;
> +			tty->disc_data      = tr_data;
> +			tty->receive_room   = RECEIVE_ROOM;
> +			tty_driver_flush_buffer(tty);
> +			retval = 0;
> +		}
> +	}
> +	mutex_unlock(&routelock);
> +	return retval;
> +}
> +
> +/**
> + * n_tracerouter_close() - close connection
> + * @tty: terminal device to the ldisc.
> + *
> + * Called when a software entity wants to close a connection.
> + */
> +static void n_tracerouter_close(struct tty_struct *tty)
> +{
> +	struct tracerouter_data *tptr = tty->disc_data;
> +
> +	WARN_ON(tptr->kref_tty != tr_data->kref_tty);
> +	tty_driver_flush_buffer(tty);

That code probably never run with lockdep as you would get a potential
deadlock warning. See n_tracerouter_open().

Though the deadlock cannot happen as you are protected by
tr_data->opencalled it does not make it more correct.

> +	mutex_lock(&routelock);
> +	tty_kref_put(tr_data->kref_tty);
> +	tr_data->kref_tty = NULL;
> +	tr_data->opencalled = 0;
> +	tty->disc_data = NULL;
> +	mutex_unlock(&routelock);
> +}
> +

Thanks,

	tglx
