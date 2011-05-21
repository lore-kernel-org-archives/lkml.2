Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1EUMYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:24:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48970 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752086Ab1EUMYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:24:52 -0400
Date: Sat, 21 May 2011 14:24:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: spitz pm: adjust messages
Message-ID: <20110521122450.GA6954@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charger error is something that should be reported to the syslog; do
it. If temperature reading fails, we do not want to charge the
battery, anyway.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 785880f..513588c 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -317,6 +302,8 @@ static void sharpsl_charge_off(void)
 
 static void sharpsl_charge_error(void)
 {
+	dev_warn(sharpsl_pm.dev, "Charger Error\n");
+
 	sharpsl_pm_led(SHARPSL_LED_ERROR);
 	sharpsl_pm.machinfo->charge(0);
 	sharpsl_pm.charge_mode = CHRG_ERROR;
@@ -513,8 +500,10 @@ static int sharpsl_check_battery_temp(void)
 	val = get_select_val(buff);
 
 	dev_dbg(sharpsl_pm.dev, "Temperature: %d\n", val);
-	if (val > sharpsl_pm.machinfo->charge_on_temp) {
-		printk(KERN_WARNING "Not charging: temperature out of limits.\n");
+	/* FIXME: this should catch battery read errors, but we should
+	   probably avoid charging in <0C temperatures, too. */
+	if ((val < 0) || (val > sharpsl_pm.machinfo->charge_on_temp)) {
+		dev_warn(sharpsl_pm.dev, "Not charging: temperature %d out of limits.\n", val);
 		return -1;
 	}
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
