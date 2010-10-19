Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0JSSJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:09:05 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58461 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0JSSJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:09:03 -0400
Date: Tue, 19 Oct 2010 11:08:05 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] i2c/mux: Driver for PCA9541 I2C Master Selector
Message-ID: <20101019180805.GA31594@ericsson.com>
References: <1286932516-20689-1-git-send-email-guenter.roeck@ericsson.com>
 <20101019190647.314302e7@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101019190647.314302e7@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tue, Oct 19, 2010 at 01:06:47PM -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Tue, 12 Oct 2010 18:15:16 -0700, Guenter Roeck wrote:
> > This patch adds support for PCA9541, an I2C Bus Master Selector.
> > The driver is modeled as single channel I2C Multiplexer to be able to utilize
> > the I2C multiplexer framework.
> >
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > Reviewed-by: Tom Grennan <tom.grennan@ericsson.com>
> > ---
> > v2 changes:
> > - Added more detailed description and reasoning why the driver was implemented
> >   as single-channel multiplexer.
> > - Modified arbitration algorithm, since access to i2c masters from interrupt
> >   level is not a good idea. Instead of using hrtimers and handling arbitration
> >   in interrupt, handle it from select_chan and either delay for short retry
> >   periods or sleep for long (millisecond) periods.
> >
> >  drivers/i2c/muxes/Kconfig   |   10 +
> >  drivers/i2c/muxes/Makefile  |    1 +
> >  drivers/i2c/muxes/pca9541.c |  397 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 408 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/muxes/pca9541.c
> 
> Sorry for the late reply. I hoped to find the time to review your
> driver in depth with the datasheet, but finally didn't, so here is a
> shorter review.
> 
As always, I appreciate your time and detailed feedback.

> Your model seems sane as long as the Linux host only controls one of
> the masters. If the two masters are controlled by the Linux host, the
> slave bus segment will appear twice but you will only be able to
> instantiate an I2C client device on one of them for each device,
> otherwise the same device will be listed twice.
> 
Yes, there is an implied assumption that a host only controls one master.
I'll add a comment to the code to clarify this.

