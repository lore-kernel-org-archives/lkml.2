Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1F1LWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:22:24 -0400
Received: from gate.eia.be ([194.78.71.18]:12218 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab1F1LUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:20:19 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 07:20:19 EDT
Date: Tue, 28 Jun 2011 13:14:10 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ryan Mallon <ryan@bluewatersys.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Message-ID: <20110628111410.GB19308@e-circ.dyndns.org>
Mail-Followup-To: Sascha Hauer <s.hauer@pengutronix.de>,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Ryan Mallon <ryan@bluewatersys.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de>
 <1309255368-9775-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1309255368-9775-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Jun 2011 11:14:23.0757 (UTC) FILETIME=[890393D0:01CC3584]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 12:02:47PM +0200, Sascha Hauer wrote:
> This patch adds framework support for PWM (pulse width modulation) devices.
> 
> The is a barebone PWM API already in the kernel under include/linux/pwm.h,
The ?? is ...
> +
[...]
> +Locking
> +-------
> +
> +The PWM core list manipulations are protected by a mutex, so pwm_request()
> +and pwm_free() may not be called from an atomic context. Currently the
> +PWM core does not enforce any locking to pwm_enable(), pwm_disable() and
> +pwm_config(), so the calling context is currently driver specific. This
> +is an issue derived from the former barebone API and should be fixed soon.
[...]
> +
> +struct pwm_device {
> +	struct			pwm_chip *chip;
> +	const char		*label;
> +	int			enabled;
.enabled is never used, in favor of FLAG_ENABLED
> +	unsigned long		flags;
> +#define FLAG_REQUESTED	0
> +#define FLAG_ENABLED	1
> +	struct list_head	node;
> +};
> +
[...]
> +
> +static struct pwm_device *find_pwm(int pwm_id)
s/find_pwm/_find_pwm/ to indicate it needs pwm_lock?

> +/**
> + * pwmchip_add() - register a new pwm
> + * @chip: the pwm
> + *
> + * register a new pwm. pwm->pwm_id must be initialized. if pwm_id < 0 then
> + * a dynamically assigned id will be used, otherwise the id specified,
> + */
> +int pwmchip_add(struct pwm_chip *chip)
> +{
> +	struct pwm_device *pwm;
> +	int ret = 0;
> +
> +	pwm = kzalloc(sizeof(*pwm), GFP_KERNEL);
> +	if (!pwm)
> +		return -ENOMEM;
> +
> +	pwm->chip = chip;
> +
> +	mutex_lock(&pwm_lock);
> +
> +	if (chip->pwm_id >= 0 && find_pwm(chip->pwm_id)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (chip->pwm_id < 0)
> +		chip->pwm_id = next_pwm_id++;
> +
> +	list_add_tail(&pwm->node, &pwm_list);
> +out:
> +	mutex_unlock(&pwm_lock);
> +
+	if (ret) ??
> +	kfree(pwm);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pwmchip_add);
> +

Kind regards,
Kurt
