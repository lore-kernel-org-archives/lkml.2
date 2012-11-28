Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2K1QBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:01:12 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40665 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2K1QBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:01:10 -0500
MIME-Version: 1.0
In-Reply-To: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
References: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
Date: Wed, 28 Nov 2012 21:31:09 +0530
X-Google-Sender-Auth: S2pQVYPGC7HsE8pdxw5oDE9M_bw
Message-ID: <CAOh2x=kw11+fGK6G_fKm2CA3TNGnG_mFq1eHeNxQ-B97-Wd_NA@mail.gmail.com>
Subject: Re: [RFC 1/2] clk: use struct clk only for external API
From: viresh kumar <viresh.kumar@linaro.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 5:22 PM, Rabin Vincent
<rabin.vincent@stericsson.com> wrote:
> In order to provide per-user accounting, this separates the struct clk
> used in the common clock framework into two structures 'struct clk_core'
> and 'struct clk'.  struct clk_core will be used for internal
> manipulation and struct clk will be used in the clock API
> implementation.
>
> In this patch, struct clk is simply renamed to struct clk_core and a new
> struct clk is implemented which simply wraps it.  In the next patch, the
> new struct clk will be used to implement per-user clock enable
> accounting.
>
> There is a rather hacky #define of clk_core to clk for the non-common
> clk case in order to avoid a mass rename of all clk non-common clk
> implementations.
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>

Hi Rabin,

I reviewed it with help of git diff --word-diff and didn't found any silly
mistake in the replacement of clk with clk_core :)

> diff --git a/drivers/clk/clk-core.h b/drivers/clk/clk-core.h
> +#ifdef CONFIG_COMMON_CLK
> +#define clk_to_clk_core(clk)   ((struct clk_core *)(clk))
> +#define clk_core_to_clk(core)  ((struct clk *)(core))
> +#else
> +#define clk_to_clk_core(clk)   ((clk))
> +#define clk_core_to_clk(core)  ((core))
> +#endif

> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> +struct clk {
> +       struct clk_core clk;
> +};
> +

Isn't something wrong here? For common clk case shouldn't
this be:

> +#define clk_to_clk_core(clk)  (&clk->clk)
> +#define clk_core_to_clk(core) (container_of(clk, ...))  //not getting into the exact format here

Sorry, if i am missing basics.

--
viresh