> If we have to support this, the i2c core will need some rework, as an
> i2c_client would have to be allowed to have more than one parent.
> 
> >
> > diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
> > index 4c9a99c..4d91d80 100644
> > --- a/drivers/i2c/muxes/Kconfig
> > +++ b/drivers/i2c/muxes/Kconfig
> > @@ -5,6 +5,16 @@
> >  menu "Multiplexer I2C Chip support"
> >       depends on I2C_MUX
> >
> > +config I2C_MUX_PCA9541
> > +     tristate "NXP PCA9541 I2C Master Selector"
> > +     depends on EXPERIMENTAL
> > +     help
> > +       If you say yes here you get support for the NXP PCA9541
> > +       I2C Master Selector.
> > +
> > +       This driver can also be built as a module.  If so, the module
> > +       will be called pca9541.
> > +
> >  config I2C_MUX_PCA954x
> >       tristate "Philips PCA954x I2C Mux/switches"
> >       depends on EXPERIMENTAL
> > diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
> > index bd83b52..4e27d0d 100644
> > --- a/drivers/i2c/muxes/Makefile
> > +++ b/drivers/i2c/muxes/Makefile
> > @@ -1,6 +1,7 @@
> >  #
> >  # Makefile for multiplexer I2C chip drivers.
> >
> > +obj-$(CONFIG_I2C_MUX_PCA9541)        += pca9541.o
> >  obj-$(CONFIG_I2C_MUX_PCA954x)        += pca954x.o
> >
> >  ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
> > diff --git a/drivers/i2c/muxes/pca9541.c b/drivers/i2c/muxes/pca9541.c
> > new file mode 100644
> > index 0000000..3a17e29
> > --- /dev/null
> > +++ b/drivers/i2c/muxes/pca9541.c
> > @@ -0,0 +1,397 @@
> > +/*
> > + * I2C multiplexer driver for pca9541 bus master selector
> 
> I tend to use capitals when I mean device names, and lower-case letters
> when I refer to the drivers.
> 
You mean use PCA9541 when describing the chip ? Makes sense - I'v been using both
PCA9541 and pca9541 in the comments, which is not really clean.

> > + *
> > + * Copyright (c) 2010 Ericsson AB.
> > + *
> > + * Author: Guenter Roeck <guenter.roeck@ericsson.com>
> > + *
> > + * Derived from:
> > + *  driver/i2c/muxes/pca954x.c
> 
> Avoid full paths in comments, they don't add value and tend to become
> incorrect after some time.
> 
Ok.

> > + *
> > + *  Copyright (c) 2008-2009 Rodolfo Giometti <giometti@linux.it>
> > + *  Copyright (c) 2008-2009 Eurotech S.p.A. <info@eurotech.it>
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> > + * License version 2. This program is licensed "as is" without any
> > + * warranty of any kind, whether express or implied.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/hrtimer.h>
> 
> You no longer need this. OTOH you would need to include
> <linux/jiffies.h> for time_is_after_eq_jiffies, and <linux/delay.h> for
> udelay and msleep.
> 
Ok.

> > +#include <linux/slab.h>
> > +#include <linux/device.h>
> > +#include <linux/i2c.h>
> > +#include <linux/i2c-mux.h>
> > +
> > +#include <linux/i2c/pca954x.h>
> > +
> > +/*
> > + * The PCA9541 is a bus master selector. It supports two I2C masters connected
> > + * to a single slave bus.
> > + *
> > + * Before each bus transaction, a master has to acquire the bus. After the
> > + * transaction is complete, bus ownership has to be released. This fits well
> > + * into the I2C multiplexer framework, which provides select and release
> > + * functions for this purpose. For this reason, this driver is modeled as
> > + * single-channel I2C bus multiplexer.
> > + */
> > +
> > +#define PCA9541_CONTROL              0x01
> > +#define PCA9541_ISTAT                0x02
> > +
> > +#define PCA9541_CTL_MYBUS    (1 << 0)
> > +#define PCA9541_CTL_NMYBUS   (1 << 1)
> > +#define PCA9541_CTL_BUSON    (1 << 2)
> > +#define PCA9541_CTL_NBUSON   (1 << 3)
> > +#define PCA9541_CTL_BUSINIT  (1 << 4)
> > +#define PCA9541_CTL_TESTON   (1 << 6)
> > +#define PCA9541_CTL_NTESTON  (1 << 7)
> > +
> > +#define PCA9541_ISTAT_INTIN  (1 << 0)
> > +#define PCA9541_ISTAT_BUSINIT        (1 << 1)
> > +#define PCA9541_ISTAT_BUSOK  (1 << 2)
> > +#define PCA9541_ISTAT_BUSLOST        (1 << 3)
> > +#define PCA9541_ISTAT_MYTEST (1 << 6)
> > +#define PCA9541_ISTAT_NMYTEST        (1 << 7)
> > +
> > +#define BUSON                (PCA9541_CTL_BUSON | PCA9541_CTL_NBUSON)
> > +#define MYBUS                (PCA9541_CTL_MYBUS | PCA9541_CTL_NMYBUS)
> > +#define mybus(x)     (!((x) & MYBUS) || ((x) & MYBUS) == MYBUS)
> > +#define busoff(x)    (!((x) & BUSON) || ((x) & BUSON) == BUSON)
> > +
> > +/* jiffies timers */
> > +#define ARB_TIMEOUT  (HZ / 8)        /* 125 ms */
> > +#define ARB2_TIMEOUT (HZ / 4)        /* 250 ms */
> 
> Might be good to explain why you need two different values.
> 
Ok.

