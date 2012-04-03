Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2DCRwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:52:06 -0400
Received: from smtp.nokia.com ([147.243.1.47]:18273 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab2DCRwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:52:04 -0400
Message-ID: <1333475491.26774.215.camel@groo>
Subject: Re: HSI: hsi: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext ext Greg KH <greg@kroah.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 20:51:31 +0300
In-Reply-To: <20120403151818.GA3231@kroah.com>
References: <20120402165607.2B2D47C0069@ra.kernel.org>
	 <20120402234134.GA18183@kroah.com> <1333464575.26774.130.camel@groo>
	 <20120403151818.GA3231@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 08:18 -0700, ext ext Greg KH wrote:
> On Tue, Apr 03, 2012 at 05:49:35PM +0300, Carlos Chinea wrote:
> > Hi Greg,
> > 
> > Thanks for the review.
> > 
> > On Mon, 2012-04-02 at 16:41 -0700, ext Greg KH wrote:
> > > On Mon, Apr 02, 2012 at 04:56:07PM +0000, Linux Kernel Mailing List wrote:
> > > > +static void hsi_controller_release(struct device *dev __maybe_unused)
> > > > +{
> > > > +}
> > > > +
> > > > +static void hsi_port_release(struct device *dev __maybe_unused)
> > > > +{
> > > > +}
> > > 
> > > As per the documentation in the kernel tree, I get to mock you
> > > mercilessly for doing something as foolish as this.  You are not smarter
> > > than the kernel and don't think that you got rid of the kernel warning
> > > properly by doing this.  Do you think that I wrote that code for no good
> > > reason?  The kernel was being nice and telling you what you did wrong,
> > > don't try to fake it out, it's smarter than you are here.
> > > 
> > > I also get to tell you that you need to fix this up right now, BEFORE
> > > 3.4 comes out.
> > > 
> > > And no, just because you created static struct devices, this is not ok,
> > > DO NOT create static struct devices, that's foolish, and even worse, not
> > > something you should be doing in the first place, create a real
> > > structure, and put a struct device within it please.
> > 
> > That was not really  my intention here.
> > But it is my fault for not keeping up with the documentation. For what
> > is worth, back on the days that the framework was initially written,
> > there was no such documentation and I went for a simple API approach
> > (alloc -> register -> unregister -> free). It also made quite trivial
> > the hsi_port allocation/freeing and device registration.
> 
> When was this code initially written that the documentation, and the
> kernel, did not show these types of warnings?  When you originally
> posted this in 2010?  Sorry, but no, those warnings and documentation
> have been there for many many years.  You obviously were avoiding them
> by providing empty functions, otherwise you would just have not had them
> at all.

Yes you are fully right. The documentation was there back in 2.6.32.
Totally my bad and I am really really sorry for this stupid comment. And
yes the warnings were there.

> > > And people wonder why kernel maintainers are grumpy.
> > > 
> > > > +/**
> > > > + * struct hsi_client - HSI client attached to an HSI port
> > > > + * @device: Driver model representation of the device
> > > > + * @tx_cfg: HSI TX configuration
> > > > + * @rx_cfg: HSI RX configuration
> > > > + * @hsi_start_rx: Called after incoming wake line goes high
> > > > + * @hsi_stop_rx: Called after incoming wake line goes low
> > > > + */
> > > > +struct hsi_client {
> > > > +	struct device		device;
> > > > +	struct hsi_config	tx_cfg;
> > > > +	struct hsi_config	rx_cfg;
> > > > +	void			(*hsi_start_rx)(struct hsi_client *cl);
> > > > +	void			(*hsi_stop_rx)(struct hsi_client *cl);
> > > > +	/* private: */
> > > > +	unsigned int		pclaimed:1;
> > > > +	struct list_head	link;
> > > > +};
> > > 
> > > Why do you need another list_head in here?  What's wrong with using the
> > > device iteration functions that are written for you to use?  Don't put
> > > the structure on yet-another-list, use what is given to you please, as
> > > odds are, you will traverse this list incorrectly (trust me...)
> > > 
> > 
> > Well I do agree about using the device iteration functions, and way back
> > in the old times of this framework that was the case:
> > 
> > https://lkml.org/lkml/2010/5/7/240
> > 
> > The issue here was that I wanted to allow the hsi_controllers drivers to
> > call hsi_event() in their BHs and ISR to minimize the latency in the
> > communication . And that's not possible if I use the
> > device_for_each_child() in hsi_event(), cause the locking does not
> > protect against interrupt handlers. 
> 
> I don't understand, why would a "client" need to iterate to find other
> clients in interrupt context?  

Not over other clients. It is the hsi_port which iterates around its
attached clients and to signal them the rise and fall of its wake line.

> What happens if you loose a device from
> the system while this is happening?  That's why we have a special
> driver-core-only list functionality to keep all of the locking and
> iteration sane.
> 

Hmmm, this initial implementation assumed that there is no hot pluggable
HSI controllers, they are part of the SoC. Once the device tree is
populated hsi clients, port and controllers devices will not disappear
unless the hsi_controller driver is removed, which can not happen if
there is still hsi_client drivers using it.

> > But I guess I can go back to the old code and push the issue down to the
> > the hsi controller drivers and force them to use threaded interrupts...
> 
> I don't understand what you are trying to solve here.  Any pointers to
> where I should look?
> 

https://lkml.org/lkml/2011/6/10/275

Basically the ssi_wake_tasklet and related code. This code takes care of
signal the clients that the other end is rising/dropping the HW wakeline
because wants to transmit. Usually, hsi_clients should not care about
this low level issues, but there is a race in HW protocol specification,
and the usual solution is to have fix on the hsi_client for that by
agreeing on a handshake.
 
> thanks,
> 
> greg k-h

Br,
Carlos Chinea


