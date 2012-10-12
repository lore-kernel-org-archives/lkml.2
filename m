Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab2JLJI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:08:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2JLJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:08:55 -0400
Message-ID: <5077DE0A.4000301@ti.com>
Date: Fri, 12 Oct 2012 14:38:26 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH 1/4] usb: phy: add a new driver for usb3 phy
References: <1348054229-27362-1-git-send-email-kishon@ti.com> <1348054229-27362-2-git-send-email-kishon@ti.com> <20121011005944.GX12552@atomide.com>
In-Reply-To: <20121011005944.GX12552@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thursday 11 October 2012 06:29 AM, Tony Lindgren wrote:
> Hi,
>
> * Kishon Vijay Abraham I <kishon@ti.com> [120919 04:32]:
>> Added a driver for usb3 phy that handles the interaction between usb phy
>> device and dwc3 controller.
>>
>> This also includes device tree support for usb3 phy driver and
>> the documentation with device tree binding information is updated.
>>
>> Currently writing to control module register is taken care in this
>> driver which will be removed once the control module driver is in place.
>
> You may be able to set up the control module register with one
> of the following Linux standard frameworks:
>
> 1. Fixed regulator defined in mach-omap2/control.c

Is it control.c?
>
>     In this case the PHY driver can pick up the regulator by name.

Do you mean we have to define something like fixed_voltage_config 
defined in board-4430sdp.c?
 From whatever I could make out from regulator/fixed.c, 
enabling/disabling of regulator is done using only gpio. I'm not sure 
how we can use that to write to control module register.
>
> 2. A mux mapped with pinctrl framework using pinctrl-single,bits
>     binding
>
>     And in this case the PHY driver can request the named pinctrl
>     states like "enabled" and "disabled".
>
>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> @@ -15,3 +15,21 @@ usb2phy@4a0ad080 {
>>   	reg = <0x4a0ad080 0x58>,
>>   	      <0x4a002300 0x4>;
>>   };
>
> The comments also apply to the omap_usb2.c driver for
> 0x4a002300 above.
>
>> +
>> +OMAP USB3 PHY
>> +
>> +Required properties:
>> + - compatible: Should be "ti,omap-usb3"
>> + - reg : Address and length of the register set for the device. Also
>> +add the address of control module phy power register until a driver for
>> +control module is added
>> +
>> +This is usually a subnode of ocp2scp to which it is connected.
>> +
>> +usb3phy@4a084400 {
>> +	compatible = "ti,omap-usb3";
>> +	reg = <0x0x4a084400 0x80>,
>> +	      <0x4a084800 0x64>,
>> +	      <0x4a084c00 0x40>,
>> +	      <0x4a002370 0x4>;
>> +};
>
> And register 0x4a002370 here. Care to post some info what the
> 0x4a002370 register bits do? Is that same as CONTROL_DEV_CONF
> on omap4, or does it have other bits there too?

It's CONTROL_PHY_POWER_USB register and it's structure looks like this.
31:22 USB_PWRCTL_CLK_FREQ
21:14 USB_PWRCTL_CLK_CMD
13:0 RESERVED

CLK_CMD takes values to power up/down the TX and RX in various combinations.

And CLK_FREQ takes values for clock configuration.

Thanks
Kishon