> > +
> > +/* high resolution timers, in uS */
> 
> I'm not sure how udelay() and msleep() qualify as "high resolution
> timers"? I think you want to rephrase this comment.
> 
Ok. Besides, those are no longer timers.
I'll rephrase to "higher resolution timeouts".

> Also I doubt you really meant microsiemens, but more likely "us" for
> microseconds.
> 
yes.

> > +#define SELECT_TO_SHORT      50
> > +#define SELECT_TO_LONG       1000
> > +
> > +struct pca9541 {
> > +     struct i2c_adapter *virt_adap;
> > +     struct i2c_client *client;
> 
> You could easily do without this field IMHO. Simply pass the client
> between the functions, instead of the data.
> 
Ok.

> > +     unsigned long select_timeout;
> > +     unsigned long arb_timeout;
> > +};
> > +
> > +static const struct i2c_device_id pca9541_id[] = {
> > +     {"pca9541", 0},
> > +     {}
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, pca9541_id);
> > +
> > +/*
> > + * Write to selector register. Don't use i2c_transfer()/i2c_smbus_xfer()
> 
> The function can actually be used to write to any register.
> 
I'll rephrase the comment. It was meant to identify the chip (short for
"bus master selector"), but I agree the comment is misleading.

> > + * as they will try to lock the adapter a second time.
> > + */
> > +static int pca9541_reg_write(struct i2c_adapter *adap,
> > +                          struct i2c_client *client, u8 command, u8 val)
> 
> Note that you could derive the adapter from the client, so you don't
> have to pass it as a function parameter.
> 
Ok. Note this is copied from pca954x.c.

