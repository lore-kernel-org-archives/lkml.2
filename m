Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1AZJoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:44:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1AZJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:44:48 -0500
Message-ID: <4D3FED0B.3060108@redhat.com>
Date: Wed, 26 Jan 2011 07:44:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: Extending rc-core/userspace to handle bigger scancodes - Was:
 Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
References: <20110125005555.GA18338@core.coreip.homeip.net> <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <20110125065217.GE7850@core.coreip.homeip.net> <4D3EE171.4020605@redhat.com> <20110125165524.GC19701@core.coreip.homeip.net>
In-Reply-To: <20110125165524.GC19701@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-01-2011 14:55, Dmitry Torokhov escreveu:
> On Tue, Jan 25, 2011 at 12:42:57PM -0200, Mauro Carvalho Chehab wrote:
>> Em 25-01-2011 04:52, Dmitry Torokhov escreveu:
>>> On Mon, Jan 24, 2011 at 09:31:17PM -0800, Dmitry Torokhov wrote:
>>>> On Tue, Jan 25, 2011 at 12:07:29AM -0500, Mark Lord wrote:
>>>>> On 11-01-25 12:04 AM, Mark Lord wrote:
>>>>>> On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
>>>>>>> On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
>>>>>> ..
>>>>>>>> This results in (map->size==10) for 2.6.36+ (wrong),
>>>>>>>> and a much larger map->size for 2.6.35 and earlier.
>>>>>>>>
>>>>>>>> So perhaps EVIOCGKEYCODE has changed?
>>>>>>>>
>>>>>>>
>>>>>>> So the utility expects that all devices have flat scancode space and
>>>>>>> driver might have changed so it does not recognize scancode 10 as valid
>>>>>>> scancode anymore.
>>>>>>>
>>>>>>> The options are:
>>>>>>>
>>>>>>> 1. Convert to EVIOCGKEYCODE2
>>>>>>> 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
>>>>>>
>>>>>> or 3. Revert/fix the in-kernel regression.
>>>>>>
>>>>>> The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
>>>>>> (but value) keycodes, and only return -EINVAL when the keycode itself
>>>>>> is out of range.
>>>>>>
>>>>>> That's how it worked in all kernels prior to 2.6.36,
>>>>>> and now it is broken.  It now returns -EINVAL for any unmapped keycode,
>>>>>> even though keycodes higher than that still have mappings.
>>>>>>
>>>>>> This is a bug, a regression, and breaks userspace.
>>>>>> I haven't identified *where* in the kernel the breakage happened,
>>>>>> though.. that code confuses me.  :)
>>>>>
>>>>> Note that this device DOES have "flat scancode space",
>>>>> and the kernel is now incorrectly signalling an error (-EINVAL)
>>>>> in response to a perfectly valid query of a VALID (and mappable)
>>>>> keycode on the remote control
>>>>>
>>>>> The code really is a valid button, it just doesn't have a default mapping
>>>>> set by the kernel (I can set a mapping for that code from userspace and it works).
>>>>>
>>>>
>>>> OK, in this case let's ping Mauro - I think he done the adjustments to
>>>> IR keymap hanlding.
>>>>
>>>> Thanks.
>>>>
>>>
>>> BTW, could you please try the following patch (it assumes that
>>> EVIOCGVERSION in input.c is alreday relaxed).
>>
>> Dmitry,
>>
>> Thanks for your patch. I used part of his logic to improve the ir-keytable 
>> tool at v4l-utils:
>> 	http://git.linuxtv.org/v4l-utils.git
>>
>> The ir-keytable is a tool that just handles Remote Controller input devices,
>> and do it well, allowing all sorts of operations related to it, and using the
>> sysfs /sys/class/rc stuff to help its operation. Without any arguments, it
>> lists the existing RC devices. Arguments are there to allow enabling/disabling
>> RC protocols, reading/writing/cleaning keycode tables and to test if the
>> remote is generating events (EV_MSC/EV_KEY/EV_REP/EV_SYN).
>>
>> Now, it will be using V2 for reads and keycode cleanups, but will still use
>> V1 for writes, as, currently with 32 bits scancodes, there's no gain to use
>> V2 for it. Also, changing the tool to use more bits will require to rewrite
>> part of the code.
>>
>> Also, writing a rc-core code that can work with an arbitrary large scancode
>> is still on our TODO list.
>>
>> I'm not entirely sure how to extend the scancode size, as there are a
>> few options:
>> 	1) Core would always work internally with 32 bytes (1024 bits). Some
>> logic will be required to accept entries with .len < 32;
>> 	2) Drivers will define the code lengtht, and core will use it,
>> returning -EINVAL if userspace uses a len grater than used internally by
>> the core. In this case, we'll need a sysfs node to tell userspace what's
>> the maximum allowed size;
>> 	3) Drivers will define the max number of bits, and core will use it,
>> truncating the number to the max size if userspace tries to write more bits 
>> than the internal representation;
>> 	4) Drivers will define the max number of bits, and core will use it,
>> returning an error if the number is bigger than the max scancode that can be
>> represented internally.
>>
>> I think that (2) is the best way for doing it, but I'm not yet entirely sure.
>> So, it is good to hear some comments about that.
> 
> I'd say 4 and userspace utility should normalize scancodes packing them into the
> least number of bits possible. Since keymap should be device specific
> data in the keymap will not exceed what the driver expects, right?

Well, it depends on what you name "device" ;) If you call it the Linux device that
will handle the Remote Controller, then, the keymap is not driver-specific data. 

They will follow one of the protocol standards, like RC-5 (14 bits), NEC (16 bits), 
NEC EXTENDED (24 bits), some NEC variants with 32 bits, RC6 (there are several modes,
and the key length depends on what mode is used, ranging from 16 to 64 bits).

The problem is that some drivers support the NEC protocol, with 16 bits, plus 16
bits of checksum, but doesn't support the variants that (ab)use the checksum bits
to extend it to 24 or 32 bits. So, if we do (4), the userspace program will clean
the keytable but will fail on the new keytable programming.

Currently, the driver exports the supported protocols, but it doesn't export the
protocol variants. Maybe the better would be to also export the supported protocol
variants via sysfs.

Cheers,
Mauro


