Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2ECNhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:37:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55097 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2ECNhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:37:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120503131904.GA11741@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
	<CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
	<alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
	<CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
	<CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
	<20120503122359.GA11552@polaris.bitmath.org>
	<CAN+gG=GS_aQ35ekF71oCjZXquB4X3xJvzq2_fT2d7nM+iBK=Zg@mail.gmail.com>
	<20120503131904.GA11741@polaris.bitmath.org>
Date: Thu, 3 May 2012 15:37:13 +0200
Message-ID: <CAN+gG=GU8NGJ70Yx8_roeA4LCohcmym7wEspbv4d_xMqbrP5hw@mail.gmail.com>
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

On Thu, May 3, 2012 at 3:19 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > 1) Add the devices in question back to the have_special_drivers list.
>>
>> Well... The device presents valid mouse and keyboard interface that
>> should be handled by hid-generic.
>> The behavior of this particular device is the following:
>> - when 1 finger is in use, then it sends events over the mouse interface
>> - when 2 fingers are present, it sends events over the multitouch interface
>> - when you physically trigger the switch mode button, a keyboard
>> appears and it sends key events over the keyboard interface, and
>> eventually mouse events if you press the "mouse" key.... ;-)
>>
>> This crap is all inherited by the fact that Microsoft do not want to
>> handle indirect touch, and the device maker found this solution to
>> counter this.
>>
>> To sum up, adding it to the have_special_drivers driver list won't
>> work as we need part of the device to be handled by hid-generic.
>
> So was this particular device never listed in have_special_drivers?

No, and that's the way it should (not being part of have_special_driver).

>
>> > 2) Add the interface type to the group descision, which should
>> > probably be done anyway. I have a patch in the pipe that, will send it
>> > later today.
>>
>> A simpler solution consists in adding the macros HID_USB_MT_DEVICE(v,
>> p) and HID_BLUETOOTH_MT_DEVICE(v, p) as you had introduced in a
>> earlier patch (I don't know why it disappeared).
>
> No, the specific entries in the hid-multitouch device list matches any
> group, so those defines were simplified away in the second version.

disagree: a device can present several interface (because it has
several "devices") and only those presenting Contact ID can and should
be handled by hid-multitouch.

Cypress for instance presents one interface for the multitouch layer,
and one other for specific controls that are seen as a keyboard.
However, in this particular case, I'm not sure we want to show this
interface to the end user.... ;-)

>
>> The problem came out because:
>> - hid-multitouch registered the triplet BUS_USB / VID / PID.
>> - For each interface, it asks udev (or the kernel) which driver to
>> use, and whatever .group was, it was always hid-multitouch that came
>> out.
>>
>> So it's just safer to specify the group for all multitouch devices.
>
> This is still confusing. I thought the real problem was that the
> non-mt interfaces do not match hid-generic. Solution 2) should take
> care of that. What I don't understand is how those other interfaces
> came to be handled by hid-generic before this patch, unless this
> device was never listed in have_special_driver.

The think is that they do match hid-generic (they get the group
HID_GROUP_GENERIC).
However they also match hid-multitouch (as hid-multitouch does not ask
for a particular group). So, if hid-multitouch is loaded __before__
hid-generic, it will be given the device whatever the match with
hid-generic.

And again, yes it was never listed in have_special_driver.

>
> Are we talking about USB_DEVICE_ID_TOPSEED2_PERIPAD_701 here?

yep


- For consistency, I'd rather specifying the group for any devices.
This because hid-multitouch can not handle other interfaces than
multitouch one. Though the catchall is interesting in the sense that
it may help us to hide unwanted interfaces.

- For backward compatibility, we should adapt each device (currently,
I only spotted this particular one) to decide if we need to catch the
group or not.

Jiri, any thought?

Benjamin

>
> Henrik