> > +{
> > +     int ret;
> > +
> > +     if (adap->algo->master_xfer) {
> > +             struct i2c_msg msg;
> > +             char buf[2];
> > +
> > +             msg.addr = client->addr;
> > +             msg.flags = 0;
> > +             msg.len = 2;
> > +             buf[0] = command;
> > +             buf[1] = val;
> > +             msg.buf = buf;
> > +             ret = adap->algo->master_xfer(adap, &msg, 1);
> > +     } else {
> > +             union i2c_smbus_data data;
> > +
> > +             data.byte = val;
> > +             ret = adap->algo->smbus_xfer(adap, client->addr,
> > +                                          client->flags,
> > +                                          I2C_SMBUS_WRITE,
> > +                                          command,
> > +                                          I2C_SMBUS_BYTE_DATA, &data);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +/*
> > + * Read from selector register. Don't use i2c_transfer()/i2c_smbus_xfer()
> 
> The function can actually be used to read from any register.
> 
Same as above.

> > + * as they will try to lock adapter a second time.
> > + */
> > +static int pca9541_reg_read(struct i2c_adapter *adap,
> > +                         struct i2c_client *client, u8 command)
> > +{
> > +     int ret;
> > +     u8 val;
> > +
> > +     if (adap->algo->master_xfer) {
> > +             struct i2c_msg msg[2] = {
> > +                     {
> > +                             .addr = client->addr,
> > +                             .flags = 0,
> > +                             .len = 1,
> > +                             .buf = &command
> > +                     },
> > +                     {
> > +                             .addr = client->addr,
> > +                             .flags = I2C_M_RD,
> > +                             .len = 1,
> > +                             .buf = &val
> > +                     }
> > +             };
> > +             ret = adap->algo->master_xfer(adap, msg, 2);
> > +             if (ret == 2)
> > +                     ret = val;
> > +             else if (ret >= 0)
> > +                     ret = -EIO;
> > +     } else {
> > +             union i2c_smbus_data data;
> > +
> > +             ret = adap->algo->smbus_xfer(adap, client->addr,
> > +                                          client->flags,
> > +                                          I2C_SMBUS_READ,
> > +                                          command,
> > +                                          I2C_SMBUS_BYTE_DATA, &data);
> > +             if (!ret)
> > +                     ret = data.byte;
> > +     }
> > +     return ret;
> > +}
> 
> Needless to say we'll end up providing helper functions for these
> "unlocked" transactions at some point in time. I'm just waiting to see
> more mux drivers pop up, to figure out the right API.
> 
Agreed. One question will be if we want to pass adap or derive it internally ...

> > +
> > +/*
> > + * Arbitration management functions
> > + */
> > +
> > +static void pca9541_release_bus(struct i2c_adapter *adap,
> > +                             struct i2c_client *client)
> > +{
> > +     int reg;
> > +
> > +     reg = pca9541_reg_read(adap, client, PCA9541_CONTROL);
> > +     if (reg >= 0 && !busoff(reg) && mybus(reg))
> > +             pca9541_reg_write(adap, client, PCA9541_CONTROL,
> > +                               (reg & PCA9541_CTL_NBUSON) >> 1);
> > +}
> 
> Is it OK to reset all other (writable) bits to 0?
> 
Yes, this ensures that those are all zero, ie that no request is pending.

> > +
> > +/*
> > + * Arbitration is defined as a two-step process. A device can only activate
> 
> I presume "device" means "bus master" here?
> 
Yes.

> > + * the bus if it owns it; otherwise it has to request ownership first.
> 
> Here "bus" means "slave bus"?
> 
Yes.

> > + * This multi-step process ensures that access contention is resolved
> > + * gracefully.
> > + *
> > + * Bus       Ownership       Other master    Action
> > + * state             requested access
> > + * ----------------------------------------------------
> > + * off       -               yes             wait for arbitration timeout or
> > + *                                   for other master to drop request
> > + * off       no              no              take ownership
> > + * off       yes             no              turn on bus
> > + * on        yes             -               done
> > + * on        no              -               wait for arbitration timeout or
> > + *                                   for other master to release bus
> > + *
> > + * The main contention point occurs if the bus is off and both masters request
> > + * access at the same time. In this case, one master will turn on the bus,
> 
> "access" means "ownership"?
> 
Yes.

> > + * believing that it owns it. The other master will request bus ownership.
> > + * Result is that the bus is turned on, and master which did _not_ own the
> > + * bus before ends up owning it.
> > + */
> > +
> > +/* Control commands per pca9541 datasheet */
> > +static u8 pca9541_control[] = {
> > +     4, 0, 1, 5, 4, 4, 5, 5, 0, 0, 1, 1, 0, 4, 5, 1
> > +};
> 
> Any reason to not make this array const? Also I would make its size
> explicit, as the driver codes assumes there are 0x10 elements in this
> array.
> 
Ok.

> > +
> > +/*
> > + * Channel arbitration
> > + *
> > + * Return values:
> > + *  <0: error
> > + *  0 : bus not acquired
> > + *  1 : bus acquired
> > + */
> > +static int pca9541_arbitrate(struct pca9541 *data)
> > +{
> > +     struct i2c_client *client = data->client;
> > +     struct i2c_adapter *adap = to_i2c_adapter(client->dev.parent);
> 
> Also known as client->adapter.
> 
Ok.

> > +     int reg;
> > +
> > +     reg = pca9541_reg_read(adap, client, PCA9541_CONTROL);
> > +     if (reg < 0)
> > +             return reg;
> > +
> > +     if (busoff(reg)) {
> > +             int istat;
> > +             /*
> > +              * Bus is off, request ownership or turn it on unless
> > +              * other master requested access.
> > +              */
> > +             istat = pca9541_reg_read(adap, client, PCA9541_ISTAT);
> > +             if (!(istat & PCA9541_ISTAT_NMYTEST)
> > +                 || time_is_before_eq_jiffies(data->arb_timeout)) {
> > +                     /*
> > +                      * Other master did not request access, or arbitration
> > +                      * timeout expired. Take the bus.
> > +                      */
> > +                     pca9541_reg_write(adap, client,
> > +                                       PCA9541_CONTROL,
> > +                                       pca9541_control[reg & 0x0f]
> > +                                       | PCA9541_CTL_NTESTON);
> > +                     data->select_timeout = SELECT_TO_SHORT;
> > +             } else {
> > +                     /* Other master requested access. */
> > +                     data->select_timeout = SELECT_TO_LONG * 2;
> 
> This "* 2" may deserve a comment.
> 
Ok.

> > +             }
> > +     } else if (mybus(reg)) {
> > +             /* Bus is on, and we own it. We are done. */
> 
> We are done, but we still have something to do? Confusing.
> 
Done with acquiring access. Still need to clean up the request bits. 
I'll clarify.

> > +             if (reg & (PCA9541_CTL_NTESTON | PCA9541_CTL_BUSINIT))
> > +                     pca9541_reg_write(adap, client,
> > +                                       PCA9541_CONTROL,
> > +                                       reg & ~(PCA9541_CTL_NTESTON
> > +                                               | PCA9541_CTL_BUSINIT));
> > +             return 1;
> > +     } else {
> > +             /* Other master owns the bus */
> > +             data->select_timeout = SELECT_TO_LONG;
> > +             if (time_is_before_eq_jiffies(data->arb_timeout)) {
> > +                     /* Time is up, take the bus and reset it. */
> > +                     pca9541_reg_write(adap, client,
> > +                                       PCA9541_CONTROL,
> > +                                       pca9541_control[reg & 0x0f]
> > +                                       | PCA9541_CTL_BUSINIT
> > +                                       | PCA9541_CTL_NTESTON);
> > +             } else {
> > +                     /* Request bus access if needed */
> > +                     if (!(reg & PCA9541_CTL_NTESTON))
> > +                             pca9541_reg_write(adap, client,
> > +                                               PCA9541_CONTROL,
> > +                                               reg | PCA9541_CTL_NTESTON);
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> > +static int pca9541_select_chan(struct i2c_adapter *adap, void *client, u32 chan)
> > +{
> > +     struct pca9541 *data = i2c_get_clientdata(client);
> > +     int ret;
> > +     unsigned long timeout = jiffies + ARB2_TIMEOUT;
> > +
> > +     data->arb_timeout = jiffies + ARB_TIMEOUT;
> 
> I would love to see a comment before each of these timeout values, to
> know which event the timeout is for.
> 
Ok.

> > +
> > +     do {
> > +             ret = pca9541_arbitrate(data);
> > +             if (ret)
> > +                     return ret < 0 ? ret : 0;
> > +
> > +             if (data->select_timeout == SELECT_TO_SHORT)
> > +                     udelay(data->select_timeout);
> > +             else
> > +                     msleep(data->select_timeout / 1000);
> > +     } while (time_is_after_eq_jiffies(timeout));
> > +
> > +     return ETIMEDOUT;
> 
> The convention is to use negative values for errors.
> 
Yes, this is a real bug.

> > +}
> > +
> > +static int pca9541_release_chan(struct i2c_adapter *adap,
> > +                             void *client, u32 chan)
> > +{
> > +     pca9541_release_bus(adap, client);
> > +     return 0;
> > +}
> > +
> > +/*
> > + * I2C init/probing/exit functions
> > + */
> > +static int __devinit pca9541_probe(struct i2c_client *client,
> > +                                const struct i2c_device_id *id)
> 
> The use of __devinit and __devexit isn't recommended for i2c drivers.
> If your driver is built into the kernel but the underlying i2c bus
> driver is build as a module, you're in trouble.
> 
Ok, I'll remove it.

> > +{
> > +     struct i2c_adapter *adap = to_i2c_adapter(client->dev.parent);
> 
> client->adapter
> 
Ok. This is copied from pca954x.c, actually.

> > +     struct pca954x_platform_data *pdata = client->dev.platform_data;
> > +     struct pca9541 *data;
> > +     int force;
> > +     int ret = -ENODEV;
> > +
> > +     if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE_DATA))
> > +             goto err;
> > +
> > +     /* Read control register to verify that the device exists */
> > +     if (i2c_smbus_read_byte_data(client, PCA9541_CONTROL) < 0)
> > +             goto err;
> 
> Note: you already know that the device exists. If not, probe() wouldn't
> be called. So if you get a failure here, it means broken platform
> initialization code.
> 
Good point. Personal paranoia, I guess. I'll remove it.

> > +
> > +     data = kzalloc(sizeof(struct pca9541), GFP_KERNEL);
> > +     if (!data) {
> > +             ret = -ENOMEM;
> > +             goto err;
> > +     }
> > +
> > +     data->client = client;
> > +     i2c_set_clientdata(client, data);
> > +
> > +     /* Create a virtual adapter */
> 
> Please don't use the term "virtual" here. This bus segment has nothing
> virtual, it exists for real.
> 
Ok. Guess the idea was not that the bus segment is virtual, but the adapter is.
I'll rephrase it to "Create mux adapter".

> > +
> > +     force = 0;
> > +     if (pdata)
> > +             force = pdata->modes[0].adap_id;
> > +     data->virt_adap = i2c_add_mux_adapter(adap, client, force, 0,
> > +                                           pca9541_select_chan,
> > +                                           pca9541_release_chan);
> > +
> > +     if (data->virt_adap == NULL) {
> > +             dev_err(&client->dev,
> > +                     "failed to register master selector as bus %d\n",
> > +                     force);
> 
> This error message is somewhat confusing if "force" is 0: in that case
> you didn't request any specific bus number.
> 
This is from pca954x code. Not sure how to rephrase it. Got an idea ?

> > +             goto exit_free;
> > +     }
> > +
> > +     dev_info(&client->dev, "registered master selector for I2C %s\n",
> > +              client->name);
> > +
> > +     pca9541_release_bus(adap, client);
> 
> This is racy. You are protected by the controller's mutex only inside
> the select_chan and release_chan methods. Outside of them, you are a
> regular user of the controller, so you have to use only regular
> ("locked") transfer functions. Alternatively, you can request and
> return exclusive access to the controller yourself with the
> i2c_lock_adapter() and i2c_unlock_adapter() functions, and keep using
> your "unlocked" transfer functions.
> 
> Additionally, as soon as your new bus segment is registered, someone
> might decide to use it. If you call pca9541_release_bus(), it will
> cause a failure. So I believe you should call pca9541_release_bus()
> _before_ you call i2c_add_mux_adapter().
> 
Makes sense. I'll do that.

> > +
> > +     return 0;
> > +
> > +exit_free:
> > +     kfree(data);
> > +err:
> > +     return ret;
> > +}
> > +
> > +static int __devexit pca9541_remove(struct i2c_client *client)
> > +{
> > +     struct pca9541 *data = i2c_get_clientdata(client);
> > +
> > +     i2c_del_mux_adapter(data->virt_adap);
> > +
> > +     kfree(data);
> > +     return 0;
> > +}
> > +
> > +static struct i2c_driver pca9541_driver = {
> > +     .driver = {
> > +                .name = "pca9541",
> > +                .owner = THIS_MODULE,
> > +                },
> > +     .probe = pca9541_probe,
> > +     .remove = __devexit_p(pca9541_remove),
> > +     .id_table = pca9541_id,
> > +};
> > +
> > +static int __init pca9541_init(void)
> > +{
> > +     return i2c_add_driver(&pca9541_driver);
> > +}
> > +
> > +static void __exit pca9541_exit(void)
> > +{
> > +     i2c_del_driver(&pca9541_driver);
> > +}
> > +
> > +module_init(pca9541_init);
> > +module_exit(pca9541_exit);
> > +
> > +MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
> > +MODULE_DESCRIPTION("PCA9541 I2C master selector driver");
> > +MODULE_LICENSE("GPL v2");
> 
> 
> --
> Jean Delvare
