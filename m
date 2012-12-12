Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2LLSNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:13:37 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55170 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2LLSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:13:36 -0500
MIME-Version: 1.0
In-Reply-To: <1355312753-16514-2-git-send-email-paolo.pisati@canonical.com>
References: <1355312753-16514-1-git-send-email-paolo.pisati@canonical.com>
	<1355312753-16514-2-git-send-email-paolo.pisati@canonical.com>
Date: Wed, 12 Dec 2012 12:13:35 -0600
Message-ID: <CAOCHtYhgQQX5560+bOHJGJ3EWqrE2JtdUfDNzk_R2Pgkw6c9+w@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
From: Robert Nelson <robertcnelson@gmail.com>
To: Paolo Pisati <paolo.pisati@canonical.com>
Cc: linux-omap <linux-omap@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 5:45 AM, Paolo Pisati
<paolo.pisati@canonical.com> wrote:
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> ---
>  drivers/regulator/core.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index e872c8b..c347fd0 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2250,6 +2250,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
>  {
>         struct regulator_dev *rdev = regulator->rdev;
>         int ret = 0;
> +       int old_min_uV, old_max_uV;
>
>         mutex_lock(&rdev->mutex);
>
> @@ -2271,18 +2272,29 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
>         ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
>         if (ret < 0)
>                 goto out;
> +
> +       /* restore original values in case of error */
> +       old_min_uV = regulator->min_uV;
> +       old_max_uV = regulator->max_uV;
>         regulator->min_uV = min_uV;
>         regulator->max_uV = max_uV;
>
>         ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
>         if (ret < 0)
> -               goto out;
> +               goto out2;
>
>         ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
> -
> +       if (ret < 0)
> +               goto out2;
> +
>  out:
>         mutex_unlock(&rdev->mutex);
>         return ret;
> +out2:
> +       regulator->min_uV = old_min_uV;
> +       regulator->max_uV = old_max_uV;
> +       mutex_unlock(&rdev->mutex);
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(regulator_set_voltage);
>
> --
> 1.7.10.4

Nice! This fixes the 800Mhz lockup on bootup after a software reset we
were seeing on the Beagle xM's with v3.7.x/v3.6.x...

Tested-by: Robert Nelson <robertcnelson@gmail.com>

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
