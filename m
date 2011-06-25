Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1FYLjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 07:39:09 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:49640 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab1FYLjF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 07:39:05 -0400
X-Greylist: delayed 1626 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jun 2011 07:39:05 EDT
Date: Sat, 25 Jun 2011 12:11:42 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <greg@kroah.com>, devicetree-discuss@lists.ozlabs.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/4] dt: early platform devices support
Message-ID: <20110625121142.4c73ca70@taxman.wild-wind.fr.eu.org>
In-Reply-To: <BANLkTi=7cM2dXniHM4mnXs46KaTc05hh-Q@mail.gmail.com>
References: <1308924659-31894-1-git-send-email-marc.zyngier@arm.com>
	<1308924659-31894-2-git-send-email-marc.zyngier@arm.com>
	<BANLkTi=7cM2dXniHM4mnXs46KaTc05hh-Q@mail.gmail.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: grant.likely@secretlab.ca, greg@kroah.com, devicetree-discuss@lists.ozlabs.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 22:49:56 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> [cc'ing linux kernel since I discuss driver core issues]
> [cc'ing greg and kay, 'cause I've included a patch I'd like you to
> look at (see end of email)]
> 
> On Fri, Jun 24, 2011 at 8:10 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > Add support for populating early platform devices from the device
> > tree, by walking the tree and adding nodes whose 'compatible'
> > property matches the 'class' string passed as a parameter.
> >
> > This allows devices to be probed long before the whole device
> > infrastructure is available.
> >
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  drivers/of/platform.c       |   26 ++++++++++++++++++++++++++
> >  include/linux/of_platform.h |    1 +
> >  2 files changed, 27 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > index e75af39..2a323ee 100644
> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -458,4 +458,30 @@ int of_platform_populate(struct device_node *root,
> >        of_node_put(root);
> >        return rc;
> >  }
> > +
> > +/**
> > + * of_early_platform_populate() - Populate early platform devices from DT
> > + * @class: string to compare to the 'compatible' attributes
> > + *
> > + * This function walks the device tree and register devices whose
> > + * 'compatible' property matches the 'class' parameter.
> > + *
> > + * Returns 0 on success, < 0 on failure.
> > + */
> > +int of_early_platform_populate(const char *class)
> > +{
> > +       struct platform_device *pdev;
> > +       struct device_node *np = NULL;
> > +
> > +       while ((np = of_find_compatible_node(np, NULL, class))) {
> 
> for_each_compatible_node()
> 
> > +               pdev = of_device_alloc(np, NULL, NULL);
> > +               if (!pdev)
> > +                       return -ENOMEM;
> > +               list_del(&pdev->dev.devres_head);
> > +               memset(&pdev->dev.devres_head, 0, sizeof(pdev->dev.devres_head));
> > +               early_platform_add_devices(&pdev, 1);
> 
> I'm not sure this will work reliably.  The of_platform semantics are
> still slightly different from 'regular' platform devices (which I do
> intend to fix though), so it may cause problems with how the device
> name gets assigned.  I'd need to dig into it though.
> 
> > +       }
> > +
> > +       return 0;
> > +}
> 
> Hmmm, I'd really rather not go down the path of having different
> 'classes' of devices that need to be registered at different times.
> There just isn't a really good generic way to know which devices
> should be the 'early' ones, it gets hairy with regard to making sure
> devices don't get registered twice, and it doesn't actually solve the
> problem that there is no way to handle dependencies between devices in
> the Linux device model.
> 
> What I /want/ to do is allow drivers to defer initialization at .probe
> time if some of the resources it needs aren't yet available.
> Unfortunately, that doesn't work so well for interrupt controllers
> since irq numbers are expected to be correctly populated in the
> platform device resource table.  What complicates things further is
> that most gpio controllers are doubling as irq controllers nowdays,
> and those are typically modelled with platform devices themselves.

While I totally agree with all the above, this patch tries to address a
slightly different problem. On top of device/device dependencies, there
is also a number of implicit dependencies.

In the case I'm currently trying to solve, the kernel expects a timer
to be up and running when hitting the delay loop calibration. At that
stage, it is impossible to register a platform device, hence the use
(abuse?) of early platform devices.

The current ARM code relies on the timers *not* being a standard
device, and being directly setup by an board specific method. The SMP
timers are even worse, as they are directly called by the core code,
meaning that we can only have *one* implementation at a time in the
kernel.

So the early platform stuff is a potential solution for that, though
there is no way it would handle any kind of dependency. What I dream of
is to have the full device/driver infrastructure available much
earlier, before the rest of the kernel starts relying on some hardware
being up and running...

Cheers,

	M.
-- 
I'm the slime oozin' out from your TV set...
