Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1BXU1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:27:39 -0500
Received: from www.tglx.de ([62.245.132.106]:44796 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab1BXU1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:27:38 -0500
Date: Thu, 24 Feb 2011 21:27:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: J Freyensee <james_p_freyensee@linux.intel.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 09/10] n_tracerouter ldisc driver.
In-Reply-To: <1298578810.2315.70.camel@localhost>
Message-ID: <alpine.LFD.2.00.1102242125410.2701@localhost6.localdomain6>
References: <james_p_freyensee@linux.intel.com>  <1298570824-26085-10-git-send-email-james_p_freyensee@linux.intel.com>  <alpine.LFD.2.00.1102242002410.2701@localhost6.localdomain6> <1298578810.2315.70.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, J Freyensee wrote:
> > > +
> > > +	mutex_lock(&routelock);
> > > +	if (tr_data->opencalled == 0) {
> > > +
> > > +		tr_data->kref_tty = tty_kref_get(tty);
> > > +		if (tr_data->kref_tty == NULL)
> > > +			retval = -EFAULT;
> > > +		else {
> > 
> > Please use braces for the if as well. It's just irritating not to have
> > them before the else.
> 
> checkpatch.pl did not care about the lack of braces so that is why this
> got missed; I can add it.

It's not a strict requirement, but add it and look at the result. Then
judge yourself.

> > +static void n_tracerouter_close(struct tty_struct *tty)
> > > +{
> > > +	struct tracerouter_data *tptr = tty->disc_data;
> > > +
> > > +	WARN_ON(tptr->kref_tty != tr_data->kref_tty);
> > > +	tty_driver_flush_buffer(tty);
> > 
> > That code probably never run with lockdep as you would get a potential
> > deadlock warning. See n_tracerouter_open().
> > 
> > Though the deadlock cannot happen as you are protected by
> > tr_data->opencalled it does not make it more correct.
> > 
> 
> What do you suggest to make it correct for upstream?

Keep the lock ordering consistent. Either call that under the lock
always or do not.

Thanks,

	tglx
