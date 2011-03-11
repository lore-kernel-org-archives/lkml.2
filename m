Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1CKUGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:06:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32867 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1CKUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:05:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=mr8FnNh5GUliFGDzXRL3ZOLV98R0jFNPi3nC/am0kvDEl/bDLo/Rud+m85dpmo7P+C
         ZZZ5QXQA7B+ILrn3ZC/v527QvbyDAVfvA7I3UodwdH9D8pBLOSSDxu7i1hRKXZsQx7ZW
         45FkAtZQbdDtiCfc/jrWqfw65HyxlTrM64fcY=
Message-ID: <4D7A80A4.6040008@linaro.org>
Date: Fri, 11 Mar 2011 20:05:56 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 07:12 PM, Somebody in the thread at some point said:

Hi -

>> I don't believe I referred to class devices anywhere.  It does not
>> matter if the main chip function is class device or not.
>
> It matters because the class specification for a USB device is never
> going to mention information sources that are outside the USB protocol,
> such as board definitions.  Consequently a class driver will never need
> to use such a thing.

Is a gadget driver a class driver?  Because I can set the MAC address 
for my g_ether from the kernel commandline which is most definitely an 
"information source outside the USB protocol".  That is exactly the kind 
of thing I am talking about enabling also to be taken from 
usb_device->dev.platform_data.

>>> Also, do you have a real example of a USB driver today that needs this?
>>
>> I think you find without devpath ->  platform_data mapping, the kind of
>> layout given above is made quite difficult to support in Linux.
>
> What would be needed to support such a mapping?  It seems to me that we
> probably have all the necessary ingredients in place already.

What I was imagining is getting the platform data structs from a header 
in include/linux/

#include <linux/onboard_device_1.h>
#include <linux/onboard_device_2.h>

Using a .name defined to be the first member to match to specific bus 
member devpath prepended with bus class:

struct onboard_device_1_platform_data device_1_platform_data {
	.name = "usb\1-0",
	.some_feature = 1,
};

struct onboard_device_2_platform_data device_2_platform_data {
	.name = "usb\1-1",
	.some_feature = 2,
};

Aggregating them into an array

void *devpath_to_platform_data_mapping[] = {
	device_1_platform_data,
	device_2_platform_data,
};

Registering the array in the machine file

register_platform_data_by_devpath(devpath_to_platform_data_mapping,
	ARRAY_SIZE(devpath_to_platform_data_mapping));

It needs to set two globals for pointer and member count

void
register_platform_data_by_devpath(void *map, int count)
{
	platform_data_mapping = map;
	platform_data_mapping_count = count;
}

Later, when a USB device is instantiated, if platform_data_mapping is 
not NULL, it checks to see if the devname it just synthesized matches 
any in the table that have static usb/ prefix, and if so, sets 
usb_device->dev.platform_data to the table entry.

Well, it's an RFC so if you have a better plan I am all ears.

-Andy
