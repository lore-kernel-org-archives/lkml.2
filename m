Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2IBNoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 09:44:15 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4490 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2IBNoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 09:44:13 -0400
X-Greylist: delayed 773 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 09:44:03 EDT
From: Maarten ter Huurne <maarten@treewalker.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Date: Sun, 02 Sep 2012 15:25:55 +0200
Message-ID: <1890769.KjIbOv8Xbz@hyperion>
User-Agent: KMail/4.9 (Linux/3.1.10-1.16-desktop; KDE/4.9.0; x86_64; ; )
In-Reply-To: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1496028.RW5dUh1a0f"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1496028.RW5dUh1a0f
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday 02 September 2012 11:52:27 Thierry Reding wrote:

> This small series fixes a build error due to a circular header
> dependency, exports the timer API so it can be used outside of
> the arch/mips/jz4740 tree and finally moves and converts the
> JZ4740 PWM driver to the PWM framework.
> 
> Note that I don't have any hardware to test this on, so I had to
> rely on compile tests only. Patches 1 and 2 should probably go
> through the MIPS tree, while I can take patch 3 through the PWM
> tree. It touches a couple of files in arch/mips but the changes
> are unlikely to cause conflicts.

Exporting the hardware outputs PWM2-7 as index 0-5 in the PWM core is rather 
confusing. I discussed with Lars on IRC and it's probably better to expose 
PWM0-7 through the API, but refuse to hand out PWM0 and PWM1 when requested, 
since their associated timers are in use by the system. I attached a diff 
that illustrates this approach.

Note that if this approach is taken, the beeper ID in board-qi_lb60.c should 
be changed back from 2 to 4, since the beeper is attached to PWM4.

I tested the "for-next" branch on the Dingoo A320 with the pwm-backlight 
driver. It didn't work at first, because the PWM number and the timer number 
didn't align: I requested PWM number 5 to get PWM7 and the GPIO of PWM7 was 
used, but with timer 5 instead of timer 7, resulting in a dark screen. 
However, it works fine after adding PWM0/1 as described above.

If other people want to test on real hardware, you can find the code in 
branch jz-3.6-rc2-pwm in the qi-kernel repository. Unfortunately our web 
interface for git is still broken, but the repo itself is fine.
  git://projects.qi-hardware.com/qi-kernel.git

Bye,
		Maarten

--nextPart1496028.RW5dUh1a0f
Content-Disposition: inline; filename="jz4740-pwm-all-8.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="jz4740-pwm-all-8.diff"

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index db29b37..554e414 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -24,9 +24,11 @@
 #include <asm/mach-jz4740/gpio.h>
 #include <timer.h>
 
-#define NUM_PWM 6
+#define NUM_PWM 8
 
 static const unsigned int jz4740_pwm_gpio_list[NUM_PWM] = {
+	JZ_GPIO_PWM0,
+	JZ_GPIO_PWM1,
 	JZ_GPIO_PWM2,
 	JZ_GPIO_PWM3,
 	JZ_GPIO_PWM4,
@@ -50,6 +52,13 @@ static int jz4740_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 	unsigned int gpio = jz4740_pwm_gpio_list[pwm->hwpwm];
 	int ret;
 
+	/*
+	 * Timer 0 and 1 are used for system tasks, so they are unavailable
+	 * for use as PWMs.
+	 */
+	if (pwm->hwpwm < 2)
+		return -EBUSY;
+
 	ret = gpio_request(gpio, pwm->label);
 
 	if (ret) {

--nextPart1496028.RW5dUh1a0f--

