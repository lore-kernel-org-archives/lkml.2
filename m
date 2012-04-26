Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2DZTzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:55:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56948 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab2DZTzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:55:16 -0400
Message-ID: <4F99A821.2040406@wwwdotorg.org>
Date: Thu, 26 Apr 2012 13:55:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: swarren@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <1335352072-4001-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335352072-4001-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> ready.

> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> +static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
...
> +int tegra_ahb_enable_smmu(void)
> +{
> +	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
> +				      __tegra_ahb_enable_smmu);
> +}
> +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> +#endif

That looks like a neat solution to avoid having a global device object.

However, if that driver_for_each_device finds no devices, the function
still succeeds. That doesn't seem right, and doesn't allow e.g. the SMMU
to defer its probe until the AHB driver has completed.

Perhaps add a local int variable to tegra_ahb_enable_smmu(), pass the
address to __tegra_ahb_enable_smmu, and have it increment the int. Then,
after calling driver_for_each_device,:

if (!ahb_device_count)
    return -EPROBE_DEFER
if (WARN_ON(ahb_device_count != 1))
    return -EINVAL;
return 0;
