Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338Ab0FQQvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:51:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60927 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0FQQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yA8GHzWRlcaxGEXWl7BRJmgZGjmnPR+93YoEuxAXvmYb1PgCQG7YXJyu7YLG93Y3UF
         +PWeYPE557LsB15OHJk/pyZl+umWEX+5Zlob776j72KGG/gGBNYnnIvuNBWceWEMyLLg
         z8mHcxqPHc2HOjfCoffKgn2zo65iyQhZfVaeU=
Date: Thu, 17 Jun 2010 20:51:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel MID platform battery driver.
Message-ID: <20100617165131.GA21141@oksana.dev.rtsoft.ru>
References: <20100617155101.21692.10433.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100617155101.21692.10433.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 04:51:43PM +0100, Alan Cox wrote:
> From: Nithish Mahalingam <nithish.mahalingam@intel.com>
> 
> The PMIC Battery driver provides battery charging and battery gauge
> functionality on Intel MID platforms. This provides the basic functions. There
> are some USB drivers to merge before the selection of charging between the
> different USB power levels can be enabled.
> 
> Moved to a platform device by Alek Du.
> 
> Signed-off-by: Nithish Mahalingam <nithish.mahalingam@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Thanks for the patch.

I reviewed this driver already:

http://lkml.org/lkml/2010/1/11/277

and I see that some (most) comments aren't addressed.

