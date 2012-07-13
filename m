Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2GMLgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 07:36:18 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:35251 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201Ab2GMLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 07:36:17 -0400
Message-ID: <500007F5.7060306@stericsson.com>
Date: Fri, 13 Jul 2012 17:05:17 +0530
From: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Organization: st.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: <arnd@arndb.de>
Cc: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        <patches@linaro.org>, <linux-kernel@vger.kernel.org>,
        <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev-request@lists.linaro.org" 
	<linaro-dev-request@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mfd: Implement devicetree support for AB8500 Btemp
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Tue, 10 Jul 2012 14:12:01 +0000
> From: Arnd Bergmann <arnd@arndb.de>
> To: linux-arm-kernel@lists.infradead.org
> Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
>         "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
patches@linaro.org
> Subject: Re: [PATCH] mfd: Implement devicetree support for AB8500
>         Btemp
> Message-ID: <201207101412.01561.arnd@arndb.de>
> Content-Type: Text/Plain;  charset="utf-8"
>
> On Tuesday 10 July 2012, Rajanikanth H.V wrote:
>
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
>> @@ -0,0 +1,54 @@
>> +AB8500 Battery Termperature Monitor Driver
>> +
>> +AB8500 is a mixed signal multimedia and power management
>> +device comprising: power and energy management module,
>> +WalliCharger and USB charger interface, audio, general
>> +purpose ADC TVOut, clock management and SIM card Interface.
>> +
>> +Battery temperature monitoring support is part of 'energy
>> +management module', the other components of this module
>> +are: 'main and USB Combo charger' and fuel guage.
>> +
>> +The properties below describes the node for battery
>> +temperature monitor driver.
>> +
>> +Required Properties:
>> +- compatible = "stericsson,ab8500-btemp"
>> +
>> +interrupts:
>> +     Four battery temperature ranges are be defined
>> +     which results in interrupt events as:
>> +     - Btemp
>> +     - BtempLow
>> +     - BtempMedium
>> +     - BtempHigh
>> +
>
> These names do not match the five interrupts in the example or in the
> code. When you provide an "interrupt-names" property you have to define
> the exact strings that are permissible for them in the binding.
>
>> +Supplied-to:
>> +     This shall be power supply class dependency where in the
runtime battery
>> +     properties will be shared across fuel guage and charging
algorithm driver.
>
> I probably don't understand enough of this, but shouldn't the other
devices
> that are supplied by this have a reference to this node rather than doing
> it this way around? Why use strings here instead of phandles?

This is a logical binding w.r.t power supply event change
across energy-management-module drivers where in runtime battery
properties are shared along with uevent notification.
ref: di->btemp_psy.external_power_changed =
     ab8500_btemp_external_power_changed;
     ref: ab8500_btemp.c

Need for this property:
 btemp, fg and charger updates power-supply properties
 based on the events listed above.
 Event handler invokes power supply change notifier
 which in-turn invokes registered power supply class call-back
 based on the 'supplied_to' string.
 ref:
   power_supply_changed_work(..) ./drivers/power/power_supply_core.c

In this case how to approach through phandle?

>
> You are also not listing some of the properties that are in the device
> tree here, like the "interrupts" property itself.
>
>> diff --git a/arch/arm/mach-ux500/board-mop500-bm.c
b/arch/arm/mach-ux500/board-mop500-bm.c
>> new file mode 100644
>> index 0000000..3349ceb
>> --- /dev/null
>> +++ b/arch/arm/mach-ux500/board-mop500-bm.c
>
> Didn't we conclude that this file has no board-specific information in it?
> Either explain why it's still here, or move it into the driver itself.
>
>> +/*
>> + * Note that the batres_vs_temp table must be strictly sorted by falling
>> + * temperature values to work.
>> + */
>> +#ifdef CONFIG_AB8500_9100_LI_ION_BATTERY
>> +#define BATRES       180
>> +#else
>> +#define BATRES       300
>> +#endif
>
> I think I mentioned before that you need to get rid of the
> CONFIG_AB8500_9100_LI_ION_BATTERY symbol. If you have exclusive
> compile-time options, it is impossible to build a kernel that
> runs on all system, so this has to be a run-time option.
>
>         Arnd
>
>
>

