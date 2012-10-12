Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab2JLStt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:49:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51547 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab2JLStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:49:47 -0400
Date: Fri, 12 Oct 2012 19:49:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, Paul Walmsley <paul@pwsan.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20121012184919.GR28061@n2100.arm.linux.org.uk>
References: <20120925091228.GI31374@n2100.arm.linux.org.uk> <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com> <87ipas2y4h.fsf@deeprootsystems.com> <alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com> <50784458.9080806@ti.com> <877gqv7imt.fsf@deeprootsystems.com> <20121012164202.GQ28061@n2100.arm.linux.org.uk> <FEB1293C1A07484EA4E9721B32981131CC2362@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FEB1293C1A07484EA4E9721B32981131CC2362@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 05:29:55PM +0000, Poddar, Sourav wrote:
> Hi Russell,
> ________________________________________
> From: Russell King - ARM Linux [linux@arm.linux.org.uk]
> Sent: Friday, October 12, 2012 10:12 PM
> To: Kevin Hilman
> Cc: Poddar, Sourav; Paul Walmsley; Balbi, Felipe; gregkh@linuxfoundation.org; tony@atomide.com; linux-kernel@vger.kernel.org; Shilimkar, Santosh; linux-serial@vger.kernel.org; linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org; alan@linux.intel.com
> Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not  suspended.
> 
> On Fri, Oct 12, 2012 at 09:35:54AM -0700, Kevin Hilman wrote:
> > Sourav <sourav.poddar@ti.com> writes:
> > > diff --git a/drivers/tty/serial/omap-serial.c
> > > b/drivers/tty/serial/omap-serial.c
> > > index 6ede6fd..3fbc7f7 100644
> > > --- a/drivers/tty/serial/omap-serial.c
> > > +++ b/drivers/tty/serial/omap-serial.c
> > > @@ -1414,6 +1414,7 @@ static int __devinit serial_omap_probe(struct
> > > platform_device *pdev)
> > >         INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
> > >
> > >         platform_set_drvdata(pdev, up);
> > > +       pm_runtime_set_active(&pdev->dev);
> >
> > NAK.
> >
> > This will obviously break platforms where the UARTs are not active
> > before driver loads.
> 
> I thought I had proposed a solution for this issue, which was this
> sequence:
> 
>         omap_device_enable(dev);
>         pm_runtime_set_active(dev);
>         pm_runtime_enable(dev);
> 
> Yes, I can understand people not liking the omap_device_enable()
> there, but I also notice that the email suggesting that never got a
> reply either - not even a "I tried this and it doesn't work" or "it
> does work".
> 
> Sorry for the late reply on this. I tried this sequence and it worked perfectly fine on
> panda and beagle. 
> 
> As such, it seems this issue isn't making any progress as we had
> already established that merely doing a "pm_runtime_set_active()"
> before "pm_runtime_enable()" was going to break other platforms.
> 
>  I was  trying to analyse your explanations on this and since
> omap_device_enable is not generally recommended,  I was trying to see
> if anything else can be done to get around this.

Right, so what you need is explanation about why I believe the above
sequence to be necessary.

What is happening is that we're starting from a device in unknown state.
We don't know whether it is enabled or disabled.  We don't know the
state of the clocks or the power domain.

PM runtime state is initialized at device creation in the "device is
suspended" state.  If we merely enable PM runtime from that state, we
are telling the PM runtime subsystem that the device is _indeed_
suspended (disabled) at boot time.

So, that causes the first pm_runtime_get() call to resume the device.
Due to the OMAP runtime PM hooks at the bus layer, this causes
_od_runtime_resume() to be called.

_od_runtime_resume() does two things.  It calls omap_device_enable()
to ensure that the device is woken up (such as, ensuring that the
power domain is on, and turning on the clocks etc.)  It then goes on
to call the device PM layers to call the driver specific runtime PM
resume hook.

