Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2KHRT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:19:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57001 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2KHRT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:19:26 -0500
Message-ID: <509BE99A.8060705@wwwdotorg.org>
Date: Thu, 08 Nov 2012 10:19:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, hs@denx.de,
        nsekhar@ti.com, mikedunn@newsguy.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        gregkh@linuxfoundation.org, hdoyu@nvidia.com, santosh.shilimkar@ti.com
Subject: Re: [RFC v2 PATCH 2/2] mtd: davinci - remove DaVinci architecture
 depedency
References: <1352238427-26085-1-git-send-email-m-karicheri2@ti.com> <1352238427-26085-3-git-send-email-m-karicheri2@ti.com> <509ABFD9.8090704@wwwdotorg.org> <509BD67E.2090200@ti.com>
In-Reply-To: <509BD67E.2090200@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 08:57 AM, Murali Karicheri wrote:
> On 11/07/2012 03:08 PM, Stephen Warren wrote:
>> On 11/06/2012 02:47 PM, Murali Karicheri wrote:
>>> DaVinci NAND driver is a controller driver based on the AEMIF hardware
>>> IP found on TI SoCs. It is also used on SoCs that are not DaVinci
>>> based. This
>>> patch removes the driver dependency on DaVinci architecture so that it
>>> can be used on other architectures such as c6x, keystone etc.
>>>
>>> Also migrate the driver to use the new AEMIF platform driver API and
>>> moving Documentation to
>>> Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> as this is expected to be used outside of arm/davinci.
>>>   delete mode 100644
>>> Documentation/devicetree/bindings/arm/davinci/nand.txt
>>>   create mode 100644
>>> Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>>   create mode 100644 include/linux/platform_data/davinci-nand.h
>> Using "git format-patch -M" might show this as a file move/rename rather
>> than a delete/add, which would be useful to highlight any changes you
>> made at the same time.
>>
>>> diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
>>> +Example (enbw_cmc board):
>>> +aemif@60000000 {
>>> +    compatible = "ti,davinci-aemif";
>>> +    #address-cells = <2>;
>>> +    #size-cells = <1>;
>>> +    reg = <0x68000000 0x80000>;
>>> +    ranges = <2 0 0x60000000 0x02000000
>>> +          3 0 0x62000000 0x02000000
>>> +          4 0 0x64000000 0x02000000
>>> +          5 0 0x66000000 0x02000000
>>> +          6 0 0x68000000 0x02000000>;
>>> +    nand@3,0 {
>> Here, isn't 3,0 the aemif chip-select ID that is decoding the NAND
>> accesses?
>>
> Yes.
>>> +        compatible = "ti,davinci-nand";
>>> +        reg = <3 0x0 0x807ff
>>> +            6 0x0 0x8000>;
>>> +        #address-cells = <1>;
>>> +        #size-cells = <1>;
>>> +        ti,davinci-chipselect = <1>;
>> So I don't understand why that chipselect property is needed, or has a
>> different value. Is this muxing the AEMIF output chip-selects onto
>> different SoC package pins or something? Seems like a job for pinctrl
>> perhaps?
>
> Actually this was added by somebody else. Do you know what 0 in 3,0
> stands for? Is there a way I can retrieve the chip-select id so that I
> can remove the davinci-chipselect property. The driver uses a cs index
> of 0-3 and the hardware documentation refers CS2-5. Actually cs2 is CE0
> signal. So internally driver
> translates to 2-5 to 0-3. pinmux is currently done in platform specific
> init code and probably need to migrate to use pictrl later.

for a node named "nand@3,0", the "3,0" is the address value from the
first entry in the reg property "reg = <3 0x0 0x807ff ...". Given your
previous email, that means chip-select 3 offset 0, I believe. Presumably
you can read the reg property directly to find these numbers, or perhaps
there are already some helper functions for this. I have no idea why
there's a "3" in the node name and reg property, but
"ti,davinci-chipselect = <1>" not "= <3>".
