Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0ESRKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:10:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38030 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab0ESRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:10:16 -0400
Date: Wed, 19 May 2010 18:10:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] REGULATOR of DA9052 Linux device drivers (5/9)
Message-ID: <20100519171013.GA24064@sirena.org.uk>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F5@pandora.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20F5@pandora.diasemi.com>
X-Cookie: You buttered your bread, now lie in it.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:53:56AM +0100, David Dajun Chen wrote:
> Dear sir/madam,

> The attached is the REGULATOR part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

There's quite a few problems with this driver.  I've made a few comments
below but I may have missed stuff due to the volume of issues.  I'm
skipping some of the general style issues that others have already
raised.  In general I'd say that it's worth comparing your driver to
other drivers for similar parts - if your driver appears visibily
different from looking at it or is implementing things that no other
driver does it's worth taking a detailed look at what you're doing and
if or how it should fit into standard Linux interfaces.

> Should you have any queries or comments please feel free to contact me.

Please do try to follow the patch submission process documented in
Documentation/SubmittingPatches.  Other people have pointed out the
issues with patch formatting, I'd also remind you that it's important to
CC the relevant maintainers on patches.  If more than one maintainer is
listed that means you should CC all of them.

>+++ linux-2.6.33.2_patch/drivers/mfd/Kconfig    2010-05-18 17:55:50.000000000

drivers/regulator/Kconfig

You'll also want to do your development against current development
versions of people's trees to ensure that your code will apply.

> +config DA9052_PM_ENABLE
> +	bool "Dialog Semiconductor DA9052 Regulator Driver"
> +	depends on MFD_DA9052
> +	select REGULATOR

This is not required, this is part of the regulator Kconfig and will
only be visible if the regulator API is enabled in the first place.

> +	help
> +	  Say Y  to enable the Regulator driver for the DA9052 chip
> +

Random space in here.

> + * History:
> + *
> + * (07/05/2009):	First release Version
> + *
> + * (23/06/2009):	Added support for multiple events occurring at the same
> + *			time
> + *
> + * (25/06/2009):	Added support to control functions in powerdown mode
> + *
> + * (29/06/2009):	Implemented review comments:
> + *			Used macros, modified function names etc.
> + *
> + * (27/04/2010): 	Created initial draft for Linux community release

Remove this.  We've got git for changelogging.

> + *
> + * Best Viewed with TabSize=8 and ColumnWidth=80

This also, this is the standard for Linux.

> +
> +/*--------------------------------------------------------------------------*/
> +/* Local Type Definitions						    */
> +/*--------------------------------------------------------------------------*/
> +
> +/*--------------------------------------------------------------------------*/
> +/* Local Constant Definitions						    */
> +/*--------------------------------------------------------------------------*/

Please clean this stuff up.

> +/*--------------------------------------------------------------------------*/
> +/* Global Variables							    */
> +/*--------------------------------------------------------------------------*/
> +static u8 pm_device_open = 0;
> +static s32 pm_major_number = 0;
> +static struct fasync_struct *pm_fasync_queue;
> +static struct platform_device *da9052_pm_platform_device;
> +static struct regulator_dev *rdev;

You should not have any global variables in the driver, key all the data
off the device you're using to probe.

> +/* Variable to store the status of event registration with EH */
> +static pm_event_registration_status event_registered_status;
> +
> +/* Notifier blocks for individual events that can occur */
> +static da9052_eh_nb seq_rdy_eh_data;
> +static da9052_eh_nb nonkey_eh_data;
> +static da9052_eh_nb id_float_eh_data;
> +static da9052_eh_nb id_gnd_eh_data;
> +static da9052_eh_nb gpi8_eh_data;
> +static da9052_eh_nb gpi9_eh_data;
> +static da9052_eh_nb gpi10_eh_data;

I'll comment in more detail on the MFD patch but you should use the
standard Linux IRQ framework rather than inventing your own.

> +	/* Initialize fault log value */
> +	fault_log = 0;

> +	DA9052_DEBUG("Finished initialization\n");

