Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2JXJ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:56:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2JXJ4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:56:09 -0400
Date: Wed, 24 Oct 2012 11:56:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Shawn Guo <shawn.guo@linaro.org>, kernel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: pwm pin stays on 1 on mxs after pwm_config(pwm, 0, period);
 pwm_disable(pwm);
Message-ID: <20121024095603.GH639@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the leds-pwm driver does the following in its led_pwm_set routine:

	if (brightness == 0) {
		pwm_config(led_dat->pwm, 0, period);
		pwm_disable(led_dat->pwm);
	} else {
		pwm_config(led_dat->pwm, brightness * period / max, period);
		pwm_enable(led_dat->pwm);
	}

The effect on setting brightness = 0 on an i.MX28 based machine after
having brightness = max = 255 before is:

pwm_config(..., 0, period) doesn't disable the output at once because of
some logic (in hardware) to prevent glitches. According to the Hardware
manual the new values take effect after the current period (which has the
output on 1). Now pwm_disable stopps the counter, the current period
doesn't run out and the output keeps the 1. So the LED stays on.

Where do I fix that? In the pwm driver (somehow block in pwm_config
until the current period is over, don't know how yet), remove the
pwm_disable in the brightness == 0 case (and then probably making the
whole if block a simple pwm_config(led_dat->pwm, brightness * period /
max, period)) or do we need a new API for that introducing a wait flag
or something different I didn't think of?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
