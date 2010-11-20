Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0KTXDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 18:03:30 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:53981 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0KTXD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 18:03:29 -0500
Message-ID: <4CE853BF.80504@telenet.be>
Date: Sun, 21 Nov 2010 00:03:27 +0100
From: Jef Driesen <jefdriesen@telenet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Robert Lukassen <Robert.Lukassen@tomtom.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: g_serial: Allow to override the default VID/PID
References: <4CE6F807.1090607@telenet.be> <1290209554-7026-1-git-send-email-jefdriesen@telenet.be> <20101120001247.GB17421@kroah.com>
In-Reply-To: <20101120001247.GB17421@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/10 01:12, Greg KH wrote:
> On Sat, Nov 20, 2010 at 12:32:34AM +0100, Jef Driesen wrote:
>> Override the default VID/PID if custom values are supplied through the
>> idVendor and idProduct kernel module parameters.
>>
>> Signed-off-by: Jef Driesen<jefdriesen@telenet.be>
>
> So this patch resolves the bug found in
> 1ab83238740ff1e1773d5c13ecac43c60cf4aec4 which showed up in .35-rc1,
> right?

Yes, although I'm really sure it is the best way to fix the problem. The way I 
understand this code is that before that commit, the 
idVendor/idProduct/bcdDevice module parameters where set after the bind(). Thus 
whatever was set as the default there got replaced with the values of the module 
parameters. Exactly what I would consider the correct behavior. After the 
commit, they get set before bind(), where they are changed back to the hardcoded 
values, which I think is wrong. My patch sets them back to the right values, but 
maybe it makes more sense to not set the default values in the first place (if 
there are already values in place of course). But I didn't knew how to 
accomplish that.

There might be similar problems for the other gadget drivers as well. I haven't 
checked that.

>> ---
>>   drivers/usb/gadget/serial.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
>> index f46a609..77b410e 100644
>> --- a/drivers/usb/gadget/serial.c
>> +++ b/drivers/usb/gadget/serial.c
>> @@ -271,6 +271,11 @@ static int __init init(void)
>>   	}
>>   	strings_dev[STRING_DESCRIPTION_IDX].s = serial_config_driver.label;
>>
>> +	if (idVendor)
>> +		device_desc.idVendor = idVendor;
>> +	if (idProduct)
>> +		device_desc.idProduct = idProduct;
>> +
>>   	return usb_composite_register(&gserial_driver);
>>   }
>>   module_init(init);
>> --
>> 1.7.1
