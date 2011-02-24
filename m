Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1BXUUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:20:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:59780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab1BXUUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,220,1297065600"; 
   d="scan'208";a="393691298"
Subject: Re: [PATCH 09/10] n_tracerouter ldisc driver.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <alpine.LFD.2.00.1102242002410.2701@localhost6.localdomain6>
References: <james_p_freyensee@linux.intel.com>
	 <1298570824-26085-10-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.LFD.2.00.1102242002410.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 24 Feb 2011 12:20:10 -0800
Message-ID: <1298578810.2315.70.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 20:20 +0100, Thomas Gleixner wrote:
> On Thu, 24 Feb 2011, james_p_freyensee@linux.intel.com wrote:
> > +
> > +/**
> > + * tracerouter_alloc
> > + *
> > + * Allocates the structure needed for this ldisc.
> > + */
> > +static struct tracerouter_data *tracerouter_alloc(void)
> > +{
> > +	struct tracerouter_data *tptr = kzalloc(
> > +					sizeof(struct tracerouter_data),
> > +					GFP_KERNEL);
> > +	if (tptr == NULL)
> > +		return NULL;
> > +	tptr->opencalled = 0;
> 
> Wheeee!
> 
> You first alloc it with kzalloc and then clear the already zero member
> again ?
> 
> That whole crap condenses down to:
> 
>      return kzalloc(sizeof(*tptr), GFP_KERNEL);
> 
> Which hardly justfies a separate function
> 
> > +	return tptr;
> > +}
> > +
> > +/**
> > + * n_tracerouter_open() - Called when a tty is opened by a SW entity.
> > + * @tty: terminal device to the ldisc.
> > + *
> > + * Return:
> > + *      0 for success.
> > + *
> > + * Caveats: This should only be opened one time per SW entity.
> > + */
> > +static int n_tracerouter_open(struct tty_struct *tty)
> > +{
> > +	int retval = -EEXIST;
> > +
> > +	mutex_lock(&routelock);
> > +	if (tr_data->opencalled == 0) {
> > +
> > +		tr_data->kref_tty = tty_kref_get(tty);
> > +		if (tr_data->kref_tty == NULL)
> > +			retval = -EFAULT;
> > +		else {
> 
> Please use braces for the if as well. It's just irritating not to have
> them before the else.

checkpatch.pl did not care about the lack of braces so that is why this
got missed; I can add it.

> 
> > +			tr_data->opencalled = 1;
> > +			tty->disc_data      = tr_data;
> > +			tty->receive_room   = RECEIVE_ROOM;
> > +			tty_driver_flush_buffer(tty);
> > +			retval = 0;
> > +		}
> > +	}
> > +	mutex_unlock(&routelock);
> > +	return retval;
> > +}
> > +
> > +/**
> > + * n_tracerouter_close() - close connection
> > + * @tty: terminal device to the ldisc.
> > + *
> > + * Called when a software entity wants to close a connection.
> > + */
> > +static void n_tracerouter_close(struct tty_struct *tty)
> > +{
> > +	struct tracerouter_data *tptr = tty->disc_data;
> > +
> > +	WARN_ON(tptr->kref_tty != tr_data->kref_tty);
> > +	tty_driver_flush_buffer(tty);
> 
> That code probably never run with lockdep as you would get a potential
> deadlock warning. See n_tracerouter_open().
> 
> Though the deadlock cannot happen as you are protected by
> tr_data->opencalled it does not make it more correct.
> 

What do you suggest to make it correct for upstream?

Thanks,
jay

> > +	mutex_lock(&routelock);
> > +	tty_kref_put(tr_data->kref_tty);
> > +	tr_data->kref_tty = NULL;
> > +	tr_data->opencalled = 0;
> > +	tty->disc_data = NULL;
> > +	mutex_unlock(&routelock);
> > +}
> > +
> 
> Thanks,
> 
> 	tglx


