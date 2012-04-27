Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab2D0PtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:49:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54893 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760709Ab2D0PtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:49:04 -0400
Message-ID: <4F9ABFEC.3090107@wwwdotorg.org>
Date: Fri, 27 Apr 2012 09:49:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
References: <20120426202610.GA30690@arwen.pp.htv.fi><4F99B0F8.4040308@wwwdotorg.org><20120426203847.GC30690@arwen.pp.htv.fi> <20120427.094826.1181797260264746303.hdoyu@nvidia.com>
In-Reply-To: <20120427.094826.1181797260264746303.hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 12:48 AM, Hiroshi Doyu wrote:
...
> Then, what about something like the following?
> 
>  static int tegra_ahb_match_by_smmu(struct device *dev, void *data)
>  {
>  	struct tegra_ahb *ahb = dev_get_drvdata(dev);
>  	struct device_node *dn = data;
>  
>  	return (ahb->dev->of_node == dn) ? 1 : 0
>  }

I imagine that function and the driver_find_device() call that uses it
will be pretty common. It may make sense as a drivers/of utility
function, although perhaps we can wait until later to refactor it, once
we actually have multiple pieces of code that do this same thing.

>  int tegra_ahb_enable_smmu(struct device_node *ahb)
>  {
>  	struct device *dev;
>  	u32 val;
>  
>  	dev = driver_find_device(&tegra_ahb_driver.driver, NULL, ahb,
>  				 tegra_ahb_match_by_smmu);
>  	if (!dev)
>  		return -ENODEV;

Yes, -EPROBE_DEFER here as you mentioned in your followup email.

>  
>  	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
>  	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
>  	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);
>  	return 0;
>  }
>  EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> 
> 	Modified arch/arm/boot/dts/tegra30.dtsi
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> index 655bc47..28f9138 100644
> --- a/arch/arm/boot/dts/tegra30.dtsi
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -242,5 +242,6 @@
>  	smmu {
>  		compatible = "nvidia,tegra30-smmu";
>  		mc = <&mc>;
> +		ahb = <&ahb>;
>  	};
>  };

Yes, that's probably the best (even only) way to connect the two drivers
precisely.
