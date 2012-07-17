Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2GQE6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:58:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5244 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2GQE6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:58:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Jul 2012 21:58:47 -0700
Message-ID: <5004F101.7040909@nvidia.com>
Date: Tue, 17 Jul 2012 10:28:41 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] clk: fix compile for OF && !COMMON_CLK
References: <1342475161-20402-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1342475161-20402-1-git-send-email-robherring2@gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012 03:16 AM, Rob Herring wrote:
> From: Rob Herring<rob.herring@calxeda.com>
>
> With commit 766e6a4ec602d0c107 (clk: add DT clock binding support),
> compiling with OF&&  !COMMON_CLK is broken.

Thanks Rob!!

This patch fixed the build failure for Tegra.

> Reported-by: Alexandre Pereira da Silva<aletes.xgr@gmail.com>
> Reported-by: Prashant Gaikwad<pgaikwad@nvidia.com>
> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
> ---
>   drivers/clk/clkdev.c |    2 +-
>   include/linux/clk.h  |    7 ++++---
>   2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 20649b3..8f87b0f 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -24,7 +24,7 @@
>   static LIST_HEAD(clocks);
>   static DEFINE_MUTEX(clocks_mutex);
>
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF)&&  defined(CONFIG_COMMON_CLK)
>   struct clk *of_clk_get(struct device_node *np, int index)
>   {
>   	struct of_phandle_args clkspec;
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 8b70342..35f7492 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -12,6 +12,7 @@
>   #ifndef __LINUX_CLK_H
>   #define __LINUX_CLK_H
>
> +#include<linux/err.h>
>   #include<linux/kernel.h>
>   #include<linux/notifier.h>
>
> @@ -313,19 +314,19 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
>   struct device_node;
>   struct of_phandle_args;
>
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF)&&  defined(CONFIG_COMMON_CLK)
>   struct clk *of_clk_get(struct device_node *np, int index);
>   struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
>   struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
>   #else
>   static inline struct clk *of_clk_get(struct device_node *np, int index)
>   {
> -	return NULL;
> +	return ERR_PTR(-EINVAL);
>   }
>   static inline struct clk *of_clk_get_by_name(struct device_node *np,
>   					     const char *name)
>   {
> -	return NULL;
> +	return ERR_PTR(-EINVAL);
>   }
>   #endif
>

