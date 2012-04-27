Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2D0Gz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:55:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6754 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2D0Gz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:55:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Apr 2012 23:55:18 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
Date: Fri, 27 Apr 2012 08:55:12 +0200
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
Thread-Topic: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
Thread-Index: Ac0kQrH/aS4j7AcGT0GBCa3JFikGPQ==
Message-ID: <20120427.095512.2246787149498272095.hdoyu@nvidia.com>
References: <4F99B0F8.4040308@wwwdotorg.org><20120426203847.GC30690@arwen.pp.htv.fi><20120427.094826.1181797260264746303.hdoyu@nvidia.com>
In-Reply-To: <20120427.094826.1181797260264746303.hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <hdoyu@nvidia.com>
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
Date: Fri, 27 Apr 2012 09:48:26 +0300 (EEST)
Message-ID: <20120427.094826.1181797260264746303.hdoyu@nvidia.com>

> From: Felipe Balbi <balbi@ti.com>
> Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
> Date: Thu, 26 Apr 2012 22:38:48 +0200
> Message-ID: <20120426203847.GC30690@arwen.pp.htv.fi>
> 
> > * PGP Signed by an unknown key
> > 
> > Hi,
> > 
> > On Thu, Apr 26, 2012 at 02:32:56PM -0600, Stephen Warren wrote:
> > > On 04/26/2012 02:26 PM, Felipe Balbi wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Apr 26, 2012 at 01:55:13PM -0600, Stephen Warren wrote:
> > > >> On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> > > >>> Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> > > >>> ready.
> > > >>
> > > >>> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> > > >>> +static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
> > > >> ...
> > > >>> +int tegra_ahb_enable_smmu(void)
> > > >>> +{
> > > >>> +	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
> > > >>> +				      __tegra_ahb_enable_smmu);
> > > >>> +}
> > > >>> +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> > > >>> +#endif
> > > >>
> > > >> That looks like a neat solution to avoid having a global device object.
> > > > 
> > > > except that it won't work always. If you happen to have two AHB bridges,
> > > > each using a separate smmu but only one smmu is ready, this will set
> > > > SMMU_INIT_DONE on both bridges.
> > > 
> > > There is only 1.
> > 
> > that's why there's a "if you happen to have" statement. If you stick to
> > this "there is only 1" argument, why do you even make this into a
> > platform driver ? Just stick the entire code hidden on the
> > machine_init() code. Drivers a supposed to be able to instantiated
> > multiple times and always work, this method won't work if tegra99999
> > ends up with two AHB bridges/SMMUs
> > 
> > > >> However, if that driver_for_each_device finds no devices, the function
> > > >> still succeeds. That doesn't seem right, and doesn't allow e.g. the SMMU
> > > >> to defer its probe until the AHB driver has completed.
> > > >>
> > > >> Perhaps add a local int variable to tegra_ahb_enable_smmu(), pass the
> > > >> address to __tegra_ahb_enable_smmu, and have it increment the int. Then,
> > > >> after calling driver_for_each_device,:
> > > >>
> > > >> if (!ahb_device_count)
> > > >>     return -EPROBE_DEFER
> > > >> if (WARN_ON(ahb_device_count != 1))
> > > >>     return -EINVAL;
> > > >> return 0;
> > > > 
> > > > that would look, well, weird. Why don't you just different initcall
> > > > leves for this ? Maybe smmu goes into postcore_initcall() and tegra_ahb
> > > > goes into postcore_initcall_sync() ?? then you know that SMMU will be
> > > > ready by the time you call tegra_ahb probe. Well, unless smmu's probe
> > > > fail, but then again, IIUC it won't work anyway...
> > > 
> > > Uggh. I'd rather all these devices just got instantiated from device
> > > tree and relied on deferred probe to manage any ordering, rather than
> > > playing complex games with multiple initcall levels (and in the end
> > > probably having to invent more and more initcall levels to correctly
> > > represent all the dependencies).
> > 
> > then do that... it'll be better than current trickery with
> > driver_for_each_device() and my initcall trickery ;-)
> 
> Then, what about something like the following?
> 
>  static int tegra_ahb_match_by_smmu(struct device *dev, void *data)
>  {
>  	struct tegra_ahb *ahb = dev_get_drvdata(dev);
>  	struct device_node *dn = data;
>  
>  	return (ahb->dev->of_node == dn) ? 1 : 0
>  }
>  
>  int tegra_ahb_enable_smmu(struct device_node *ahb)
>  {
>  	struct device *dev;
>  	u32 val;
>  
>  	dev = driver_find_device(&tegra_ahb_driver.driver, NULL, ahb,
>  				 tegra_ahb_match_by_smmu);
>  	if (!dev)
>  		return -ENODEV;

+		return -EPROBE_DEFER

Maybe this is better(?).

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
