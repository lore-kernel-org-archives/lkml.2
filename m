Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2DJKFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:05:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62022 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab2DJKFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <1333535036-24409-1-git-send-email-myungjoo.ham@samsung.com>
References: <1333535036-24409-1-git-send-email-myungjoo.ham@samsung.com>
Date: Tue, 10 Apr 2012 15:35:39 +0530
Message-ID: <CAG17yqRq5+vQZngEwNjbANjhGPr68Hy8frwRSzRZH31juk=ahA@mail.gmail.com>
Subject: Re: [PATCH] [CPUFREQ] EXYNOS: bugfix on retrieving old_index from freqs.old
From: Inderpal Singh <inderpal.singh@linaro.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Jaecheol Lee <jc.lee@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On 4 April 2012 15:53, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> The policy might have been changed since last call of target().
> Thus, using cpufreq_frequency_table_target(), which depends on
> policy to find the correspoding index from a frequency, may return
> inconsistent index for freqs.old. Thus, old_index should be
> calculated not based on the current policy.
>
> We have been observing such issue when scaling_min/max_freq were
> updated and sometimes caused system lockups due to incorrectly
> configured voltages.
>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/cpufreq/exynos-cpufreq.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index b243a7e..1577522 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -62,8 +62,17 @@ static int exynos_target(struct cpufreq_policy *policy,
>                goto out;
>        }
>
> -       if (cpufreq_frequency_table_target(policy, freq_table,
> -                                          freqs.old, relation, &old_index)) {
> +       /*
> +        * The policy may have been changed so that we cannot get proper
> +        * old_index with cpufreq_frequency_table_target(). Thus, ignore
> +        * policy and get the index from the raw frequency table.
> +        */
> +       for (old_index = 0;
> +            freq_table[old_index].frequency != CPUFREQ_TABLE_END;
> +            old_index++)
> +               if (freq_table[old_index].frequency == freqs.old)
> +                       break;
> +       if (freq_table[old_index].frequency == CPUFREQ_TABLE_END) {
>                ret = -EINVAL;
>                goto out;
>        }

I also had the same issue and same fix while testing powertop 1.98 as
it changes the scaling_min/max_freq.

The only concern I have is when this code gets called for the very
first time, the freqs.old will be the freq set by bootloader. Now if
bootloader sets a freq which is not in the freq_table (not sure if its
practical but theoretically its possible ), this code will error out.


> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Inder
