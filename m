Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2KZWy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:54:27 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:35677 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab2KZWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:54:26 -0500
Message-ID: <50B3F31F.6080203@synaptics.com>
Date: Mon, 26 Nov 2012 14:54:23 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com> <1353124734-16803-3-git-send-email-cheiny@synaptics.com> <CAN+gG=HLjJzGs3aZ9JTB0vvbMkJQWv=8cZXNpBhpFNYxdvKmVw@mail.gmail.com>
In-Reply-To: <CAN+gG=HLjJzGs3aZ9JTB0vvbMkJQWv=8cZXNpBhpFNYxdvKmVw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 10:41 AM, Benjamin Tissoires wrote:
> Hi Christopher,
>
> On Sat, Nov 17, 2012 at 4:58 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
>> rmi_bus.c implements the basic functionality of the RMI bus.  This file is
>> greatly simplified compared to the previous patch - we've switched from
>> "do it yourself" device/driver binding to using device_type to distinguish
>> between the two kinds of devices on the bus (sensor devices and function
>> specific devices) and using the standard bus implementation to manage devices
>> and drivers.
>>
>>
>> rmi_driver.c is a driver for the general functionality of the RMI sensor as a
>> whole, managing those behaviors (including IRQ handling) that are not specific
>> to any RMI4 function.  It has some unavoidable dependencies on F01 behavior,
>> though we have worked to minimize those as far as possible.
>>
>>
>> The header file rmi_driver.h provides definitions that are shared among
>> the modules of the RMI implementation, but not thought to be necessary
>> outside it.
>>
>>
>> Greg KH - Linus Walleij recommended that we seek your input on these core
>> files, particularly the bus implementation.
>>
>>
>> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
>> Cc: Joeri de Gram <j.de.gram@gmail.com>
>>
>> ---
>>
>>   drivers/input/rmi4/rmi_bus.c    |  248 ++++++
>>   drivers/input/rmi4/rmi_driver.c | 1663 +++++++++++++++++++++++++++++++++++++++
>>   drivers/input/rmi4/rmi_driver.h |  139 ++++
>>   include/uapi/linux/input.h      |    1 +
>>   4 files changed, 2051 insertions(+), 0 deletions(-)
>>
> [snipped]
>> diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
>> new file mode 100644
>> index 0000000..05a73ae
>> --- /dev/null
>> +++ b/drivers/input/rmi4/rmi_driver.c
> [snipped]
>> +/* extract product ID */
>> +void get_prod_id(struct rmi_device *rmi_dev, struct rmi_driver_data *drvdata)
>> +{
>> +       struct device *dev = &rmi_dev->dev;
>> +       int retval;
>> +       int board = 0, rev = 0;
>> +       int i;
>> +       static const char * const pattern[] = {
>> +               "tm%4d-%d", "s%4d-%d", "s%4d-ver%1d"};
>> +       u8 product_id[RMI_PRODUCT_ID_LENGTH+1];
>> +
>> +       retval = rmi_read_block(rmi_dev,
>> +               drvdata->f01_container->fd.query_base_addr+
>> +               sizeof(struct f01_basic_queries),
>> +               product_id, RMI_PRODUCT_ID_LENGTH);
>> +       if (retval < 0) {
>> +               dev_err(dev, "Failed to read product id, code=%d!", retval);
>> +               return;
>> +       }
>> +       product_id[RMI_PRODUCT_ID_LENGTH] = '\0';
>> +
>> +       for (i = 0; i < sizeof(product_id); i++)
>> +               product_id[i] = tolower(product_id[i]);
>> +
>> +       for (i = 0; i < sizeof(pattern); i++) {
>
> This should be ARRAY_SIZE(pattern).
> It gave me a wonderful kernel oops :)

Yep, that's a bug!  Oddly enough, it runs without barfing on my systems 
(though who knows what horrible things are happening under the hood). 
Thanks for letting us know.

					Chris

>
> Cheers,
> Benjamin

[snip]
