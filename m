Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2FOVIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:08:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53296 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab2FOVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:07:58 -0400
Message-ID: <4FDBA429.4090302@gmail.com>
Date: Fri, 15 Jun 2012 16:07:53 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, mturquette@linaro.org,
        "sboyd@codeaurora.org >> Stephen Boyd" <sboyd@codeaurora.org>,
        skannan@codeaurora.org, s.hauer@pengutronix.de
Subject: Re: [PATCH v3 0/4] DT clock bindings
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com> <20120615083937.GH31565@S2101-09.ap.freescale.net>
In-Reply-To: <20120615083937.GH31565@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 03:39 AM, Shawn Guo wrote:
> On Tue, Jun 12, 2012 at 09:41:47AM -0500, Rob Herring wrote:
>> I'm posting this again to solicit further review. There has been some
>> discussion[1], but no definite path forward. This series is not changed
>> from the last post other than rebasing to v3.5-rc2.
>>
> Hi Rob,
> 
> Per your comment[1], the patch below takes imx6q as example to define
> single CCM node with a whole bunch of outputs to support clk lookup
> with device tree.  (Only uart and usdhc clocks are being put there for
> demonstration.)  Though it seems working, going through the patch you
> will see a couple problems which may need to be solved to make the
> binding useful for cases like imx.
> 
> * Different clk matching behavior between DT and non-DT lookup
> 
> Let's take usdhc example (drivers/mmc/host/sdhci-esdhc-imx.c) to
> elaborate the problem.  The driver is being shared by several imx
> SoCs, imx25, imx35, imx5 and imx6.  It needs to get 3 clocks below.
> 
> 	imx_data->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
> 	imx_data->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
> 	imx_data->clk_per = devm_clk_get(&pdev->dev, "per");
> 
> But not every single imx SoC clock tree implementation has all these 3
> clocks for sdhc available.  The imx6q happens to have only "per" clock,
> and clk-imx6q driver registers one clkdev for each usdhc instance with
> con_id being NULL.
> 
> 	clk_register_clkdev(clk[usdhc1], NULL, "2190000.usdhc");
> 	clk_register_clkdev(clk[usdhc2], NULL, "2194000.usdhc");
> 	clk_register_clkdev(clk[usdhc3], NULL, "2198000.usdhc");
> 	clk_register_clkdev(clk[usdhc4], NULL, "219c000.usdhc");
> 
> The non-DT lookup will match all those three clk_get calls to that
> single clkdev entry.  That said, the NULL con_id is treated as wildcard.
> When translating above clk_register_clkdev calls into DT lookup, I
> would expect having "clock-names" absent should just work with all
> those 3 clk_get calls to get <&clks 2>.
> 
> 	usdhc@02190000 {
> 		...
> 		clocks = <&clks 2>;
> 	};
> 
> But with the current of_clk implementation, we will have to have
> something like below to keep the usdhc behavior same as non-DT lookup.
> 
> 	usdhc@02190000 {
> 		...
> 		clocks = <&clks 2>, <&clks 2>, <&clks 2>;
> 		clock-names = "ipg", "ahb", "per";
> 	};

This looks correct to me. The module always has 3 clock inputs, but some
chips may hook up the same clock to all 3 inputs. If you had different
versions of the module, then that would imply different compatible strings.

Which clock input is which should be defined by the order listed and the
names are supposed to be optional, but the current clk_get API doesn't
have any way to specify the index. So either you have to put in the
names or convert the driver to lookup by index. It's really no different
than irqs.

> 
> Can we force all the clk_get calls with different con_id to get the
> only clk listed in "clocks" when "clock-names" is absent, so that we
> can somehow match the behavior with non-DT lookup?
> 
> * phandle argument is not easy for engineering
> 
> As we will have a whole bunch of clock outputs listed in ccm node,
> which will be referenced by peripheral phandle in form of <&clks index>.
> When the list gets long, it becomes hard for people to find the correct
> index number for the clock referenced.

As Stephen pointed out, you just have to document them until we have
defines in dts.

Rob

