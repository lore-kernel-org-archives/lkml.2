Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2J2Lmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:42:39 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51150 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab2J2Lmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351079900-32236-3-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-3-git-send-email-hongbo.zhang@linaro.com>
Date: Mon, 29 Oct 2012 17:12:35 +0530
Message-ID: <CAK44p22G4ri9KBYiLMCK9SThgFxofz66LVgUY28SepaC+YBDdw@mail.gmail.com>
Subject: Re: [PATCH V2 2/6] Thermal: make sure cpufreq cooling register after
 cpufreq driver
From: Amit Kachhap <amit.kachhap@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 17:28, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>
> The cpufreq works as a cooling device, so the cooling layer should check if the
> cpufreq driver is initialized or not.
>
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> ---
>  drivers/thermal/cpu_cooling.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index b6b4c2a..7519a0b 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -354,6 +354,10 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>         int ret = 0, i;
>         struct cpufreq_policy policy;
>
> +       /* make sure cpufreq driver has been initialized */
> +       if (!cpufreq_frequency_get_table(cpumask_any(clip_cpus)))
> +               return ERR_PTR(-EPROBE_DEFER);
> +
Hi Hongbo,

I am not against this change but this might cause unnecessary delay in
probe thread. I also thought about it but have not put this
restriction. Actually you can put a check in platform_bind for this
condition and defer the binding till the time actual throttling
starts. So basically only after throttling cpufreq_table is needed.
(See my implementation exynos_thermal.c).

Thanks,
Amit Daniel
>         list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
>                 cpufreq_dev_count++;
>
> --
> 1.7.11.3
>
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
