Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0DPQMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:12:25 -0400
Received: from mga12.intel.com ([143.182.124.36]:35653 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756767Ab0DPQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:12:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,220,1270450800"; 
   d="scan'208";a="266566156"
Date: Fri, 16 Apr 2010 18:12:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH 3/3] MFD: AB3550 core driver
Message-ID: <20100416161248.GB28863@sortiz.org>
References: <1271113543-7303-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271113543-7303-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Apr 13, 2010 at 01:05:43AM +0200, Linus Walleij wrote:
> This adds a core driver for the AB3550 mixed-signal circuit
> found in the ST-Ericsson U300 platforms. This driver
> is a singleton proxy for all access to the AB3550
> sub-drivers which will be merged on top of this one: RTC,
> regulators, battery and system power control, vibrator,
> LEDs and an ALSA codec.

Some comments:

> diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
> index d893ee0..f0394ba 100644
> --- a/arch/arm/mach-u300/i2c.c
> +++ b/arch/arm/mach-u300/i2c.c
I'd like the machine specific files to be part of a separate patch, please.



> @@ -46,6 +46,7 @@
>  /* BUCK SLEEP 0xAC: 1.05V, Not used, SLEEP_A and B, Not used */
>  #define BUCK_SLEEP_SETTING	0xAC
>  
> +#ifdef CONFIG_AB3100_CORE
>  static struct regulator_consumer_supply supply_ldo_c[] = {
>  	{
>  		.dev_name = "ab3100-codec",
> @@ -253,14 +254,68 @@ static struct ab3100_platform_data ab3100_plf_data = {
>  		LDO_D_SETTING,
>  	},
>  };
> +#endif
> +
> +#ifdef CONFIG_AB3550_CORE
> +static struct abx500_init_settings ab3550_init_settings[] = {
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR1,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR2,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR3,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR4,
> +		.setting = 0xff
> +	},
> +	{
> +		.bank = 0,
> +		.reg = AB3550_IMR5,
> +		/* The two most significant bits are not used */
> +		.setting = 0x3f
> +	},
> +};
> +
> +static struct ab3550_platform_data ab3550_plf_data = {
> +	.irq = {
> +		.base = IRQ_AB3550_BASE,
> +		.count = (IRQ_AB3550_END - IRQ_AB3550_BASE + 1),
> +	},
> +	.dev_data = {
> +	},
> +	.init_settings = ab3550_init_settings,
> +	.init_settings_sz = ARRAY_SIZE(ab3550_init_settings),
> +};
> +#endif
>  
>  static struct i2c_board_info __initdata bus0_i2c_board_info[] = {
> +#if defined(CONFIG_AB3550_CORE)
> +	{
> +		.type = "ab3550",
> +		.addr = 0x4A,
> +		.irq = IRQ_U300_IRQ0_EXT,
> +		.platform_data = &ab3550_plf_data,
> +	},
> +#elif defined(CONFIG_AB3100_CORE)
>  	{
>  		.type = "ab3100",
>  		.addr = 0x48,
>  		.irq = IRQ_U300_IRQ0_EXT,
>  		.platform_data = &ab3100_plf_data,
>  	},
> +#else
> +	{ },
> +#endif
All those ifdefs really look like they should be part of your board definition
files.


> +/**
> + * struct ab3550_reg_range
> + * @first: the first address of the range
> + * @last: the last address of the range
> + * @perm: access permissions for the range
> + */
> +struct ab3550_reg_range {
> +	u8 first;
> +	u8 last;
> +	u8 perm;
> +};
I wonder if you could simply use struct resource for that purpose.

> +/*
> + * I2C transactions with error messages.
> + */
> +static int ab3550_i2c_master_send(struct ab3550 *ab, u8 bank, u8 *data,
> +	u8 count)
> +{
> +	int err;
> +
> +	err = i2c_master_send(ab->i2c_client[bank], data, count);
> +	if (err < 0) {
> +		dev_err(&ab->i2c_client[0]->dev, "send error: %d\n", err);
> +	} else if (err != count) {
> +		dev_err(&ab->i2c_client[0]->dev,
> +			"send error: %d bytes transferred (expected %d)\n",
> +			err, count);
> +		err = -EIO;
> +	} else {
> +		err = 0;
> +	}
> +	return err;
> +}
This one could be simplified, as i2c_master_send() either return the negative
error number or count. So, this routine could look like:

static int ab3550_i2c_master_send(struct ab3550 *ab, u8 bank, u8 *data,
	u8 count)
{
	int err;

	err = i2c_master_send(ab->i2c_client[bank], data, count);
	if (err < 0) {
		dev_err(&ab->i2c_client[0]->dev, "send error: %d\n", err);
		return err;
	}

	return 0;
}


> +static int ab3550_i2c_master_recv(struct ab3550 *ab, u8 bank, u8 *data,
> +	u8 count)
> +{
> +	int err;
> +
> +	err = i2c_master_recv(ab->i2c_client[bank], data, count);
> +	if (err < 0) {
> +		dev_err(&ab->i2c_client[0]->dev, "receive error: %d\n", err);
> +	} else if (err != count) {
> +		dev_err(&ab->i2c_client[0]->dev,
> +			"receive error: %d bytes transferred (expected %d)\n",
> +			err, count);
> +		err = -EIO;
> +	} else {
> +		err = 0;
> +	}
> +	return err;
> +}
Ditto.

> +static bool reg_read_allowed(const struct ab3550_reg_ranges *ranges, u8 reg)
> +{
> +	return page_read_allowed(ranges, reg, reg);
> +}
> +
> +/*
> + * The exported register access functionality.
> + */
> +int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
> +	u8 value)
> +{
> +	return abx500_mask_and_set_register_interruptible(dev, bank, reg, 0xFF,
> +		value);
> +}
> +EXPORT_SYMBOL(abx500_set_register_interruptible);
> +
> +int abx500_get_register_interruptible(struct device *dev, u8 bank, u8 reg,
> +	u8 *value)
> +{
> +	struct ab3550 *ab;
> +	struct ab3550_dev *abdev;
> +
> +	abdev = to_ab3550_dev(dev);
> +	if ((AB3550_NUM_BANKS <= bank) ||
> +		!reg_read_allowed(&abdev->reg_ranges[bank], reg))
> +		return -EINVAL;
> +
> +	ab = dev_get_drvdata(dev->parent);
> +	return get_register_interruptible(ab, bank, reg, value);
> +}
> +EXPORT_SYMBOL(abx500_get_register_interruptible);
> +
> +int abx500_get_register_page_interruptible(struct device *dev, u8 bank,
> +	u8 first_reg, u8 *regvals, u8 numregs)
> +{
> +	struct ab3550 *ab;
> +	struct ab3550_dev *abdev;
> +
> +	abdev = to_ab3550_dev(dev);
> +	if ((AB3550_NUM_BANKS <= bank) ||
> +		!page_read_allowed(&abdev->reg_ranges[bank], first_reg,
> +			(first_reg + numregs - 1)))
> +		return -EINVAL;
> +
> +	ab = dev_get_drvdata(dev->parent);
> +	return get_register_page_interruptible(ab, bank, first_reg, regvals,
> +		numregs);
> +}
> +EXPORT_SYMBOL(abx500_get_register_page_interruptible);
> +
> +int abx500_mask_and_set_register_interruptible(struct device *dev, u8 bank,
> +	u8 reg, u8 bitmask, u8 bitvalues)
> +{
> +	struct ab3550 *ab;
> +	struct ab3550_dev *abdev;
> +
> +	abdev = to_ab3550_dev(dev);
> +	if ((AB3550_NUM_BANKS <= bank) ||
> +		!reg_write_allowed(&abdev->reg_ranges[bank], reg))
> +		return -EINVAL;
> +
> +	ab = dev_get_drvdata(dev->parent);
> +	return mask_and_set_register_interruptible(ab, bank, reg,
> +		 bitmask, bitvalues);
> +}
> +EXPORT_SYMBOL(abx500_mask_and_set_register_interruptible);
All those exports here will conflict with the new ones from your 2nd patch.
This is not acceptable as there is nothing (and there shouldnt be) preventing
me from building both at the same time.

