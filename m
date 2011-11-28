Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1K1PKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:10:43 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:52555 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab1K1PKl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:10:41 -0500
From: Morten CHRISTIANSEN <morten.christiansen@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>, Greg KH <gregkh@suse.de>
Cc: NeilBrown <neilb@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Lockwood <lockwood@android.com>,
        =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>
Date: Mon, 28 Nov 2011 16:09:47 +0100
Subject: RE: [RFC PATCH 0/3] introduce: Multistate Switch Class
Thread-Topic: [RFC PATCH 0/3] introduce: Multistate Switch Class
Thread-Index: AcytzjlpHQoE1XzpROexo7zsM+OlbAACXOvw
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA36EE80C928@EXDCVYMBSTM005.EQ1STM.local>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>	<20111128123114.2601bd7c@notabene.brown>
	<20111128072713.GA17724@suse.de>
 <CACRpkdZ+Epa_Y2Kr3dy3-BM8qrcV3f3fWsJXUAbhMTqd268+hw@mail.gmail.com>
In-Reply-To: <CACRpkdZ+Epa_Y2Kr3dy3-BM8qrcV3f3fWsJXUAbhMTqd268+hw@mail.gmail.com>
Accept-Language: nb-NO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: nb-NO, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Linus is correct. However some more info might be useful? Feel free to drop off whenever in the more and more detailed explanations! This is a non-trivial issue that has had some effort spent on it already.

SUMMARY: Devices today charge at high current (1.5A) from a dedicated charger and 500mA max from a standard USB port, using the standard MaxPower parameter. It would have been great if devices could also charge at higher current from a host or hub port but that is not really practical due to HW issues, not SW issues. See below. A new USB Power Delivery spec is imminent that might be of interest?

SHORT VERSION OF PREVIOUS EFFORTS:
Using HID for managing USB battery charging current from the host is indeed the correct approach. And a work effort in USB Device Working Group went all the way to "ready for publication" state - and then died (for a number of reasons) some years ago. (Due to IPR reasons I cannot forward the un-released version of the spec.)

I see no reason to revisit the HID approach since it will not get any device support. Even if it was the correct approach.

USB POWER DELIVERY:
Currently there is an ongoing effort for USB power delivery, this might be relevant and useful even if it also allows much higher voltage than 5V. The industry review of the preliminary spec has happened and the spec should be public in a few months.  

http://www.usb.org/press/USB_Power_Delivery_Specification.pdf for press release 

and further details from IDF 2011:
https://intel.wingateweb.com/us11/scheduler/download/download.jsp?E4B2973BCDE53502BEFEB912D75B8DA8=A6B62020AAED1E8D4EDE0D1DA89C386D&B74A4263B8A60B9174A0CE5F9461219F=8BC9EC1D19D07830717163157D635C00


LONGER VERSION: 
The really simplified explanation of the battery charger spec states that a dedicated charger port has D+ and D- short-circuited. The device can detect this and charge at any current up to 1.5A. No enumeration, no traffic etc. And no USB host in the charger! As some originally proposed. Note that other versions of modifying D+/D- in a charger exists, notably in Apple chargers but this is out of scope for this discussion. And obviously all of this is handled in the lower level USB stack down at the physical driver level as there is no point in sending this info further "up" into the SW stack in the device since the charger app is already handling this. Regardless of device OS used.  

In order to charge at higher current from a host (or hub) port a different mechanism is used to detect charging capability without killing USB traffic - something that shorting D+/D- usually does! In practice the device sends a low level pulse on D+ and the host answers with a similar pulse on D-. Giving the device the indication that D+/D- are shorted. While still allowing USB traffic after the initial charger detection has taken place. 

However there are very few if any host ports that support this. And even if a few hub chips have been launched this has not caught on. One problem with the host port is that the user expects that all ports will allow higher current charging. The hub's problem is to ensure that a 7-8A power supply instead of the standard 2.5A power supply is connected. And why would people want to pay extra for this hub capability anyway? Same applies to the host; the host will have to upgrade the 3-4 USB ports from 500mA each to 1.5A each. Not nice! And it will also have to continue to supply 5-6A on the 5V Vbus power supply when in standby since once a port has been detected as a charger port the charger capability cannot be revoked unless Vbus is removed, killing the device etc. And not allowing the power supply to meet the standby current requirements that now apply at least in the European Union. 

So the approach with new commands (using HID) to allow the host to read battery status on each device and intelligently decide which port - if any - and at any time - has higher current capability than the standard 500mA - and even programmable 500 - 1500mA current - is indeed the right approach. But "dead" as briefly described above.

I can provide more information if needed. But would advise you to follow up on the USB power delivery specification effort first.

BR Morten Christiansen, Siv.Ing
Principal System Designer, Datacom USB
ST-Ericsson R&D Grimstad, Norway

-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org] 
Sent: 28. november 2011 14:04
To: Greg KH
Cc: NeilBrown; Arnd Bergmann; myungjoo.ham@gmail.com; linux-kernel@vger.kernel.org; Mike Lockwood; Arve Hjønnevåg; Kyungmin Park; Donggeun Kim; Grant Likely; Karl KOMIEROWSKI; Johan BJORNSTEDT; Daniel WILLERUD; Dmitry Torokhov; Mian Yousaf KAUKAB; Morten CHRISTIANSEN
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class

On Mon, Nov 28, 2011 at 8:27 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Nov 28, 2011 at 12:31:14PM +1100, NeilBrown wrote:
>>
>>  My own thought is that this deserves a new device class which allows 
>> easy
>>  hook-up of in-kernel signalling using notifications and which can be
>>  exported as input devices in much the same way the 'gpio' devices 
>> can be
>>  exported via gpio_keys.  The switch could also optionally be 
>> exported through
>>  sysfs much like gpio can be exported through sysfs.
>
> That might also work, but again, odds are the HID spec already defines 
> this type of "switch", so why recreate it as a different type of device?

I think both yes and no, but I will stand corrected.

When you plug it into a host, I guess your device will negotiate power withdrawal from the host as anything else, no matter what device or interface classes it presents.

However in the other case I am under the impression that devices supporting EPS http://en.wikipedia.org/wiki/Common_External_Power_Supply
Or the "battery charging specification"
http://www.usb.org/developers/devclass_docs/batt_charging_1_1.zip
do so in their Phy transceiver drivers, say e.g.
drivers/usb/otg/ab8500-usb.c in our case. This is sometime called a "chinese charger" or "dedicated charger". It's just appearing on the micro-USB port, it doesn't enumerate and the OS driver does not talk to it. I think it notifies the transceiver by short-circuiting D+ and D- and the transceiver/phy driver may in many cases notify charging circuitry and userspace that it's been plugged in (switch uevent, cable insertion input event or whatever we come up with).

So no, I don't think HID defines this, it's defined in a physical layer spec, and the interfaces to OS:es are transciever/phy-custom.

I've CC:ed Morten who was part of writing the charging spec so he can correct me if I'm saying the wrong thing.

Yours,
Linus Walleij
