Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161170Ab2GLO1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:27:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50114 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933910Ab2GLO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <4FFEA2D4.9050308@nvidia.com>
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
	<1341814105-20690-4-git-send-email-acourbot@nvidia.com>
	<CAPnjgZ1QbjE+-tr0c01K2feUdEE2wMBfR=bKpTxnyDOJbY8+1Q@mail.gmail.com>
	<4FFEA2D4.9050308@nvidia.com>
Date: Thu, 12 Jul 2012 16:27:25 +0200
X-Google-Sender-Auth: DHGSwlki-C473fl_wVADtrzLn5E
Message-ID: <CAPnjgZ2=Ga2P-40trA_=UABm=i7Uy4NTAM=ehea11mE22VfDew@mail.gmail.com>
Subject: Re: [RFC][PATCH V2 3/3] tegra: add pwm backlight device tree nodes
From: Simon Glass <sjg@chromium.org>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Thu, Jul 12, 2012 at 12:11 PM, Alex Courbot <acourbot@nvidia.com> wrote:
> Hi Simon,
>
>
> On Thu 12 Jul 2012 06:37:33 PM JST, Simon Glass wrote:
>>
>> I would like to do something similar in U-Boot for Tegra, although
>> perhaps not right away. For now I will go with something considerably
>> simpler! But if this is merged into the kernel we will move to it in
>> U-Boot.
>
>
> Cool, I'd love to see that used in U-Boot as well.
>
>
>>> +               default-brightness-level = <12>;
>>> +
>>> +               pwms = <&pwm 2 5000000>;
>>> +               pwm-names = "backlight";
>>> +               power-supply = <&backlight_reg>;
>>> +               enable-gpios = <&gpio 28 0>;
>>> +
>>> +               power-on-sequence = "REGULATOR", "power", <1>,
>>> +                                   "DELAY", <10>,
>>> +                                   "PWM", "backlight", <1>,
>>> +                                   "GPIO", "enable", <1>;
>>
>>
>> So the names REGULATOR, DELAY, etc. here are looked up through some
>> existing mechanism? In general I am not a big fan of mixing strings
>> and numbers in a property.
>
>
> Yes, these are strings we are looking up to know the type of the next
> element to power on/off in the sequence. I don't like these, honestly, and
> would rather have them replaced by constants - however there is no way to
> define constants in the DT AFAIK (but I have heard some other persons are
> interested in having them too), and this is the only way I have found to
> keep the sequence readable.

That might be the 100th time that I have heard this. I have brought a
patch from Stephen Warren into our tree to solve this locally, but it
is not merged upstream.

>
>
>> Maybe something like:
>>
>> power_on_sequence {
>>     step@0 {
>>        phandle = <&backlight_reg>;
>>        enable = <1>;
>>        post-delay = <10>;
>>     }
>>     step@1 {
>>        phandle = <&pwm 2 5000000>;
>>     }
>>     step@2 {
>>        phandle = <&gpio 28 0>;
>>        enable = <1>;
>>     }
>
>
> I see a few problems with this: first, how do you know the types of your
> phandles? At step 0, we should get a regulator, step 1 is a PWM and step 2
> is a GPIO. This is why I have used strings to identify the type of the
> phandle and the number (and type) of additional arguments to parse for a
> step.

Well it's similar to giving them names - you would need to look up the
phandle and see its compatible string or which driver type owns it.
Maybe too complicated, and no such infrastructure exists, so:

>> power_on_sequence {
>>     step@0 {
            type = "regulator";
>>        phandle = <&backlight_reg>;
>>        enable = <1>;
>>        post-delay = <10>;
>>     }
>>     step@1 {
            type = "pwm";
>>        phandle = <&pwm 2 5000000>;
>>     }
>>     step@2 {
            type = "gpio";
>>        phandle = <&gpio 28 0>;
>>        enable = <1>;
>>     }

>
> Second, I am afraid the representation in memory would be significantly
> bigger since the properties names would have to be stored as well (I am no
> DT expert, please correct me if I am wrong). Lastly, the additional freedom
> of having extra properties might make the parser more complicated.

The property names are only stored one, in the string table. I am not
sure about parsing complexity, but it might actually be easier.

>
> I agree the type strings are a problem in the current form - if we could get
> constants in the device tree, that would be much better. Your way of
> representing the sequences is interesting though, if we can solve the type
> issue (and also evaluate its cost in terms of memory footprint), it would be
> interesting to consider it as well.

At a guess:

>>> +               power-on-sequence = "REGULATOR", "power", <1>,
>>> +                                   "DELAY", <10>,
>>> +                                   "PWM", "backlight", <1>,
>>> +                                   "GPIO", "enable", <1>;

About 106 bytes I think

>>     step@0 { 16
            type = "regulator"; 24
>>        phandle = <&backlight_reg>; 16
>>        enable = <1>; 16
>>        post-delay = <10>; 16
>>     }
>>     step@1 { 16
            type = "pwm"; 16
>>        phandle = <&pwm 2 5000000>; 24
>>     }
>>     step@2 { 16
            type = "gpio"; 20
>>        phandle = <&gpio 28 0>; 24
>>        enable = <1>; 16
>>     }

220?

>From my understanding mixing strings and numbers in a property is
frowned on though.

>
> Alex.

Regards,
Simon
