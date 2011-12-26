Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1LZLCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:02:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57950 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab1LZLCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:02:10 -0500
Date: Mon, 26 Dec 2011 11:02:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/4] ASoC: cx20442: add bias control over a platform
 provided regulator
Message-ID: <20111226110201.GA8722@opensource.wolfsonmicro.com>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1324681944-19067-3-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324681944-19067-3-git-send-email-jkrzyszt@tis.icnet.pl>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 12:12:22AM +0100, Janusz Krzysztofik wrote:

> +	case SND_SOC_BIAS_ON:
> +	case SND_SOC_BIAS_PREPARE:
> +		if (IS_ERR(cx20442->por.regulator)) {
> +			err = PTR_ERR(cx20442->por.regulator);
> +		} else if (!cx20442->por.enabled) {
> +			err = regulator_enable(cx20442->por.regulator);
> +			if (!err)
> +				cx20442->por.enabled = true;
> +		}
> +		break;
> +	case SND_SOC_BIAS_STANDBY:
> +	case SND_SOC_BIAS_OFF:
> +		if (IS_ERR(cx20442->por.regulator)) {
> +			err = PTR_ERR(cx20442->por.regulator);
> +		} else if (cx20442->por.enabled) {
> +			err = regulator_disable(cx20442->por.regulator);
> +			if (!err)
> +				cx20442->por.enabled = false;
> +		}
> +	}
> +	mutex_unlock(&cx20442->por.lock);

You can avoid the mutex and simplify the code by relying on the fact
that the only possible transitions are:

   OFF <-> STANDBY <-> PREPARE <-> ON

which would look a lot more natural - you shouldn't need to remember if
the regulator is enabled, you should just turn it on in the STANDBY to
PREPARE transition and turn it off in the ON to PREPARE or PREPARE to
STANDBY transitions.
