Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2LRQ2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:28:08 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:48726 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab2LRQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:28:07 -0500
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 11:28:07 EST
MIME-Version: 1.0
In-Reply-To: <1355819384-25983-1-git-send-email-sonnyrao@chromium.org>
References: <1355819384-25983-1-git-send-email-sonnyrao@chromium.org>
Date: Tue, 18 Dec 2012 08:03:36 -0800
X-Google-Sender-Auth: 1dJirw7x2T39qsH2zkv9Qn3vWtU
Message-ID: <CAD=FV=XP9sPUEJPGZtrFqyPhBbAzsPYFBb6sAgbsSuj8qtiX=A@mail.gmail.com>
Subject: Re: [PATCH] [RFC] cpufreq: can't raise max frequency with cpu_thermal
From: Doug Anderson <dianders@chromium.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Sameer Nanda <snanda@chromium.org>, Subash <subash.rp@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:29 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
> The cpu_thermal generic thermal management code has a bug where once
> max cpu frequency has been lowered in sysfs (scaling_max_freq) it is
> not possible to raise the max back up later.  The bug is that the
> notifer gets called by __cpufreq_set_policy() before the user policy
> max is raised, and is incorrectly trying to enforce the max frequency
> policy even when we are trying to change the policy.  It is also not
> clear why this driver is looking at the user policy since it is
> primarily supposed to enforce thermal policy, not user set policy.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  drivers/thermal/cpu_cooling.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 836828e..63bc708 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -219,10 +219,6 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
>         if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
>                 max_freq = notify_device->cpufreq_val;
>
> -       /* Never exceed user_policy.max*/
> -       if (max_freq > policy->user_policy.max)
> -               max_freq = policy->user_policy.max;
> -
>         if (policy->max != max_freq)
>                 cpufreq_verify_within_limits(policy, 0, max_freq);
>
> --
> 1.7.7.3
>

Sonny's change matches what the "ACPI version" of this code
(drivers/acpi/processor_thermal.c) does as well.  I would certainly be
interested to know why the code was added here in the first place.
Amit: do you know?

Reviewed-by: Doug Anderson <dianders@chromium.org>