> 
> Regards,
> Shawn
> 
> [1] http://thread.gmane.org/gmane.linux.kernel/1300259/focus=1301107
> 
> 8<---
>  .../devicetree/bindings/clk/clk-imx6q.txt          |   58 ++++++++++++++++++++
>  arch/arm/boot/dts/imx6q.dtsi                       |   27 +++++++++-
>  arch/arm/mach-imx/clk-imx6q.c                      |   31 ++++++-----
>  3 files changed, 101 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clk/clk-imx6q.txt
> 
> diff --git a/Documentation/devicetree/bindings/clk/clk-imx6q.txt b/Documentation/devicetree/bindings/clk/clk-imx6q.txt
> new file mode 100644
> index 0000000..c5698a7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clk/clk-imx6q.txt
> @@ -0,0 +1,58 @@
> +* Clock bindings for Freescale i.MX6Q
> +
> +Required properties:
> +- compatible: Should be "fsl,imx6q-ccm"
> +- reg: Address and length of the register set
> +- interrupts: Should contain CCM interrupt
> +- #clock-cells: Should be <1>
> +- clock-output-names: A list of clock output that CCM provides.  The valid
> +  clock names include:
> +
> +	dummy, ckil, ckih, osc, pll2_pfd0_352m, pll2_pfd1_594m, pll2_pfd2_396m,
> +	pll3_pfd0_720m, pll3_pfd1_540m, pll3_pfd2_508m, pll3_pfd3_454m,
> +	pll2_198m, pll3_120m, pll3_80m, pll3_60m, twd, step, pll1_sw,
> +	periph_pre, periph2_pre, periph_clk2_sel, periph2_clk2_sel, axi_sel,
> +	esai_sel, asrc_sel, spdif_sel, gpu2d_axi, gpu3d_axi, gpu2d_core_sel,
> +	gpu3d_core_sel, gpu3d_shader_sel, ipu1_sel, ipu2_sel, ldb_di0_sel,
> +	ldb_di1_sel, ipu1_di0_pre_sel, ipu1_di1_pre_sel, ipu2_di0_pre_sel,
> +	ipu2_di1_pre_sel, ipu1_di0_sel, ipu1_di1_sel, ipu2_di0_sel,
> +	ipu2_di1_sel, hsi_tx_sel, pcie_axi_sel, ssi1_sel, ssi2_sel, ssi3_sel,
> +	usdhc1_sel, usdhc2_sel, usdhc3_sel, usdhc4_sel, enfc_sel, emi_sel,
> +	emi_slow_sel, vdo_axi_sel, vpu_axi_sel, cko1_sel, periph, periph2,
> +	periph_clk2, periph2_clk2, ipg, ipg_per, esai_pred, esai_podf,
> +	asrc_pred, asrc_podf, spdif_pred, spdif_podf, can_root, ecspi_root,
> +	gpu2d_core_podf, gpu3d_core_podf, gpu3d_shader, ipu1_podf, ipu2_podf,
> +	ldb_di0_podf, ldb_di1_podf, ipu1_di0_pre, ipu1_di1_pre, ipu2_di0_pre,
> +	ipu2_di1_pre, hsi_tx_podf, ssi1_pred, ssi1_podf, ssi2_pred, ssi2_podf,
> +	ssi3_pred, ssi3_podf, uart_serial_podf, usdhc1_podf, usdhc2_podf,
> +	usdhc3_podf, usdhc4_podf, enfc_pred, enfc_podf, emi_podf,
> +	emi_slow_podf, vpu_axi_podf, cko1_podf, axi, mmdc_ch0_axi_podf,
> +	mmdc_ch1_axi_podf, arm, ahb, apbh_dma, asrc, can1_ipg, can1_serial,
> +	can2_ipg, can2_serial, ecspi1, ecspi2, ecspi3, ecspi4, ecspi5, enet,
> +	esai, gpt_ipg, gpt_ipg_per, gpu2d_core, gpu3d_core, hdmi_iahb,
> +	hdmi_isfr, i2c1, i2c2, i2c3, iim, enfc, ipu1, ipu1_di0, ipu1_di1, ipu2,
> +	ipu2_di0, ldb_di0, ldb_di1, ipu2_di1, hsi_tx, mlb, mmdc_ch0_axi,
> +	mmdc_ch1_axi, ocram, openvg_axi, pcie_axi, pwm1, pwm2, pwm3, pwm4,
> +	gpmi_bch_apb, gpmi_bch, gpmi_io, gpmi_apb, sata, sdma, spba, ssi1,
> +	ssi2, ssi3, uart_ipg, uart_serial, usboh3, usdhc1, usdhc2, usdhc3,
> +	usdhc4, vdo_axi, vpu_axi, cko1, pll1_sys, pll2_bus, pll3_usb_otg,
> +	pll4_audio, pll5_video, pll6_mlb, pll7_usb_host, pll8_enet, ssi1_ipg,
> +	ssi2_ipg, ssi3_ipg, rom,
> +
> +  But generally, only the clocks that peripheral nodes have a phandle pointing
> +  to need to be listed there.
> +
> +Examples:
> +
> +clks: ccm@020c4000 {
> +	compatible = "fsl,imx6q-ccm";
> +	reg = <0x020c4000 0x4000>;
> +	interrupts = <0 87 0x04 0 88 0x04>;
> +	#clock-cells = <1>;
> +	clock-output-names = "uart_ipg",
> +			     "uart_serial",
> +			     "usdhc1",
> +			     "usdhc2",
> +			     "usdhc3",
> +			     "usdhc4";
> +};
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index 8c90cba..51b915835 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -169,6 +169,8 @@
>  					compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>  					reg = <0x02020000 0x4000>;
>  					interrupts = <0 26 0x04>;
> +					clocks = <&clks 0>, <&clks 1>;
> +					clock-names = "ipg", "per";
>  					status = "disabled";
>  				};
>  
> @@ -348,10 +350,17 @@
>  				status = "disabled";
>  			};
>  
> -			ccm@020c4000 {
> +			clks: ccm@020c4000 {
>  				compatible = "fsl,imx6q-ccm";
>  				reg = <0x020c4000 0x4000>;
>  				interrupts = <0 87 0x04 0 88 0x04>;
> +				#clock-cells = <1>;
> +				clock-output-names = "uart_ipg",
> +						     "uart_serial",
> +						     "usdhc1",
> +						     "usdhc2",
> +						     "usdhc3",
> +						     "usdhc4";
>  			};
>  
>  			anatop@020c8000 {
> @@ -589,6 +598,8 @@
>  				compatible = "fsl,imx6q-usdhc";
>  				reg = <0x02190000 0x4000>;
>  				interrupts = <0 22 0x04>;
> +				clocks = <&clks 2>, <&clks 2>, <&clks 2>;
> +				clock-names = "ipg", "ahb", "per";
>  				status = "disabled";
>  			};
>  
> @@ -596,6 +607,8 @@
>  				compatible = "fsl,imx6q-usdhc";
>  				reg = <0x02194000 0x4000>;
>  				interrupts = <0 23 0x04>;
> +				clocks = <&clks 3>, <&clks 3>, <&clks 3>;
> +				clock-names = "ipg", "ahb", "per";
>  				status = "disabled";
>  			};
>  
> @@ -603,6 +616,8 @@
>  				compatible = "fsl,imx6q-usdhc";
>  				reg = <0x02198000 0x4000>;
>  				interrupts = <0 24 0x04>;
> +				clocks = <&clks 4>, <&clks 4>, <&clks 4>;
> +				clock-names = "ipg", "ahb", "per";
>  				status = "disabled";
>  			};
>  
> @@ -610,6 +625,8 @@
>  				compatible = "fsl,imx6q-usdhc";
>  				reg = <0x0219c000 0x4000>;
>  				interrupts = <0 25 0x04>;
> +				clocks = <&clks 5>, <&clks 5>, <&clks 5>;
> +				clock-names = "ipg", "ahb", "per";
>  				status = "disabled";
>  			};
>  
> @@ -700,6 +717,8 @@
>  				compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>  				reg = <0x021e8000 0x4000>;
>  				interrupts = <0 27 0x04>;
> +				clocks = <&clks 0>, <&clks 1>;
> +				clock-names = "ipg", "per";
>  				status = "disabled";
>  			};
>  
> @@ -707,6 +726,8 @@
>  				compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>  				reg = <0x021ec000 0x4000>;
>  				interrupts = <0 28 0x04>;
> +				clocks = <&clks 0>, <&clks 1>;
> +				clock-names = "ipg", "per";
>  				status = "disabled";
>  			};
>  
> @@ -714,6 +735,8 @@
>  				compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>  				reg = <0x021f0000 0x4000>;
>  				interrupts = <0 29 0x04>;
> +				clocks = <&clks 0>, <&clks 1>;
> +				clock-names = "ipg", "per";
>  				status = "disabled";
>  			};
>  
> @@ -721,6 +744,8 @@
>  				compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>  				reg = <0x021f4000 0x4000>;
>  				interrupts = <0 30 0x04>;
> +				clocks = <&clks 0>, <&clks 1>;
> +				clock-names = "ipg", "per";
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
> index abb42e7..87b134e 100644
> --- a/arch/arm/mach-imx/clk-imx6q.c
> +++ b/arch/arm/mach-imx/clk-imx6q.c
> @@ -57,6 +57,21 @@ static void __iomem *ccm_base;
>  
>  void __init imx6q_clock_map_io(void) { }
>  
> +static struct clk *imx_clk_src_get(struct of_phandle_args *clkspec,
> +				   void *data)
> +{
> +	const char *clk_name;
> +	int idx = clkspec->args[0];
> +	int ret;
> +
> +	ret = of_property_read_string_index(clkspec->np, "clock-output-names",
> +					    idx, &clk_name);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	return __clk_lookup(clk_name);
> +}
> +
>  int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
>  {
>  	u32 val = readl_relaxed(ccm_base + CLPCR);
> @@ -391,21 +406,7 @@ int __init mx6q_clocks_init(void)
>  	clk_register_clkdev(clk[gpt_ipg], "ipg", "imx-gpt.0");
>  	clk_register_clkdev(clk[gpt_ipg_per], "per", "imx-gpt.0");
>  	clk_register_clkdev(clk[twd], NULL, "smp_twd");
> -	clk_register_clkdev(clk[uart_serial], "per", "2020000.serial");
> -	clk_register_clkdev(clk[uart_ipg], "ipg", "2020000.serial");
> -	clk_register_clkdev(clk[uart_serial], "per", "21e8000.serial");
> -	clk_register_clkdev(clk[uart_ipg], "ipg", "21e8000.serial");
> -	clk_register_clkdev(clk[uart_serial], "per", "21ec000.serial");
> -	clk_register_clkdev(clk[uart_ipg], "ipg", "21ec000.serial");
> -	clk_register_clkdev(clk[uart_serial], "per", "21f0000.serial");
> -	clk_register_clkdev(clk[uart_ipg], "ipg", "21f0000.serial");
> -	clk_register_clkdev(clk[uart_serial], "per", "21f4000.serial");
> -	clk_register_clkdev(clk[uart_ipg], "ipg", "21f4000.serial");
>  	clk_register_clkdev(clk[enet], NULL, "2188000.ethernet");
> -	clk_register_clkdev(clk[usdhc1], NULL, "2190000.usdhc");
> -	clk_register_clkdev(clk[usdhc2], NULL, "2194000.usdhc");
> -	clk_register_clkdev(clk[usdhc3], NULL, "2198000.usdhc");
> -	clk_register_clkdev(clk[usdhc4], NULL, "219c000.usdhc");
>  	clk_register_clkdev(clk[i2c1], NULL, "21a0000.i2c");
>  	clk_register_clkdev(clk[i2c2], NULL, "21a4000.i2c");
>  	clk_register_clkdev(clk[i2c3], NULL, "21a8000.i2c");
> @@ -422,6 +423,8 @@ int __init mx6q_clocks_init(void)
>  	clk_register_clkdev(clk[ahb], "ahb", NULL);
>  	clk_register_clkdev(clk[cko1], "cko1", NULL);
>  
> +	of_clk_add_provider(np, imx_clk_src_get, NULL);
> +
>  	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
>  		clk_prepare_enable(clk[clks_init_on[i]]);
>  

