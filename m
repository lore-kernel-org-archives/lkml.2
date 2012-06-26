Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2FZBNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:13:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39592 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2FZBM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:12:59 -0400
MIME-Version: 1.0
In-Reply-To: <4FE8F90B.2010303@gmail.com>
References: <1340655832-30447-1-git-send-email-aletes.xgr@gmail.com>
	<4FE8F90B.2010303@gmail.com>
Date: Mon, 25 Jun 2012 22:12:58 -0300
Message-ID: <CAAAP30Gad9-NjBq+b9R9qEw1tT-gEvsYCUPXAE5V74ANk_LnTA@mail.gmail.com>
Subject: Re: [RFC 2/2] usb: gadget: composite: parse dt overrides
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 8:49 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 06/25/2012 03:23 PM, Alexandre Pereira da Silva wrote:
>> Grab the devicetree node properties to override VendorId, ProductId,
>> bcdDevice, Manucacturer, Product and SerialNumber
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> ---
>>  drivers/usb/gadget/composite.c |   31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>
> Are these bindings documented? I think they should be less generic.
> Perhaps prefixed with 'usb-'.

Not yet, I will in the final series. This was just to see it had big
issues because the final one needs to change lots of files.
I will add some prefix to them.

About the documentation, should I include it in all of the controllers
bindings or should I add a common file to describe the gadget drivers
binding?

>>
>> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>> index 390749b..f3b480e 100644
>> --- a/drivers/usb/gadget/composite.c
>> +++ b/drivers/usb/gadget/composite.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/module.h>
>>  #include <linux/device.h>
>>  #include <linux/utsname.h>
>> +#include <linux/of.h>
>>
>>  #include <linux/usb/composite.h>
>>  #include <asm/unaligned.h>
>> @@ -1423,6 +1424,7 @@ static int composite_bind(struct usb_gadget *gadget)
>>  {
>>       struct usb_composite_dev        *cdev;
>>       int                             status = -ENOMEM;
>> +     struct device_node              *np = gadget->dev.of_node;
>>
>>       cdev = kzalloc(sizeof *cdev, GFP_KERNEL);
>>       if (!cdev)
>> @@ -1470,6 +1472,35 @@ static int composite_bind(struct usb_gadget *gadget)
>>
>>       cdev->desc = *composite->dev;
>>
>> +     /* grab overrides from devicetree */
>
> Reading the code, it looks more like the DT entries are defaults rather
> than overrides.

Actually, it's mixed. The DT overrides the hard coded defaults. And
module parameters can override both. I think the safest path is to
keep them like this, so a DT would not break existing code.

>> +     if (np) {
>> +             u32 reg;
>> +
>> +             if (!idVendor &&
>> +                     of_property_read_u32(np, "vendor_id", &reg) == 0)
>> +                     idVendor = reg;
>
> if (!idVendor)
>        of_property_read_u32(np, "vendor_id", &idVendor);
>
> Rob
