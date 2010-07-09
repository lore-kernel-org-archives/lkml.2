Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0GIOGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:06:41 -0400
Received: from core.signal11.us ([64.251.29.136]:55683 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0GIOGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:06:39 -0400
Message-ID: <4C372CEE.3070109@signal11.us>
Date: Fri, 09 Jul 2010 10:06:38 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David S Miller <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
       Michael Poole <mdpoole@troilus.org>, Bastien Nocera <hadess@hadess.net>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Bluetooth: hidp: Add support for hidraw    HIDIOCGFEATURE    and HIDIOCSFEATURE
References: <1276467601-9066-1-git-send-email-alan@signal11.us>	 <1278623485.10421.73.camel@localhost.localdomain>	 <4C369CDC.9080104@signal11.us>	 <1278662497.10421.94.camel@localhost.localdomain>	 <4C371DE8.9020002@signal11.us> <1278680790.10421.106.camel@localhost.localdomain>
In-Reply-To: <1278680790.10421.106.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  9 10:06:39 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c372cef179271267913364
X-DSPAM-Factors: 27,
	That, 0.01000,
	reports, 0.01000,
	and+Bluetooth, 0.01000,
	Received*26+177, 0.01000,
	Subject*hidraw+HIDIOCGFEATURE, 0.01000,
	AM, 0.01000,
	Cc*troilus.org>, 0.01000,
	a+better, 0.01000,
	an, 0.01000,
	an, 0.01000,
	indeed, 0.01000,
	References*git, 0.01000,
	interface, 0.01000,
	interface, 0.01000,
	from, 0.01000,
	from, 0.01000,
	of, 0.01000,
	of, 0.01000,
	User-Agent*Mozilla/5.0, 0.01000,
	References*alan+signal11.us>, 0.01000,
	send, 0.01000,
	Received*ESMTP, 0.01000,
	not+be, 0.01000,
	transport, 0.01000,
	transport, 0.01000,
	Cc*<jkosina, 0.01000,
	Received*(c+76, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 09:06 AM, Marcel Holtmann wrote:
>>>>> I looked at this and I am bit worried that this should not be done in
>>>>> this detail in the HIDP driver. Essentially HIDP is a pure transport
>>>>> driver. It should not handle all these details. Can we make this a bit
>>>>> easier for the transport drivers to support such features?
>>>>>
>>>>>            
>>>> I put these changes (most notably the addition of hidp_get_raw_report())
>>>> in hidp because that's where the parallel function
>>>> hidp_output_raw_report() was already located. I figured the input should
>>>> go with the output. That said, if there's a better place for both of
>>>> them (input and output) to go, let me know where you think it should be,
>>>> and I'll get them moved into the proper spot.
>>>>
>>>> I'm not sure what you mean about HIDP being a pure transport driver.
>>>>
>>>>          
>>> what is usb-hid.ko doing here? I would expect a bunch of code
>>> duplication with minor difference between USB and Bluetooth.
>>>        
>> usbhid doesn't have a lot of code for hidraw. Two functions are involved:
>>       usbhid_output_raw_report()
>>           - calls usb_control_msg() with Get_Report
>>       usbhid_get_raw_report()
>>           - calls usb_control_msg() with Set_Report
>>               OR
>>           - calls usb_interrupt_msg() on the Ouput pipe.
>>
>> This is of course easier than bluetooth because usb_control_msg() is
>> synchronous, even when requesting reports, mostly because of the nature
>> of USB, where the request and response are part of the same transfer.
>>
>> For Bluetooth, it's a bit more complicated since the kernel treats it
>> more like a networking interface (and indeed it is). My understanding is
>> that to make a synchronous transfer in bluetooth, one must:
>>       - send the request packet
>>       - block (wait_event_*())
>>       - when the response is received in the input handler, wake_up_*().
>>
>> There's not really any code duplication, mostly because initiating
>> synchronous USB transfers (input and output) is easy (because of the
>> usb_*_msg() functions), while making synchronous Bluetooth transfers
>> must be done manually. If there's a nice, convenient, synchronous
>> function in Bluetooth similar to usb_control_msg() that I've missed,
>> then let me know, as it would simplify this whole thing.
>>      
> there is not and I don't think we ever get one. My question here was
> more in the direction why HID core is doing these synchronously in the
> first place. Especially since USB can do everything async as well.
>
> Regards
>
> Marcel
>    

Hi Marcel,

I'm open to suggestions. The way I see it is from a user space 
perspective. With Get_Feature being on an ioctl(), I don't see any clean 
way to do it other than synchronously. Other operating systems (I can 
say for sure Windows, Mac OS X, and FreeBSD) handle Get/Set Feature the 
same way (synchronously) from user space.

You seem to be proposing an asynchronous interface. What would that look 
like from user space?

Alan.







