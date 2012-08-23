Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab2HWNVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:21:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55248 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab2HWNVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-4-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-4-git-send-email-cheiny@synaptics.com>
Date: Thu, 23 Aug 2012 15:21:43 +0200
Message-ID: <CACRpkdY5bgMhntpwtP4X+x+tzNeeABuU372GTLh4UGSEAVyWLw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/17] input: RMI4 physical layer drivers for I2C and SPI
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
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
<cheiny@synaptics.com> wrote:

>  drivers/input/rmi4/rmi_i2c.c |  452 +++++++++++++++++++++
>  drivers/input/rmi4/rmi_spi.c |  911 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 1363 insertions(+), 0 deletions(-)

NB: Mark Brown is looking after SPI FTM so include him!

(...)
> diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
(...)
> +#define COMMS_DEBUG 0
> +
> +#define IRQ_DEBUG 0
> +
> +#if COMMS_DEBUG || IRQ_DEBUG
> +#define DEBUG
> +#endif

Don't do things like this. Debugging shall always be switched on from the
Kconfig menus.

Look at this from drivers/pinctrl/:

Kconfig:
config DEBUG_PINCTRL
        bool "Debug PINCTRL calls"
        depends on DEBUG_KERNEL
        help
          Say Y here to add some extra checks and diagnostics to PINCTRL calls.

Makefile:
ccflags-$(CONFIG_DEBUG_PINCTRL) += -DDEBUG

Other more specific defines: same thing. Use Kconfig.
The kernel also has a native concept of verbos debugging
see e.g. drivers/dma*:

config DMADEVICES_VDEBUG
        bool "DMA Engine verbose debugging"
        depends on DMADEVICES_DEBUG != n
        help
          This is an option for use by developers; most people should
          say N here.  This enables deeper (more verbose) debugging of
          the DMA engine core and drivers.

ccflags-$(CONFIG_DMADEVICES_VDEBUG) += -DVERBOSE_DEBUG

