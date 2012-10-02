Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2JBQlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:41:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2JBQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Pavel Machek <pavel@ucw.cz>,
        Stanislav Brabec <utx@penguin.cz>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 05/17] ARM: pxa: remove sharpsl_fatal_check function
Date: Tue,  2 Oct 2012 18:36:44 +0200
Message-Id: <1349195816-2225-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BROzabsOdDRw7rJaQcxXsTdmdlCpJB40KrQKZm4FAfk
 JrIz7RvfhM4kOCmp3/XpcdXdTGPu1O+yJW4GEmgI7zQ0Lw9vxe
 kgKp+rRCS+8NNo5dLdncPpeVsqrnk56s4XehFDgfnzzaTYHlvM
 VoFyI5i6+grhVfsab5bFHlG2BcyUE5hZg6KN62iKIV53kr3iYk
 q8uwq988p4HMdMBXQ0XEwQLLa4E4wWnRLpT2L2kJJsDIa3fNmp
 7QiHOictbZNtwM4g6GoK7RbYWycFRIa9W3pnlFhbFys8M0qOr3
 3e+RbtNgC3jt2dgYEcg6x31KGKx/FVB3wW+WnW5bsdpX7/cUEv
 TxsdX7SmOAA4zztBJGqm4GA5barpVYIkelheZMKv/dFnqcdMtM
 ZIdgTnb3bpw4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sharpsl_fatal_check has not been used since Pavel Machek removed
the caller in 99f329a2b "pxa/sharpsl_pm: zaurus c3000 aka spitz: fix
resume". Nobody has complained since 2009, so it's safe to assume we
can just remove the function.

Without this patch, building corgi_defconfig results in:

/home/arnd/linux-arm/arch/arm/mach-pxa/sharpsl_pm.c:693:12: warning: 'sharpsl_fatal_check' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 arch/arm/mach-pxa/sharpsl_pm.c |   48 ----------------------------------------
 1 file changed, 48 deletions(-)

diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index bdf4cb8..6c9658f 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -55,7 +55,6 @@
 #ifdef CONFIG_PM
 static int sharpsl_off_charge_battery(void);
 static int sharpsl_check_battery_voltage(void);
-static int sharpsl_fatal_check(void);
 #endif
 static int sharpsl_check_battery_temp(void);
 static int sharpsl_ac_check(void);
@@ -686,53 +685,6 @@ static int corgi_pxa_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-/*
- * Check for fatal battery errors
- * Fatal returns -1
- */
-static int sharpsl_fatal_check(void)
-{
-	int buff[5], temp, i, acin;
-
-	dev_dbg(sharpsl_pm.dev, "sharpsl_fatal_check entered\n");
-
-	/* Check AC-Adapter */
-	acin = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
-
-	if (acin && (sharpsl_pm.charge_mode == CHRG_ON)) {
-		sharpsl_pm.machinfo->charge(0);
-		udelay(100);
-		sharpsl_pm.machinfo->discharge(1);	/* enable discharge */
-		mdelay(SHARPSL_WAIT_DISCHARGE_ON);
-	}
-
-	if (sharpsl_pm.machinfo->discharge1)
-		sharpsl_pm.machinfo->discharge1(1);
-
-	/* Check battery : check inserting battery ? */
-	for (i = 0; i < 5; i++) {
-		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
-		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
-	}
-
-	if (sharpsl_pm.machinfo->discharge1)
-		sharpsl_pm.machinfo->discharge1(0);
-
-	if (acin && (sharpsl_pm.charge_mode == CHRG_ON)) {
-		udelay(100);
-		sharpsl_pm.machinfo->charge(1);
-		sharpsl_pm.machinfo->discharge(0);
-	}
-
-	temp = get_select_val(buff);
-	dev_dbg(sharpsl_pm.dev, "sharpsl_fatal_check: acin: %d, discharge voltage: %d, no discharge: %ld\n", acin, temp, sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT));
-
-	if ((acin && (temp < sharpsl_pm.machinfo->fatal_acin_volt)) ||
-			(!acin && (temp < sharpsl_pm.machinfo->fatal_noacin_volt)))
-		return -1;
-	return 0;
-}
-
 static int sharpsl_off_charge_error(void)
 {
 	dev_err(sharpsl_pm.dev, "Offline Charger: Error occurred.\n");
-- 
1.7.10

