Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2HXEZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:25:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37186 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2HXEZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <5036B8EB.5050502@wwwdotorg.org>
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
	<1345720529-32315-2-git-send-email-thomas.abraham@linaro.org>
	<5036B8EB.5050502@wwwdotorg.org>
Date: Fri, 24 Aug 2012 09:55:16 +0530
Message-ID: <CAJuYYwQ2fGxVddWiaUGXQWfSUCw9LBBpYF=pKPFkU5RmZfpJRg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] pinctrl: add samsung pinctrl and gpiolib driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, dong.aisheng@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 August 2012 04:42, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/23/2012 05:15 AM, Thomas Abraham wrote:
>> Add a new device tree enabled pinctrl and gpiolib driver for Samsung
>> SoC's. This driver provides a common and extensible framework for all
>> Samsung SoC's to interface with the pinctrl and gpiolib subsystems. This
>> driver supports only device tree based instantiation and hence can be
>> used only on those Samsung platforms that have device tree enabled.
>>
>> This driver is split into two parts: the pinctrl interface and the gpiolib
>> interface. The pinctrl interface registers pinctrl devices with the pinctrl
>> subsystem and gpiolib interface registers gpio chips with the gpiolib
>> subsystem. The information about the pins, pin groups, pin functions and
>> gpio chips, which are SoC specific, are parsed from device tree node.
>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
>
> BTW, this is a very nicely written and complete/precise binding
> document. Well done.

Thank you!

>
>> +Samsung GPIO and Pin Mux/Config controller
>> +
>> +Samsung's ARM based SoC's integrates a GPIO and Pin mux/config hardware
>> +controller. It controls the input/output settings on the available pads/pins
>> +and also provides ability to multiplex and configure the output of various
>> +on-chip controllers onto these pads.
>> +
>> +Required Properties:
>> +- compatible: should be one of the following.
>> +  - "samsung,pinctrl-exynos4210": for Exynos4210 compatible pin-controller.
>> +  - "samsung,pinctrl-exynos5250": for Exynos5250 compatible pin-controller.
>> +
>> +- reg: Base address of the pin controller hardware module and length of
>> +  the address space it occupies.
>> +
>> +- interrupts: interrupt specifier for the controller. The format and value of
>> +  the interrupt specifier depends on the interrupt parent for the controller.
>> +
>> +- Pin mux/config groups as child nodes: The pin mux (selecting pin function
>
> Direct child nodes of the pin-controller, not a second level?

The child nodes would be direct child nodes.

>
> While that's quite legal, it means that if you need a particular client
> module to use 4 pins, 2 of which need one samsung,pin-function value and
> 2 of which need a different pin-function value, then the client device's
> pinctrl-0 property has to have two entries.
>
> i.e. a completely hypothetical example roughly based on yours below:
>
>         pinctrl_1: pinctrl@11000000 {
>                 uart0_rxd: uart0-rxd {
>                         samsung,pins = "gpa0-0";
>                         samsung,pin-function = <2>;
>                         samsung,pin-pud = <0>;
>                         samsung,pin-drv = <0>;
>                 };
>
>                 uart0_txd: uart0-txd {
>                         samsung,pins = "gpa0-1";
>                         samsung,pin-function = <1>;
>                         samsung,pin-pud = <0>;
>                         samsung,pin-drv = <0>;
>                 };
>         };
>
>         uart@13800000 {
>                 pinctrl-names = "default";
>                 pinctrl-0 = <&uart0_rxd &uart0_txd>;
>         };
>
> rather than:
>
>         pinctrl_1: pinctrl@11000000 {
>                 uart0_opt1: uart0-opt1 {
>                         uart0_rxd: uart0-rxd {
>                                 samsung,pins = "gpa0-0";
>                                 samsung,pin-function = <2>;
>                                 samsung,pin-pud = <0>;
>                                 samsung,pin-drv = <0>;
>                         };
>
>                         uart0_txd: uart0-txd {
>                                 samsung,pins = "gpa0-1";
>                                 samsung,pin-function = <1>;
>                                 samsung,pin-pud = <0>;
>                                 samsung,pin-drv = <0>;
>                         };
>                 };
>         };
>
>         uart@13800000 {
>                 pinctrl-names = "default";
>                 pinctrl-0 = <&uart0_opt1;
>         };
>
> The latter layout simplifies writing the client nodes, since all the
> related settings can be grouped together by whoever writes the pinctrl
> node, rather than every client author having to work out all the entries
> to include in the list.
>
> That all said, the way you've defined the binding is perfectly
> legitimate, and I don't have any kind of issue with it; it's just
> something you might want to consider.

Thanks for suggesting this alternate method. I do agree with your
point. But, for now, I would prefer to stabilize this driver without
changing the dt parsing code and make it usable for client nodes. I
will revisit your suggested approach at a later point. I assume for
now that the author's of client nodes know which pin settings to
select.

>
> Irrespective of whether you choose to keep the binding as-is, or change
> it, please consider it:
>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks.

>
>> +  The values specified by these config properties should be dervied from the
>
> s/dervied/derived/

Ok.

>
>> +External GPIO and Wakeup Interrupts:
>> +
>> +The controller supports two types of external interrupts over gpio. The first
>> +is the external gpio interrupt and second is the external wakeup interrupts.
>> +The difference between the two is that the external wakeup interrupts can be
>> +used as system wakeup events.
>> +
>> +A. External GPIO Interrupts: For supporting external gpio interrupts, the
>> +   properties should be specified in the pin-controller device node.
>
> s/the properties/the following properties/ ?

Ok.

>
>> +Aliases:
>> +
>> +All the pin controller nodes should be represented in the aliases node using
>> +the following format 'pinctrl{n}' where n is a unique number for the alias.
>
> There /should/ be an alias, or there /may/ be; I'm not sure why
> requiring or recommending an alias would be particularly important for
> this device?

The alias is required since the SoC data for a particular instance is
dependent on the instance number. And the instance number is derived
from the alias.

>
> I've only had time to review the binding document so far.

Ok. Thanks Stephen for your comments on this patch.

Regards,
Thomas.