(...)
> +static irqreturn_t rmi_i2c_irq_thread(int irq, void *p)
> +{
> +       struct rmi_phys_device *phys = p;
> +       struct rmi_device *rmi_dev = phys->rmi_dev;
> +       struct rmi_driver *driver = rmi_dev->driver;
> +       struct rmi_device_platform_data *pdata = phys->dev->platform_data;
> +
> +#if IRQ_DEBUG
> +       dev_dbg(phys->dev, "ATTN gpio, value: %d.\n",
> +                       gpio_get_value(pdata->attn_gpio));
> +#endif

If you absolutely cannot just use dev_dbg() or dev_vdbg(), then
define your own irq debugging macro on top:

#ifdef IRQ_DEBUG
#define dev_irqdbg        dev_irqdbg
#else
#define dev_irqdbg(dev, format, arg...)                           \
({                                                              \
        if (0)                                                  \
                dev_printk(KERN_DEBUG, dev, format, ##arg);     \
        0;                                                      \
})
#endif

(...)
> +static int rmi_set_page(struct rmi_phys_device *phys, unsigned int page)
> +{
> +       struct i2c_client *client = to_i2c_client(phys->dev);
> +       struct rmi_i2c_data *data = phys->data;
> +       char txbuf[2] = {RMI_PAGE_SELECT_REGISTER, page};
> +       int retval;
> +
> +#if COMMS_DEBUG
> +       dev_dbg(&client->dev, "RMI4 I2C writes 3 bytes: %02x %02x\n",
> +               txbuf[0], txbuf[1]);
> +#endif

Same comment, mutatis mutandis.

(...)
> +static int acquire_attn_irq(struct rmi_i2c_data *data)
> +{
> +       return request_threaded_irq(data->irq, NULL, rmi_i2c_irq_thread,
> +                       data->irq_flags, dev_name(data->phys->dev), data->phys);
> +}

Do you really need a separate function to just call another function?
Inline this instead.

(...)
> +static int __devinit rmi_i2c_probe(struct i2c_client *client,
> +                                 const struct i2c_device_id *id)
> +{
> +       struct rmi_phys_device *rmi_phys;
> +       struct rmi_i2c_data *data;
> +       struct rmi_device_platform_data *pdata = client->dev.platform_data;
> +       int error;
> +
> +       if (!pdata) {
> +               dev_err(&client->dev, "no platform data\n");
> +               return -EINVAL;
> +       }
> +       dev_info(&client->dev, "Probing %s at %#02x (IRQ %d).\n",
> +               pdata->sensor_name ? pdata->sensor_name : "-no name-",
> +               client->addr, pdata->attn_gpio);
> +
> +       if (pdata->gpio_config) {
> +               dev_info(&client->dev, "Configuring GPIOs.\n");
> +               error = pdata->gpio_config(pdata->gpio_data, true);
> +               if (error < 0) {
> +                       dev_err(&client->dev, "Failed to configure GPIOs, code: %d.\n",
> +                               error);
> +                       return error;
> +               }
> +               dev_info(&client->dev, "Done with GPIO configuration.\n");
> +       }
> +
> +       error = i2c_check_functionality(client->adapter, I2C_FUNC_I2C);
> +       if (!error) {
> +               dev_err(&client->dev, "i2c_check_functionality error %d.\n",
> +                       error);
> +               return error;
> +       }
> +
> +       rmi_phys = kzalloc(sizeof(struct rmi_phys_device), GFP_KERNEL);

Could you use devm_kzalloc(&client->dev, ... ) ?

> +
> +       data = kzalloc(sizeof(struct rmi_i2c_data), GFP_KERNEL);

Dito.

> +       data->enabled = true;   /* We plan to come up enabled. */
> +       data->irq = gpio_to_irq(pdata->attn_gpio);
> +       if (pdata->level_triggered) {
> +               data->irq_flags = IRQF_ONESHOT |
> +                       ((pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH) ?
> +                       IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW);
> +       } else {
> +               data->irq_flags =

I'm uncertain to whether this is not IRQF_ONESHOT, I realized why
you do this for edge triggers but will the threads handle this properly?
The irq thread will have to be fully reentrant.

> +                       (pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH) ?
> +                       IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
> +       }
> +       data->phys = rmi_phys;
(...)
> +       error = rmi_register_phys_device(rmi_phys);
> +       if (error) {
> +               dev_err(&client->dev,
> +                       "failed to register physical driver at 0x%.2X.\n",
> +                       client->addr);
> +               goto err_gpio;
> +       }
> +       i2c_set_clientdata(client, rmi_phys);

Especially since it's associated with this one client, devm_kzalloc() and
friends are apropriate.

> +#if defined(CONFIG_RMI4_DEV)

Nowadays much code is moving away from using any #ifdef:s
and instead relying on constructs using IS_ENABLED from
<linux/kconfig.h> like this:

if (IS_ENABLED(CONFIG_FOO)) {}

If that resolves to if (0) the compiler will strip out the
code.

(...)
> +static int __devexit rmi_i2c_remove(struct i2c_client *client)
> +{
> +       struct rmi_phys_device *phys = i2c_get_clientdata(client);
> +       struct rmi_device_platform_data *pd = client->dev.platform_data;
> +
> +       disable_device(phys);
> +       rmi_unregister_phys_device(phys);
> +       kfree(phys->data);
> +       kfree(phys);

So these kfree():s would not be needed if you used devm_*

(...)
> +static const struct i2c_device_id rmi_id[] = {
> +       { "rmi", 0 },
> +       { "rmi_i2c", 0 },
> +       { }
> +};

Why is just "rmi" an acceptable device ID? Since the
SPI driver also allows the same it's a bit confusing.

(...)
> +++ b/drivers/input/rmi4/rmi_spi.c
> +#define COMMS_DEBUG 0
> +#define FF_DEBUG 0

Same comment as about the other custom debug stuff.

(...)
> +static char *spi_v1_proto_name = "spi";
> +static char *spi_v2_proto_name = "spiv2";

const!

And can this be a bit more specific, like "rmi-spiv1", "rmi-spiv2"?

(...)
> +static irqreturn_t rmi_spi_hard_irq(int irq, void *p)
> +{
> +       struct rmi_phys_device *phys = p;
> +       struct rmi_spi_data *data = phys->data;
> +       struct rmi_device_platform_data *pdata = phys->dev->platform_data;
> +
> +       if (data->split_read_pending &&
> +                     gpio_get_value(pdata->attn_gpio) ==
> +                     pdata->attn_polarity) {
> +               phys->info.attn_count++;
> +               complete(&data->irq_comp);

Nice use of completion here!

(...)
> +static int rmi_spi_xfer(struct rmi_phys_device *phys,
> +                   const u8 *txbuf, unsigned n_tx, u8 *rxbuf, unsigned n_rx)
> +{
> +       struct spi_device *client = to_spi_device(phys->dev);
> +       struct rmi_spi_data *v2_data = phys->data;
> +       struct rmi_device_platform_data *pdata = phys->dev->platform_data;
> +       int status;
> +       struct spi_message message;
> +       struct spi_transfer *xfers;
> +       int total_bytes = n_tx + n_rx;
> +       u8 local_buf[total_bytes];
> +       int xfer_count = 0;
> +       int xfer_index = 0;
> +       int block_delay = n_rx > 0 ? pdata->spi_data.block_delay_us : 0;
> +       int byte_delay = n_rx > 1 ? pdata->spi_data.read_delay_us : 0;
> +       int write_delay = n_tx > 1 ? pdata->spi_data.write_delay_us : 0;
> +#if FF_DEBUG
> +       bool bad_data = true;
> +#endif
> +#if COMMS_DEBUG || FF_DEBUG
> +       int i;
> +#endif

This is overzealous I think, this #ifdeffery is looking complex.

(...)
> +#if COMMS_DEBUG
> +       if (n_tx) {
> +               dev_dbg(&client->dev, "SPI sends %d bytes: ", n_tx);
> +               for (i = 0; i < n_tx; i++)
> +                       pr_info("%02X ", txbuf[i]);
> +               pr_info("\n");
> +       }

Atleast move the definiton of i into this #ifdef, or break it out as a
separate function which in turn is ifdeffed.

(...)
> +static int rmi_spi_v1_write(struct rmi_phys_device *phys, u16 addr, u8 data)
> +{
> +       int error = rmi_spi_v1_write_block(phys, addr, &data, 1);
> +
> +       return (error == 1) ? 0 : error;
> +}

Isn't this overabstracted? Cut this function and call rmi_spi_v1_write_block()
directly instead.

(...)
> +static int rmi_spi_v2_read(struct rmi_phys_device *phys, u16 addr, u8 *buf)
> +{
> +       int error = rmi_spi_v2_read_block(phys, addr, buf, 1);
> +
> +       return (error == 1) ? 0 : error;
> +}

Dito.

(...)
> +static int rmi_spi_v1_read(struct rmi_phys_device *phys, u16 addr, u8 *buf)
> +{
> +       int error = rmi_spi_v1_read_block(phys, addr, buf, 1);
> +
> +       return (error == 1) ? 0 : error;
> +}

Dito.

(...)
> +static int rmi_spi_check_device(struct rmi_phys_device *rmi_phys)
> +{
> +       u8 buf[6];
> +       int error;
> +       int i;
> +
> +       /* Some SPI subsystems return 0 for the very first read you do.  So
> +        * we use this dummy read to get that out of the way.
> +        */

This is not looking good. It's like there are bugs in some SPI drivers
and then you put on some duct-tape to fix it?

You must rely on the SPI framework to do its work.
So instead fix the bug in the SPI driver, not at this level in the stack.

I think I know where the bug is, actually:

For each SPI struct spi_transfer transfer, there is a field named
.delay_usecs that can set the delay for a certain transfer. This
must be handled in the driver.

So set this delay in the struct spi_transfer, then debug the
driver, because maybe not all of them are respecting that
delay (but they should!) consult the code in the function
giveback() in drivers/spi/spi-pl022.c for example.

If it's a bug in the RMI4 device-side stack that's another
issue, then the fix needs to be here, of course, but I
didn't get that impression?

(...)
> +static int __devinit rmi_spi_probe(struct spi_device *spi)
> +{
> +       struct rmi_phys_device *rmi_phys;
> +       struct rmi_spi_data *data;
> +       struct rmi_device_platform_data *pdata = spi->dev.platform_data;
> +       u8 buf[2];
> +       int retval;
> +
> +       if (!pdata) {
> +               dev_err(&spi->dev, "no platform data\n");
> +               return -EINVAL;
> +       }
> +
> +       if (spi->master->flags & SPI_MASTER_HALF_DUPLEX)
> +               return -EINVAL;
> +
> +       spi->bits_per_word = 8;
> +       spi->mode = SPI_MODE_3;
> +       retval = spi_setup(spi);
> +       if (retval < 0) {
> +               dev_err(&spi->dev, "spi_setup failed!\n");
> +               return retval;
> +       }
> +
> +       if (pdata->gpio_config) {
> +               retval = pdata->gpio_config(pdata->gpio_data, true);
> +               if (retval < 0) {
> +                       dev_err(&spi->dev, "Failed to setup GPIOs, code: %d.\n",
> +                               retval);
> +                       return retval;
> +               }
> +       }
> +
> +       rmi_phys = kzalloc(sizeof(struct rmi_phys_device), GFP_KERNEL);

Again this can use devm_kzalloc(&spi->dev, ...)

> +       if (!rmi_phys)
> +               return -ENOMEM;
> +
> +       data = kzalloc(sizeof(struct rmi_spi_data), GFP_KERNEL);

Here too...

(...)
> +       if (buf[0] == 1) {
> +               /* SPIv2 */
> +               rmi_phys->write         = rmi_spi_v2_write;
> +               rmi_phys->write_block   = rmi_spi_v2_write_block;
> +               rmi_phys->read          = rmi_spi_v2_read;
> +               data->set_page          = rmi_spi_v2_set_page;

I really like how you auto-detect and switch vtable for the
different protocol versions here.

(...)
> +err_data:
> +       kfree(data);
> +err_phys:
> +       kfree(rmi_phys);

Managed resources simplifies the error path here a lot.

> +       return retval;
> +}

(...)
> +static int __devexit rmi_spi_remove(struct spi_device *spi)
> +{
> +       struct rmi_phys_device *phys = dev_get_drvdata(&spi->dev);
> +       struct rmi_device_platform_data *pd = spi->dev.platform_data;
> +
> +       disable_device(phys);
> +       rmi_unregister_phys_device(phys);
> +       kfree(phys->data);
> +       kfree(phys);

And here.

> +       if (pd->gpio_config)
> +               pd->gpio_config(pdata->gpio_data, false);
> +
> +       return 0;
> +}
> +
> +static const struct spi_device_id rmi_id[] = {
> +       { "rmi", 0 },

Why? Why not just "rmi-spi"

Apart from this it looks really nice, and has progressed enormously!

Yours,
Linus Walleij
