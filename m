Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab2HWNkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:40:22 -0400
Received: from zose-mta-11.w4a.fr ([178.33.204.86]:36177 "EHLO
	zose-mta11.web4all.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758797Ab2HWNkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:40:18 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 09:40:18 EDT
Date: Thu, 23 Aug 2012 15:36:54 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Cc: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Message-ID: <320569847.2756382.1345729013971.JavaMail.root@advansee.com>
In-Reply-To: <322770447.2755463.1345727876098.JavaMail.root@advansee.com>
Subject: [BUG] leds-pwm: First setting of brightness does nothing
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have found a bug using leds-pwm with the i.MX PWM driver. The first time a
non-0 brightness is set through sysfs, this has no effect. It works fine from
the 2nd time.

The cause of this bug is that leds-pwm.c:led_pwm_set() calls pwm_config() before
pwm_enable(), while in the i.MX PWM driver pwm_enable() enables the PWM IP
clock, so that a call to pwm_config() has no effect before the first call to
pwm_enable().

Several other PWM drivers in drivers/pwm/ work in the same way. pwm-beeper.c and
pwm_bl.c also call pwm_config() before pwm_enable(). The PWM documentation does
not say if the wrong doers are these PWM users or the i.MX-like PWM drivers.

So what should be fixed? Fixing these PWM users would be quite easy since it's a
simple swap of the pwm_config() and pwm_enable() calls. This should not produce
any glitch since the duty cycle is always set to 0 by these PWM users before
calling pwm_disable().

Best regards,
Benoît
