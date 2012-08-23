Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2HWFQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:16:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57728 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2HWFQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:16:34 -0400
Message-ID: <5035BCB1.8000801@wwwdotorg.org>
Date: Wed, 22 Aug 2012 23:16:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: Zhao Richard-B20223 <B20223@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "paul.liu@linaro.org" <paul.liu@linaro.org>
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
References: <1345619928-15446-1-git-send-email-b29396@freescale.com> <1345619928-15446-2-git-send-email-b29396@freescale.com> <20120822082940.GJ4011@b20223-02.ap.freescale.net> <20120822105729.GB10057@shlinux2.ap.freescale.net>
In-Reply-To: <20120822105729.GB10057@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 04:57 AM, Dong Aisheng wrote:
> On Wed, Aug 22, 2012 at 04:29:41PM +0800, Zhao Richard-B20223 wrote:
>> On Wed, Aug 22, 2012 at 03:18:42PM +0800, Dong Aisheng wrote:
>>> Add regmap based imx syscon driver.
>>> This is usually used for access misc bits in registers which does not belong
>>> to a specific module, for example, IOMUXC GPR and ANATOP.
>>> With this driver, we provide a standard API for client driver to call to
>>> access registers which are registered into syscon.

>>> +static int imx_syscon_match(struct device *dev, void *data)
>>> +{
>>> +	struct imx_syscon *syscon = dev_get_drvdata(dev);
>>> +	struct device_node *dn = data;
>>> +
>>> +	return (syscon->dev->of_node == dn) ? 1 : 0;
>>> +}
>>> +
>>> +int imx_syscon_write(struct device_node *np, u32 reg, u32 val)
>>
>> For API function, is it better to use struct device rather not np?
>>  - it won't need to search dev in below code every time it access
>>    registers.
>
> The purpose is not require client driver to know the implementation details
> of imx_syscon_{read/write} API, it's more easy to use since client only
> needs pass the device node to which it wants to read/write.
> 
> For search dev, it doesn't look like a big issue since it only search devices
> attached on the driver which is very quick.
> And hide it in common API does not require every client driver to write
> duplicated codes.

You could still implement a function:

struct device *imx_syscon_lookup(struct device_node *np)

... and require all clients to call that, and pass the dev to the other
functions. That'd still keep all the lookup code in one place, but
prevent it having to run every time, no matter how small it is.

I think such an API is required anyway, since client drivers need some
way to determine whether the imx_syscon driver is available yet, and if
not defer their probe until it is.

So, clients would do:

foo->syscon_dev = imx_syscon_lookup(np);
if (!foo->syscon_dev)
    return -EPROBE_DEFER;

rather than:

foo->syscon_np = np;

Not too much overhead/boiler-plate in each client driver.
