Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1HSLkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:40:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40255 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1HSLkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:40:09 -0400
MIME-Version: 1.0
In-Reply-To: <1312891671-28680-3-git-send-email-per.forlin@linaro.org>
References: <1312891671-28680-1-git-send-email-per.forlin@linaro.org>
	<1312891671-28680-3-git-send-email-per.forlin@linaro.org>
Date: Fri, 19 Aug 2011 13:40:08 +0200
Message-ID: <CACRpkdZjNr6Wse9A_y_8TXBGc6NNr_=-uXGsFPD2w-mhwGUcDg@mail.gmail.com>
Subject: Re: [PATCH --mmotm v8 2/3] mmc: core: add random fault injection
From: Linus Walleij <linus.walleij@linaro.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 2:07 PM, Per Forlin <per.forlin@linaro.org> wrote:

> This adds support to inject data errors after a completed host transfer.
> The mmc core will return error even though the host transfer is successful.
> This simple fault injection proved to be very useful to test the
> non-blocking error handling in the mmc_blk_issue_rw_rq().
> Random faults can also test how the host driver handles pre_req()
> and post_req() in case of errors.

Good idea!

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 89bdeae..a4996b0 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -25,6 +25,11 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/suspend.h>
>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +#include <linux/fault-inject.h>
> +#include <linux/random.h>
> +#endif

You don't need to #ifdef around the #include <> stuff, and if you
do, something is wrong with those headers. It's just a bunch of defines
that aren't used in some circumstances. Stack them with the others,
simply, just #ifdef the code below.

> @@ -83,6 +88,43 @@ static void mmc_flush_scheduled_work(void)
>        flush_workqueue(workqueue);
>  }
>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +
> +/*
> + * Internal function. Inject random data errors.
> + * If mmc_data is NULL no errors are injected.
> + */
> +static void mmc_should_fail_request(struct mmc_host *host,
> +                                   struct mmc_request *mrq)
> +{
> +       struct mmc_command *cmd = mrq->cmd;
> +       struct mmc_data *data = mrq->data;
> +       static const int data_errors[] = {
> +               -ETIMEDOUT,
> +               -EILSEQ,
> +               -EIO,
> +       };
> +
> +       if (!data)
> +               return;
> +
> +       if (cmd->error || data->error ||
> +           !should_fail(&host->fail_mmc_request, data->blksz * data->blocks))
> +               return;
> +
> +       data->error = data_errors[random32() % ARRAY_SIZE(data_errors)];
> +       data->bytes_xfered = (random32() % (data->bytes_xfered >> 9)) << 9;
> +}
> +
> +#else /* CONFIG_FAIL_MMC_REQUEST */
> +
> +static void mmc_should_fail_request(struct mmc_host *host,
> +                                   struct mmc_request *mrq)

Should be "static inline" so we know it will be folded in and nullified
by the compiler, lots of kernel code use that pattern.

> diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
> index f573753..189581d 100644
> --- a/drivers/mmc/core/debugfs.c
> +++ b/drivers/mmc/core/debugfs.c
> @@ -13,6 +13,9 @@
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/stat.h>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +#include <linux/fault-inject.h>
> +#endif

No #ifdef:ing...

> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 0f83858..ee472fe 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -12,6 +12,9 @@
>
>  #include <linux/leds.h>
>  #include <linux/sched.h>
> +#ifdef CONFIG_FAIL_MMC_REQUEST
> +#include <linux/fault-inject.h>
> +#endif

Neither here...

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 47879c7..ebff0c9 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug

I'm contemplating if we should create drivers/mmc/Kconfig.debug
and stash this in there instead, i.e. also move out MMC_DEBUG
from drivers/mmc/Kconfig and add to that?

It seems more apropriate to select this from the MMC subsystem.
However the core of fault injection is in lib/

So maybe a simple:

config FAIL_MMC_REQUEST
    bool
    select FAULT_INJECTION

That can then be selected by a debug option in the MMC subsystem?
I fear it may be hard to find this otherwise...

(NB: I have very little clue how the Kconfig.debug files get sourced
into the Kbuild so I might be misguided...)

> @@ -1090,6 +1090,17 @@ config FAIL_IO_TIMEOUT
>          Only works with drivers that use the generic timeout handling,
>          for others it wont do anything.
>
> +config FAIL_MMC_REQUEST
> +       bool "Fault-injection capability for MMC IO"
> +       select DEBUG_FS
> +       depends on FAULT_INJECTION && MMC

Isn't:

depends on MMC
select FAULT_INJECTION

Simpler to use? Now you have to select fault injection first
to even see this option right?

Apart from this it looks fine.

Thanks,
Linus Walleij
