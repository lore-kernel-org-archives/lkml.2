Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0IUOm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:42:29 -0400
Received: from atl.turmel.org ([74.117.157.138]:37680 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab0IUOm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:42:27 -0400
Message-ID: <4C98C442.8030305@turmel.org>
Date: Tue, 21 Sep 2010 10:42:10 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alan Stern <stern@rowland.harvard.edu>, Mat <jackdachef@gmail.com>,
        Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>, Heinz Diehl <htd@fritha.org>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
References: <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1009211638450.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009211638450.26813@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 10:40 AM, Jiri Kosina wrote:
> On Tue, 21 Sep 2010, Alan Stern wrote:
> 
>> On Tue, 21 Sep 2010, Jiri Kosina wrote:
>>
>>> I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
>>> makes the difference. When unset, the problem doesn't trigger, and 
>>> usb_find_interface() always returns the proper interface. When 
>>> CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
>>>
>>> I'll look into that.
>>
>> Apparently the problem is that intf->minors doesn't get initialized 
>> properly.  This patch should fix it.  Everybody, please try it out.
>>
>> Alan Stern
>>
>>
>> Index: usb-2.6/drivers/usb/core/file.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/usb/core/file.c
>> +++ usb-2.6/drivers/usb/core/file.c
>> @@ -159,9 +159,9 @@ void usb_major_cleanup(void)
>>  int usb_register_dev(struct usb_interface *intf,
>>  		     struct usb_class_driver *class_driver)
>>  {
>> -	int retval = -EINVAL;
>> +	int retval;
>>  	int minor_base = class_driver->minor_base;
>> -	int minor = 0;
>> +	int minor;
>>  	char name[20];
>>  	char *temp;
>>  
>> @@ -173,12 +173,17 @@ int usb_register_dev(struct usb_interfac
>>  	 */
>>  	minor_base = 0;
>>  #endif
>> -	intf->minor = -1;
>> -
>> -	dbg ("looking for a minor, starting at %d", minor_base);
>>  
>>  	if (class_driver->fops == NULL)
>> -		goto exit;
>> +		return -EINVAL;
>> +	if (intf->minor >= 0)
>> +		return -EADDRINUSE;
>> +
>> +	retval = init_usb_class();
>> +	if (retval)
>> +		return retval;
>> +
>> +	dev_dbg(&intf->dev, "looking for a minor, starting at %d", minor_base);
>>  
>>  	down_write(&minor_rwsem);
>>  	for (minor = minor_base; minor < MAX_USB_MINORS; ++minor) {
>> @@ -186,20 +191,12 @@ int usb_register_dev(struct usb_interfac
>>  			continue;
>>  
>>  		usb_minors[minor] = class_driver->fops;
>> -
>> -		retval = 0;
>> +		intf->minor = minor;
>>  		break;
>>  	}
>>  	up_write(&minor_rwsem);
>> -
>> -	if (retval)
>> -		goto exit;
>> -
>> -	retval = init_usb_class();
>> -	if (retval)
>> -		goto exit;
>> -
>> -	intf->minor = minor;
>> +	if (intf->minor < 0)
>> +		return -EXFULL;
>>  
>>  	/* create a usb class device for this usb interface */
>>  	snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
>> @@ -212,12 +209,12 @@ int usb_register_dev(struct usb_interfac
>>  				      MKDEV(USB_MAJOR, minor), class_driver,
>>  				      "%s", temp);
>>  	if (IS_ERR(intf->usb_dev)) {
>> +		retval = PTR_ERR(intf->usb_dev);
>>  		down_write(&minor_rwsem);
>> -		usb_minors[intf->minor] = NULL;
>> +		usb_minors[minor] = NULL;
>> +		intf->minor = -1;
>>  		up_write(&minor_rwsem);
>> -		retval = PTR_ERR(intf->usb_dev);
>>  	}
>> -exit:
>>  	return retval;
>>  }
>>  EXPORT_SYMBOL_GPL(usb_register_dev);
>> Index: usb-2.6/drivers/usb/core/message.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/usb/core/message.c
>> +++ usb-2.6/drivers/usb/core/message.c
>> @@ -1803,6 +1803,7 @@ free_interfaces:
>>  		intf->dev.groups = usb_interface_groups;
>>  		intf->dev.dma_mask = dev->dev.dma_mask;
>>  		INIT_WORK(&intf->reset_ws, __usb_queue_reset_device);
>> +		intf->minor = -1;
>>  		device_initialize(&intf->dev);
>>  		dev_set_name(&intf->dev, "%d-%s:%d.%d",
>>  			dev->bus->busnum, dev->devpath,
> 
> [ adding Heinz to CC ]
> 
> If USB core would guarantee the initialization of intf->minor to -1, that 
> would be of course nicer than having to do it myself in the driver (which 
> is exactly what my previous patch has been doing).
> 
> So everyone please test Alan's patch rather than mine, as it is more 
> general.
> 

For what it's worth, I just finished testing yours, and it works just fine.  I'll try Alan's now.

Phil