You either have one driver for all those chips or you keep 2 of them but them
you need to have 2 separate namespaces.

> +/*
> + * Basic set-up, datastructure creation/destruction and I2C interface.
> + * This sets up a default config in the AB3550 chip so that it
> + * will work as expected.
> + */
> +static int __init ab3550_setup(struct ab3550 *ab)
> +{
> +	int err = 0;
> +	int i;
> +	struct ab3550_platform_data *plf_data;
> +
> +	plf_data = ab->i2c_client[0]->dev.platform_data;
In the loop below, you're referencing plf_data->init_settings at least 6
times. Having a settings = plf_data->init_settings would be more efficient
(although I suspect gcc is smart enough to do that for you) but also would
make your code more readable.

> +static void ab3550_mask_work(struct work_struct *work)
> +{
> +	struct ab3550 *ab = container_of(work, struct ab3550, mask_work);
> +	int i;
> +	unsigned long flags;
> +	u8 mask[AB3550_NUM_EVENT_REG];
> +
> +	spin_lock_irqsave(&ab->event_lock, flags);
> +	for (i = 0; i < AB3550_NUM_EVENT_REG; i++)
> +		mask[i] = ab->event_mask[i];
> +	spin_unlock_irqrestore(&ab->event_lock, flags);
Unless you're strongly against it, please add new lines to to your code. In
general this driver as a lot of block codes not separated by newlines. It
makes this code look compact and difficult to read. At least to me.


> +static int __init ab3550_probe(struct i2c_client *client,
> +	const struct i2c_device_id *id)
> +{
> +	struct ab3550 *ab;
> +	struct ab3550_platform_data *ab3550_plf_data =
> +		client->dev.platform_data;
> +	int err;
> +	int i;
> +	int num_i2c_clients = 0;
> +
> +	ab = kzalloc(sizeof(struct ab3550), GFP_KERNEL);
> +	if (!ab) {
> +		dev_err(&client->dev,
> +			"could not allocate " AB3550_NAME_STRING " device\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Initialize data structure */
> +	mutex_init(&ab->access_mutex);
> +	spin_lock_init(&ab->event_lock);
> +	ab->i2c_client[0] = client;
> +
> +	i2c_set_clientdata(client, ab);
> +
> +	/* Read chip ID register */
> +	err = get_register_interruptible(ab, 0, AB3550_CID_REG, &ab->chip_id);
> +	if (err) {
> +		dev_err(&client->dev, "could not communicate with the analog "
> +			"baseband chip\n");
> +		goto exit_no_detect;
> +	}
> +
> +	for (i = 0; ids[i].id != 0x0; i++) {
> +		if (ids[i].id == ab->chip_id) {
> +			snprintf(&ab->chip_name[0], sizeof(ab->chip_name) - 1,
> +				 AB3550_ID_FORMAT_STRING, ids[i].name);
> +			break;
> +		}
> +	}
> +
> +	if (ids[i].id == 0x0) {
> +		dev_err(&client->dev, "unknown analog baseband chip id: 0x%x\n",
> +			ab->chip_id);
> +		dev_err(&client->dev, "driver not started!\n");
> +		goto exit_no_detect;
> +	}
> +
> +	dev_info(&client->dev, "detected AB chip: %s\n", &ab->chip_name[0]);
> +
> +	/* Attach other dummy I2C clients. */
> +	while (++num_i2c_clients < AB3550_NUM_BANKS) {
> +		ab->i2c_client[num_i2c_clients] =
> +			i2c_new_dummy(client->adapter,
> +				(client->addr + num_i2c_clients));
> +		if (!ab->i2c_client[num_i2c_clients]) {
> +			err = -ENOMEM;
> +			goto exit_no_dummy_client;
> +		}
> +		strlcpy(ab->i2c_client[num_i2c_clients]->name, id->name,
> +			sizeof(ab->i2c_client[num_i2c_clients]->name));
> +	}
> +
> +	err = ab3550_setup(ab);
> +	if (err)
> +		goto exit_no_setup;
> +
> +	INIT_WORK(&ab->mask_work, ab3550_mask_work);
> +
> +	for (i = 0; i < ab3550_plf_data->irq.count; i++) {
> +		unsigned int irq;
> +
> +		irq = ab3550_plf_data->irq.base + i;
> +		set_irq_chip_data(irq, ab);
> +		set_irq_chip_and_handler(irq, &ab3550_irq_chip,
> +			handle_simple_irq);
> +		set_irq_nested_thread(irq, 1);
> +		set_irq_flags(irq, IRQF_VALID);
> +	}
> +
> +	err = request_threaded_irq(client->irq, NULL, ab3550_irq_handler,
> +			   IRQF_ONESHOT, "ab3550-core", ab);
> +	/* This real unpredictable IRQ is of course sampled for entropy */
> +	rand_initialize_irq(client->irq);
> +
> +	if (err)
> +		goto exit_no_irq;
> +
> +	/* Set up and register the platform devices. */
> +	for (i = 0; i < AB3550_NUM_DEVICES; i++) {
> +		unsigned int j;
> +		struct resource *res;
> +
> +		ab3550_devs[i].pdev.dev.parent = &client->dev;
> +		ab3550_devs[i].pdev.dev.platform_data =
> +			ab3550_plf_data->dev_data[i];
> +		res = ab3550_devs[i].pdev.resource;
> +		for (j = 0; j < ab3550_devs[i].pdev.num_resources; res++, j++) {
> +			if (res->flags & IORESOURCE_IRQ) {
> +				res->start += ab3550_plf_data->irq.base;
> +				res->end += ab3550_plf_data->irq.base;
> +			}
> +		}
> +		platform_device_register(&ab3550_devs[i].pdev);
> +	}
I would really like you to consider using the mfd-core API for registering
your sub devices.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
