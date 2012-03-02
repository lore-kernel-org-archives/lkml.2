Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2CBCtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 21:49:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2CBCtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 21:49:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.gortmaker@gmail.com designates 10.68.125.133 as permitted sender) smtp.mail=paul.gortmaker@gmail.com; dkim=pass header.i=paul.gortmaker@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330650922-24143-1-git-send-email-festevam@gmail.com>
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>
	<1330650922-24143-1-git-send-email-festevam@gmail.com>
Date: Thu, 1 Mar 2012 21:49:07 -0500
X-Google-Sender-Auth: 9kN-8fAiQImyV_QyfC635bkluPk
Message-ID: <CAP=VYLpd5EFmD+8Yo_jm-9N7O5zkLTsTwGjgmxG4u_G6t=4fag@mail.gmail.com>
Subject: Re: [PATCH v2] compiler.h: Include <linux/bug.h> to avoid build
 breakage with ARRAY_SIZE()
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux@arm.linux.org.uk, sam@ravnborg.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 8:15 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Building imx_v6_v7_defconfig generated the following build error:
>
> arch/arm/mach-imx/cpu_op-mx51.c: In function 'mx51_get_cpu_op':
> arch/arm/mach-imx/cpu_op-mx51.c:27: error: implicit declaration of function 'BUILD_BUG_ON_ZERO'
>
> commit 6f863554 (kernel.h: doesn't explicitly use bug.h, so don't include it.)
> has removed asm/debug.h from linux/kernel.h.
>
> Quoting Russell King (http://www.spinics.net/lists/arm-kernel/msg161916.html)
>
> "linux/kernel.h _does_ use bug stuff - in ARRAY_SIZE().
>
> ARRAY_SIZE() uses __must_be_array(), which is defined in linux/compiler-gcc.h,
> which is obtained via linux/compiler.h and linux/linkage.h.
>
> linux/compiler-gcc.h defines __must_be_array() to be:
> #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
>
> and BUILD_BUG_ON_ZERO used to be in linux/kernel.h but got moved to
> linux/bug.h.
>
> Hence why people are seeing build breakage with ARRAY_SIZE()."
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks, but no.

You missed the whole point of my previous comments -- that being
that we don't want to just jam headers into always-used headers.

The compiler.h is going to be an "always used" header.  So if we
can avoid stuffing it full of extra crap, we need to really try.

Paul.

> ---
> Changes since v1:
> - Move linux/bug.h to linux/compiler.h
>
>  include/linux/compiler.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 4a24354..0300fb7 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -46,6 +46,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>
>  #ifdef __GNUC__
>  #include <linux/compiler-gcc.h>
> +#include <linux/bug.h>
>  #endif
>
>  #define notrace __attribute__((no_instrument_function))
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
