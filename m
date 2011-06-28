Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1F1Too (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:44:44 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:34316 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1F1Toj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:44:39 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.134
X-Originating-IP: 83.160.107.163
Date: Tue, 28 Jun 2011 21:40:40 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, viresh kumar <viresh.kumar@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Message-ID: <20110628194040.GE15091@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
	viresh kumar <viresh.kumar@st.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Ryan Mallon <ryan@bluewatersys.com>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de>
 <1309255368-9775-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309255368-9775-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, Jun 28, 2011 at 12:02:47PM +0200 Sascha Hauer ha dit:

> This patch adds framework support for PWM (pulse width modulation) devices.
[...]
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> new file mode 100644
> index 0000000..79dc051
> --- /dev/null
> +++ b/drivers/pwm/core.c
[...]
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
> +	kfree(pwm);

as already pointed out by kurt, pwm should only be freed in case of an
error

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pwmchip_add);
> +
> +/**
> + * pwmchip_remove() - remove a pwm
> + * @chip: the pwm
> + *
> + * remove a pwm. This function may return busy if the pwm is still requested.
> + */
> +int pwmchip_remove(struct pwm_chip *chip)
> +{
> +	struct pwm_device *pwm;
> +	int ret = 0;
> +
> +	mutex_lock(&pwm_lock);
> +
> +	pwm = find_pwm(chip->pwm_id);
> +	if (!pwm) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	list_del(&pwm->node);
  +	kfree(pwm);
> +out:
> +	mutex_unlock(&pwm_lock);
> +
> +	return ret;
> +}

[...]

best regards

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

             It always seems impossible until it's done
                        (Nelson Mandela)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
