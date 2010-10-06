Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab0JFO2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:28:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32692 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab0JFO2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:28:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56915052"
Subject: Re: [PATCH 19/20 v2] msm: Platform initialization for the IOMMU
 driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
In-Reply-To: <1286350979-19328-20-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
	 <1286350979-19328-20-git-send-email-johlstei@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 07:28:17 -0700
Message-ID: <1286375297.22265.67.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 00:42 -0700, Jeff Ohlstein wrote:
> From: Stepan Moskovchenko <stepanm@codeaurora.org>
> 
> Register a driver for the MSM IOMMU devices and a driver
> for the translation context devices. Set up the global
> IOMMU registers and initialize the context banks.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
>  arch/arm/mach-msm/Makefile    |    2 +-
>  arch/arm/mach-msm/iommu_dev.c |  364 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 365 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-msm/iommu_dev.c
> 
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 6a0b92e..56b1db9 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -12,7 +12,7 @@ obj-y += irq.o
>  endif
>  endif
>  
> -obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o
> +obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o iommu.o iommu_dev.o
>  obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
>  obj-$(CONFIG_MSM_PROC_COMM) += clock.o gpio.c
>  obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
> diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
> new file mode 100644
> index 0000000..59ac7e5
> --- /dev/null
> +++ b/arch/arm/mach-msm/iommu_dev.c
> @@ -0,0 +1,364 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +
> +#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/iommu.h>
> +#include <linux/interrupt.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +
> +#include <mach/iommu_hw-8xxx.h>
> +#include <mach/iommu.h>
> +
> +struct iommu_ctx_iter_data {
> +	/* input */
> +	const char *name;
> +
> +	/* output */
> +	struct device *dev;
> +};
> +
> +static struct platform_device *msm_iommu_root_dev;
> +
> +static int each_iommu_ctx(struct device *dev, void *data)
> +{
> +	struct iommu_ctx_iter_data *res = data;
> +	struct msm_iommu_ctx_dev *c = dev->platform_data;
> +
> +	if (!res || !c || !c->name || !res->name)
> +		return -EINVAL;
> +
> +	if (!strcmp(res->name, c->name)) {
> +		res->dev = dev;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static int each_iommu(struct device *dev, void *data)
> +{
> +	return device_for_each_child(dev, data, each_iommu_ctx);
> +}
> +
> +struct device *msm_iommu_get_ctx(const char *ctx_name)
> +{
> +	struct iommu_ctx_iter_data r;
> +	int found;
> +
> +	if (!msm_iommu_root_dev) {
> +		pr_err("No root IOMMU device.\n");
> +		goto fail;
> +	}
> +
> +	r.name = ctx_name;
> +	found = device_for_each_child(&msm_iommu_root_dev->dev, &r, each_iommu);
> +
> +	if (!found) {
> +		pr_err("Could not find context <%s>\n", ctx_name);
> +		goto fail;
> +	}
> +
> +	return r.dev;
> +fail:
> +	return NULL;
> +}
> +EXPORT_SYMBOL(msm_iommu_get_ctx);
> +
> +static void msm_iommu_reset(void __iomem *base)
> +{
> +	int ctx, ncb;
> +
> +	SET_RPUE(base, 0);
> +	SET_RPUEIE(base, 0);
> +	SET_ESRRESTORE(base, 0);
> +	SET_TBE(base, 0);
> +	SET_CR(base, 0);
> +	SET_SPDMBE(base, 0);
> +	SET_TESTBUSCR(base, 0);
> +	SET_TLBRSW(base, 0);
> +	SET_GLOBAL_TLBIALL(base, 0);
> +	SET_RPU_ACR(base, 0);
> +	SET_TLBLKCRWE(base, 1);
> +	ncb = GET_NCB(base)+1;
> +
> +	for (ctx = 0; ctx < ncb; ctx++) {
> +		SET_BPRCOSH(base, ctx, 0);
> +		SET_BPRCISH(base, ctx, 0);
> +		SET_BPRCNSH(base, ctx, 0);
> +		SET_BPSHCFG(base, ctx, 0);
> +		SET_BPMTCFG(base, ctx, 0);
> +		SET_ACTLR(base, ctx, 0);
> +		SET_SCTLR(base, ctx, 0);
> +		SET_FSRRESTORE(base, ctx, 0);
> +		SET_TTBR0(base, ctx, 0);
> +		SET_TTBR1(base, ctx, 0);
> +		SET_TTBCR(base, ctx, 0);
> +		SET_BFBCR(base, ctx, 0);
> +		SET_PAR(base, ctx, 0);
> +		SET_FAR(base, ctx, 0);
> +		SET_CTX_TLBIALL(base, ctx, 0);
> +		SET_TLBFLPTER(base, ctx, 0);
> +		SET_TLBSLPTER(base, ctx, 0);
> +		SET_TLBLKCR(base, ctx, 0);
> +		SET_PRRR(base, ctx, 0);
> +		SET_NMRR(base, ctx, 0);
> +		SET_CONTEXTIDR(base, ctx, 0);
> +	}
> +}
> +
> +static int msm_iommu_probe(struct platform_device *pdev)
> +{
> +	struct resource *r;
> +	struct clk *iommu_clk;
> +	struct msm_iommu_drvdata *drvdata;
> +	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
> +	void __iomem *regs_base;
> +	resource_size_t	len;
> +	int ret = 0, ncb, nm2v, irq;
> +
> +	if (pdev->id != -1) {
> +		drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
> +
> +		if (!drvdata) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		if (!iommu_dev) {
> +			ret = -ENODEV;
> +			goto fail;
> +		}
> +
> +		if (iommu_dev->clk_rate != 0) {
> +			iommu_clk = clk_get(&pdev->dev, "iommu_clk");
> +
> +			if (IS_ERR(iommu_clk)) {
> +				ret = -ENODEV;
> +				goto fail;
> +			}
> +
> +			if (iommu_dev->clk_rate > 0)
> +				clk_set_rate(iommu_clk, iommu_dev->clk_rate);
> +
> +			clk_enable(iommu_clk);

Steve,

What happens if clk_enable fails? Doesn't look like your handling that
case here.

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