[...]
> +struct pmic_power_module_info {
> +	bool is_dev_info_updated;
> +	struct device *dev;
> +	/* pmic battery data */
> +	unsigned long update_time;		/* jiffies when data read */
> +	unsigned int usb_is_present;
> +	unsigned int batt_is_present;
> +	unsigned int batt_health;
> +	unsigned int usb_health;
> +	unsigned int batt_status;
> +	unsigned int batt_charge_now;		/* in mAS */
> +	unsigned int batt_prev_charge_full;	/* in mAS */
> +	unsigned int batt_charge_rate;		/* in units per second */

pmic_battery_get_property() returns these mAS values, which
is wrong.

Please see include/linux/power_supply.h and
Documentation/power/power_supply_class.txt:

 * All voltages, currents, charges, energies, time and temperatures in uV,
 * uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
 * stated. It's driver's job to convert its raw values to units in which
 * this class operates.

FYI, this is the only real "merge-stopper" for me, because it's
actually ABI thing.

> +	struct power_supply usb;
> +	struct power_supply batt;
> +	int irq;				/* GPE_ID or IRQ# */
> +	struct workqueue_struct *monitor_wqueue;
> +	struct delayed_work monitor_battery;
> +	struct work_struct handler;
> +};
> +
> +static unsigned int delay_time = 2000;	/* in ms */
> +
> +/*
> + * pmic ac properties
> + */
> +static enum power_supply_property pmic_usb_props[] = {
> +	POWER_SUPPLY_PROP_PRESENT,
> +	POWER_SUPPLY_PROP_HEALTH,
> +};
> +
> +/*
> + * pmic battery properties
> + */
> +static enum power_supply_property pmic_battery_props[] = {
> +	POWER_SUPPLY_PROP_STATUS,
> +	POWER_SUPPLY_PROP_HEALTH,
> +	POWER_SUPPLY_PROP_PRESENT,
> +	POWER_SUPPLY_PROP_CHARGE_NOW,
> +	POWER_SUPPLY_PROP_CHARGE_FULL,
> +	POWER_SUPPLY_PROP_CHARGE_AVG,
> +};
> +
> +
> +/*
> + * Glue functions for talking to the IPC
> + */
> +
> +struct battery_property {
> +	u32 capacity;	/* Charger capacity */
> +	u8  crnt;	/* Quick charge current value*/
> +	u8  volt;	/* Fine adjustment of constant charge voltage */
> +	u8  prot;	/* CHRGPROT register value */
> +	u8  prot2;	/* CHRGPROT1 register value */
> +	u8 timer;	/* Charging timer */

Whitespace issue(s?).

> +};
> +
> +#define IPCMSG_BATTERY		0xEF
> +
[...]
> +static void pmic_battery_read_status(struct pmic_power_module_info *pbi)
> +{
> +	unsigned int update_time_intrvl;
> +	unsigned int chrg_val;
> +	u32 ccval;
> +	u8 r8;
> +	struct battery_property batt_prop;
> +	int batt_present = 0;
> +	int usb_present = 0;
> +	int batt_exception = 0 ;

Stray whitespace.

[...]
> +/**
> + * pmic_battery_interrupt_handler - pmic battery interrupt handler
> + * Context: interrupt context
> + *
> + * PMIC battery interrupt handler which will be called with either
> + * battery full condition occurs or usb otg & battery connect
> + * condition occurs.
> + */
> +static irqreturn_t pmic_battery_interrupt_handler(int id, void *dev)
> +{
> +	struct pmic_power_module_info *pbi =
> +				(struct pmic_power_module_info *)dev;

The type cast isn't needed.

> +	schedule_work(&pbi->handler);

In the previous review I mentioned that you probably could use
request_threaded_irq().

I'm not insisting on using it, i.e. I'm OK with schedule_work()
for now, but I'm just curious why you still don't use threaded IRQ
handlers.

> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * pmic_battery_handle_intrpt - pmic battery service interrupt
> + * @work: work structure
> + * Context: can sleep
> + *
> + * PMIC battery needs to either update the battery status as full
> + * if it detects battery full condition caused the interrupt or needs
> + * to enable battery charger if it detects usb and battery detect
> + * caused the source of interrupt.
> + */
> +static void pmic_battery_handle_intrpt(struct work_struct *work)
> +{
> +	struct pmic_power_module_info *pbi = container_of(work,
> +				struct pmic_power_module_info, handler);
> +	enum batt_charge_type chrg;
> +	u8 r8;
> +
> +	/* check if pmic_power_module_info is initialized */
> +	if (!pbi)
> +		return;

This check is useless. container_of always returns non-NULL
result.

> +	if (intel_scu_ipc_ioread8(PMIC_BATT_CHR_SCHRGINT_ADDR, &r8)) {
> +		dev_warn(pbi->dev, "%s(): ipc pmic read failed\n",
> +								__func__);
> +		return;
> +	}
> +	/* find the cause of the interrupt */
> +	if (r8 & PMIC_BATT_CHR_SBATDET_MASK) {
> +		pbi->batt_is_present = PMIC_BATT_PRESENT;
> +	} else {
> +		pbi->batt_is_present = PMIC_BATT_NOT_PRESENT;
> +		pbi->batt_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +		pbi->batt_status = POWER_SUPPLY_STATUS_UNKNOWN;
> +		return;
> +	}
> +
> +	if (r8 & PMIC_BATT_CHR_EXCPT_MASK) {
> +		pbi->batt_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +		pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +		pbi->usb_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +		pmic_battery_log_event(BATT_EVENT_EXCPT);
> +		return;
> +	} else {
> +		pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
> +		pbi->usb_health = POWER_SUPPLY_HEALTH_GOOD;
> +	}
> +
> +	if (r8 & PMIC_BATT_CHR_SCOMP_MASK) {
> +		u32 ccval;
> +		pbi->batt_status = POWER_SUPPLY_STATUS_FULL;
> +
> +		if (pmic_scu_ipc_battery_cc_read(&ccval)) {
> +			dev_warn(pbi->dev, "%s(): ipc config cmd "
> +							"failed\n", __func__);
> +			return;
> +		}
> +		pbi->batt_prev_charge_full = ccval &
> +						PMIC_BATT_ADC_ACCCHRGVAL_MASK;
> +		return;
> +	}
> +
> +	if (r8 & PMIC_BATT_CHR_SUSBDET_MASK) {
> +		pbi->usb_is_present = PMIC_USB_PRESENT;
> +	} else {
> +		pbi->usb_is_present = PMIC_USB_NOT_PRESENT;
> +		pbi->usb_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +		return;
> +	}
> +
> +	/* setup battery charging */
> +
> +#if 0

Dead code? Is this a leftover, or you're going to use it soon?

> +	/* check usb otg power capability and set charger accordingly */
> +	retval = langwell_udc_maxpower(&power);
> +	if (retval) {
> +		dev_warn(pbi->dev, "%s(): usb otg power query failed "
> +				"with error code %d\n",	__func__, retval);
> +		return;
> +	}
> +
> +	if (power >= 500)
> +		chrg = BATT_USBOTG_500MA_CHARGE;
> +	else
> +#endif
> +		chrg = BATT_USBOTG_TRICKLE_CHARGE;
> +
> +	/* enable battery charging */
> +	if (pmic_battery_set_charger(pbi, chrg)) {
> +		dev_warn(pbi->dev,
> +			"%s(): failed to set up battery charging\n", __func__);
> +		return;
> +	}
> +
> +	if (debug)
> +		printk(KERN_INFO "pmic-battery: %s() - setting up battery "
> +					"charger successful\n", __func__);

dev_dbg()?

> +}
> +
> +/**
> + * pmic_battery_probe - pmic battery initialize
> + * @irq: pmic battery device irq
> + * @dev: pmic battery device structure
> + * Context: can sleep
> + *
> + * PMIC battery initializes its internal data structue and other
> + * infrastructure components for it to work as expected.
> + */
> +static __devinit int probe(int irq, struct device *dev)
> +{
> +	int retval = 0;
> +	struct pmic_power_module_info *pbi = 0;

Do not initialize pointers with 0. Plus, you don't actually need
to initialize pbi here.

> +	if (debug)
> +		printk(KERN_INFO "pmic-battery: found pmic battery device\n");

dev_dbg()?

> +	pbi = kzalloc(sizeof(*pbi), GFP_KERNEL);
> +	if (!pbi) {
> +		dev_err(dev, "%s(): memory allocation failed\n",
> +								__func__);
> +		return -ENOMEM;
> +	}
> +
> +	pbi->dev = dev;
> +	pbi->irq = irq;
> +	dev_set_drvdata(dev, pbi);
> +
> +	/* initialize all required framework before enabling interrupts */
> +	INIT_WORK(&pbi->handler, (void *)pmic_battery_handle_intrpt);

No need for the (void *) cast.

> +	INIT_DELAYED_WORK(&pbi->monitor_battery, pmic_battery_monitor);
> +	pbi->monitor_wqueue =
> +			create_singlethread_workqueue(dev_name(dev));
> +	if (!pbi->monitor_wqueue) {
> +		dev_err(dev, "%s(): wqueue init failed\n", __func__);
> +		retval = -ESRCH;
> +		goto wqueue_failed;
> +	}
> +
> +	/* register interrupt */
> +	retval = request_irq(pbi->irq, pmic_battery_interrupt_handler,
> +							0, DRIVER_NAME, pbi);

I think you'd better use dev_name() instead of DRIVER_NAME here,
to distinguish interrupts from several devices.

> +	if (retval) {
> +		dev_err(dev, "%s(): cannot get IRQ\n", __func__);
> +		goto requestirq_failed;
> +	}
> +
> +	/* register pmic-batt with power supply subsystem */
> +	pbi->batt.name = "pmic-batt";

This won't work if we have several pmic batteries. I think you need
kasprintf(GFP_KERNEL, "%s-batt", dev_name(..));

> +	pbi->batt.type = POWER_SUPPLY_TYPE_BATTERY;
> +	pbi->batt.properties = pmic_battery_props;
> +	pbi->batt.num_properties = ARRAY_SIZE(pmic_battery_props);
> +	pbi->batt.get_property = pmic_battery_get_property;
> +	retval = power_supply_register(dev, &pbi->batt);
> +	if (retval) {
> +		dev_err(dev,
> +			"%s(): failed to register pmic battery device with power supply subsystem\n",
> +				__func__);
> +		goto power_reg_failed;
> +	}
> +
> +	if (debug)
> +		printk(KERN_INFO "pmic-battery: %s() - pmic battery device "
> +				"registration with power supply subsystem "
> +				"successful\n", __func__);

dev_info()?

> +	queue_delayed_work(pbi->monitor_wqueue, &pbi->monitor_battery, HZ * 1);
> +
> +	/* register pmic-usb with power supply subsystem */
> +	pbi->usb.name = "pmic-usb";

kasprintf(GFP_KERNEL, "%s-usb", dev_name(..));

> +	pbi->usb.type = POWER_SUPPLY_TYPE_USB;
> +	pbi->usb.properties = pmic_usb_props;
> +	pbi->usb.num_properties = ARRAY_SIZE(pmic_usb_props);
> +	pbi->usb.get_property = pmic_usb_get_property;
> +	retval = power_supply_register(dev, &pbi->usb);
> +	if (retval) {
> +		dev_err(dev,
> +			"%s(): failed to register pmic usb device with power supply subsystem\n",
> +				__func__);
> +		goto power_reg_failed_1;
> +	}
> +
> +	if (debug)
> +		printk(KERN_INFO "pmic-battery: %s() - pmic usb device "
> +			"registration with power supply subsystem successful\n",
> +			__func__);

dev_info()?

> +	return retval;
> +
> +power_reg_failed_1:
> +	power_supply_unregister(&pbi->batt);
> +power_reg_failed:
> +	cancel_rearming_delayed_workqueue(pbi->monitor_wqueue,
> +						&pbi->monitor_battery);
> +requestirq_failed:
> +	destroy_workqueue(pbi->monitor_wqueue);
> +wqueue_failed:
> +	kfree(pbi);
> +
> +	return retval;
> +}
> +
> +static int __devinit platform_pmic_battery_probe(struct platform_device *pdev)
> +{
> +	return probe(pdev->id, &pdev->dev);
> +}
> +
> +/**
> + * pmic_battery_remove - pmic battery finalize
> + * @dev: pmic battery device structure
> + * Context: can sleep
> + *
> + * PMIC battery finalizes its internal data structue and other
> + * infrastructure components that it initialized in
> + * pmic_battery_probe.
> + */
> +
> +static int __devexit remove(struct device *dev)

Looks like too broad identifier.

> +{
> +	struct pmic_power_module_info *pbi = dev_get_drvdata(dev);
> +
> +	if (pbi) {

The check isn't needed. _remove() won't run if device didn't probe
successfully.

> +		free_irq(pbi->irq, pbi);
> +
> +		cancel_rearming_delayed_workqueue(pbi->monitor_wqueue,
> +						&pbi->monitor_battery);
> +		destroy_workqueue(pbi->monitor_wqueue);
> +
> +		power_supply_unregister(&pbi->usb);
> +		power_supply_unregister(&pbi->batt);
> +
> +		flush_scheduled_work();
> +
> +		kfree(pbi);
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit platform_pmic_battery_remove(struct platform_device *pdev)
> +{
> +	return remove(&pdev->dev);

This can be merged with remove() above.

> +}
> +
> +static struct platform_driver platform_pmic_battery_driver = {
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = platform_pmic_battery_probe,
> +	.remove = platform_pmic_battery_remove,

__devexit_p(platform_pmic_battery_remove)?

> +};
> +
> +static int __init platform_pmic_battery_module_init(void)
> +{
> +	return platform_driver_register(&platform_pmic_battery_driver);
> +}
> +
> +static void __exit platform_pmic_battery_module_exit(void)
> +{
> +	platform_driver_unregister(&platform_pmic_battery_driver);
> +}
> +
> +module_init(platform_pmic_battery_module_init);
> +module_exit(platform_pmic_battery_module_exit);
> +
> +MODULE_AUTHOR("Nithish Mahalingam <nithish.mahalingam@intel.com>");
> +MODULE_DESCRIPTION("Intel Moorestown PMIC Battery Driver");
> +MODULE_LICENSE("GPL");

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