So, in summary, what this sequence does is:

        pm_runtime_enable(&pdev->dev);
        pm_runtime_use_autosuspend(&pdev->dev);
        pm_runtime_set_autosuspend_delay(&pdev->dev,
                        omap_up_info->autosuspend_timeout);

        pm_runtime_irq_safe(&pdev->dev);
        pm_runtime_get_sync(&pdev->dev);

is, at the last call, it calls:

		_od_runtime_resume()
			omap_device_enable()
			serial_omap_runtime_resume()

Your original patch at the head of this thread says that the driver
specific runtime resume call causes a problem for N800 - because the
device is already enabled and setup.

Okay, so the initial device state does not match the runtime PM state.

So, what happens if we _do_ make it match your state - as required by
the runtime PM documentation - by adding a call before the sequence:

	pm_runtime_set_active(&pdev->dev);
        pm_runtime_enable(&pdev->dev);
        pm_runtime_use_autosuspend(&pdev->dev);
        pm_runtime_set_autosuspend_delay(&pdev->dev,
                        omap_up_info->autosuspend_timeout);

        pm_runtime_irq_safe(&pdev->dev);
        pm_runtime_get_sync(&pdev->dev);

Right, now runtime PM knows that the device is enabled and alive prior
to that pm_runtime_get_sync() call, and it will _not_ call the runtime
resume hooks.

However, this breaks beaglebone, because the device is disabled when
this driver probes.  So, we have exactly the opposite problem here -
the device is disabled, but runtime PM thinks it is enabled.

The _two_ problems are precisely the same problem: the runtime PM state
does not accurately reflect the actual hardware state - again, as required
by the runtime PM documentation.  The only sane solution to this is to
ensure that the hardware _is_ in a known state prior to enabling runtime
PM.

How do we do that?  Well, the clue is in the bus layer runtime resume
handler - that's what is missing from the beaglebone situation.

Calling this before calling pm_runtime_set_active() gets the hardware
into a known state (enabled), and we then tell the runtime PM code
that the harware _is_ enabled.  Now, runtime PM can be sure what the
initial state is, and everything works.

What's the longer term answer?

Well, I _bet_ all OMAP drivers are doing something along the lines of:

	pm_runtime_enable(dev);
	pm_runtime_get(dev);

in their probe functions.

PCI already solved this problem - partly because it has far too many drivers
to convert.  I took that solution over to the AMBA bus layer, because I
didn't want to have a flag day for all the drivers to convert over in one
massive patch.  What is this solution?

You get the bus layer to handle the initial setup of runtime PM state like
this - in OMAP's case:

	omap_device_enable(pdev);
	pm_runtime_get_noresume(&pdev->dev);
	pm_runtime_set_active(&pdev->dev);
	pm_runtime_enable(&pdev->dev);

You do this prior to calling the device probe function.  If the device
probe fails, then you can undo those actions.  You also need to undo them
when the device is unbound from the driver:

	pm_runtime_disable(&pdev->dev);
	pm_runtime_set_suspended(&pdev->dev);
	pm_runtime_put_noidle(&pdev->dev);

(It is probably dangerous to call omap_device_disable() here for certain
devices...)

This gets rid of all that driver specific runtime PM initialization, with
questionable starting state.  It also means that your devices all get
runtime PM support in so far as if they're bound to a driver, they will
be runtime PM resumed, and when unbound, they will be runtime PM suspended.

However, it means that the driver has to do something to make runtime PM
work.  In the probe function, just before it returns success, it has to
'put' that pm_runtime_get_noresume() reference to allow the device to
enter runtime PM states.  And more importantly, on a remove call, it
_must_ balance that 'put' in the probe with an appropriate 'get' - no
exceptions to that.

And that is how we get to a sane state over runtime PM here, which will
work in every situation on every device, without throwing calls to
omap_device_enable() into every OMAP device driver.

This also has another advantage - by doing that, the OMAP specific
omap_device_enable() call ends up being in bus layer code, not driver
layer, which is the right place for it to be - after all, it's the
bus layer which is already handling that stuff in its runtime PM support
code.
