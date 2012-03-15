Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979Ab2CORTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:19:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296Ab2CORTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:19:00 -0400
Message-ID: <4F62247F.5090103@wwwdotorg.org>
Date: Thu, 15 Mar 2012 11:18:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org> <20120312143407.GA4513@shlinux2.ap.freescale.net> <4F5E2F63.6070303@wwwdotorg.org> <20120313032010.GB4513@shlinux2.ap.freescale.net> <4F5F9F9E.7030706@wwwdotorg.org> <20120315033257.GD13022@shlinux2.ap.freescale.net>
In-Reply-To: <20120315033257.GD13022@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 09:32 PM, Dong Aisheng wrote:
> On Wed, Mar 14, 2012 at 03:27:26AM +0800, Stephen Warren wrote:
>> On 03/12/2012 09:20 PM, Dong Aisheng wrote:
...
>>> I can't see why we still need a special compatible flag to tell driver.
>>> Just do not define pinctrl-* properties for that devices in device tree.
>>> Did i understand wrong?
>>
>> The compatible property would be the only way to implement anything like
>> is_soc_foo. However, it's a bad idea to overload the compatible property
>> in this way.
>
> I guess i might not describe my idea clearly.
> My idea is that the compatible string does that work.
> For example:
> static const struct of_device_id mxs_mmc_dt_ids[] = {
>         { .compatible = "fsl,imx23-mmc", .data = NULL, },
>         { .compatible = "fsl,imx28-mmc", .data = NULL, },
>         { /* sentinel */ }
> };
> MODULE_DEVICE_TABLE(of, mxs_mmc_dt_ids);
>
> Replace NULL to some special data like SOC_MX23 or SOC_MX28 can let driver
> driver know which SoC it's running on.
> Then driver can use private macro like is_soc_foo.

OK, you could implement is_soc_foo based on the compatible flag.
However, it's best not to do that.

Instead of asking is_soc_foo(), you should really ask has_bug_xxx() or
has_feature_xxx(), and implement those based on either the compatible
flag, or perhaps other properties.

That way, when 10 of the 20 SoCs that contain the IP block all have the
same feature or need the same bugfix, the code that implements the
bugfix just calls a single has_bug_xxx() rather than having to sprinkle
many many is_soc_foo() calls through the code, which gets unmaintainable.

>>>> That also means that if you were the first user of an IP block in a
>>>> system which didn't need pin muxing for it, you'd have to modify the
>>>> kernel to support pinctrl being optional before you could use that device.
>>>
>>> Why need modify the kernel?
>>> Assuming above example.
>>> I'm a bit confused.
>>
>> If the driver contains code like:
>>
>> if (is_soc_a) {
>>     ...
>> } else if (is_soc_b) {
>>    ...
>> }
>> ...
>>
>> Then in order to support a new SoC, even if the driver doesn't need to
>> do anything different, you'd need to go and edit the code to add an "if
>> (is_soc_c)" condition into that list.
>
> No.
> No changes needed if the driver does not need to do anything different.
> Compatible string does that work

To make the driver support a new compatible property value, you have to
edit the driver to add it to the of_device_id table, and recompile it.
