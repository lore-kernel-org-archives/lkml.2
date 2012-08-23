Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2HWIzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:55:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44132 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2HWIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-3-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-3-git-send-email-cheiny@synaptics.com>
Date: Thu, 23 Aug 2012 10:55:32 +0200
Message-ID: <CACRpkdbxJ0=SLuw+av4xxkABWR2MbXrS_T=HYzfCaZdXVLeTjw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/17] input: RMI4 core bus and sensor drivers.
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject of the patch sounds like something Greg should have a look
at at some point.

On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
<cheiny@synaptics.com> wrote:

> Driver for Synaptics touchscreens using RMI4 protocol.

This doesn't match the subject. Does it really driver touchscreens
too? It certainly contains infrastructure. This blurb should be pretty verbose
for the core driver.

(...)
> +DEFINE_MUTEX(rmi_bus_mutex);
> +
> +static struct rmi_function_list {
> +       struct list_head list;
> +       struct rmi_function_handler *fh;
> +} rmi_supported_functions;
> +
> +static struct rmi_character_driver_list {
> +       struct list_head list;
> +       struct rmi_char_driver *cd;
> +} rmi_character_drivers;

We usually do not staticize structs and split definition and
usage please:

struct foo {
..
};

struct foo bar; /* Instance */

> +static atomic_t physical_device_count/* = ATOMIC_INIT(0) ?*/;

Yes please. (Assign it with that.)

(...)
> +static int rmi_bus_match(struct device *dev, struct device_driver *driver)

Why are you re-implementing bus matching? Is there something wrong
with using the core

