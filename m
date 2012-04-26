Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab2DZUdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:33:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59586 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2DZUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:33:00 -0400
Message-ID: <4F99B0F8.4040308@wwwdotorg.org>
Date: Thu, 26 Apr 2012 14:32:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: balbi@ti.com
CC: Hiroshi DOYU <hdoyu@nvidia.com>, swarren@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <1335352072-4001-2-git-send-email-hdoyu@nvidia.com> <4F99A821.2040406@wwwdotorg.org> <20120426202610.GA30690@arwen.pp.htv.fi>
In-Reply-To: <20120426202610.GA30690@arwen.pp.htv.fi>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 02:26 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Apr 26, 2012 at 01:55:13PM -0600, Stephen Warren wrote:
>> On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
>>> Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
>>> ready.
>>
>>> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
>>> +static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
>> ...
>>> +int tegra_ahb_enable_smmu(void)
>>> +{
>>> +	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
>>> +				      __tegra_ahb_enable_smmu);
>>> +}
>>> +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
>>> +#endif
>>
>> That looks like a neat solution to avoid having a global device object.
> 
> except that it won't work always. If you happen to have two AHB bridges,
> each using a separate smmu but only one smmu is ready, this will set
> SMMU_INIT_DONE on both bridges.

There is only 1.

>> However, if that driver_for_each_device finds no devices, the function
>> still succeeds. That doesn't seem right, and doesn't allow e.g. the SMMU
>> to defer its probe until the AHB driver has completed.
>>
>> Perhaps add a local int variable to tegra_ahb_enable_smmu(), pass the
>> address to __tegra_ahb_enable_smmu, and have it increment the int. Then,
>> after calling driver_for_each_device,:
>>
>> if (!ahb_device_count)
>>     return -EPROBE_DEFER
>> if (WARN_ON(ahb_device_count != 1))
>>     return -EINVAL;
>> return 0;
> 
> that would look, well, weird. Why don't you just different initcall
> leves for this ? Maybe smmu goes into postcore_initcall() and tegra_ahb
> goes into postcore_initcall_sync() ?? then you know that SMMU will be
> ready by the time you call tegra_ahb probe. Well, unless smmu's probe
> fail, but then again, IIUC it won't work anyway...

Uggh. I'd rather all these devices just got instantiated from device
tree and relied on deferred probe to manage any ordering, rather than
playing complex games with multiple initcall levels (and in the end
probably having to invent more and more initcall levels to correctly
represent all the dependencies).
