Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2IYGTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:19:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38340 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2IYGTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:19:16 -0400
Message-ID: <50614CE2.7010301@wwwdotorg.org>
Date: Tue, 25 Sep 2012 00:19:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v2] pwm_backlight: Add device tree support for Low Threshold
 Brightness
References: <1348203080-16348-1-git-send-email-avinashphilip@ti.com> <505BF83D.8040201@wwwdotorg.org> <518397C60809E147AF5323E0420B992E3E9A685B@DBDE01.ent.ti.com> <505CA74B.2090405@wwwdotorg.org> <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9A8449@DBDE01.ent.ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 10:29 PM, Philip, Avinash wrote:
> On Fri, Sep 21, 2012 at 23:13:39, Stephen Warren wrote:
>> On 09/21/2012 12:03 AM, Philip, Avinash wrote:
>>> Hi Stephen,
>>>
>>> On Fri, Sep 21, 2012 at 10:46:45, Stephen Warren wrote:
>>>> On 09/20/2012 10:51 PM, Philip, Avinash wrote:
>>>>> Some backlights perform poorly when driven by a PWM with a short
>>>>> duty-cycle. For such devices, the low threshold can be used to specify a
>>>>> lower bound for the duty-cycle and should be chosen to exclude the
>>>>> problematic range.
>>>>>
>>>>> This patch adds support for an optional low-threshold-brightness
>>>>> property.
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>>>>
>>>>>  Optional properties:
>>>>>    - pwm-names: a list of names for the PWM devices specified in the
>>>>>                 "pwms" property (see PWM binding[0])
>>>>> +  - low-threshold-brightness: brightness threshold low level. Low threshold
>>>>> +    brightness set to value so that backlight present on low end of
>>>>> +    brightness.
>>>>
>>>> For my education, why not just specify values above this value in the
>>>> brightness-levels array; how do those two interact?
>>>
>>> Please find details from 
>>> https://lkml.org/lkml/2012/7/18/284
>>
>> Hmm. That still doesn't really explain what this property does.
>>
>> I'm going to guess that if this property is present, and values in the
>> brightness-levels property get scaled between the
>> low-threshold-brightness and 255 instead of being used directly.
> 
> This is correct.
> 
>> But then, in the email you linked to, what does "But brightness-levels won't
>> be uniformly divided" mean?
> 
> For some panels, backlight would absent on low end of brightness due to low
> percentage in duty_cycle. Consider following example where backlight absent
> for brightness levels from 0 - 51.
> 
> pwms = <&pwm 0 50000>;
> brightness-levels = <0 51 53 56 62 75 101 152 255>; 
> default-brightness-level = <6>;
> 
> So in the example, brightness-levels are set to have values for backlight present.
> Here levels are not uniformly divided.

So why not just change the values so they /are/ what you want? After
all, it's just data and you can put whatever values you want there. What
is preventing you from doing this?

Perhaps e.g.:

brightness-levels = <0 101 106 112 124 150 202 304 511>;
(just multiplying everything by N, for arbitrary N=2, to get extra
precision)

... plus whatever adjustments are required to make the data "uniformly
divided", which I can't do in the example here since I'd need to know
whatever non-linear equation characterizes the backlight's PWM % duty
cycle to perceived brightness mapping.

The only thing that could be preventing this is mathematical precision.
While all the PWM DT examples I've seen have brightness-levels range
from 0..255, I don't think there is any such actual limit; you could
range from say 0..1000000 if you wanted, right?

>> Either way, the DT binding should explain exactly what this value is
>> used for, and how it affects the interpretation of values in
>> brightness-levels.
> 
> Is DT binding documentation a good place to explain this feature?
> Initially Thierry suggested document option. So I left out.

The binding documents are supposed to be a standalone description of
what the data in DT does; given general no-Linux-specific domain
knowledge, the binding document should be detailed enough for someone to
understand how to fill in the DT. So, yes, I think the binding document
would be a great place to put such documentation.
