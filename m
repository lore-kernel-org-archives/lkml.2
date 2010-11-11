Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0KKGJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:09:00 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64650 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0KKGI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:08:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6163"; a="61454864"
Message-ID: <94b5e0c5f9e16620a6ff80de37ff69e2.squirrel@www.codeaurora.org>
In-Reply-To: <4b3ddcee66c62d34bd9cb8fb3bf0c447.squirrel@www.codeaurora.org>
References: <568203.56459.qm@web180308.mail.gq1.yahoo.com>
    <4b3ddcee66c62d34bd9cb8fb3bf0c447.squirrel@www.codeaurora.org>
Date: Wed, 10 Nov 2010 22:11:26 -0800 (PST)
Subject: Re: [RFC/PATCH 2/2 RESEND] usb:gadget: Add SuperSpeed support to 
     the      Gadget Framework
From: tlinder@codeaurora.org
To: "David Brownell" <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, "tlinder" <tlinder@codeaurora.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Robert Lukassen" <robert.lukassen@tomtom.com>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Matthew Wilcox" <willy@linux.intel.com>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that not everyone received this email.

>>
>>
>> --- On Sun, 10/3/10, tlinder <tlinder@codeaurora.org> wrote:
>>
>>> In order not to force all the FDs to supply
>>
>> What do File Descriptors have to do with this?
>>
>> If you don't mean FD == File Descriptor, then
>> please spell out what you do mean, instead of
>> trying to repurpose a widely used abbreviation.
>
> By FD we meant Function Drivers. We'll update the patch description.
>
>>
>>
>> SuperSpeed
>>> descriptors when
>>> operating in SuperSpeed mode the following approach was
>>> taken:
>>> If we're operating in SuperSpeed mode and the FD didn't
>>> supply SuperSpeed
>>> descriptors, the composite layer will automatically create
>>> SuperSpeed
>>> descriptors with default values.
>>
>> That bothers me in two ways.  First, I want to
>> see a solution that maintains today's policy where
>> the composite framework is optional for all gadget
>> drivers.
>
> This policy is maintained. Gadget drivers are not required to use the
> composite framework in order to work in SuperSpeed mode. If a certain
> driver wishes to do so, without using the composite framework, it should
> add definitions of SuperSpeed descriptors and support of new SuperSpeed
> features. If a driver wishes to work in High/Low speeds then no changes
> are needed.
> Please note that this change is backward compatible.
> In order to test a non composite gadget driver we used the File storage.
> We managed to load the file_storage gadget driver (while the SuperSpeed
> gadget flag is enabled) and the File Storage successfully registered as a
> high speed driver and enumerated with a super speed host.
> We also tested a composite gadget driver (mass storage) that defines the
> descriptors and doesn't use the automatic and it worked successfully.
> All the other gadget drivers were also tested using the automatic
> composite framework and managed to enumerate.
>
>
>>
>> Second, that kind of automagic bothers me.
>>
>> What could be wrong with expecting gadget
>> drivers to provide all the descriptors they need,
>> instead of introducing automagic?
>
> In the current implementation a gadget driver can still provide his own
> SuperSpeed descriptors as it provides HighSpeed descriptors and not use
> the automation.
> Implementing the automatic creation of the SuperSpeed descriptors approach
> has several benefits:
> 1. All existing gadget drivers (that use the composite framework) are
> operational in SuperSpeed mode without any modifications to their code
> 2. Code duplication, of the additional SuperSpeed descriptors in each
> existing gadget driver, is spared: A gadget driver that doesn't wish to
> exploit the SuperSpeed capabilities (such as streaming for example) but
> wishes to operate in a SuperSpeed mode is not required to provide
> additional SuperSpeed descriptors with default values (meaning, that none
> of the SuperSpeed capabilities are supported by it). Such will be created
> for it automatically.
> 2. Single snippet of code tested for all existing gadget drivers
>
>
>>
>>
>>> Support for new SuperSpeed BOS descriptor was
>>
>> Wireless USB BOS descriptors exist too, yes?  Does
>> this approach cover them, or just SuperSpeed?  (We
>> may someday want to support Wireless USB on the
>> peripheral/gadget side too...
>
> In the current implementation the composite framework supports
> GetDescriptor(BOS) request only if the gadget driver supports SuperSpeed.
> In order to extend this functionality for wireless USB one should add
> another condition (is_wireless_USB()) to the existing if().
>
>>
>>
>>
>>> +++++++++++++++++++++++++++++++++++++---
>>>  include/linux/usb/ch9.h
>>
>> I like to see patches related to USB-IF formats
>> and protocols be separate from functional changes
>> in the USB stack or its drivers. which may rely
>> on those formats/protocols; less entanglement.
>
> We will divide this patch into two patches.
>
>>        
>>> +
>>
>>> +config USB_GADGET_SUPERSPEED
>>> +    boolean "Gadget opperating in Super
>>> Speed"
>>> +    depends on USB_GADGET
>>> +    depends on USB_GADGET_DUALSPEED
>>> +    default n
>>> +    help
>>> +      Enabling this feature enables
>>> Super Speed support in the Gadget
>>> +      driver. It means that gadget
>>> drivers should include extra (SuperSpeed)
>>> +      descriptors.
>>
>> That is:  the automagic isn't needed.  The
>> concepts in this patch seem to be a bit on
>> the self-contradictory side...
>
> You are correct. We should change the comment as follows;
> "...It means that gadget drivers should provide extra (SuperSpeed)
> descriptors to the host."
>
>>
>> ep_comp_desc = {
>>> +        .bDescriptorType =
>>> USB_DT_SS_ENDPOINT_COMP,
>>> +        .bLength = 0x06,
>>> +        .bMaxBurst = 0,
>>> /*the default is we don't support bursting*/
>>
>> I've not followed the SuperSpeed stuff as closely
>> as I might, but ... doesn't bursting require some
>> hardware support?  So that not all UDC + driver
>> stacks can support it?   (That'd be a case, if so,
>> for more sanity checks ... and the gadget driver to
>> explicitly say if it handles bursting.
>
> You're right. Bursting and streaming functionality support is defined by
> the UDC and not the gadget framework.
> Due to the above, the create_ss_descriptors() is used for providing
> default SuperSpeed descriptors, meaning that streaming and bursting is not
> supported.
>
>
>>
>>
>>
>>
>
>


