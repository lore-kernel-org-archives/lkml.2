Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0JOOhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:37:52 -0400
Received: from www.tglx.de ([62.245.132.106]:44791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab0JOOhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:37:51 -0400
Date: Fri, 15 Oct 2010 16:37:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [RESEND PATCH] x86/mrst: add SFI platform device parsing code
In-Reply-To: <20101014142924.12442.3219.stgit@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1010151443520.2496@localhost6.localdomain6>
References: <20101014142924.12442.3219.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Alan Cox wrote:
> index 4a711a6..cb8fb61 100644
> --- a/arch/x86/include/asm/mrst.h
> +++ b/arch/x86/include/asm/mrst.h
> @@ -14,6 +14,7 @@
>  #include <linux/sfi.h>
>  
>  extern int pci_mrst_init(void);
> +

Stray newline

>  int __init sfi_parse_mrtc(struct sfi_table_header *table);
>  
>  /*
> @@ -50,4 +51,8 @@ extern void mrst_early_console_init(void);
>  
>  extern struct console early_hsu_console;
>  extern void hsu_early_console_init(void);
> +
> +extern void intel_scu_devices_create(void);
> +extern void intel_scu_devices_destroy(void);
> +
>  #endif /* _ASM_X86_MRST_H */
> diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
> index 79ae681..0bf74c5 100644
> --- a/arch/x86/kernel/mrst.c
> +++ b/arch/x86/kernel/mrst.c
> @@ -12,6 +12,14 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/sfi.h>
> +#include <linux/intel_pmic_gpio.h>
> +#include <linux/spi/spi.h>
> +#include <linux/i2c.h>
> +#include <linux/sfi.h>

  linux/sfi.h  is already included above

> +#include <linux/i2c/pca953x.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +#include <linux/platform_device.h>
>  #include <linux/irq.h>
>  #include <linux/module.h>
>  
> @@ -23,6 +31,7 @@
>  #include <asm/mrst.h>
>  #include <asm/io.h>
>  #include <asm/i8259.h>
> +#include <asm/intel_scu_ipc.h>
>  #include <asm/apb_timer.h>
>  
>  /*
> @@ -309,3 +318,694 @@ static inline int __init setup_x86_mrst_timer(char *arg)
>  	return 0;
>  }
>  __setup("x86_mrst_timer=", setup_x86_mrst_timer);
> +
> +/*
> + * Parsing GPIO table first, since the DEVS table will need this table
> + * to map the pin name to the actual pin.
> + */
> +static struct sfi_gpio_table_entry *gpio_table;
> +static int gpio_num_entry;
> +
> +static int __init sfi_parse_gpio(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_gpio_table_entry *pentry;
> +	int num, i;
> +
> +	if (gpio_table)
> +		return 0;
> +	sb = (struct sfi_table_simple *)table;
> +	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
> +	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
> +
> +	gpio_table = (struct sfi_gpio_table_entry *)
> +				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
> +	if (!gpio_table)
> +		return -1;
> +	memcpy(gpio_table, pentry, num * sizeof(*pentry));
> +	gpio_num_entry = num;
> +
> +	pr_info("Moorestown GPIO pin info:\n");
> +	for (i = 0; i < num; i++, pentry++)
> +		pr_info("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
> +		" pin = %d\n", i,
> +			pentry->controller_name,
> +			pentry->pin_name,
> +			pentry->pin_no);

Shouldn't this be pr_debug ? Also MRST boot seems to be printing out
the world and some more in a completely inconsistent way. Grep will
fail miserably to get any info from this noise.

> +	return 0;
> +}
> +
> +static int get_gpio_by_name(const char *name)
> +{
> +	struct sfi_gpio_table_entry *pentry = gpio_table;
> +	int i;
> +
> +	if (!pentry)
> +		return -1;
> +	for (i = 0; i < gpio_num_entry; i++, pentry++) {
> +		if (!strncmp(name, pentry->pin_name, 16))

Can we please make this 16/17 string length stuff all over the place a
readable define like SFI_DEVNAME_LEN instead of a magic number ?

> +			return pentry->pin_no;
> +	}
> +	return -1;
> +}
> +
> +/*
> + * Here defines the array of devices platform data that IAFW would export
> + * through SFI "DEVS" table, we use name and type to match the device and
> + * its platform data.
> + */
> +struct devs_id {
> +	char name[17];
> +	u8 type;
> +	u8 delay;
> +	void *(*get_platform_data)(void *info);
> +};
> +
> +/* the offset for the mapping of global gpio pin to irq */
> +#define MRST_IRQ_OFFSET 0x100

Uuurg. How does the gpio irq chip implementation know about this
number ? Another define somewhere else ?

We really should _NOT_ hardcode this in several places. The gpio code
is providing the irq chip implementation, right? So that code should
allocate the irq numbers and provide the base number to code which
uses it by some sensible mechanism.

Btw, the irq rework which is pending for 37 allows you to allocate a
consecutive range of interrupts and reserve it so it can't be used by
create_irq() or any other thing which allocates irqs dynamically.

> +
> +static void *pmic_gpio_platform_data(void *info)
> +{
> +	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
> +	int gpio_base = get_gpio_by_name("pmic_gpio_base");
> +
> +	if (gpio_base == -1)
> +		gpio_base = 64;	/* Needed for 0.7 SFI firmware */

Hmm, for 0.8 firmware this will do the same thing, when the
pmic_gpio_base entry or the gpio table itself are missing. So how is
this 0.7 specific and what are the consequences when the table is
wrong or the entry missing on purpose?

> +	pmic_gpio_pdata.gpio_base = gpio_base;
> +	pmic_gpio_pdata.irq_base = gpio_base + MRST_IRQ_OFFSET;
> +	pmic_gpio_pdata.gpiointr = 0xffffeff8;
> +
> +	return &pmic_gpio_pdata;
> +}
> +
> +static void *max3111_platform_data(void *info)
> +{
> +	static int dummy;
> +	struct spi_board_info *spi_info = (struct spi_board_info *)info;

Typecasting void* is pretty pointless.

> +	int intr = get_gpio_by_name("max3111_int");
> +
> +	if (intr == -1)
> +		return NULL;
> +	spi_info->irq = intr + MRST_IRQ_OFFSET;
> +	/* we return a dummy pdata */
> +	return &dummy;
> +}
> +
> +/* we have multiple max7315 on the board ... */
> +#define MAX7315_NUM 2
> +static void *max7315_platform_data(void *info)
> +{
> +	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
> +	static int nr;
> +	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
> +	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;
> +	int gpio_base;
> +	int intr;

  int gpio_base, intr;

Please

> +	char base_pin_name[17];
> +	char intr_pin_name[17];
> +
> +	if (nr == MAX7315_NUM) {
> +		printk(KERN_ERR "too many max7315s, we only support %d\n",
> +				MAX7315_NUM);

  pr_err() perhaps ?

These printks, pr_info, pr_err ...  lack a consistent prefix like
"MRST: " all over the place. IIRC pr_xxx supports that already.

> +		return NULL;
> +	}
> +	/* we have several max7315 on the board, we only need load several
> +	 * instances of the same pca953x driver to cover them
> +	 */
> +	strcpy(i2c_info->type, "max7315");
> +	if (nr++) {
> +		sprintf(base_pin_name, "max7315_%d_base", nr);
> +		sprintf(intr_pin_name, "max7315_%d_int", nr);
> +	} else {
> +		strcpy(base_pin_name, "max7315_base");
> +		strcpy(intr_pin_name, "max7315_int");
> +	}
> +
> +	gpio_base = get_gpio_by_name(base_pin_name);
> +	intr = get_gpio_by_name(intr_pin_name);

So these pin numbers are taken as is from the SFI table. Are those
tables more trustworthy than ACPI tables? I'm not seeing that there is
any basic sanity checking on those entries.

> +	if (gpio_base == -1)
> +		return NULL;
> +	max7315->gpio_base = gpio_base;
> +	if (intr != -1) {
> +		i2c_info->irq = intr + MRST_IRQ_OFFSET;
> +		max7315->irq_base = gpio_base + MRST_IRQ_OFFSET;
> +	} else {
> +		i2c_info->irq = -1;
> +		max7315->irq_base = -1;
> +	}
> +	return max7315;
> +}

> +static void intel_scu_device_register(struct platform_device *pdev)
> +{
> +	BUG_ON(ipc_next_dev == MAX_IPCDEVS);

Why crash the machine here ? Above you don't care when the pin number
is 4711 or whatever.

> +	ipc_devs[ipc_next_dev++] = pdev;
> +}
> +
> +static void intel_delayed_spi_device_register(struct spi_board_info *sdev)
> +{
> +	struct spi_board_info *new_dev;
> +
> +	BUG_ON(spi_next_dev == MAX_DELAYED_SPI);
> +

Ditto

> +/* Called by IPC driver */
> +void intel_scu_devices_create(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ipc_next_dev; i++)
> +		platform_device_add(ipc_devs[i]);
> +
> +	for (i = 0; i < spi_next_dev; i++) {
> +		spi_register_board_info(spi_devs[i], 1);
> +		kfree(spi_devs[i]);

Hmm, we kfree but keep the reference in spi_devs.

> +	}
> +
> +	for (i = 0; i < i2c_next_dev; i++) {
> +		struct i2c_adapter *adapter;
> +		struct i2c_client *client;
> +
> +		adapter = i2c_get_adapter(i2c_bus[i]);
> +		if (adapter) {
> +			client = i2c_new_device(adapter, i2c_devs[i]);
> +			if (!client)
> +				pr_err("mrst: can't create i2c device %s\n",
> +					i2c_devs[i]->type);
> +		} else
> +			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
> +		kfree(i2c_devs[i]);

Ditto

> +static void install_irq_resource(struct platform_device *pdev, int irq)
> +{
> +	/* Single threaded */
> +	static struct resource res = {
> +		.name = "IRQ",
> +		.flags = IORESOURCE_IRQ,
> +	};

And why needs this to be static and cant be just on the stack ?

> +	res.start = irq;
> +	platform_device_add_resources(pdev, &res, 1);
> +}

> +static int sfi_force_ipc(const char *name)
> +{
> +	static const char *to_force[] = {
> +		"pmic_gpio",
> +		"pmic_battery",
> +		"pmic_touch",
> +		"pmic_audio",
> +		"msic_audio",
> +		NULL
> +	};
> +	const char **p = &to_force[0];
> +	while (*p != NULL) {
> +		if (strcmp(*p, name) == 0)
> +			return 1;
> +		p++;
> +	}
> +	return 0;
> +}

Aren't most of these functions including the static arrays inside of
the functions __init ?

> +static void sfi_handle_spi_dev(struct spi_board_info *spi_info)
> +{
> +	const struct devs_id *dev = device_ids;
> +	void *pdata = NULL;
> +
> +	/* Older firmware lists some IPC devices as SPI. We want to force
> +	   these to be the correct type for Linux */
> +	if (sfi_force_ipc(spi_info->modalias)) {
> +		/* Allocate a platform device, and translate the device
> +		   configuration, then use the ipc helper. */
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc(spi_info->modalias,
> +					spi_info->irq);
> +		if (pdev == NULL) {
> +			pr_err("out of memory for SFI platform device '%s'.\n",
> +						spi_info->modalias);
> +			return;
> +		}
> +		install_irq_resource(pdev, spi_info->irq);
> +		sfi_handle_ipc_dev(pdev);
> +		return;
> +	}
> +
> +
> +	while (dev->name[0]) {
> +		if (dev->type == SFI_DEV_TYPE_SPI &&
> +				!strncmp(dev->name, spi_info->modalias, 16)) {
> +			pdata = dev->get_platform_data(spi_info);
> +			break;
> +		}
> +		dev++;
> +	}
> +	spi_info->platform_data = pdata;
> +	if (dev->delay)

What's the reason of this delay magic ? I guess the scu module needs
to be loaded, right? Took me a time to figure it out. So can we give
that a sensible function name which makes that obvious ?

> +		intel_delayed_spi_device_register(spi_info);
> +	else
> +		spi_register_board_info(spi_info, 1);
> +}
> +

> +#define MRST_SPI2_CS_START	4

Where's that magic constant coming from and is it never subject to
change on later MRST incarnations ?

> +static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;

How is that different from pmic_gpio_pdata in
pmic_gpio_platform_data() and why do we need two incarnations of the
same data structure with the same name in different places ?

> +static int __init sfi_parse_spib(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_spi_table_entry *pentry;
> +	struct spi_board_info *info;
> +	int num, i, j;
> +	int ioapic;
> +	struct io_apic_irq_attr irq_attr;
> +
> +	sb = (struct sfi_table_simple *)table;
> +	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_spi_table_entry);
> +	pentry = (struct sfi_spi_table_entry *) sb->pentry;
> +
> +	info = kzalloc(num * sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		pr_info("%s(): Error in kzalloc\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	if (num)
> +		pr_info("Moorestown SPI devices info:\n");
> +
> +	for (i = 0, j = 0; i < num; i++, pentry++) {
> +		strncpy(info[j].modalias, pentry->name, 16);
> +		info[j].irq = pentry->irq_info;
> +		info[j].bus_num = pentry->host_num;
> +		info[j].chip_select = pentry->cs;
> +		info[j].max_speed_hz = 3125000;	/* hard coded */
> +		if (info[i].chip_select >= MRST_SPI2_CS_START) {
> +			/* these SPI2 devices are not exposed to system as PCI
> +			 * devices, but they have separate RTE entry in IOAPIC
> +			 * so we have to enable them one by one here
> +			 */
> +			ioapic = mp_find_ioapic(info[j].irq);
> +			irq_attr.ioapic = ioapic;
> +			irq_attr.ioapic_pin = info[j].irq;
> +			irq_attr.trigger = 1;
> +			irq_attr.polarity = 1;
> +			io_apic_set_pci_routing(NULL, info[j].irq,
> +							&irq_attr);
> +		}
> +		info[j].platform_data = pentry->dev_info;
> +
> +		if (!strcmp(pentry->name, "pmic_gpio")) {
> +			memcpy(&pmic_gpio_pdata, pentry->dev_info, 8);
> +			pmic_gpio_pdata.gpiointr = 0xffffeff8;
> +			info[j].platform_data = &pmic_gpio_pdata;
> +		}
> +		pr_info("info[%d]: name = %16.16s, irq = 0x%04x, bus = %d, "
> +			"cs = %d\n", j, info[j].modalias, info[j].irq,
> +			info[j].bus_num, info[j].chip_select);
> +		sfi_handle_spi_dev(&info[j]);
> +		j++;
> +	}
> +	kfree(info);
> +	return 0;
> +}
> +
> +#define MRST_I2C_BUSNUM	3
> +static struct pca953x_platform_data max7315_pdata;
> +static struct pca953x_platform_data max7315_pdata_2;

Again. 

Guys, this is confusing as hell and needs a cleanup. I understand that
your firmware dudes suck big time, but replicating the suckage in the
kernel is even worse. I don't want to see the code which is cooking
for SFI version 0.9.

So either consolidate this or split out the horror into different
source files so it's entirely clear which clusterfuck is necessary for
which broken version of SFI.

While at it we really need to start to move that stuff into a separate
directory. arch/x86/kernel has become the dumpground for everything
and some more. We are going to see a gazillion of mrst, sodaville and
next gen support files, which really have nothing to do with the core
kernel functionality of x86.

> +static int __init mrst_platform_init(void)
> +{
> +	/* Keep for back compatibility for SFI 0.7 and before */
> +	sfi_table_parse(SFI_SIG_SPIB, NULL, NULL, sfi_parse_spib);
> +	sfi_table_parse(SFI_SIG_I2CB, NULL, NULL, sfi_parse_i2cb);
> +
> +	/* For SFi 0.8 version */
> +	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
> +	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
> +	return 0;
> +}
> +arch_initcall(mrst_platform_init);
> +
> +/*
> + * we will search these buttons in SFI GPIO table (by name)
> + * and register them dynamically. Please add all possible
> + * buttons here, we will shrink them if no GPIO found.
> + */
> +static struct gpio_keys_button gpio_button[] = {
> +	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},

Please use proper C99 initializers. struct initializers relying on the
struct order hardcoded suck.

> +	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
> +	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
> +	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
> +	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
> +	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
> +	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
> +	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
> +	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
> +	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
> +	{-1},/* must be ended with code = -1 */
> +};

> +/* shrink non-existent buttons and return total available number */
> +static int __init pb_shrink(void)
> +{
> +	struct gpio_keys_button *gb = gpio_button;
> +	struct gpio_keys_button *next = NULL;
> +	int num = 0;
> +
> +	while (gb->code != -1) {
> +		if (gb->gpio == -1) {
> +			if (!next)
> +				next = gb + 1;
> +			while (next->code != -1 && next->gpio == -1)
> +				next++;
> +			if (next->code == -1)/* end */
> +				break;
> +			*gb = *next;
> +			next->gpio = -1;
> +			next++;
> +		}
> +		num++;
> +		gb++;
> +	}
> +	return num;

This function should be written into one line and submitted to the
obfuscated c-code contest.

What about making gpio_button __init_data and let pb_shrink copy the
real entries to gpio_button_real, which even could be kmalloc'ed with
the proper size ?

> +}
> +
> +static int __init pb_keys_init(void)
> +{
> +	int num;
> +	/* for SFI 0.7, we have to claim static gpio buttons */
> +	if (!gpio_table) {
> +		pb_match("power_btn", 65);
> +		pb_match("prog_btn1", 66);
> +		pb_match("prog_btn2", 69);
> +		pb_match("lid_switch", 101);
> +	} else {/* SFI 0.8 */
> +		struct gpio_keys_button *gb = gpio_button;
> +
> +		while (gb->code != -1) {
> +			gb->gpio = get_gpio_by_name(gb->desc);
> +			gb++;
> +		}
> +	}
> +	num = pb_shrink();
> +	if (num) {
> +		mrst_gpio_keys.nbuttons = num;
> +		return platform_device_register(&pb_device);
> +	}
> +	return 0;
> +}
> +
> +late_initcall(pb_keys_init);
> +
> diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
> index 41a9e34..ca35b0c 100644
> --- a/drivers/platform/x86/intel_scu_ipc.c
> +++ b/drivers/platform/x86/intel_scu_ipc.c
> @@ -26,6 +26,7 @@
>  #include <linux/sfi.h>
>  #include <asm/mrst.h>
>  #include <asm/intel_scu_ipc.h>
> +#include <asm/mrst.h>

asm/mrst.h is included already and that hunk does not apply to any
tree I can find.

Thanks,

	tglx
