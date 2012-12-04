Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2LDKOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:14:09 -0500
Received: from mxout4.netvision.net.il ([194.90.9.27]:45008 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2LDKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:14:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50BDCCCA.4000000@gmail.com>
Date: Tue, 04 Dec 2012 12:13:30 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <20121128165719.GB31314@kroah.com> <50B8C7BF.4000004@gmail.com>
 <20121130163254.GB4478@kroah.com> <50BB8F43.4010208@gmail.com>
 <20121204034128.GC911@kroah.com>
In-reply-to: <20121204034128.GC911@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 05:41 AM, Greg KH wrote:
> On Sun, Dec 02, 2012 at 07:26:27PM +0200, Eli Billauer wrote:
>    
>> On 11/30/2012 06:32 PM, Greg KH wrote:
>>      
>>>>>>>   >>+static struct class *xillybus_class;
>>>>>>>                
>>>>>>   >Why not just use the misc interface instead of your own class?
>>>>>>              
>>>>>   When Xillybus is used, the whole system's mission is usually around
>>>>>   it (e.g. it's a computer doing data acquisition through the Xillybus
>>>>>   pipes). So giving it a high profile makes sense, I believe. Besides,
>>>>>   a dozen of device files are not rare.
>>>>>            
>>> It is no problem to create dozens of misc devices.  It makes your driver
>>> smaller, contain less code that I have to audit and you have to ensure
>>> you got right, and it removes another user of 'struct class' which we
>>> are trying to get rid of anyway.  So please, move to use a misc device.
>>>
>>>        
>> It has just occurred to me that DYNAMIC_MINORS is 64
>> (drivers/char/misc.c), so I guess that limits the number of misc
>> devices that can be generated, at least with dynamically allocated
>> minors. I previously mentioned "a dozen" as the number of devices,
>> but I've already run tests with 100+ devices, and I can also think
>> of a sane application for that.
>>
>>
>> So if I understood the situation correctly, it looks like using misc
>> devices will create a limitation which will be reached sooner or
>> later.
>>
>> Any suggestion what to do?
>>      
> Given that I don't really understand how you can have that many device
> nodes, because I don't know what they all seem to be needed for, I can't
> answer this question.
>
> Again, any hints on the user/kernel api you use/need here?  Does it
> really have to be device nodes?  What's wrong with the simple firmware
> interface the kernel provides?
>
>    
I'm currently writing some documentation which will cover the API and 
also help reading the code, I hope. It takes some time...

Until it's done, let's look at a usage example: Suppose that the FPGA's 
application is to receive a high-speed bitstream with time multiplexed 
data, demultiplex the bitstream into individual channel streams, and 
send each channel's data to the host. And let's say that there are 64 
channels in original bitstream. So the FPGA has now 64 independent 
sources of data.

For that purpose, the Xillybus IP core (on the FPGA) is configured to 
create 64 pipes for FPGA to host communication. The names of these pipes 
(say, "chan00", "chan01", ...) are also stored in the FPGA.

When the driver starts, it queries the FPGA for its Xillybus 
configuration, and creates 64 device nodes: /dev/xillybus_chan00, 
/dev/xillybus_chan01, ... /dev/xillybus_chan63.

If the user wants to dump the data in channel 43 into a file, it's just:

$ cat /dev/xillybus_chan43 > mydump.dat

I hope this clarified things a bit.

I can't see how the firmware interface would help here.

Regards,
     Eli
> thanks,
>
> greg k-h
>
>    


