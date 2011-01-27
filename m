Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1A0KaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:30:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab1A0KaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:30:11 -0500
Message-ID: <4D414928.80801@redhat.com>
Date: Thu, 27 Jan 2011 08:30:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D40C3D7.90608@teksavvy.com> <4D40C551.4020907@teksavvy.com> <20110127021227.GA29709@core.coreip.homeip.net> <4D40E41D.2030003@teksavvy.com> <20110127063815.GA29924@core.coreip.homeip.net>
In-Reply-To: <20110127063815.GA29924@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-01-2011 04:38, Dmitry Torokhov escreveu:
> On Wed, Jan 26, 2011 at 10:18:53PM -0500, Mark Lord wrote:
>> On 11-01-26 09:12 PM, Dmitry Torokhov wrote:
>>> On Wed, Jan 26, 2011 at 08:07:29PM -0500, Mark Lord wrote:
>>>> On 11-01-26 08:01 PM, Mark Lord wrote:
>>>>> On 11-01-26 10:05 AM, Mark Lord wrote:
>>>>>> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
>>>>> ..
>>>>>>> I wonder if the patch below is all that is needed...
>>>>>>
>>>>>> Nope. Does not work here:
>>>>>>
>>>>>> $ lsinput
>>>>>> protocol version mismatch (expected 65536, got 65537)
>>>>>>
>>>>>
>>>>> Heh.. I just noticed something *new* in the bootlogs on my system:
>>>>>
>>>>> kernel: Registered IR keymap rc-rc5-tv
>>>>> udevd-event[6438]: run_program: '/usr/bin/ir-keytable' abnormal exit
>>>>> kernel: input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input7
>>>>> kernel: ir-keytable[6439]: segfault at 8 ip 00000000004012d2 sp 00007fff6d43ca60
>>>>> error 4 in ir-keytable[400000+7000]
>>>>> kernel: rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
>>>>> kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c
>>>>> driver #0]
>>>>>
>>>>> That's udev invoking ir-keyboard when the ir-kbd-i2c kernel module is loaded,
>>>>> and that is also ir-keyboard (userspace) segfaulting when run.
>>>>
>>>> Note: I tried to capture an strace of ir-keyboard segfaulting during boot
>>>> (as above), but doing so kills the system (hangs on boot).
>>>>
>>>> The command from udev was: /usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0
>>>
>>> Does it die when you try to invoke the command by hand? Can you see where?
>>
>>
>> No, it does not seem to segfault when I unload/reload ir-kbd-i2c
>> and then invoke it by hand with the same parameters.
>> Quite possibly the environment is different when udev invokes it,
>> and my strace attempt with udev killed the system, so no info there.
>>
>> It does NOT segfault on the stock 2.6.37 kernel, without the patch.
> 
> I must admit I am baffled. The patch in question only affects the
> EVIOCGKEYCODE path whereas '-a' means "automatically load appropriate
> keymap" and as far as I can see it does not call EVIOCGKEYCODE, only
> EVIOCSKEYCODE...
> 
> Mauro, any ideas?
> 
> BTW, I wonder what package ir-keytable is coming from? Ubuntu seems to
> have v4l-utils at 0.8.1-2 and you say yours is 0.8.2...

0.8.2 is the new version that was released in Jan, 25. One of the major
differences is that it now installs the udev rules, with make install.

This is there in order to prepare to the removal of all those in-kernel
Remote Controller tables.

On my tests here, this is working fine, with Fedora and RHEL 6, on my
usual test devices, so I don't believe that the tool itself is broken, 
nor I think that the issue is due to the fix patch.

I remember that when Kay added a persistence utility tool that opens a V4L
device in order to read some capabilities, this caused a race condition
into a number of drivers that use to register the video device too early.
The result is that udev were opening the device before the end of the
register process, causing OOPS and other problems.

I suspect that Mark may be experiencing a similar issue.

I don't think that most of the c/c will be able to help with this issue.
So, I think that the better is if Mark could either open a Buzgilla or
send me and linux-media the dmesg logs and other information that he may
have about what's happening. It would be interesting if he can remove the
udev rule, boot it and run the udev command manually, to see if this is
really a race condition or something else. If it fails manually, the
better is to activate ftrace logs for rc-core and for the driver functions
and send us the trace logs.

Thanks,
Mauro
