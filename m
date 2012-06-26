Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2FZFi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:38:57 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:57019 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2FZFi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:38:56 -0400
Message-ID: <4FE94AE3.9010000@firmworks.com>
Date: Mon, 25 Jun 2012 19:38:43 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC 2/2] usb: gadget: composite: parse dt overrides
References: <1340655832-30447-1-git-send-email-aletes.xgr@gmail.com> <4FE8F90B.2010303@gmail.com>
In-Reply-To: <4FE8F90B.2010303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q5Q5ci2a027207 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2012 1:49 PM, Rob Herring wrote:
> On 06/25/2012 03:23 PM, Alexandre Pereira da Silva wrote:
>> Grab the devicetree node properties to override VendorId, ProductId,
>> bcdDevice, Manucacturer, Product and SerialNumber
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> ---
>>   drivers/usb/gadget/composite.c |   31 +++++++++++++++++++++++++++++++
>>   1 file changed, 31 insertions(+)
>
> Are these bindings documented? I think they should be less generic.
> Perhaps prefixed with 'usb-'.

There is precedent for the following properties in the USB node, namely 
the device tree that has been used on OLPC systems for the past several 
years.  Also, I think that Sun machines from the same timeframe use the 
same property names, based on the fact that Sun is using my USB 2.0 OFW 
driver code.

Here's a listing of the properties of a representative USB child device, 
in this case a USB FLASH drive.

configuration#           00000001
bulk-out-size            00000200
bulk-out-pipe            00000001
bulk-in-size             00000200
bulk-in-pipe             00000001
serial$                  200435137016ae938861
device$                  Cruzer Mini
vendor$                  SanDisk Corporation
compatible               usb781,5150.20
                          usb781,5150
                          usbif781,class8.6.50
                          usbif781,class8.6
                          usbif781,class8
                          usbif,class8.6.50
                          usbif,class8.6
                          usbif,class8
                          usb,device
vendor-id                00000781
device-id                00005150
release                  00000020
name                     scsi
class                    00000008
subclass                 00000006
protocol                 00000050
high-speed
assigned-address         00000002
reg                      00000003 00000000
#size-cells              00000000
#address-cells           00000001

Note that:

a) The separator in "vendor-id" is hyphen, not underscore, in keeping 
with the established property naming convention (except for the 
unfortunate "device_type").

b) There is no "usb," prefix, since the presence of this in a device 
node that is a child of a USB bus implicitly identifies the kind of ID. 
  "vendor-id" and "device-id" in PCI bus child devices is similarly 
un-prefixed.

c) Some of these property names are defined in 
http://www.openfirmware.org/ofwg/bindings/usb/usb-1_0.ps




>
>>
>> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>> index 390749b..f3b480e 100644
>> --- a/drivers/usb/gadget/composite.c
>> +++ b/drivers/usb/gadget/composite.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/module.h>
>>   #include <linux/device.h>
>>   #include <linux/utsname.h>
>> +#include <linux/of.h>
>>
>>   #include <linux/usb/composite.h>
>>   #include <asm/unaligned.h>
>> @@ -1423,6 +1424,7 @@ static int composite_bind(struct usb_gadget *gadget)
>>   {
>>   	struct usb_composite_dev	*cdev;
>>   	int				status = -ENOMEM;
>> +	struct device_node		*np = gadget->dev.of_node;
>>
>>   	cdev = kzalloc(sizeof *cdev, GFP_KERNEL);
>>   	if (!cdev)
>> @@ -1470,6 +1472,35 @@ static int composite_bind(struct usb_gadget *gadget)
>>
>>   	cdev->desc = *composite->dev;
>>
>> +	/* grab overrides from devicetree */
>
> Reading the code, it looks more like the DT entries are defaults rather
> than overrides.
>
>> +	if (np) {
>> +		u32 reg;
>> +
>> +		if (!idVendor &&
>> +			of_property_read_u32(np, "vendor_id", &reg) == 0)
>> +			idVendor = reg;
>
> if (!idVendor)
> 	of_property_read_u32(np, "vendor_id", &idVendor);
>
> Rob
>
>> +
>> +		if (!idProduct &&
>> +			of_property_read_u32(np, "product_id", &reg) == 0)
>> +			idProduct = reg;
>> +
>> +		if (!bcdDevice &&
>> +			of_property_read_u32(np, "bcd_device", &reg) == 0)
>> +			bcdDevice = reg;
>> +
>> +		if (!iManufacturer)
>> +			of_property_read_string(np, "manufacturer",
>> +				&iManufacturer);
>> +
>> +		if (!iProduct)
>> +			of_property_read_string(np, "product",
>> +				&iProduct);
>> +
>> +		if (!iSerialNumber)
>> +			of_property_read_string(np, "serial_number",
>> +				&iSerialNumber);
>> +	}
>> +
>>   	/* standardized runtime overrides for device ID data */
>>   	if (idVendor)
>>   		cdev->desc.idVendor = cpu_to_le16(idVendor);
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
>

