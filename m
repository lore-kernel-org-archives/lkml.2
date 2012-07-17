Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2GQAna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 20:43:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61149 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2GQAn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 20:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <1342475161-20402-1-git-send-email-robherring2@gmail.com>
References: <1342475161-20402-1-git-send-email-robherring2@gmail.com>
Date: Mon, 16 Jul 2012 21:43:26 -0300
Message-ID: <CAAAP30HO=Khku3HeMUSJxwpzUaVBoiC+-jm+RQ4mUGp6_HNS=A@mail.gmail.com>
Subject: Re: [PATCH] clk: fix compile for OF && !COMMON_CLK
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 6:46 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> With commit 766e6a4ec602d0c107 (clk: add DT clock binding support),
> compiling with OF && !COMMON_CLK is broken.

Thanks, Rob.

This fixed the issue for me, but Mike's comments applies.

> Reported-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Reported-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  drivers/clk/clkdev.c |    2 +-
>  include/linux/clk.h  |    7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 20649b3..8f87b0f 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -24,7 +24,7 @@
>  static LIST_HEAD(clocks);
>  static DEFINE_MUTEX(clocks_mutex);
>
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>  struct clk *of_clk_get(struct device_node *np, int index)
>  {
>         struct of_phandle_args clkspec;
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 8b70342..35f7492 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -12,6 +12,7 @@
>  #ifndef __LINUX_CLK_H
>  #define __LINUX_CLK_H
>
> +#include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/notifier.h>
>
> @@ -313,19 +314,19 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
>  struct device_node;
>  struct of_phandle_args;
>
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>  struct clk *of_clk_get(struct device_node *np, int index);
>  struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
>  struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
>  #else
>  static inline struct clk *of_clk_get(struct device_node *np, int index)
>  {
> -       return NULL;
> +       return ERR_PTR(-EINVAL);
>  }
>  static inline struct clk *of_clk_get_by_name(struct device_node *np,
>                                              const char *name)
>  {
> -       return NULL;
> +       return ERR_PTR(-EINVAL);
>  }
>  #endif
>
> --
> 1.7.9.5
>
