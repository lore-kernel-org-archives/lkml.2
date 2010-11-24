Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0KXAvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:51:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63822 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KXAvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nwFpEsAMrlxrKAZ8Dt+ddEE+pTLSdEDRbu7vfruigbua3UO6Ha4dNvYIprmL2CGMzK
         jMhljTzgDlcYfURbKN4wicf/PN8A+iMReT1n7qZP9KUxW4VhCzWD0RZ0q+r95nMLcONY
         XrtmyEK20pBP121zBvZRXU8KZ5odqpVm39Dio=
MIME-Version: 1.0
In-Reply-To: <20101124003832.GA27368@core.coreip.homeip.net>
References: <1290126335-12430-1-git-send-email-pingc@wacom.com>
	<20101122075554.GA27300@core.coreip.homeip.net>
	<AANLkTinVYUrD2a+6Z3K0nUze12ZoSc5N0AtR0xB=AjOa@mail.gmail.com>
	<20101123222458.GB20283@core.coreip.homeip.net>
	<AANLkTimht8osNw=L+1TkhYOW5AafQDPBX64Xa1qBbdfP@mail.gmail.com>
	<20101124003832.GA27368@core.coreip.homeip.net>
Date: Tue, 23 Nov 2010 16:51:10 -0800
Message-ID: <AANLkTinJZyDcORj5DBGNr6Ss8penFyLxw4YDBFaTNLSK@mail.gmail.com>
Subject: Re: [PATCH] Add BTN_TOOL_BUTTONS to input.h
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 4:38 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Nov 23, 2010 at 04:12:13PM -0800, Ping Cheng wrote:
>> On Tue, Nov 23, 2010 at 2:24 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> >
>> >> > The BTN_TOOL_* were introduced to indicate to the userspace tool that is
>> >> > currently touching the surface of the device. Buttons are expected to be
>> >> > always present and can change their state regardless of what tool is
>> >> > being used at the moment. I.e. The full hardware state (between
>> >> > EV_SYN/SYN_REPORT) could be, for example,
>> >> >
>> >> > Pen at 10,20, BTN_0, and BTN_2 (ABS_X 10, ABS_Y 20, BTN_TOOL_PEN, BTN_0,
>> >> > BTN_2) or
>> >> >
>> >> > Lens at 20,15 and BTN_1 (ABS_X 20, ABS_Y 15, BTN_TOOL_LENS, BTN_1).
>> >> >
>> >> > As you can see BTN_* events can accompany either BTN_TOOL_LENS or
>> >> > BTN_TOOL_PEN or any other BTN_TOOL_*.
>> >>
>> >> You are right. The tablet buttons can go with one of those other
>> >> BTN_TOOL_s _if_ they do not define the same event types (BTN_s) as the
>> >> tablet buttons.
>> >>
>> >> The new Bamboo MT code sends both BTN_LEFT and BTN_RIGHT events for
>> >> Tablet Buttons (refer to line 905 and 908 of wacom_wac.c). However,
>> >> BTN_LEFT and BTN_RIGHT are also sent by BTN_TOOL_MOUSE/LENS tool
>> >> (refer to wacom_wac.c line 622 to 665).
>> >>
>> >> If we remove BTN_TOOL_FINGER without a BTN_TOOL-something to replace
>> >> it, the two LEFT and RIGHT buttons will have a hard time to tell the
>> >> user land if they are from the MOUSE/LENS or the Tablet Buttons. The
>> >> worst case could be the LEFT/RIGHT sent later overwrites the earlier
>> >> ones.
>> >>
>> >> We could do some guesswork in the user land to figure out which
>> >> LEFT/RIGHT belongs to which BTN_TOOL_ if the above scenario does not
>> >> happen. But, it would be much cheaper and more reliable if we can tell
>> >> the user land where those LEFT and RIGHT come from. This is the whole
>> >> purpose of the kernel driver, isn't it?
>> >
>> > What would userspace want to figure what physical button was pressed?
>> > Input events convey _actions_, i.e. BTN_LEFT means that user pressed
>> > primary button on the device. It does not matter if it was pressed on
>> > tablet or the mouse/lens; the response should be the same.
>>
>> You're right, if the user wants a LEFT click. In a lot of cases, they
>> want to translate it into something else. LEFT is only a default value
>> that we give them if they do nothing.
>>
>> > If you expect different response, depending on which physical button is
>> > pressed, then they should emit different BTN_* events. If you are
>> > concerned that some users might want to have the same actions while
>> > others want different actions - then please implement key remapping in
>> > the driver.
>>
>> That is exactly what I am trying to convince you. Without being able
>> to tell one button event from the other, even just logically, how can
>> I and other clients remap them?
>
> EVIOCSKEYCODE. You just need to wire wacom driver to support this ioctl.
>
>>
>> > If you want to treat touch and pen as completely independent devices -
>> > we can do that too but as you remember there are some issues with
>> > "pairing" of the devices.
>>
>> No, this issue has nothing to do with separating pen and touch
>> devices. This is for BUTTONS only. Those button events can come from
>> the physical tools (pen, mouse, lens, etc.) or the tablet itself.
>> Without knowing that the button events are from the ones that
>> physically sit on the tablet, it may mess up with the buttons that are
>> from the physical tools.
>>
>> You might have mixed my BTN_TOOL_TOUCH request with this patch.
>
> No, I have not. Again, if actions are different then physical buttons
> should emit different events. If actions are the same then events are
> the same and it does not matter whether user pushed button on the
> touchpad or the mouse.

All right. I'll submit a patch to close this request. The
BTN_TOOL_TOUCH request is still open though.

Thank you,

Ping
