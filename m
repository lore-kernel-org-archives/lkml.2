Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2JQOgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:36:14 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:55080 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2JQOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <1350387889-15324-5-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-5-git-send-email-hongbo.zhang@linaro.com>
Date: Wed, 17 Oct 2012 20:06:11 +0530
Message-ID: <CAKohpokQjjrc91yJJfG-f-A44070k5AN4Q2jCnPxAtCeJRdmww@mail.gmail.com>
Subject: Re: [PATCH 4/5] Thermal: make sure cpufreq cooling register after
 cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2012 17:14, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>
> The cpufreq works as a cooling device, so the cooling layer should
> check and wait until the cpufreq driver is initialized.

Idea is good.

> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> ---
>  drivers/thermal/cpu_cooling.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index d196230..01aba58 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/cpu.h>
>  #include <linux/cpu_cooling.h>
> +#include <linux/delay.h>

Would be better if we add them alphabetically. That makes there maintenance
easier. I know the list is already mismanaged. :)

If you can add another patch here to fix that, would be good.

>  /**
>   * struct cpufreq_cooling_device
> @@ -352,9 +353,18 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>         struct cpufreq_cooling_device *cpufreq_dev = NULL;
>         unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
>         char dev_name[THERMAL_NAME_LENGTH];
> -       int ret = 0, i;
> +       int ret = 0, to = 1000, i;
>         struct cpufreq_policy policy;
>
> +       /* make sure cpufreq driver is initialized */
> +       while (!cpufreq_frequency_get_table(0) && --to)
> +               mdelay(10);
> +
> +       if (!to) {
> +               pr_err("No cpufreq driver act as cooling device.\n");
> +               return ERR_PTR(-ENOSYS);
> +       }

I understand that you want cpufreq to be there before this thing, but
i didn't like the idea here. There should be something else like
returning -EPROBE_DEFER, so that driver can be pinged again.

--
viresh
