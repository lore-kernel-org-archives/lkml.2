Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab1F1M33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:29:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab1F1M1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:27:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Date: Tue, 28 Jun 2011 14:27:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de> <1309255368-9775-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1309255368-9775-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281427.04373.arnd@arndb.de>
X-Provags-ID: V02:K0:0s5p3yAfh6NJQE28IPK7QVM95lXt0jVMbg1RS0ayuru
 Bqd1kO8riIWL51K4wU6uIicWN4Fsn58BTOtIgFCxVqJdaxxjFL
 tpjqAN+1ihl5wvLszSSzXRhoepuKBnZsy6xSf9iunb6wBxUSxL
 sWNZwM2Se19tR7ZSxl+4j+GukemJLyTeUuNmhv4o/iDywHAUdG
 XhboFjJhHvETV/PsQtHdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Sascha Hauer wrote:
> This patch adds framework support for PWM (pulse width modulation) devices.
> 
> The is a barebone PWM API already in the kernel under include/linux/pwm.h,
> but it does not allow for multiple drivers as each of them implements the
> pwm_*() functions.

Hi Sascha,

This looks very nice.
I have only trivial comments, except for the suggestion to use idr.
 
> +PWM core
> +M:	Sascha Hauer <s.hauer@pengutronix.de>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained

I would add

F:	drivers/pwm/

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> new file mode 100644
> index 0000000..93c1052
> --- /dev/null
> +++ b/drivers/pwm/Kconfig
> @@ -0,0 +1,12 @@
> +menuconfig PWM
> +	bool "PWM Support"
> +	help
> +	  This enables PWM support through the generic PWM framework.
> +	  You only need to enable this, if you also want to enable
> +	  one or more of the PWM drivers below.

Remove the comma.

> +
> +/*
> + * The next pwm id to assign. We do not bother to fill gaps which
> + * occur during dynamic registering/deregistering of pwms, but
> + * instead assign a uniq id to each new pwm.
                       unique

> + */
> +static int next_pwm_id;

How about using idr? It provides you a fast lookup and handles giving
out unique numbers.

> +
> +/**
> + * pwmchip_reserve() - reserve range of pwms to use with platform code only
> + * @npwms: number of pwms to reserve
> + * Context: platform init
> + *
> + * Maybe called only once. It reserves the first pwm_ids for platform use so

I assume you mean "May only be called once".

> +/**
> + * struct pwm_ops - PWM operations
> + * @request: optional hook for requesting a PWM
> + * @free: optional hook for freeing a PWM
> + * @config: configure duty cycles and period length for this PWM
> + * @enable: enable PWM output toggling
> + * @disable: disable PWM output toggling
> + */
> +struct pwm_ops {
> +	int			(*request)(struct pwm_chip *chip);
> +	void			(*free)(struct pwm_chip *chip);
> +	int			(*config)(struct pwm_chip *chip, int duty_ns,
> +						int period_ns);
> +	int			(*enable)(struct pwm_chip *chip);
> +	void			(*disable)(struct pwm_chip *chip);
> +};
>
> +/**
> + * struct pwm_chip - abstract a PWM
> + * @label: for diagnostics
> + * @owner: helps prevent removal of modules exporting active PWMs
> + * @ops: The callbacks for this PWM
> + */
> +struct pwm_chip {
> +	int			pwm_id;
> +	const char		*label;
> +	struct module		*owner;
> +	struct pwm_ops		*ops;
> +};

I think the "owner" field should be in the pwm_ops, not in the pwm_chip,
because the pwm_ops is likely to be statically allocated, while the
pwm_chip is probably runtime allocated and cannot be preinitialized.

Should a pwm_chip contain a "struct device" so you can refer to it in
sysfs and add attributes?

	Arnd
