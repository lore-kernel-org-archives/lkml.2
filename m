Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab2JLSyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:54:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51558 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2JLSyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:54:43 -0400
Date: Fri, 12 Oct 2012 19:54:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Sourav <sourav.poddar@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20121012185426.GS28061@n2100.arm.linux.org.uk>
References: <20120925091228.GI31374@n2100.arm.linux.org.uk> <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com> <87ipas2y4h.fsf@deeprootsystems.com> <alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com> <50784458.9080806@ti.com> <877gqv7imt.fsf@deeprootsystems.com> <20121012164202.GQ28061@n2100.arm.linux.org.uk> <877gqv4lmt.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gqv4lmt.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:59:22AM -0700, Kevin Hilman wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > On Fri, Oct 12, 2012 at 09:35:54AM -0700, Kevin Hilman wrote:
> >> Sourav <sourav.poddar@ti.com> writes:
> >> > diff --git a/drivers/tty/serial/omap-serial.c
> >> > b/drivers/tty/serial/omap-serial.c
> >> > index 6ede6fd..3fbc7f7 100644
> >> > --- a/drivers/tty/serial/omap-serial.c
> >> > +++ b/drivers/tty/serial/omap-serial.c
> >> > @@ -1414,6 +1414,7 @@ static int __devinit serial_omap_probe(struct
> >> > platform_device *pdev)
> >> >         INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
> >> >
> >> >         platform_set_drvdata(pdev, up);
> >> > +       pm_runtime_set_active(&pdev->dev);
> >> 
> >> NAK.
> >> 
> >> This will obviously break platforms where the UARTs are not active
> >> before driver loads.
> >
> > I thought I had proposed a solution for this issue, which was this
> > sequence:
> >
> >         omap_device_enable(dev);                                                
> >         pm_runtime_set_active(dev);                                             
> >         pm_runtime_enable(dev);                                                 
> >
> > Yes, I can understand people not liking the omap_device_enable()
> > there, but I also notice that the email suggesting that never got a
> > reply either - not even a "I tried this and it doesn't work" or "it
> > does work".
> 
> Yes, that solution would work (though I didn't actually try it.)
> 
> However, we can't use omap_device_enable() in the driver.  We're trying
> to clean all the drivers of OMAP-specific APIs.  That being said,
> something similar could be done in the device/board init code to ensure
> the UART HW is in the state that the driver is expecting it, but again,
> that would just mask the real problem which is that a (re)init of the
> console UART on 2420/n800 is causing output to disappear.

See my more expansive suggestion just posted.

Whatever way, this discrepancy between runtime PM state and actual device
state is what is biting you, and it is that which needs fixing.  It's
fairly easy to fix given the right design, one which several other bus
types are already using.

Given the route that OMAP went down when adopting runtime PM, it's going
to be a big change across many drivers, because there's no way to gradually
transition them, but that's unfortunately one of the results of ignoring
requirements of the layers being used.  Sooner or later the oversights
come back to haunt.  Just make sure it's not the ghost of Jaws.