Use standard kernel pr_debug().

> +s32 da9052_pm_signal_to_user(u8 event)
> +{
> +	/* Acquire semaphore to update event status */
> +	if (down_interruptible(&event_occurance_status_sem))
> +		return (EINTR);
> +
> +	/* Mark the particular event as set */
> +	event_occurance_status |= event;
> +
> +	/* Release semaphore */
> +	up(&event_occurance_status_sem);
> +
> +	DA9052_DEBUG("I am in function: %s, event :%d \n", __FUNCTION__,event);
> +	kill_fasync (&pm_fasync_queue, SIGIO, POLL_IN);
> +
> +	return(SUCCESS);
> +}

> +/**
> + * da9052_pm_nonkey_handler : EH callback function for nONKEY event
> + * 
> + * @param u32 event_type	complete event status.
> + * @return void
> + */
> +void da9052_pm_nonkey_handler(u32 event_type)
> +{
> +	da9052_pm_signal_to_user(DA9052_PM_ONKEY_EVENT);
> +}

This looks like you should be implementing the on key - you should be
implementing this via the input subsystem.

> +/**
> + * da9052_pm_idgnd_handler : EH callback function for ID_GND event
> + * 
> + * @param u32 event_type	complete event status.
> + * @return void
> + */
> +void da9052_pm_idgnd_handler(u32 event_type)
> +{
> +	da9052_pm_signal_to_user(DA9052_PM_ID_GND_EVENT);
> +}

I'm not entirely sure what this stuff is but again you probably ought
not to be implementing a custom userspace API and it doesn't seem to
have terribly much to do with the regulator driver...

> +/**
> + * da9052_pm_gpi8_handler : EH callback function for GPI_8 event
> + * 
> + * @param u32 event_type	complete event status.
> + * @return void
> + */
> +void da9052_pm_gpi8_handler(u32 event_type)
> +{
> +	da9052_pm_signal_to_user(DA9052_PM_GPI8_EVENT);
> +}

This looks like it should be gpiolib stuff, accessed via gpio_to_irq().

