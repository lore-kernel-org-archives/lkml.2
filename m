Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423685Ab2KOSYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:24:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57302 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471Ab2KOSYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:24:53 -0500
Message-ID: <50A53368.6090306@ti.com>
Date: Thu, 15 Nov 2012 12:24:40 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: <i.mazanov@gmail.com>, Mike Turquette <mturquette@ti.com>
CC: <linux-omap@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove inline from clock framework function definitions
 to build the kernel with GCC 4.7
References: <50A52134.2010502@gmail.com>
In-Reply-To: <50A52134.2010502@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/15/2012 11:07 AM, Igor Mazanov wrote:
>  Remove inline from clock framework function definitions to
>  build the kernel with GCC 4.7

Adding Mike to the party ...

May be good to add some details about the exact problem seen.

I am seeing the same problem today with GCC 4.7 and Tony's master
branch. For a bit of background it seems that for 4.7 not having
the body of the inlined function available in the header is
causing this error. Another example here [1].

The actual compiler error seen for OMAP is ...

In file included from arch/arm/mach-omap2/clockdomain.c:25:0:
arch/arm/mach-omap2/clockdomain.c: In function ‘clkdm_clk_disable’:
include/linux/clk-provider.h:338:12: error: inlining failed in call to always_inline ‘__clk_get_enable_count’: function body not available
arch/arm/mach-omap2/clockdomain.c:1001:28: error: called from here
make[1]: *** [arch/arm/mach-omap2/clockdomain.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

 
> Signed-off-by: Igor Mazanov <i.mazanov@gmail.com>
> ---
>  include/linux/clk-provider.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
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

Do we also need to remove the inline from the functions declared in
drivers/clk/clk.c too?

Cheers
Jon

[1] https://bugs.launchpad.net/linaro-android/+bug/983496
