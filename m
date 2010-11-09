Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0KITF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:05:26 -0500
Received: from imr4.ericy.com ([198.24.6.8]:33777 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0KITFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:05:25 -0500
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup
 table (rev2)
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1289315711-3011-5-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
	 <1289315711-3011-5-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 11:04:29 -0800
Message-ID: <1289329469.22931.221.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:15 -0500, Henrik Rydberg wrote:
> One main problem with the current driver is the inability to quickly
> search for supported keys, resulting in detailed feature maps per
> machine model which are cumbersome to maintain.
> 
> This patch adds a register lookup table, which enables binary search
> for supported keys. The lookup also reduces the io frequency, so the
> original mutex is replaced by locks around the actual io.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Hi Henrik,

looks pretty good now. Couple of additional comments.

> ---
>  drivers/hwmon/applesmc.c |  528 +++++++++++++++++++++++++---------------------
>  1 files changed, 286 insertions(+), 242 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 5f67e39..623f71c 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
[ ... ]
> +/*
> + * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
> + */
> +static int applesmc_init_smcreg_try(void)
> +{
> +       struct applesmc_registers *s = &smcreg;
> +       int ret;
> +
> +       if (s->init_complete)
> +               return 0;
> +
> +       mutex_init(&s->mutex);
> +
I am a bit concerned that mutex_init() can be called multiple times. Are
you sure this is safe ?

> +       ret = read_register_count(&s->key_count);
> +       if (ret)
> +               return ret;
> +
> +       if (!s->cache)
> +               s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
> +       if (!s->cache)
> +               return -ENOMEM;
> +
> +       s->init_complete = true;
> +
> +       pr_info("key=%d\n", s->key_count);
> +
Hope that means more to macbook users than it does to me ;).

> +       return 0;
> +}
> +
> +/*
> + * applesmc_init_smcreg - Initialize register cache.
> + *
> + * Retries until initialization is successful, or the operation times out.
> + *
> + */
> +static int applesmc_init_smcreg(void)
> +{
> +       int ms, ret;
> +
> +       for (ms = 0; ms < INIT_TIMEOUT_MSECS; ms += INIT_WAIT_MSECS) {
> +               ret = applesmc_init_smcreg_try();
> +               if (!ret)
> +                       return 0;
> +               pr_warn("slow init, retrying\n");

INIT_WAIT_MS is 50ms, so you issue this warning every 50ms for up to
five seconds. Pretty noisy... sure that is what you want ? Also, does it
really make sense to retry if the error is ENOMEM ?

Thanks,
Guenter


