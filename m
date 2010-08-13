Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab0HMKxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934156Ab0HMKxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:53:23 -0400
Message-ID: <4C6524EC.3020200@redhat.com>
Date: Fri, 13 Aug 2010 12:56:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Laurens Leemans <laurens@signips.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: Add support for the Fintek F71808E
References: <20100801132226.GE3711@salidar.me.mortis.eu> <1280669402-31213-1-git-send-email-me@mortis.eu> <4C5950B6.5010503@redhat.com> <20100804154431.GA14382@salidar.me.mortis.eu>
In-Reply-To: <20100804154431.GA14382@salidar.me.mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/04/2010 05:44 PM, Giel van Schijndel wrote:
> On Wed, Aug 04, 2010 at 13:36:22 +0200, Hans de Goede wrote:
>> On 08/01/2010 03:30, Giel van Schijndel wrote:
>>> Allow device probing to recognise the Fintek F71808E.
>>>
>>> Sysfs interface:
>>>    * Fan/pwm control is the same as for F71889FG
>>
>> My datasheet strongly disagrees with this the F71889FG has 5 pwm zones
>> each with their own speed divided by 4 boundary temps, where as
>> the F71808E has 3 pwm zones divided by 2 boundary temps. So it is much
>> more like the F71862FG, which also has 2 boundary temps, and 3 pwm zones,
>> *but* the F71862FG has one pwm zone hardwired to 100%.
>
> I'm assuming that by "pwm zone" you mean a separate PWM output channel?
> I.e. each "pwm zone" controls a single fan?
>

With pwm zone I mean the number of different speeds which can be programmed
for one output channel, the temps divide the entire temp range into zones
(number of zones == number of temps + 1) and for each zone one can then
tell at what speed / pwm setting the fan should operate when the temperature
is in that zone.


<snip>

>> Also while making changes, I must say I don't like the splitting
>> of fxxxx_temp_attr into fxxxx_temp_attr and f71862_temp_attr just because
>> the number of sensors differs. I think it would be better to instead
>> make fxxxx_temp_attr a 2 dimensional array like fxxxx_fan_attr and like
>> with fxxxx_fan_attr register as many sensor attr blocks as the specific
>> model has.
>
> Right, that's probably a nicer way of going about it, I think that might
> be easier done in a separate patch (most likely preceding the addition
> of F71808E support), though I'll look at that.
>

Yes first splitting the attr in a separate patch would be very good.

>>> Signed-off-by: Giel van Schijndel<me@mortis.eu>
>>> ---
>>>    Documentation/hwmon/f71882fg |    4 ++
>>>    drivers/hwmon/Kconfig        |    6 ++--
>>>    drivers/hwmon/f71882fg.c     |   83 ++++++++++++++++++++++++++++++++++++++----
>>>    3 files changed, 82 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/Documentation/hwmon/f71882fg b/Documentation/hwmon/f71882fg
>>> index a7952c2..1a07fd6 100644
>>> --- a/Documentation/hwmon/f71882fg
>>> +++ b/Documentation/hwmon/f71882fg
>>> @@ -2,6 +2,10 @@ Kernel driver f71882fg
>>>    ======================
>>>
>>>    Supported chips:
>>> +  * Fintek F71808E
>>> +    Prefix: 'f71808fg'
>>
>> This is wrong, as you already indicate and the datasheet as well this
>> chip in question is an f71808e not an f71808fg, also note that there is
>> an f71808a model as well which is different (and has a different super io
>> chip id).
>
> Ah yes, I think I, wrongly, assumed that 'fg' was just some suffix used
> in this driver.  For example, I cannot find F71889FG in the datasheet I
> have, only 'F71889' along with 'F71889F' in the section "Ordering
> Information" (for the F71889 I've got datasheet version V0.17P released
> December 2008).
>

I have a V0.27P datasheet for the 71889, but yes the fg suffix does not
seem to be mentioned anywhere in the datasheet not sure where it comes from.
I do know however that there are now new chips coming out with different
a and e suffixes so I suggest that we stay with fg for the old chips and
use a and e to distuingish the new ones.

> At the same time the F71808E datasheet I have clearly marks the chip as
> F71808E all over the entire datasheet (version V0.17P released October
> 2009).
>

Right.

> Either way I changed that ^^ portion of documentation while changing the
> enumeration value 'f71808fg' ->  'f71808e' in the code itself as well.
>

Good.

>> One last request in the second switch case in f71882fg_remove()
>> there is a default label which contains a comment which models it applies
>> to, please add the f71808e to that comment.
>
> Wouldn't it be better, to instead replace that 'default' label with a
> serie of case labels that code applies to?  Along with providing the
> same documentation effect (expressed in C instead of English) it would
> cause GCC to warn whenever one of the chips was forgotten in a switch
> statement.

Ack, if you could do that that would be great! Please do that
in a preparation patch though and not in the main patch.

<snip>

> PS For comparison, which datasheet versions do you have?
> All Fintek datasheets I have access to:
>   * F71808E - V0.17P, October 2009
>   * F71858  - V0.26P, July 2007
>   * F71862  - V0.28P, July 2008
>   * F71882  - V0.24P, November 2006
>   * F71889  - V0.17P, December 2008
>
> Those most interesting are of course the F71808E, F71862 and F71889---as
> you refer to those in your text.  This because I have already had
> experience with a hardware vendor giving me the wrong datasheets and
> would like to prevent any such mistakes from causing similar
> communication problems here.

Here is my list:
F71612A_V020P.pdf
F71808A_V0.15P.pdf
F71808E_V0.20P.pdf
F71858_V026P.pdf
F71862_V028P.pdf
F71869E_V0.19P.pdf
F71869_V1.1.pdf
F71882_V0.24P.pdf
F71889E_V0.19P.pdf
F71889_V0.27P.pdf
F8000_REG.pdf

Regards,

Hans
