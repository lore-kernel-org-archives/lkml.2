Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2CLRQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:16:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42408 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2CLRQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:16:23 -0400
Message-ID: <4F5E2F63.6070303@wwwdotorg.org>
Date: Mon, 12 Mar 2012 11:16:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org> <20120312143407.GA4513@shlinux2.ap.freescale.net>
In-Reply-To: <20120312143407.GA4513@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 08:34 AM, Dong Aisheng wrote:
> On Sat, Mar 10, 2012 at 02:14:33AM +0800, Stephen Warren wrote:
>> The core pin controller bindings define:
>> * The fact that pin controllers expose pin configurations as nodes in
>>   device tree.
>> * That the bindings for those pin configuration nodes is defined by the
>>   individual pin controller drivers.
>> * A standardized set of properties for client devices to define numbered
>>   or named pin configuration states, each referring to some number of the
>>   afore-mentioned pin configuration nodes.
>> * That the bindings for the client devices determines the set of numbered
>>   or named states that must exist.

>> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

>> +Required properties:
>> +pinctrl-0:	List of phandles, each pointing at a pin configuration
>> +		node. These referenced pin configuration nodes must be child
>> +		nodes of the pin controller that they configure. Multiple
>> +		entries may exist in this list so that multiple pin
>> +		controllers may be configured, or so that a state may be built
>> +		from multiple nodes for a single pin controller, each
>> +		contributing part of the overall configuration. See the next
>> +		section of this document for details of the format of these
>> +		pin configuration nodes.
>> +
>> +		In some cases, it may be useful to define a state, but for it
>> +		to be empty. This may be required when a common IP block is
>> +		used in an SoC either without a pin controller, or where the
>> +		pin controller does not affect the HW module in question. If
>> +		the binding for that IP block requires certain pin states to
>> +		exist, they must still be defined, but may be left empty.
>> +
>
> It looks this functions similar as the PIN_MAP_DUMMY_STATE you introduced
> before to address the issues that the shared IP block may need or not need
> pinctrl configuration on different platforms(correct me if wrong).

Yes, it's to generate the dummy states.

> Then, there may be cases like below which may look a bit confusing
> to people.
> device {
> 	pinctrl-names = "active", "idle";
> 	pinctrl-0;
> 	pinctrl-1;
> };

I'd personally expect the syntax to look like:

device {
	pinctrl-names = "active", "idle";
	pinctrl-0 = <>;
	pinctrl-1 = <>;
};

which has an explicitly empty value. Admittedly, these would both
compile down to the exact same thing in the DTB, but I think the
interpretation of the above is pretty readable.

> I'm wondering if we can let each individual driver to handle this special case?
> Like checking device id then make decision whether call pinctrl_* APIs.
> Then we can just do not define those properties for devices who
> do not need pin configurations.

The individual client drivers certainly could work that way.

However, the disadvantage is that the client driver then needs explicit
code to deal with this case, and this needs to be triggered by using a
different compatible flag (or perhaps some other explicit property).
You'd have to write this code over and over for each individual driver.

That also means that if you were the first user of an IP block in a
system which didn't need pin muxing for it, you'd have to modify the
kernel to support pinctrl being optional before you could use that device.

If the pinctrl subsystem itself hides this from the client driver, then
you'd never need to add any code to any driver to support this case, and
all you'd need to do is write a few lines of device tree to use the
driver; no code changes.
