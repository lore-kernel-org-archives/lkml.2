Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423374Ab2LFMgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:36:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41431 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab2LFMgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:36:40 -0500
Message-ID: <50C0913B.9070802@ti.com>
Date: Thu, 6 Dec 2012 13:36:11 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 3/3] leds: leds-pwm: Add device tree bindings
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-4-git-send-email-peter.ujfalusi@ti.com> <20121206100052.EC8293E0E22@localhost>
In-Reply-To: <20121206100052.EC8293E0E22@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 12/06/2012 11:00 AM, Grant Likely wrote:
> On Mon, 12 Nov 2012 15:41:10 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> Support for device tree booted kernel.
>> When the kernel is booted with DeviceTree blob we support one led per
>> leds-pwm device to have cleaner integration with the PWM subsystem.
>>
>> For usage see:
>> Documentation/devicetree/bindings/leds/leds-pwm.txt
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  .../devicetree/bindings/leds/leds-pwm.txt          |  34 ++++++
>>  drivers/leds/leds-pwm.c                            | 125 +++++++++++++++------
>>  2 files changed, 127 insertions(+), 32 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/leds/leds-pwm.txt b/Documentation/devicetree/bindings/leds/leds-pwm.txt
>> new file mode 100644
>> index 0000000..9fe3040
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/leds/leds-pwm.txt
>> @@ -0,0 +1,34 @@
>> +LED connected to PWM
>> +
>> +Required properties:
>> +- compatible : should be "pwm-leds".
>> +- pwms : PWM property, please refer to: 
>> +  Documentation/devicetree/bindings/pwm/pwm.txt
>> +- pwm-names : (optional) Name to be used by the PWM subsystem for the PWM device
>> +- label : (optional) The label for this LED.  If omitted, the label is
>> +  taken from the node name (excluding the unit address).
>> +- max-brightness : Maximum brightness possible for the LED
>> +- linux,default-trigger :  (optional) This parameter, if present, is a
>> +  string defining the trigger assigned to the LED.  Current triggers are:
>> +    "backlight" - LED will act as a back-light, controlled by the framebuffer
>> +		  system
>> +    "default-on" - LED will turn on, but see "default-state" below
>> +    "heartbeat" - LED "double" flashes at a load average based rate
>> +    "ide-disk" - LED indicates disk activity
>> +    "timer" - LED flashes at a fixed, configurable rate
> 
> The binding mostly looks good. However, it seems to be gratuitously
> different from the gpio-leds binding and it duplicates property
> definitions. Please match the gpio-leds behaviour with each led defined
> as a sub node of the pwm-leds node.

The GPIO and PWM bindings are substantially different. For start in pwm we do
not have of_get_pwm* helpers. To get the PWM itself we need to use wpm_get()
which uses the pwms = <>; pwm-names = <>; properties on the device's main node.
This is what I could do at the moment:

twl_pwm: pwm {
	compatible = "ti,twl4030-pwm";
	#pwm-cells = <2>;
};

twl_led: pwmled {
	compatible = "ti,twl4030-pwmled";
	#pwm-cells = <2>;
};

pwmleds {
	compatible = "pwm-leds";
	pwms = <&twl_pwm 0 7812500
		&twl_pwmled 0 7812500>;
	pwm-names = "omap4::keypad",
		    "omap4:green:chrg";
	kpad {
		label = "omap4::keypad";
		max-brightness = <127>;
	};

	charging {
		label = "omap4:green:chrg";
		max-brightness = <255>;
	};


};

The string in pwm-names and under the led section's label must match in order
to be able to get the correct PWM for the led to drive it.
If this is good, I can make the change and resend the series soon.

> Also, please reference the common properties in bindings/leds/common.txt
> (This is a new file in linux-next. See how leds-gpio references it).

Will do that.

-- 
Péter
