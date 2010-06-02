Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab0FBOmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:42:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35869 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755023Ab0FBOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:42:06 -0400
Date: Wed, 2 Jun 2010 15:42:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajiv Aurangabadkar <Rajiv.Aurangabadkar@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Dajun.Chen@diasemi.com" <Dajun.Chen@diasemi.com>,
       "Ashish P. Chavan" <Ashish.Chavan@kpitcummins.com>,
       Nitin Shah <Nitin.Shah@kpitcummins.com>,
       "Vijay R. Iyengar" <Vijay.Iyengar@kpitcummins.com>
Subject: Re: [PATCH] REGULATOR of DA9052 Linux device drivers (5/9)
Message-ID: <20100602144214.GA5155@opensource.wolfsonmicro.com>
References: <F56EA673D3E56E48804FE2B0D23EFD2D2174204AAF@KCINPUNHJCMS01.kpit.com>
 <F56EA673D3E56E48804FE2B0D23EFD2D21745C67FA@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F56EA673D3E56E48804FE2B0D23EFD2D21745C67FA@KCINPUNHJCMS01.kpit.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:47:13PM +0530, Rajiv Aurangabadkar wrote:

> Please find our reply to some of the comments which we feel should be highlighted/ discussed are mentioned below along with our reply's starting with '>>' sign.
> Comments other those mentioned below have been accepted.
> Please have a look.

You really should fix the configuration of your mail client to quote
replies properly.  It is exceptionally difficult to read your reply and
identify the new text due to the non-standard format you have used here.
Documentation/email-clients.txt contains some suggestions for a number
of mail clients.

> > +void da9052_pm_nonkey_handler(u32 event_type)
> > +{
> > +	da9052_pm_signal_to_user(DA9052_PM_ONKEY_EVENT);
> > +}
> 
> This looks like you should be implementing the on key - you should be
> implementing this via the input subsystem.
> 
> >> We intended to notify our user space test applications only, about the occurrence of this event hence we did not implement on-key through input sub system.

This is not acceptable in mainline code, it needs to be removed for
submission to mailine.  Non-standard test interfaces like this should
not be included in the standard Linux kernel.

> > + * @param u32 event_type	complete event status.
> > + * @return void
> > + */
> > +void da9052_pm_gpi8_handler(u32 event_type)
> > +{
> > +	da9052_pm_signal_to_user(DA9052_PM_GPI8_EVENT);
> > +}

> This looks like it should be gpiolib stuff, accessed via gpio_to_irq().

> >> It can be handled by the GPIO driver, but since it was also related to Power management of DA9052 with a particular GPIO setting, we preferred placing it in PM driver.

In what way is this related to the power management of the Linux driver?
There is no visible description of which this is supposed to do, it
appears to be just a vanilla interrupt from the GPIO with no connection
with the rest of the code.

If this does need to talk to the GPIOs why is this not using gpiolib to
talk to the GPIOs?

> > + * @param da9052_buck_config buck_config   Buck configuration
> settings
> > + * @return int		Error status 0:SUCCESS, Non Zero: Error
> > + */
> > +s32 da9052_pm_configure_buck(da9052_buck_config buck_config)
> > +{
> > +	da9052_ssc_msg msg;
> > +	u8 buck_volt_conf_reg;

> This should be static or EXPORT_SYMBOL,
> >> All the necessary functions are exported at the end of the driver source code file.

This is not the standard kernel style, the exports should be along with
the function.

> If it is a function you'll need to change the API to provide some way of
> specifying the device to talk to.

> >> Can you please explain this.

All of your code refers to global variables to find the device to talk
to, this is not how mainline code should work - you should be doing per
device things using private data on the file descriptor to find the
driver specific data.

> > +static s32 da9052_regulator_suspend(struct platform_device *dev,
> pm_message_t state)
> > +{
> > +	/* Put your suspend related operations here */
> > +	printk(KERN_INFO "%s: called\n", __FUNCTION__);
> > +	return (0);
> > +}

> Users should not be editing regulator drivers to add per-board
> customisation, they should just use the standard Linux facilities for
> this stuff.  Doing the suspend in the regulator driver will most likely
> result in poor sequencing of the shutdown anyway.

> >> Above function was implemented in order to simply support the suspend resume framework of the linux framework.

Please engage technically with what I wrote above: this is not something
that should be required in the standard Linux kernel.  What do you mean
by your above statement - what problems does this solve?

As I said above even if users have for some reason to supply some custom
code editing the driver to do this is just not acceptable for mainline.

> > +static s32 __devinit da9052_regulator_probe(struct platform_device
> *dev)
> > +{
> > +	s32 ret;
> > +	struct da9052_regulator_info *ri = NULL;
> > +	struct regulator_init_data init_data;
> > +
> > +
> > +	/* Find the required regulator */
> > +	ri = find_regulator_info(dev->id);

> Allocate the structures here as you probe rather than using a static
> table.

> >> We have multiple LDOs/Bucks.
> We have implemented this referring to other drivers in the kernel.
> Kindly refer to drivers\regulator\da903x.c;drivers\regulator\wm8350-regulator.c

Having multiple regulators is absolutely standard, the majority of
regulator drivers do stuff like this and some of them do need to look up
specific per-regulator data.

The problem here is what's in the data you're looking up - if it were
static data for constant information that's always the same for the
regulator because it comes from the physical device that'd be fine, the
problem is that the structure you're looking up here includes things
like the regulator constraints that need to vary per board and per
instantiation of the chip rather than static properties of the hardware.

Note also that Unix based system like Linux use / as a directory
separator...
