Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1K1AJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:09:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41463 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1K1AJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:09:42 -0500
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com> <201111251402.28016.arnd@arndb.de> <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com> <20111127230836.GA29728@suse.de>
User-Agent: K-9 Mail for Android
In-Reply-To: <20111127230836.GA29728@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sun, 27 Nov 2011 16:09:19 -0800
To: Greg KH <gregkh@suse.de>, Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Message-ID: <3f636639-7081-40f5-961d-72b1123c19a0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:

>On Sun, Nov 27, 2011 at 11:43:39PM +0100, Linus Walleij wrote:
>> Hi MyungJoo, Arnd
>> 
>> On Fri, Nov 25, 2011 at 3:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thursday 24 November 2011, MyungJoo Ham wrote:
>> >> For switch ports, which may have different types of cables
>> >> (USB, TA, HDMI, Analog A/V, and others), we often have seperated
>device
>> >> drivers that detect the state changes at the port and device
>drivers that
>> >> do something according to the state changes.
>> >>
>> >> For example, when MAX8997-MUIC detects a Charger cable insertion,
>another
>> >> device driver (such as MAX8903 charger, MAX8997 charger, Charger
>Manager,
>> >> or board file) needs to set charger current limit accordingly and
>when
>> >> MAX8997-MUIC detects a HDMI cable insertion, multimedia device
>drivers
>> >> need to do some operations accordingly.
>> >>
>> >> This patchset supports the usage of notifier for passing such
>information
>> >> between device drivers.
>> >>
>> >> Another issue is that at a single switch port, there might be
>multiple
>> >> and heterogeneous cables attached at the same time. Besides, the
>state
>> >> (Attached or Detached) of each cable may alter independently.
>> >>
>> >> In order to address such issues, Android kernel's "Switch" class
>seems to
>> >> be a good basis and we have implemented "Multistate Switch Class"
>based on
>> >> it. The "Switch" class code of Android kernel is GPL as well.
>> >
>> > How does this relate to the new "pinmux" subsystem that Linus
>Walleij
>> > maintains? Would it be useful to integrate your driver into pinmux
>> > instead of starting a new subsystem?
>> 
>> Looks unrelated to pinmux but very useful.
>> 
>> And the uevent scheme from Arve seems like it's doing the
>> right thing to me, but see below on relation to <linux/input.h>.
>> 
>> The GPIO part has to be reviewed by Grant though.
>> 
>> Our charger code also needs to
>> know when the USB cable is inserted, currently we have a simple
>> cross-call in a header file:
>> static void ab8500_charger_usb_state_changed(u8 bm_usb_state, u16
>mA);
>> 
>> So there is certainly a growing need of subsystems that
>> need to notify each other about things that are happening,
>> the need comes naturally from mobile ICs I think, and
>> I also think they all have one or another custom mechanism
>> in place already.
>> 
>> But - and now we need Dmitry to check the concepts:
>> 
>> Some use this stuff from <linux/input.h> to talk to userspace
>> though the input subsystem:
>> 
>> /*
>>  * Switch events
>>  */
>> 
>> #define SW_LID                  0x00  /* set = lid shut */
>> #define SW_TABLET_MODE          0x01  /* set = tablet mode */
>> #define SW_HEADPHONE_INSERT     0x02  /* set = inserted */
>> #define SW_RFKILL_ALL           0x03  /* rfkill master switch, type
>"any"
>>                                          set = radio enabled */
>> #define SW_RADIO                SW_RFKILL_ALL   /* deprecated */
>> #define SW_MICROPHONE_INSERT    0x04  /* set = inserted */
>> #define SW_DOCK                 0x05  /* set = plugged into dock */
>> #define SW_LINEOUT_INSERT       0x06  /* set = inserted */
>> #define SW_JACK_PHYSICAL_INSERT 0x07  /* set = mechanical switch set
>*/
>> #define SW_VIDEOOUT_INSERT      0x08  /* set = inserted */
>> #define SW_CAMERA_LENS_COVER    0x09  /* set = lens covered */
>> #define SW_KEYPAD_SLIDE         0x0a  /* set = keypad slide out */
>> #define SW_FRONT_PROXIMITY      0x0b  /* set = front proximity sensor
>active */
>> #define SW_ROTATE_LOCK          0x0c  /* set = rotate locked/disabled
>*/
>> #define SW_LINEIN_INSERT        0x0d  /* set = inserted */
>> #define SW_MAX                  0x0f
>> #define SW_CNT                  (SW_MAX+1)
>> 
>> These are *also* switches. You could very well add USB
>> cable insertion to the list above.
>> 
>> So for the userspace part it seems to me that we need to make
>> up our mind about this stuff: is it going to be through input or
>> uevent like in this patch? Or ?both??
>
>Input please, uevent is not for things like switches that are "common",
>but for things that are "uncommon" and don't happen often.

Actually, please do not. I never liked audio-related switches added to input; ALSA guys just wore me down. These are usually not switches that user can flip, they are connections between components. Should we switch betide_carrier_*(), power supply state, etc, etc over to input? I think not.

I haven't looked at the patch yet, but a class that has an attribute that could be queried and emitting uneventful on state change seems like a good diluting for me.

Thanks.

-- 
Dmitry
