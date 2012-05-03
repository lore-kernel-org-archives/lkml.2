Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2ECMwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:52:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33987 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2ECMv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120503122359.GA11552@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
	<CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
	<alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
	<CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
	<CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
	<20120503122359.GA11552@polaris.bitmath.org>
Date: Thu, 3 May 2012 14:45:44 +0200
Message-ID: <CAN+gG=GS_aQ35ekF71oCjZXquB4X3xJvzq2_fT2d7nM+iBK=Zg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 2:23 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> I'm currently on the bug fix I told you earlier. However, I found a
>> more problematic bug in the hid_groups functionality.
>>
>> Some device, like the Perixx peripad, present several interfaces
>> (mouse, keyboard and multitouch).
>> The hid groups functionality detects the HID field Contact ID, and
>> then forwards all interfaces to hid-multitouch. The point is that
>> hid-multitouch does not know how to handle mice and keyboards, and
>> then fails handling the interfaces of the device.
>
> I am a bit unclear as to which devices this applies to, but I see two
> possible solutions:
>
> 1) Add the devices in question back to the have_special_drivers list.

Well... The device presents valid mouse and keyboard interface that
should be handled by hid-generic.
The behavior of this particular device is the following:
- when 1 finger is in use, then it sends events over the mouse interface
- when 2 fingers are present, it sends events over the multitouch interface
- when you physically trigger the switch mode button, a keyboard
appears and it sends key events over the keyboard interface, and
eventually mouse events if you press the "mouse" key.... ;-)

This crap is all inherited by the fact that Microsoft do not want to
handle indirect touch, and the device maker found this solution to
counter this.

To sum up, adding it to the have_special_drivers driver list won't
work as we need part of the device to be handled by hid-generic.

>
> 2) Add the interface type to the group descision, which should
> probably be done anyway. I have a patch in the pipe that, will send it
> later today.

A simpler solution consists in adding the macros HID_USB_MT_DEVICE(v,
p) and HID_BLUETOOTH_MT_DEVICE(v, p) as you had introduced in a
earlier patch (I don't know why it disappeared).

The problem came out because:
- hid-multitouch registered the triplet BUS_USB / VID / PID.
- For each interface, it asks udev (or the kernel) which driver to
use, and whatever .group was, it was always hid-multitouch that came
out.

So it's just safer to specify the group for all multitouch devices.

Cheers,
Benjamin

>
>> This particular device is then fully broken (as anyone pumped the events).
>> I also noticed the same problem (but less problematic) with cypress
>> panels: it presents different vendor interfaces and they are handled
>> by hid-multitouch.
>
> It would be great if you could test soution 1) before on a device -
> something seems wrong if those interfaces were handled by hid-generic
> before, but before getting the logic straight, it does not hurt to
> try. :-)
>
> Thanks,
> Henrik
