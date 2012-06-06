Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2FFQ03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:26:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39229 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FFQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:26:27 -0400
Date: Wed, 6 Jun 2012 09:24:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120606162429.GN19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120606154808.GK19601@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1206061159020.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206061159020.1788-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060616-6148-0000-0000-00000678EFE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:05:08PM -0400, Alan Stern wrote:
> On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> 
> > On Wed, Jun 06, 2012 at 11:21:52AM -0400, Alan Stern wrote:
> > > On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> > > 
> > > > No sane compiler would change it to a byte-at-a-time store, but the
> > > > compiler would nevertheless be within its rights to do so.  And a quick
> > > > review of certain LKML threads could easily cause anyone to question gcc's
> > > > sanity.  Furthermore, the compiler is permitted to make transformations
> > > > like the following, which it might well do to save a branch:
> > > > 
> > > > 	if (b)				a = 0;
> > > > 		a = 1;			if (b)
> > > > 	else					a = 1;
> > > > 		a = 0;
> > > 
> > > The compiler would be forbidden if the original code were
> > > 
> > > 	if (b)
> > > 		ACCESS_ONCE(a) = 1;
> > > 	else
> > > 		ACCESS_ONCE(a) = 0;
> > > 
> > > But if I remember correctly, the code snippet we were talking was more 
> > > like:
> > > 
> > > 	if (ACCESS_ONCE(b))
> > > 		a = 1;
> > > 
> > > Isn't this use of ACCESS_ONCE unnecessary?
> > 
> > That would depend on what else is nearby.
> 
> Here's the relevant part of the original patch:
> 
> @@ -467,6 +473,12 @@ EXPORT_SYMBOL_GPL(driver_attach);
>  static void __device_release_driver(struct device *dev)
>  {
>  	struct device_driver *drv;
> +	int idx;
> +
> +	idx = srcu_read_lock(&driver_srcu);
> +
> +	if (ACCESS_ONCE(device_shutdown_started))
> +		goto exit;
> 
>  	drv = dev->driver;
>  	if (drv) {
> @@ -494,6 +506,8 @@ static void __device_release_driver(struct device *dev)
>  						     dev);
> 
>  	}
> +exit:
> +	srcu_read_unlock(&driver_srcu, idx);
>  }

In this case, the ACCESS_ONCE() prevents the compiler from speculatively
executing the stuff following the "goto exit", which I freely admit is
insane even for compiler writers.  But the documentation benefits still
stand.

> > There are some limitations because volatile accesses are not allowed to
> > move past "sequence points", but it would be possible to come up with
> > similar examples.  This sort of thing is why C1x has a memory model and
> > why it allows variables to be designated as needing to be SMP-safe.
> 
> Almost certainly the kernel won't use this facility.  Or else it will 
> just require that _all_ global variables be SMP-safe.

I will reserve judgment until after I see what effect requiring all
globals to be SMP-safe has on code generation.  ;-)

							Thanx, Paul

