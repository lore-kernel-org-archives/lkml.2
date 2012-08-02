Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2HBUIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:08:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53315 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2HBUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <1343936764-6461-1-git-send-email-vikram.pandita@ti.com>
References: <1343936764-6461-1-git-send-email-vikram.pandita@ti.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 2 Aug 2012 22:08:18 +0200
Message-ID: <CAPXgP10fJj3SwDdCa=rzfjZM8TL1GsvbSwEnfomFQ+NrW2j15w@mail.gmail.com>
Subject: Re: [PATCH] printk: add option to print cpu id
To: Vikram Pandita <vikram.pandita@ti.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 9:46 PM, Vikram Pandita <vikram.pandita@ti.com> wrote:
> From: Vikram Pandita <vikram.pandita@ti.com>
>
> Introduce config option to enable CPU id reporting for printk() calls.
>
> Its sometimes very useful to have printk also print the CPU Identifier
> that executed the call. This has helped to debug various SMP issues on shipping
> products.
>
> Known limitation is, if the system gets preempted between function call and
> actual printk, the reported cpu-id might not be accurate. But most of the
> times its seen to give a good feel of how the N cpu's in the system are
> getting loaded.
>
> Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> ---
>  kernel/printk.c   |   20 ++++++++++++++++++++
>  lib/Kconfig.debug |   13 +++++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 6a76ab9..50feb82 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -855,6 +855,25 @@ static size_t print_time(u64 ts, char *buf)
>                        (unsigned long)ts, rem_nsec / 1000);
>  }
>
> +#if defined(CONFIG_PRINTK_CPUID)
> +static bool printk_cpuid = 1;
> +#else
> +static bool printk_cpuid;
> +#endif
> +module_param_named(cpuid, printk_cpuid, bool, S_IRUGO | S_IWUSR);
> +
> +static size_t print_cpuid(char *buf)
> +{
> +
> +       if (!printk_cpuid)
> +               return 0;
> +
> +       if (!buf)
> +               return 4;
> +
> +       return sprintf(buf, "[%1d] ", smp_processor_id());
> +}
> +
>  static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
>  {
>         size_t len = 0;
> @@ -874,6 +893,7 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
>                 }
>         }
>
> +       len += print_cpuid(buf ? buf + len : NULL);
>         len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
>         return len;
>  }

How is that supposed to be useful?

The prefix is added while exporting data from the kmsg buffer, which
is just the CPU that *reads* the data from the buffer, not the one
that has *written* the data it into it.

Do I miss anything here?

Thanks,
Kay
