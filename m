Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2IEPTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:19:14 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50535 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab2IEPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <k27lbg$hrj$1@ger.gmane.org>
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
	<1345720529-32315-2-git-send-email-thomas.abraham@linaro.org>
	<k27lbg$hrj$1@ger.gmane.org>
Date: Wed, 5 Sep 2012 20:49:09 +0530
Message-ID: <CAJuYYwTuPFK3aLD1jrcn4bQODdVYHg9T1Wt7zkz1pfo0nkRnxQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] pinctrl: add samsung pinctrl and gpiolib driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2012 19:20, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Thomas,
>
> Thomas Abraham wrote:
>> Add a new device tree enabled pinctrl and gpiolib driver for Samsung
>> SoC's. This driver provides a common and extensible framework for all
>> Samsung SoC's to interface with the pinctrl and gpiolib subsystems. This
>> driver supports only device tree based instantiation and hence can be
>> used only on those Samsung platforms that have device tree enabled.
>>
>> This driver is split into two parts: the pinctrl interface and the gpiolib
>> interface. The pinctrl interface registers pinctrl devices with the
>> pinctrl subsystem and gpiolib interface registers gpio chips with the
>> gpiolib subsystem. The information about the pins, pin groups, pin
>> functions and gpio chips, which are SoC specific, are parsed from device
>> tree node.
>>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>
> Does the driver provide any kind of compatibility with current gpiolib
> users?
>
> Let me show an example of what I mean. We have a fixed voltage regulator
> defined in device tree of an imaginary board
>
>         vemmc_reg: voltage-regulator@0 {
>                 compatible = "regulator-fixed";
>                 regulator-name = "VMEM_VDD_2.8V";
>                 regulator-min-microvolt = <2800000>;
>                 regulator-max-microvolt = <2800000>;
>                 gpio = <&gpk0 2 1 0 0>;
>                 enable-active-high;
>         };
>
> The gpio pin used to control status of the regulator is defined using the
> gpio property and regulator-fixed driver uses of_get_named_gpio to get the
> pin number from device tree.
>
> Is this kind of setup also valid when using your pinctrl driver?

Hi Tomasz,

It is possible to get the pin number using of_get_named_gpio()
function with the gpiolib support included in the Samsung pinctrl
driver. The following are the steps on how this can be done. Please
note that, the old Samsung gpio binding will change when we switch the
pinctrl driver. But that was inevitable.

1. The gpio binding will now follow the standard gpio binding.
    Which means, it will be something like

           uart@13800000 {
                         <the usual bindings here>
                         gpios = <&pinctrl_0 10 0>;
           };

   Note that,

   A. First cell: the pin-controller instance is used as the phandle
(i.e &pinctrl_0).
   B. Second cell: the pin number __local__ to the pin controller instance.
   C. Third cell: Flags associated with the gpio pin (as per standard binding).

   The pin number specified in the second cell is local to the
pin-controller instance.

   For example, the Exynos4210 GPJ1[1] pin, which belongs to pinctrl instance 1,
   will have pin number (pin number local to pinctrl instance 1) as 10.

   That is because, the number of pins in GPJ0 is 8. So GPJ1[1] =
nr_pins(GPJ0) + 2
   = 8 + 2 = 10.

   Yes, I understand that this is hard to derive the pin number like
this and write
   in the dts(i) files, but while writing the pinctrl driver, there
were two thoughts.

   A. The pin numbers for all the pins included in a pinctrl instance
will be documented
        in the device tree binding documentation. So it can be easily looked up.

   B. How many instances of listing gpio number like this will ever be
needed for a
       board dts file. Not much, maybe atmost 10.

   Considering the two points above, it seemed okay to derive the pin
numbers for
   the gpio as listed in the above example.


2. The client driver can now lookup the pin number using

            gpio = of_get_gpio(dev->of_node);

    which returns the pin number in the linux gpio space.

So, it is possible to lookup the pin number using Samsung pinctrl driver.

But, I have missed adding the #gpio-cells property in the three
instances of the pinctrl driver. If you are trying this, please add

          #gpio-cells = <2>;

line in all the three instances of the pinctrl controller nodes. I
will send this change as a separate patch.

Thanks,
Thomas.
