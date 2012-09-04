Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2IDL5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:57:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63272 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab2IDL5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:57:36 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 4 Sep 2012 04:57:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH] Revert "spi/doc: spi_master_put must be followed up by
 kfree"
Message-ID: <20120904115738.GA24634@roeck-us.net>
References: <1346703986-7849-1-git-send-email-linux@roeck-us.net>
 <20120904072523.GB28643@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120904072523.GB28643@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 09:25:23AM +0200, Uwe Kleine-König wrote:
> On Mon, Sep 03, 2012 at 01:26:26PM -0700, Guenter Roeck wrote:
> > Actually, spi_master_put() after spi_alloc_master() must _not_ be followed
> > by kfree(). The memory is already freed with the call to spi_master_put()
> > through spi_master_class, which registers a release function. Calling both
> > spi_master_put() and kfree() results in often nasty (and delayed) crashes
> > elsewhere in the kernel, often in the networking stack.
> > 
> > This reverts commit eb4af0f5349235df2e4a5057a72fc8962d00308a.
> > 
> > Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> I didn't check the callback, but I introduced
> eb4af0f5349235df2e4a5057a72fc8962d00308a because I saw the kfree in
> drivers/spi/spi-imx.c. So I guess this needs fixing, too?!
> 
This is a bitbang driver, which is one of the tricky ones which I have not touched
yet.

That driver calls
	spi_alloc_master
	spi_master_get
..
error:
	spi_master_put
	kfree

which works out fine, since there are two references to master (one from
spi_alloc_master and one from spi_master_put). Calling spi_master_put twice
would be cleaner, of course, but one can not have everything and at least
nothing bad will happen.

Other bitbang drivers are problematic, though. For example, looking at
spi-altera.c:

	hw->bitbang.master = spi_master_get(master);
	if (!hw->bitbang.master)
		return err;

That error case should never happen, but if it does the return would leave master
unreleased. In practice it is not necessary to check the return code here since
it will only be NULL if master is NULL.

exit:
	spi_master_put(master);
	return err;

So this driver calls spi_alloc_master and spi_master_get, but only calls
spi_master_put once in the error path, meaning one reference is left and
master will not be freed. Given the context, it should really be
	spi_master_put(hw->bitbang.master);
	spi_master_put(master);
	return err;

This is just an example. spi-ath79.c and spi-au1550.c are wrong as well, and
many others.

The issue really is that one must keep track of the number of references to
master, and many drivers don't get that right. Bitbang drivers usually call
spi_master_get() to get an additional reference to master, and thus must call
spi_master_put twice (or spi_master_put/kfree) in the error path. Non-bitbang
drivers don't call spi_master_get() and thus don't need the additional call to
spi_master_put (or kfree).

Guenter
