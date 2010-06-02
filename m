Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab0FBOsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:48:40 -0400
Received: from mail-va3.bigfish.com ([216.32.180.111]:48239 "EHLO
	mail5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757935Ab0FBOsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:48:38 -0400
X-Greylist: delayed 1868 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 10:48:38 EDT
X-SpamScore: -2
X-BigFish: VPS-2(zz1454Kzz1202hz4fhzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 203.197.93.240;Service: EHS
From: Rajiv Aurangabadkar <Rajiv.Aurangabadkar@kpitcummins.com>
To: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Dajun.Chen@diasemi.com" <Dajun.Chen@diasemi.com>,
       "Ashish P. Chavan" <Ashish.Chavan@kpitcummins.com>,
       Nitin Shah <Nitin.Shah@kpitcummins.com>,
       "Vijay R. Iyengar" <Vijay.Iyengar@kpitcummins.com>
Date: Wed, 2 Jun 2010 19:47:13 +0530
Subject: RE: [PATCH] REGULATOR of DA9052 Linux device drivers (5/9)
Thread-Topic: [PATCH] REGULATOR of DA9052 Linux device drivers (5/9)
Thread-Index: Acr3dibbCum+nFgRTsy/So+7ybpCkQAI2L2wAAzVe4ACpDagIA==
Message-ID: <F56EA673D3E56E48804FE2B0D23EFD2D21745C67FA@KCINPUNHJCMS01.kpit.com>
References: <F56EA673D3E56E48804FE2B0D23EFD2D2174204AAF@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <F56EA673D3E56E48804FE2B0D23EFD2D2174204AAF@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: Kcinpunhjhc01.kpit.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Please find our reply to some of the comments which we feel should be highlighted/ discussed are mentioned below along with our reply's starting with '>>' sign.
Comments other those mentioned below have been accepted.
Please have a look.

> Dear sir/madam,

> The attached is the REGULATOR part of the device drivers newly
developed for DA9052 Power Management IC from Dialog Semiconductor.

There's quite a few problems with this driver.  I've made a few comments below but I may have missed stuff due to the volume of issues.  I'm skipping some of the general style issues that others have already raised.  In general I'd say that it's worth comparing your driver to other drivers for similar parts - if your driver appears visibily different from looking at it or is implementing things that no other driver does it's worth taking a detailed look at what you're doing and if or how it should fit into standard Linux interfaces.

>> The Regulator driver earlier was developed in order to meet our custom requirements; hence posted patch contains both the Linux standard regulator interface and the customized driver functions. The customization related part of the driver can be removed. Kindly refer to responses below.
 
> Should you have any queries or comments please feel free to contact
me.

> +/**
> + * da9052_pm_nonkey_handler : EH callback function for nONKEY event
> + * 
> + * @param u32 event_type	complete event status.
> + * @return void
> + */
> +void da9052_pm_nonkey_handler(u32 event_type) {
> +	da9052_pm_signal_to_user(DA9052_PM_ONKEY_EVENT);
> +}

This looks like you should be implementing the on key - you should be implementing this via the input subsystem.

>> We intended to notify our user space test applications only, about the occurrence of this event hence we did not implement on-key through input sub system.

> +/**
> + * da9052_pm_idgnd_handler : EH callback function for ID_GND event
> + * 
> + * @param u32 event_type	complete event status.
> + * @return void
> + */
> +void da9052_pm_idgnd_handler(u32 event_type) {
> +	da9052_pm_signal_to_user(DA9052_PM_ID_GND_EVENT);
> +}

I'm not entirely sure what this stuff is but again you probably ought not to be implementing a custom userspace API and it doesn't seem to have terribly much to do with the regulator driver...

>> We intended to use these event handlers for our user space test applications.

> +/**
> + * da9052_pm_gpi8_handler : EH callback function for GPI_8 event
> + * 
> + * @param u32 event_type	complete event status.
> + * @return void
> + */
> +void da9052_pm_gpi8_handler(u32 event_type) {
> +	da9052_pm_signal_to_user(DA9052_PM_GPI8_EVENT);
> +}

This looks like it should be gpiolib stuff, accessed via gpio_to_irq().

>> It can be handled by the GPIO driver, but since it was also related to Power management of DA9052 with a particular GPIO setting, we preferred placing it in PM driver.


> +/**
> + * da9052_pm_configure_buck: Sets the Buck attributes as per input
> + * 
> + * @param da9052_buck_config buck_config   Buck configuration
settings
> + * @return int		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_configure_buck(da9052_buck_config buck_config) {
> +	da9052_ssc_msg msg;
> +	u8 buck_volt_conf_reg;

This should be static or EXPORT_SYMBOL,
>> All the necessary functions are exported at the end of the driver source code file.

 I suspect, though really it looks like you want to set up platform data here - have the user pass in the buck configuration to the device as platform data rather than have them call a function.

>> These driver functions (during the initial phase i.e. customization) were tested using our test applications, which communicated with these functions through IOCTL calls through pre defined data types.

If it is a function you'll need to change the API to provide some way of specifying the device to talk to.

>> Can you please explain this.

> +	case BUCK_PRO:
> +		if(msg.data & DA9052_CONTROLB_BUCKMERGE)
> +			return(INVALID_OPERATION_ON_MERGED_BUCK);
> +		/* Validate the BUCK Voltage configuration */
> +		if (SUCCESS !=
(validate_buckpro_mV(buck_config.buck_volt)))
> +			return (INVALID_BUCKPRO_VOLT_VALUE);
> +		/* Convert the user configuration to bit value */
> +		buck_volt=buckpro_mV_to_reg(buck_config.buck_volt);

I am somewhat suspicous of the fact that it looks like a voltage is being specified here...  If the user needs to specify a voltage they should use regulator constraints.

>> Instead of using the regulator constraints we have used local validation functions as we were using IOCTL based test framework.

> +/**
> + * da9052_pm_configure_ldo: Configure LDO base on user inputs
> + * 
> + * @param da9052_ldo_config ldo_config   LDO configuration settings
> + * @return int		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_configure_ldo(da9052_ldo_config ldo_config) {

Similar comments here.  This looks like it should be platform data and/or standard regulator API functionality.

>> These driver functions (during the initial phase) were tested using our test applications, which communicated with these functions through IOCTL calls through pre defined data types.

> +/**
> + * da9052_pm_go_buck :  BUCK voltage Ramp/Hold at current setting
> + * 
> + * @param u8 buck_num	BUCK Number
> + * @param u8 flag   	Hold/Ramp setting
> + * @return int		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_go_buck(u8 buck_num, u8 flag)
> +

And again.  You're adding a *lot* of DA9052 specific APIs in this driver which aren't being exported and either don't belong in the driver or should be using standard APIs.  I'm going to stop commenting on these at this point, please review the remainder of the driver for these issues.

A lot of this looks like you need platform data or should be placing this code in other drivers.

>> Same as above.

> +/**
> + * da9052_pm_open: Opens the device
> + * 
> + * @param *inode   	pointer to device inode
> + * @param *file   	file pointer
> + * @return s32		Error status 0:SUCCESS, Non Zero: Error
> + */
> +s32 da9052_pm_open(struct inode *inode, struct file *file) {

Remove this userspace API, you should be using standard Linux intefaces.

>> This was developed to get a handle of PM driver and test it through the IOCTL framework.

> +/**
> + * da9052_regulator_suspend: Power Management support function
> + * 
> + * @param *dev   	pointer to platform device
> + * @param state  	pm state
> + * @return s32		Error status 0:SUCCESS, Non Zero: Error
> + */
> +static s32 da9052_regulator_suspend(struct platform_device *dev,
pm_message_t state)
> +{
> +	/* Put your suspend related operations here */
> +	printk(KERN_INFO "%s: called\n", __FUNCTION__);
> +	return (0);
> +}

Users should not be editing regulator drivers to add per-board customisation, they should just use the standard Linux facilities for this stuff.  Doing the suspend in the regulator driver will most likely result in poor sequencing of the shutdown anyway.

>> Above function was implemented in order to simply support the suspend resume framework of the linux framework.

> +	switch (cmd) {
> +	case DA9052_PM_IOCTL_CONFIGURE_BUCK:
> +		if (copy_from_user(&usr_param_buck_config, 
> +					(da9052_buck_config *) arg, 
> +					sizeof(usr_param_buck_config)))
> +			return (FAILURE);
> +		ret = da9052_pm_configure_buck(usr_param_buck_config);
> +		return (ret);
> +		break;

If userspace needs to control the regulators at runtime a regulator consumer driver providing appropriate access should be used.

>> This stands true for standard Linux framework, but as per our user requirement we implemented the test frame work using IOCTL calls.

This is not something that userspace should have unmediated access to since there is a real possibility of system damage from incorrect configuration and this shouldn't be driver specific anyway since Linux should be offering standard interfaces.

>>We have implemented proper checks in order to avoid the system damage through the above used test framework also we did not implement the standard interfaces initially.

> +/**
> + * da9052_regulator_probe:	Called when a device gets attached to
driver 
> + *
> + * @param struct platform_device *dev	platform device to be
probe
> + * @return s32				Error status 0:SUCCESS,
Non Zero: Error
> + */
> +static s32 __devinit da9052_regulator_probe(struct platform_device
*dev)
> +{
> +	s32 ret;
> +	struct da9052_regulator_info *ri = NULL;
> +	struct regulator_init_data init_data;
> +
> +
> +	/* Find the required regulator */
> +	ri = find_regulator_info(dev->id);

Allocate the structures here as you probe rather than using a static table.

>> We have multiple LDOs/Bucks.
We have implemented this referring to other drivers in the kernel.
Kindly refer to drivers\regulator\da903x.c;drivers\regulator\wm8350-regulator.c

Thanks and Regards,
Rajiv Aurangabadkar.

