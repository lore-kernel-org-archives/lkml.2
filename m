Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2KZT57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:57:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45922 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2KZT56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:57:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <1353957609-1295-1-git-send-email-Russ.Dill@ti.com>
CC: Russ Dill <Russ.Dill@ti.com>
References: <1353957609-1295-1-git-send-email-Russ.Dill@ti.com>
Message-ID: <20121126195742.21126.16500@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] Don't mark shared helper functions as inline
Date: Mon, 26 Nov 2012 11:57:42 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Russ Dill (2012-11-26 11:20:09)
> The helper functions that access the opaque struct clk should
> not be marked inline since they are contained in clk.c, but expected
> to be used by other compilation units. This causes compile errors
> under gcc-4.7
> 
> In file included from arch/arm/mach-omap2/clockdomain.c:25:0:
> arch/arm/mach-omap2/clockdomain.c: In function ‘clkdm_clk_disable’:
> include/linux/clk-provider.h:338:12: error: inlining failed in call to always_inline ‘__clk_get_enable_count’: function body not available
> arch/arm/mach-omap2/clockdomain.c:1001:28: error: called from here
> make[1]: *** [arch/arm/mach-omap2/clockdomain.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> 

Hi Russ,

A fix for this was merged into rc7.  See 93532c8a, "clk: remove inline
usage from clk-provider.h".

Regardless, I'm still considering this patch.  I've heard many times
that we should trust the compiler to optimize for us and some folks look
down on inlining in general.  If anyone has an opinion on removing
inlines from the common clk core then please do speak up.

Russ, can you update to the latest rc and verify if that fix is enough
for you?

Regards,
Mike

> 
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> ---
>  drivers/clk/clk.c            | 14 +++++++-------
>  include/linux/clk-provider.h |  4 ++--
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 56e4495e..ed01746 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -249,32 +249,32 @@ late_initcall(clk_disable_unused);
>  
>  /***    helper functions   ***/
>  
> -inline const char *__clk_get_name(struct clk *clk)
> +const char *__clk_get_name(struct clk *clk)
>  {
>         return !clk ? NULL : clk->name;
>  }
>  
> -inline struct clk_hw *__clk_get_hw(struct clk *clk)
> +struct clk_hw *__clk_get_hw(struct clk *clk)
>  {
>         return !clk ? NULL : clk->hw;
>  }
>  
> -inline u8 __clk_get_num_parents(struct clk *clk)
> +u8 __clk_get_num_parents(struct clk *clk)
>  {
>         return !clk ? -EINVAL : clk->num_parents;
>  }
>  
> -inline struct clk *__clk_get_parent(struct clk *clk)
> +struct clk *__clk_get_parent(struct clk *clk)
>  {
>         return !clk ? NULL : clk->parent;
>  }
>  
> -inline int __clk_get_enable_count(struct clk *clk)
> +int __clk_get_enable_count(struct clk *clk)
>  {
>         return !clk ? -EINVAL : clk->enable_count;
>  }
>  
> -inline int __clk_get_prepare_count(struct clk *clk)
> +int __clk_get_prepare_count(struct clk *clk)
>  {
>         return !clk ? -EINVAL : clk->prepare_count;
>  }
> @@ -300,7 +300,7 @@ out:
>         return ret;
>  }
>  
> -inline unsigned long __clk_get_flags(struct clk *clk)
> +unsigned long __clk_get_flags(struct clk *clk)
>  {
>         return !clk ? -EINVAL : clk->flags;
>  }
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index c127315..f9f5e9e 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -335,8 +335,8 @@ const char *__clk_get_name(struct clk *clk);
>  struct clk_hw *__clk_get_hw(struct clk *clk);
>  u8 __clk_get_num_parents(struct clk *clk);
>  struct clk *__clk_get_parent(struct clk *clk);
> -inline int __clk_get_enable_count(struct clk *clk);
> -inline int __clk_get_prepare_count(struct clk *clk);
> +int __clk_get_enable_count(struct clk *clk);
> +int __clk_get_prepare_count(struct clk *clk);
>  unsigned long __clk_get_rate(struct clk *clk);
>  unsigned long __clk_get_flags(struct clk *clk);
>  int __clk_is_enabled(struct clk *clk);
> -- 
> 1.8.0
