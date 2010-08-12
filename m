Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab0HLNJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:09:31 -0400
Received: from core.signal11.us ([64.251.29.136]:55718 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012Ab0HLNJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:09:28 -0400
Message-ID: <4C63F285.8070801@signal11.us>
Date: Thu, 12 Aug 2010 09:09:25 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Heinz Diehl <htd@fritha.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being   called
References: <20100810210941.GA7938@fritha.org> <20100810223215.GA1609@arch.tripp.de> <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz> <20100812091659.GA1591@arch.tripp.de> <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz> <20100812113624.GB1591@arch.tripp.de> <20100812114513.GA1584@arch.tripp.de> <20100812115657.GA1611@arch.tripp.de> <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz> <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz> <20100812130411.GA1626@arch.tripp.de>
In-Reply-To: <20100812130411.GA1626@arch.tripp.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Aug 12 09:09:27 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c63f287270807514917925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 09:04 AM, Markus Trippelsdorf wrote:
> On Thu, Aug 12, 2010 at 02:57:57PM +0200, Jiri Kosina wrote:
>    
>> On Thu, 12 Aug 2010, Jiri Kosina wrote:
>>
>>      
>>>>>>>>> Guys, could you please send me your .config with which you are
>>>>>>>>> experiencing the problem, so that I can try to reproduce it with it?
>>>>>>>>>                    
>>>>>>>> Attached.
>>>>>>>>                  
>>>>>>> So I had to add support for HW of mine (SATA_VIA, PATA_VIA, disabled the
>>>>>>> radeon firmware stuff, and, most importantly, enabled UHCI, which is what
>>>>>>> is on machine I am using now for testing), and disconnect-connect cycle
>>>>>>> works nicely:
>>>>>>>
>>>>>>> usb 3-2: USB disconnect, address 3
>>>>>>> usb 3-2: new low speed USB device using uhci_hcd and address 4
>>>>>>> input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.0/input/input6
>>>>>>> generic-usb 0003:05B8:3091.0004: input,hidraw0: USB HID v1.10 Mouse [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input0
>>>>>>> input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.1/input/input7
>>>>>>> generic-usb 0003:05B8:3091.0005: input,hidraw1: USB HID v1.10 Keyboard [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input1
>>>>>>>
>>>>>>> so still no BUG from kobject refcounting, and the hidraw numbers are the
>>>>>>> same. The major difference seems to be that I am using UHCI and you have
>>>>>>> your HID devices connected through OHCI, is that correct?
>>>>>>>                
>>>>>> Correct. And I should add that it very easy to reproduce here; just
>>>>>> disconnecting the usb receiver triggers the WARNING.
>>>>>>              
>>>>> Disabling USB_HIDDEV in my .config solves the problem (there is no
>>>>> WARNING anymore when disconnecting the receiver).
>>>>>            
>>>> Reverting bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a with USB_HIDDEV
>>>> enabled also solves the problem. So there must be a bug in that patch:
>>>>
>>>> commit bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a
>>>> Author: Arnd Bergmann<arnd@arndb.de>
>>>> Date:   Sun Jul 11 15:34:05 2010 +0200
>>>>
>>>>      HID: hiddev: use usb_find_interface, get rid of BKL
>>>>
>>>>      This removes the private hiddev_table in the usbhid
>>>>      driver and changes it to use usb_find_interface
>>>>      instead.
>>>>
>>>>      The advantage is that we can avoid the race between
>>>>      usb_register_dev and usb_open and no longer need the
>>>>      big kernel lock.
>>>>
>>>>      This doesn't introduce race condition -- the intf pointer could be
>>>>      invalidated only in hiddev_disconnect() through usb_deregister_dev(),
>>>>      but that will block on minor_rwsem and not actually remove the device
>>>>      until usb_open().
>>>>
>>>>      Signed-off-by: Arnd Bergmann<arnd@arndb.de>
>>>>      Cc: Jiri Kosina<jkosina@suse.cz>
>>>>      Cc: "Greg Kroah-Hartman"<gregkh@suse.de>
>>>>      Signed-off-by: Jiri Kosina<jkosina@suse.cz>
>>>>          
>>> Thanks, I had my suspicion about this commit (that's why I asked to you
>>> verify with CONFIG_USB_HIDDEV turned off as well).
>>>
>>> Adding Arnd to CC and will look into it myself as well soon.
>>>
>>> Arnd, the complete thread can be found at
>>> http://lkml.org/lkml/2010/8/10/280
>>>        
>> Could please those of you, who are able to reproduce the problem, verify
>> whether the patch below (completely untested) makes everything behave
>> again? Thanks.
>>      
> Yes, everything behaves again. Thanks Jiri.
>    

Seconded. Works good. Thanks for your support Jiri.