> +	ldo_volt = msg.data & info->mask_bits;
> +	if (info->reg_desc.id == DA9052_BUCK_PERI) {
> +		if (ldo_volt >= BUCK_PERI_VALUES_UPTO_3000) {

Given that just about everything has this check for BUCK_PERI you
should just define separate functions for BUCK_PERI - it'd make the code
clearer.

> +/**
> + * da9052_pm_configure_buck: Sets the Buck attributes as per input
> + * 
> + * @param da9052_buck_config buck_config   Buck configuration settings
> + * @return int		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_configure_buck(da9052_buck_config buck_config)
> +{
> +	da9052_ssc_msg msg;
> +	u8 buck_volt_conf_reg;

This should be static or EXPORT_SYMBOL, I suspect, though really it
looks like you want to set up platform data here - have the user pass in
the buck configuration to the device as platform data rather than have
them call a function.

If it is a function you'll need to change the API to provide some way of
specifying the device to talk to.

> +	case BUCK_PRO:
> +		if(msg.data & DA9052_CONTROLB_BUCKMERGE)
> +			return(INVALID_OPERATION_ON_MERGED_BUCK);
> +		/* Validate the BUCK Voltage configuration */
> +		if (SUCCESS != (validate_buckpro_mV(buck_config.buck_volt)))
> +			return (INVALID_BUCKPRO_VOLT_VALUE);
> +		/* Convert the user configuration to bit value */
> +		buck_volt=buckpro_mV_to_reg(buck_config.buck_volt);

I am somewhat suspicous of the fact that it looks like a voltage is
being specified here...  If the user needs to specify a voltage they
should use regulator constraints.

> +/**
> + * da9052_pm_configure_ldo: Configure LDO base on user inputs
> + * 
> + * @param da9052_ldo_config ldo_config   LDO configuration settings
> + * @return int		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_configure_ldo(da9052_ldo_config ldo_config)
> +{

Similar comments here.  This looks like it should be platform data
and/or standard regulator API functionality.

> +/**
> + * da9052_pm_go_buck :  BUCK voltage Ramp/Hold at current setting
> + * 
> + * @param u8 buck_num	BUCK Number
> + * @param u8 flag   	Hold/Ramp setting
> + * @return int		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_go_buck(u8 buck_num, u8 flag)
> +{

And again.  You're adding a *lot* of DA9052 specific APIs in this driver
which aren't being exported and either don't belong in the driver or
should be using standard APIs.  I'm going to stop commenting on these at
this point, please review the remainder of the driver for these issues.

A lot of this looks like you need platform data or should be placing
this code in other drivers.

> +/**
> + * da9052_pm_open: Opens the device
> + * 
> + * @param *inode   	pointer to device inode
> + * @param *file   	file pointer
> + * @return s32		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_open(struct inode *inode, struct file *file)
> +{

Remove this userspace API, you should be using standard Linux intefaces.

> +/**
> + * da9052_regulator_suspend: Power Management support function
> + * 
> + * @param *dev   	pointer to platform device
> + * @param state  	pm state
> + * @return s32		Error status 0:SUCCESS, Non Zero: Error
> + */
> +static s32 da9052_regulator_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	/* Put your suspend related operations here */
> +	printk(KERN_INFO "%s: called\n", __FUNCTION__);
> +	return (0);
> +}

Users should not be editing regulator drivers to add per-board
customisation, they should just use the standard Linux facilities for
this stuff.  Doing the suspend in the regulator driver will most likely
result in poor sequencing of the shutdown anyway.

> +	switch (cmd) {
> +	case DA9052_PM_IOCTL_CONFIGURE_BUCK:
> +		if (copy_from_user(&usr_param_buck_config, 
> +					(da9052_buck_config *) arg, 
> +					sizeof(usr_param_buck_config)))
> +			return (FAILURE);
> +		ret = da9052_pm_configure_buck(usr_param_buck_config);
> +		return (ret);
> +		break;

If userspace needs to control the regulators at runtime a regulator
consumer driver providing appropriate access should be used.  This is
not something that userspace should have unmediated access to since
there is a real possibility of system damage from incorrect
configuration and this shouldn't be driver specific anyway since Linux
should be offering standard interfaces.

> +/**
> + * da9052_regulator_probe:	Called when a device gets attached to driver 
> + *
> + * @param struct platform_device *dev	platform device to be probe
> + * @return s32				Error status 0:SUCCESS, Non Zero: Error
> + */
> +static s32 __devinit da9052_regulator_probe(struct platform_device *dev)
> +{
> +	s32 ret;
> +	struct da9052_regulator_info *ri = NULL;
> +	struct regulator_init_data init_data;
> +
> +
> +	/* Find the required regulator */
> +	ri = find_regulator_info(dev->id);

Allocate the structures here as you probe rather than using a static
table.

> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)
> +	rdev = regulator_register(&ri->reg_desc,&dev->dev,dev->dev.platform_data,ri);
> +#else
> +	rdev = regulator_register(&ri->reg_desc, &dev->dev, ri);
> +#endif

Remove this stuff for mainline.

> +	printk(banner);
> +
> +	DA9052_DEBUG("DA9052: init : %d.\n",DA9052_PM_DEVICE_MAJOR_NO);
> +
> +	da9052_pm_platform_device = platform_device_alloc(DA9052_PM_DEVICE_NAME, DA9052_BUCK_PERI);
> +	if (!da9052_pm_platform_device)
> +		return (-ENOMEM);
> +
> +	retval = platform_device_add(da9052_pm_platform_device);
> +	if (retval < 0) {
> +		platform_device_put(da9052_pm_platform_device);
> +		return (retval);
> +	}

You shouldn't be adding devices here, these should be appearing as a
result of the core driver probing as per other MFD drivers.

> @@ -23,6 +23,7 @@
>  obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
>  obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
> +obj-$(CONFIG_DA9052_PM_ENABLE)	+= da9052_pm.o

Please try to follow the same naming convention as the other drivers for
your config varaible.