> +#ifdef CONFIG_PM
> +static int rmi_bus_suspend(struct device *dev)
> +{
> +       struct device_driver *driver = dev->driver;
> +#ifdef GENERIC_SUBSYS_PM_OPS
> +       const struct dev_pm_ops *pm;
> +#endif

Why should generic subsys PM ops be optional if you're using
CONFIG_PM? Just cut these #ifdefs.

(...)
> +static int rmi_bus_probe(struct device *dev)
> +{
> +       struct rmi_driver *driver;
> +       struct rmi_device *rmi_dev = to_rmi_device(dev);
> +
> +       driver = rmi_dev->driver;
> +       if (driver && driver->probe)
> +               return driver->probe(rmi_dev);
> +
> +       return 0;

Should this really return 0? Isn't this a failure?

(The rest of this file looks like it'll work to me, but I'm not
smart with such things.)

> +++ b/drivers/input/rmi4/rmi_driver.c
(...)
> +#ifdef CONFIG_RMI4_DEBUG
> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>

uaccess seems to be used by non-debug code in this file as well, but
I may be wrong.

> +#endif
> +
> +#define REGISTER_DEBUG 0

Why not make a Kconfig for this debug option if it's really
useful?

> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +static void rmi_driver_early_suspend(struct early_suspend *h);
> +static void rmi_driver_late_resume(struct early_suspend *h);
> +#endif

More out-of-tree Android stuff?

(...)
> +#define PHYS_NAME "phys"

"rmi4-phys"? Phys is a bit un-specific.

(...)
> +static int setup_debugfs(struct rmi_device *rmi_dev)
> +{
> +       struct rmi_driver_data *data = rmi_get_driverdata(rmi_dev);
> +#ifdef CONFIG_RMI4_SPI
> +       struct rmi_phys_info *info = &rmi_dev->phys->info;
> +#endif

If something named "phys" is turned on by a plugin for "SPI"
then something is conceptually wrong. Either you consequently
name everything *PHYS or *SPI, and if you want to abstract
away the particulars behind some physical layer you cannot name
the switch *SPI.

> +/* Useful helper functions for u8* */
> +
> +void u8_set_bit(u8 *target, int pos)
> +{
> +       target[pos/8] |= 1<<pos%8;
> +}

Now these helper functions you already reimplemented in
a header file, and here is yet ANOTHER implementatin, with
different code! And I said please use <linux/bitops.h> and
<linux/bitmap.h>, so I'm saying the same again.

> +void u8_clear_bit(u8 *target, int pos)

Dito.

> +bool u8_is_set(u8 *target, int pos)

Dito.

> +bool u8_is_any_set(u8 *target, int size)

Dito.

> +void u8_or(u8 *dest, u8 *target1, u8 *target2, int size)

Dito.

> +void u8_and(u8 *dest, u8 *target1, u8 *target2, int size)

Dito.

(...)
> +/* Utility routine to set bits in a register. */
> +int rmi_set_bits(struct rmi_device *rmi_dev, u16 address,
> +                unsigned char bits)
> +{
> +       unsigned char reg_contents;
> +       int retval;
> +
> +       retval = rmi_read_block(rmi_dev, address, &reg_contents, 1);
> +       if (retval)
> +               return retval;
> +       reg_contents = reg_contents | bits;
> +       retval = rmi_write_block(rmi_dev, address, &reg_contents, 1);
> +       if (retval == 1)
> +               return 0;
> +       else if (retval == 0)
> +               return -EIO;

It's more nice if that function could also return negative error codes
so if (retval <= 0) ...error.

> +/* Utility routine to clear bits in a register. */
> +int rmi_clear_bits(struct rmi_device *rmi_dev, u16 address,
> +                  unsigned char bits)
> +{
> +       unsigned char reg_contents;
> +       int retval;
> +
> +       retval = rmi_read_block(rmi_dev, address, &reg_contents, 1);
> +       if (retval)
> +               return retval;
> +       reg_contents = reg_contents & ~bits;
> +       retval = rmi_write_block(rmi_dev, address, &reg_contents, 1);
> +       if (retval == 1)
> +               return 0;
> +       else if (retval == 0)
> +               return -EIO;

Dito.

> +       return retval;
> +}
> +EXPORT_SYMBOL(rmi_clear_bits);
> +
> +static void rmi_free_function_list(struct rmi_device *rmi_dev)
> +{
> +       struct rmi_function_container *entry, *n;
> +       struct rmi_driver_data *data = rmi_get_driverdata(rmi_dev);
> +
> +       if (!data) {
> +               dev_err(&rmi_dev->dev, "WTF: No driver data in %s\n", __func__);

Yeah I just love acronyms like that in the code, keep it ;-)

(...)
> +static void construct_mask(u8 *mask, int num, int pos)
> +{
> +       int i;
> +
> +       for (i = 0; i < num; i++)
> +               u8_set_bit(mask, pos+i);
> +}

Just use bitmap_set(dst, pos, nbits) from <linux/bitmap.h>

(...)
> +static int rmi_driver_irq_handler(struct rmi_device *rmi_dev, int irq)
> +{
> +       struct rmi_driver_data *data = rmi_get_driverdata(rmi_dev);
> +
> +       /* Can get called before the driver is fully ready to deal with
> +        * interrupts.
> +        */
> +       if (!data || !data->f01_container || !data->f01_container->fh) {
> +               dev_dbg(&rmi_dev->dev,
> +                        "Not ready to handle interrupts yet!\n");
> +               return 0;
> +       }
> +
> +       return process_interrupt_requests(rmi_dev);
> +}

I guess this function mandates that the interrupts handled must
be threaded? Suggest adding might_sleep(); from <linux/kernel.h>
into this function so the runtime checks get correct.

(...)
> +       return 0;
> +}
> +
> +
> +
> +/*
> + * Construct a function's IRQ mask. This should
> + * be called once and stored.
> + */

Lots of blank lines there, you can never get enough whitespace eh? ;-)

> +static u8 *rmi_driver_irq_get_mask(struct rmi_device *rmi_dev,
> +                                  struct rmi_function_container *fc) {
> +       struct rmi_driver_data *data = rmi_get_driverdata(rmi_dev);
> +
> +       u8 *irq_mask = kcalloc(data->num_of_irq_regs, sizeof(u8), GFP_KERNEL);
> +       if (irq_mask)
> +               construct_mask(irq_mask, fc->num_of_irqs, fc->irq_pos);
> +
> +       return irq_mask;
> +}

I just get the feeling that you're trying to reimplement parts of
struct irq_chip and the associated machinery in kernel/irq/*

Please check how e.g. several GPIO drivers utilized the IRQ chips
for virtual IRQ domains, i.e. interrupts from say a GPIO expander
chip cascaded off a "hard" IRQ line on another GPIO chip.

To Linux these are usually just another range of IRQs, and the
space of virtual IRQs is way larger than the number of interrupt
lines the SoC interrupt controller can handle, it just spreads out,
hierarchically.

c.f. the small and nice new Emma driver from Magnus Damm:
drivers/gpio/gpio-em.c

> +/*
> + * This pair of functions allows functions like function 54 to request to have
> + * other interupts disabled until the restore function is called. Only one store
> + * happens at a time.
> + */
> +static int rmi_driver_irq_save(struct rmi_device *rmi_dev, u8 * new_ints)
(...)
> +static int rmi_driver_irq_restore(struct rmi_device *rmi_dev)
(...)

These look just like mask/unmask operations of a struct irq_chip.
Using threaded interrupts and ONESHOT flagged IRQs this
should work just fine with present infrastructure I think.

(...)
> +static int rmi_driver_probe(struct rmi_device *rmi_dev)

Should this be tagged __devinit?

> +{
> +       struct rmi_driver_data *data = NULL;
> +       struct rmi_function_container *fc;
> +       struct rmi_device_platform_data *pdata;
> +       int retval = 0;
> +       struct device *dev = &rmi_dev->dev;
> +       int attr_count = 0;
> +
> +       dev_dbg(dev, "%s: Starting probe.\n", __func__);
> +
> +       pdata = to_rmi_platform_data(rmi_dev);
> +
> +       data = kzalloc(sizeof(struct rmi_driver_data), GFP_KERNEL);

Since rmi_dev contains a struct device, could you use managed
resources?

data = devm_kzalloc(dev, ...);

Check
Documentation/driver-model/devres.txt
in recent kernels.

This lets you cut down the code by getting rid of a lot of
errorpath free():ing and stuff.

> +       if (!data) {
> +               dev_err(dev, "%s: Failed to allocate driver data.\n", __func__);
> +               return -ENOMEM;
> +       }
> +       INIT_LIST_HEAD(&data->rmi_functions.list);
> +       rmi_set_driverdata(rmi_dev, data);
> +       mutex_init(&data->pdt_mutex);
> +
> +       if (!pdata->reset_delay_ms)
> +               pdata->reset_delay_ms = DEFAULT_RESET_DELAY_MS;
> +       retval = do_initial_reset(rmi_dev);
> +       if (retval)
> +               dev_warn(dev, "RMI initial reset failed! Soldiering on.\n");

Not that I have a clue what "soldiering" is...

> +       retval = rmi_scan_pdt(rmi_dev);
> +       if (retval) {
> +               dev_err(dev, "PDT scan for %s failed with code %d.\n",
> +                       pdata->sensor_name, retval);
> +               goto err_free_data;
> +       }
> +
> +       if (!data->f01_container) {
> +               dev_err(dev, "missing F01 container!\n");
> +               retval = -EINVAL;
> +               goto err_free_data;
> +       }
> +
> +       data->f01_container->irq_mask = kcalloc(data->num_of_irq_regs,
> +                       sizeof(u8), GFP_KERNEL);

Actually pretty cool that you use kcalloc, I always forget to use
that. devm_kcalloc() with managed resources tho...

(...)

Then follows a large block of PM stuff that I think you should
let Rafael look at.

> +static struct rmi_driver sensor_driver = {
> +       .driver = {
> +               .owner = THIS_MODULE,
> +               .name = "rmi_generic",
> +#ifdef UNIVERSAL_DEV_PM_OPS

I really think you should try to kill this #ifdef.

> +               .pm = &rmi_driver_pm,
> +#endif
> +       },
> +       .probe = rmi_driver_probe,
> +       .irq_handler = rmi_driver_irq_handler,
> +       .reset_handler = rmi_driver_reset_handler,
> +       .fh_add = rmi_driver_fh_add,
> +       .fh_remove = rmi_driver_fh_remove,
> +       .get_func_irq_mask = rmi_driver_irq_get_mask,
> +       .store_irq_mask = rmi_driver_irq_save,
> +       .restore_irq_mask = rmi_driver_irq_restore,
> +       .remove = __devexit_p(rmi_driver_remove)
> +};

This is quite comprehensive, the basic API is looking good.

(...)
> +static ssize_t rmi_driver_bsr_show(struct device *dev,
> +                                  struct device_attribute *attr, char *buf)
(...)
> +static ssize_t rmi_driver_bsr_store(struct device *dev,
> +                                   struct device_attribute *attr,
> +                                   const char *buf, size_t count)
(...)
> +static ssize_t rmi_driver_enabled_show(struct device *dev,
> +                                      struct device_attribute *attr, char *buf)
(...)
> +static ssize_t rmi_driver_enabled_store(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)

Disable drivers from userspace? Is this really a good idea?

(...)
> +static ssize_t rmi_driver_reg_store(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       int retval;
> +       u32 address;    /* use large addr here so we can catch overflow */
> +       unsigned int bytes;
> +       struct rmi_device *rmi_dev;
> +       struct rmi_driver_data *data;
> +       u8 readbuf[128];
> +       unsigned char outbuf[512];
> +       unsigned char *bufptr = outbuf;
> +       int i;
> +
> +       rmi_dev = to_rmi_device(dev);
> +       data = rmi_get_driverdata(rmi_dev);
> +
> +       retval = sscanf(buf, "%x %u", &address, &bytes);
> +       if (retval != 2) {
> +               dev_err(dev, "Invalid input (code %d) for reg store: %s",
> +                       retval, buf);
> +               return -EINVAL;
> +       }
> +       if (address < 0 || address > 0xFFFF) {
> +               dev_err(dev, "Invalid address for reg store '%#06x'.\n",
> +                       address);
> +               return -EINVAL;
> +       }
> +       if (bytes < 0 || bytes >= sizeof(readbuf) || address+bytes > 65535) {
> +               dev_err(dev, "Invalid byte count for reg store '%d'.\n",
> +                       bytes);
> +               return -EINVAL;
> +       }
> +
> +       retval = rmi_read_block(rmi_dev, address, readbuf, bytes);
> +       if (retval != bytes) {
> +               dev_err(dev, "Failed to read %d registers at %#06x, code %d.\n",
> +                       bytes, address, retval);
> +               return retval;
> +       }
> +
> +       dev_info(dev, "Reading %d bytes from %#06x.\n", bytes, address);
> +       for (i = 0; i < bytes; i++) {
> +               retval = snprintf(bufptr, 4, "%02X ", readbuf[i]);
> +               if (retval < 0) {
> +                       dev_err(dev, "Failed to format string. Code: %d",
> +                               retval);
> +                       return retval;
> +               }
> +               bufptr += retval;
> +       }
> +       dev_info(dev, "%s\n", outbuf);
> +
> +       return count;
> +}
> +#endif

1. Use debugfs for this, not sysfs.

2. Please consider using seq_file for this, it doesn't require you to
handle your own buffers, and I think the kernel already contains
nice hexdump helpers you can use for this.

For seqfile examples see end of drivers/pinctrl/core.c.

(...)
> +++ b/drivers/input/rmi4/rmi_driver.h
(...)
> +/* Sysfs related macros */
> +
> +/* You must define FUNCTION_DATA and FNUM to use these functions. */
> +#define RMI4_SYSFS_DEBUG (defined(CONFIG_RMI4_DEBUG) || defined(CONFIG_ANDROID))

CONFIG_ANDROID doesn't look like something we have in  the kernel currently,
there are some drivers in drivers/staging but they are not to be dependent upon.

> +#if defined(FNUM) && defined(FUNCTION_DATA)
> +
> +#define tricat(x, y, z) tricat_(x, y, z)
> +
> +#define tricat_(x, y, z) x##y##z
> +
> +#define show_union_struct_prototype(propname)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(\
> +                                       struct device *dev, \
> +                                       struct device_attribute *attr, \
> +                                       char *buf);\
> +\
> +static DEVICE_ATTR(propname, RMI_RO_ATTR,\
> +               tricat(rmi_fn_, FNUM, _##propname##_show), \
> +               rmi_store_error);
> +
> +#define store_union_struct_prototype(propname)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(\
> +                                       struct device *dev,\
> +                                       struct device_attribute *attr,\
> +                                       const char *buf, size_t count);\
> +\
> +static DEVICE_ATTR(propname, RMI_WO_ATTR,\
> +               rmi_show_error,\
> +               tricat(rmi_fn_, FNUM, _##propname##_store));
> +
> +#define show_store_union_struct_prototype(propname)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(\
> +                                       struct device *dev,\
> +                                       struct device_attribute *attr,\
> +                                       char *buf);\
> +\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(\
> +                                       struct device *dev,\
> +                                       struct device_attribute *attr,\
> +                                       const char *buf, size_t count);\
> +\
> +static DEVICE_ATTR(propname, RMI_RW_ATTR,\
> +               tricat(rmi_fn_, FNUM, _##propname##_show),\
> +               tricat(rmi_fn_, FNUM, _##propname##_store));
> +
> +#define simple_show_union_struct(regtype, propname, fmt)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device *dev,\
> +                               struct device_attribute *attr, char *buf) {\
> +       struct rmi_function_container *fc;\
> +       struct FUNCTION_DATA *data;\
> +\
> +       fc = to_rmi_function_container(dev);\
> +       data = fc->data;\
> +\
> +       return snprintf(buf, PAGE_SIZE, fmt,\
> +                       data->regtype.propname);\
> +}
> +
> +#define simple_show_union_struct2(regtype, reg_group, propname, fmt)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device *dev,\
> +                               struct device_attribute *attr, char *buf) {\
> +       struct rmi_function_container *fc;\
> +       struct FUNCTION_DATA *data;\
> +\
> +       fc = to_rmi_function_container(dev);\
> +       data = fc->data;\
> +\
> +       return snprintf(buf, PAGE_SIZE, fmt,\
> +                       data->regtype.reg_group->propname);\
> +}
> +
> +#define show_union_struct(regtype, reg_group, propname, fmt)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(\
> +                                       struct device *dev,\
> +                                       struct device_attribute *attr,\
> +                                       char *buf) {\
> +       struct rmi_function_container *fc;\
> +       struct FUNCTION_DATA *data;\
> +       int result;\
> +\
> +       fc = to_rmi_function_container(dev);\
> +       data = fc->data;\
> +\
> +       mutex_lock(&data->regtype##_mutex);\
> +       /* Read current regtype values */\
> +       result = rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
> +                               (u8 *)data->regtype.reg_group,\
> +                               sizeof(data->regtype.reg_group->regs));\
> +       mutex_unlock(&data->regtype##_mutex);\
> +       if (result < 0) {\
> +               dev_dbg(dev, "%s : Could not read regtype at 0x%x\\n",\
> +                                       __func__,\
> +                                       data->regtype.reg_group->address);\
> +               return result;\
> +       } \
> +       return snprintf(buf, PAGE_SIZE, fmt,\
> +                       data->regtype.reg_group->propname);\
> +}
> +
> +#define show_store_union_struct(regtype, reg_group, propname, fmt)\
> +show_union_struct(regtype, reg_group, propname, fmt)\
> +\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(\
> +                                       struct device *dev,\
> +                                       struct device_attribute *attr,\
> +                                       const char *buf, size_t count) {\
> +       int result;\
> +       unsigned long val;\
> +       unsigned long old_val;\
> +       struct rmi_function_container *fc;\
> +       struct FUNCTION_DATA *data;\
> +\
> +       fc = to_rmi_function_container(dev);\
> +       data = fc->data;\
> +\
> +       /* need to convert the string data to an actual value */\
> +       result = strict_strtoul(buf, 10, &val);\
> +\
> +       /* if an error occured, return it */\
> +       if (result)\
> +               return result;\
> +       /* Check value maybe */\
> +\
> +       /* Read current regtype values */\
> +       mutex_lock(&data->regtype##_mutex);\
> +       result =\
> +           rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
> +                               (u8 *)data->regtype.reg_group,\
> +                               sizeof(data->regtype.reg_group->regs));\
> +\
> +       if (result < 0) {\
> +               mutex_unlock(&data->regtype##_mutex);\
> +               dev_dbg(dev, "%s : Could not read regtype at 0x%x\\n",\
> +                                        __func__,\
> +                                       data->regtype.reg_group->address);\
> +               return result;\
> +       } \
> +       /* if the current regtype registers are already set as we want them,\
> +        * do nothing to them */\
> +       if (data->regtype.reg_group->propname == val) {\
> +               mutex_unlock(&data->regtype##_mutex);\
> +               return count;\
> +       } \
> +       /* Write the regtype back to the regtype register */\
> +       old_val = data->regtype.reg_group->propname;\
> +       data->regtype.reg_group->propname = val;\
> +       result =\
> +           rmi_write_block(fc->rmi_dev, data->regtype.reg_group->address,\
> +                               (u8 *)data->regtype.reg_group,\
> +                               sizeof(data->regtype.reg_group->regs));\
> +       if (result < 0) {\
> +               dev_dbg(dev, "%s : Could not write regtype to 0x%x\\n",\
> +                                       __func__,\
> +                                       data->regtype.reg_group->address);\
> +               /* revert change to local value if value not written */\
> +               data->regtype.reg_group->propname = old_val;\
> +               mutex_unlock(&data->regtype##_mutex);\
> +               return result;\
> +       } \
> +       mutex_unlock(&data->regtype##_mutex);\
> +       return count;\
> +}
> +
> +
> +#define show_repeated_union_struct(regtype, reg_group, propname, fmt)\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device *dev,\
> +                                       struct device_attribute *attr,\
> +                                       char *buf) {\
> +       struct rmi_function_container *fc;\
> +       struct FUNCTION_DATA *data;\
> +       int reg_length;\
> +       int result, size = 0;\
> +       char *temp;\
> +       int i;\
> +\
> +       fc = to_rmi_function_container(dev);\
> +       data = fc->data;\
> +       mutex_lock(&data->regtype##_mutex);\
> +\
> +       /* Read current regtype values */\
> +       reg_length = data->regtype.reg_group->length;\
> +       result = rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
> +                       (u8 *) data->regtype.reg_group->regs,\
> +                       reg_length * sizeof(u8));\
> +       mutex_unlock(&data->regtype##_mutex);\
> +       if (result < 0) {\
> +               dev_dbg(dev, "%s : Could not read regtype at 0x%x\n"\
> +                                       "Data may be outdated.", __func__,\
> +                                       data->regtype.reg_group->address);\
> +       } \
> +       temp = buf;\
> +       for (i = 0; i < reg_length; i++) {\
> +               result = snprintf(temp, PAGE_SIZE - size, fmt " ",\
> +                               data->regtype.reg_group->regs[i].propname);\
> +               if (result < 0) {\
> +                       dev_err(dev, "%s : Could not write output.", __func__);\
> +                       return result;\
> +               } \
> +               size += result;\
> +               temp += result;\
> +       } \
> +       result = snprintf(temp, PAGE_SIZE - size, "\n");\
> +       if (result < 0) {\
> +                       dev_err(dev, "%s : Could not write output.", __func__);\
> +                       return result;\
> +       } \
> +       return size + result;\
> +}
> +
> +#define show_store_repeated_union_struct(regtype, reg_group, propname, fmt)\
> +show_repeated_union_struct(regtype, reg_group, propname, fmt)\
> +\
> +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(struct device *dev,\
> +                                  struct device_attribute *attr,\
> +                                  const char *buf, size_t count) {\
> +       struct rmi_function_container *fc;\
> +       struct FUNCTION_DATA *data;\
> +       int reg_length;\
> +       int result;\
> +       const char *temp;\
> +       int i;\
> +       unsigned int newval;\
> +\
> +       fc = to_rmi_function_container(dev);\
> +       data = fc->data;\
> +       mutex_lock(&data->regtype##_mutex);\
> +\
> +       /* Read current regtype values */\
> +\
> +       reg_length = data->regtype.reg_group->length;\
> +       result = rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
> +                       (u8 *) data->regtype.reg_group->regs,\
> +                       reg_length * sizeof(u8));\
> +\
> +       if (result < 0) {\
> +               dev_dbg(dev, "%s: Could not read regtype at %#06x. "\
> +                                       "Data may be outdated.", __func__,\
> +                                       data->regtype.reg_group->address);\
> +       } \
> +       \
> +       /* parse input */\
> +       temp = buf;\
> +       for (i = 0; i < reg_length; i++) {\
> +               if (sscanf(temp, fmt, &newval) == 1) {\
> +                       data->regtype.reg_group->regs[i].propname = newval;\
> +               } else {\
> +                       /* If we don't read a value for each position, abort, \
> +                        * restore previous values locally by rereading */\
> +                       result = rmi_read_block(fc->rmi_dev, \
> +                                       data->regtype.reg_group->address,\
> +                                       (u8 *) data->regtype.reg_group->regs,\
> +                                       reg_length * sizeof(u8));\
> +\
> +                       if (result < 0) {\
> +                               dev_dbg(dev, "%s: Couldn't read regtype at "\
> +                                       "%#06x. Local data may be inaccurate", \
> +                                       __func__,\
> +                                       data->regtype.reg_group->address);\
> +                       } \
> +                       return -EINVAL;\
> +               } \
> +               /* move to next number */\
> +               while (*temp != 0) {\
> +                       temp++;\
> +                       if (isspace(*(temp - 1)) && !isspace(*temp))\
> +                               break;\
> +               } \
> +       } \
> +       result = rmi_write_block(fc->rmi_dev, data->regtype.reg_group->address,\
> +                       (u8 *) data->regtype.reg_group->regs,\
> +                       reg_length * sizeof(u8));\
> +       mutex_unlock(&data->regtype##_mutex);\
> +       if (result < 0) {\
> +               dev_dbg(dev, "%s: Could not write new values to %#06x\n", \
> +                               __func__, data->regtype.reg_group->address);\
> +               return result;\
> +       } \
> +       return count;\
> +}

This looks bizarre, convert them to plain static inline functions if you want
to have them in the header file.

However I suspect you may be duplicating part of existing sysfs
macros, and in particular it looks like you're actually duplicating
the debug facility in Mark Brows recently integrated regmap.

Please consult regmap to see if you can use this!

> +/* Create templates for given types */
> +#define simple_show_union_struct_unsigned(regtype, propname)\
> +simple_show_union_struct(regtype, propname, "%u\n")
> +
> +#define simple_show_union_struct_unsigned2(regtype, reg_group, propname)\
> +simple_show_union_struct2(regtype, reg_group, propname, "%u\n")
> +
> +#define show_union_struct_unsigned(regtype, reg_group, propname)\
> +show_union_struct(regtype, reg_group, propname, "%u\n")
> +
> +#define show_store_union_struct_unsigned(regtype, reg_group, propname)\
> +show_store_union_struct(regtype, reg_group, propname, "%u\n")
> +
> +#define show_repeated_union_struct_unsigned(regtype, reg_group, propname)\
> +show_repeated_union_struct(regtype, reg_group, propname, "%u")
> +
> +#define show_store_repeated_union_struct_unsigned(regtype, reg_group, propname)\
> +show_store_repeated_union_struct(regtype, reg_group, propname, "%u")
> +
> +/* Remove access to raw format string versions */
> +/*#undef simple_show_union_struct
> +#undef show_union_struct_unsigned
> +#undef show_store_union_struct
> +#undef show_repeated_union_struct
> +#undef show_store_repeated_union_struct*/

This looks like trying to reimplement ioctl() in sysfs.

If what you want is to send big structs in/out of the kernel,
use either ioctl() on device nodes (should be trivial since input
is using real device nodes) or use configfs.

The rest looks pretty nice to me ... but you most certainly need
review of the device model and bus code.

Yours,
Linus Walleij
