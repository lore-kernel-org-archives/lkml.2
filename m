Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3AHSGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:06:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:55264 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab3AHSG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:06:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,432,1355126400"; 
   d="scan'208";a="274351071"
Date: Tue, 8 Jan 2013 20:09:59 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add ACPI support
Message-ID: <20130108180958.GL13897@intel.com>
References: <1357650332-30031-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAN+gG=HzJaOwPfymx5JST1+r9QxfqU5D-gN8i95aVDkqQ=ot8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HzJaOwPfymx5JST1+r9QxfqU5D-gN8i95aVDkqQ=ot8Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 02:51:53PM +0100, Benjamin Tissoires wrote:
> Hi Mika,
> 
> On Tue, Jan 8, 2013 at 2:05 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > The HID over I2C protocol specification states that when the device is
> > enumerated from ACPI the HID descriptor address can be obtained by
> > executing "_DSM" for the device with function 1. Enable this.
> 
> Hehe, funny thing, I worked on the very same patch last Friday. I was
> not able to send it upstream as I still don't have an ACPI 5 enabled
> device...
> So thanks for submitting (and testing) this!
> 
> Before the review, I just have a quick question. All the HID/i2c
> devices I saw so far present a reset line (through a GPIO). Does the
> shipped device you have present this line, and if yes, how this meld
> with the code (i.e. should we take this into account).

Yes, there is either one or two GPIO lines. But there are also devices that
don't have any GPIO lines.

We probably should take this into account. I'm not too familiar with HID
drivers but what if we set the hid->dev.acpi_node and let the actual HID
driver to deal with the GPIO?

> Please note that I can only compare this to my patch, based on the
> DSDT example Microsoft gave in its spec. So sorry if I'm asking
> useless things, but I like to understand... :)
> Here are a few comments:
> 
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c |   73 +++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 71 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index 9ef22244..b2eebb6 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/hid.h>
> >  #include <linux/mutex.h>
> > +#include <linux/acpi.h>
> >
> >  #include <linux/i2c/i2c-hid.h>
> >
> > @@ -810,6 +811,70 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
> >         return 0;
> >  }
> >
> > +#ifdef CONFIG_ACPI
> > +static struct i2c_hid_platform_data *
> > +i2c_hid_acpi_pdata(struct i2c_client *client)
> > +{
> > +       static u8 i2c_hid_guid[] = {
> > +               0xF7, 0xF6, 0xDF, 0x3C, 0x67, 0x42, 0x55, 0x45,
> > +               0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE,
> > +       };
> > +       struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
> > +       struct i2c_hid_platform_data *pdata = NULL;
> > +       union acpi_object params[4], *obj;
> > +       struct acpi_object_list input;
> > +       struct acpi_device *adev;
> > +       acpi_handle handle;
> > +
> > +       handle = ACPI_HANDLE(&client->dev);
> > +       if (!handle || acpi_bus_get_device(handle, &adev))
> > +               return NULL;
> > +
> > +       input.count = ARRAY_SIZE(params);
> > +       input.pointer = params;
> > +
> > +       params[0].type = ACPI_TYPE_BUFFER;
> > +       params[0].buffer.length = sizeof(i2c_hid_guid);
> > +       params[0].buffer.pointer = i2c_hid_guid;
> > +       params[1].type = ACPI_TYPE_INTEGER;
> > +       params[1].integer.value = 1;
> 
> Can you confirm that any value here is ok (this is what I read from
> the DSDT example Microsoft gave, Arg1 is not used).

It is being used in the Microsoft example for querying the supported
functions so I decided to stick with the same when calling the func 1.

All the DSDTs I've seen where the _DSM is implemented, this is not checked
at all.

> > +       params[2].type = ACPI_TYPE_INTEGER;
> > +       params[2].integer.value = 1; /* HID function */
> > +       params[3].type = ACPI_TYPE_INTEGER;
> > +       params[3].integer.value = 0;
> 
> Again, the DSDT example showed that no Arg3 was used... But again, I
> never wrote ACPI driver, so I may be wrong.

It is not being used, right. But the _DSM function wants 4 parameters so we
must pass something.

> > +
> > +       if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
> > +               return NULL;
> 
> As you are returning NULL here, the error that will be raised is
> -EINVAL. I think it should be -ENODEV in this case. I have no strong
> opinion on this, but this can be achieved by returning the error from
> the function, and the returned i2c_hid_platform_data as an argument.

Good idea.

> 
> Or maybe just an error message will be sufficient.
> 
> > +
> > +       obj = (union acpi_object *)buf.pointer;
> > +       if (obj->type != ACPI_TYPE_INTEGER)
> > +               goto fail;
> 
> Again, I would like to know what happened here in case of a failure.
> So an error message would be good.

OK.

> > +
> > +       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> > +       if (!pdata)
> > +               goto fail;
> 
> idem (and returning -ENOMEM would be better IMHO).

OK.

> 
> > +
> > +       pdata->hid_descriptor_address = obj->integer.value;
> > +
> > +fail:
> > +       kfree(buf.pointer);
> > +       return pdata;
> > +}
> > +
> > +static struct acpi_device_id i2c_hid_acpi_match[] = {
> > +       {"ACPI0C50", 0 },
> 
> I never saw this _CID/_HID. Just out of curiosity, is this a
> standardized _CID or is it a _HID specific to a device?

In the Microsoft spec you can have either PNPxxxx or ACPIxxxx.

> > +       {"PNP0C50", 0 },
> > +       { },
> > +};
> > +MODULE_DEVICE_TABLE(acpi, i2c_hid_acpi_match);
> > +#else
> > +static inline struct i2c_hid_platform_data *
> > +i2c_hid_acpi_pdata(struct i2c_client *client)
> > +{
> > +       return NULL;
> > +}
> > +#endif
> > +
> >  static int __devinit i2c_hid_probe(struct i2c_client *client,
> >                 const struct i2c_device_id *dev_id)
> >  {
> > @@ -822,8 +887,11 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
> >         dbg_hid("HID probe called for i2c 0x%02x\n", client->addr);
> >
> >         if (!platform_data) {
> > -               dev_err(&client->dev, "HID register address not provided\n");
> > -               return -EINVAL;
> > +               platform_data = i2c_hid_acpi_pdata(client);
> > +               if (!platform_data) {
> > +                       dev_err(&client->dev, "HID register address not provided\n");
> 
> You may have a line with more than 80 characters here (it's difficult
> to guess thanks to my gmail client converting tabs into spaces...
> grrr)

Shouldn't be as checkpatch.pl didn't complain but I'll re-check.

> > +                       return -EINVAL;
> 
> Always returning -EINVAL does not seem to be the exact error code if
> i2c_hid_acpi_pdata fails.

OK. I'll return whatever error code is returned from i2c_hid_acpi_pdata().

> > +               }
> >         }
> >
> >         if (!client->irq) {
> > @@ -964,6 +1032,7 @@ static struct i2c_driver i2c_hid_driver = {
> >                 .name   = "i2c_hid",
> >                 .owner  = THIS_MODULE,
> >                 .pm     = &i2c_hid_pm,
> > +               .acpi_match_table = ACPI_PTR(i2c_hid_acpi_match),
> 
> This is something I was wondering when looking at your documentation.
> If CONFIG_ACPI is not defined, then 'i2c_hid_acpi_match' does not exists.
> Is there some magic within ACPI_PTR if CONFIG_ACPI is not defined, or
> should we put the #ifdef around?

if !CONFIG_ACPI then ACPI_PTR(whatever) becomes NULL so it is safe to set
here.

> Anyway thanks for this job!

No problem and thanks for your review.
