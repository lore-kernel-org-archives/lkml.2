Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0IPN2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:28:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36945 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0IPN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AyYckv7xN6P1UxSf9pzQb5hQkob2yHHeiXqujB5xFOfqhlf+KvdQ0a1HY4lV4EKD6j
         neoehQCvXxgndCfeLGFMy9mVrFgFwmKGcEpiA96Rr3exFmBSLK9lkKxE6cdNiGmIKhX+
         YsJnNyBHJU/W7F5lHKHSXmroF+afCMQyHhi8g=
Date: Thu, 16 Sep 2010 17:27:59 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.36.git
Message-ID: <20100916132759.GA15321@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

There are a few battery-related commits queued for 2.6.36.

Not regression fixes (not 2.6.36 regressions, that is), but very
small and, more importantly, useful fixes.

One makes intel_pmic_battery (a new driver, appeared in 2.6.36)
actually usable, and another one fixes a long standing bug in
apm_power emulation driver.

I think these particular fixes are OK for 2.6.36, but, as always,
I can just postpone them for 2.6.37.

Thanks,

The following changes since commit d1b113bb028999e82a8528e1484be8c23fb5a7d9:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.infradead.org/users/cbou/battery-2.6.36.git master

Anton Vorontsov (1):
      apm_power: Add missing break statement

Shuduo Sang (1):
      intel_pmic_battery: Fix battery charging status on mrst

 drivers/power/apm_power.c         |    1 +
 drivers/power/intel_mid_battery.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)


commit 77f4b9fe050d59a30c3b11e267289630bb13f56a
Author: Shuduo Sang <shuduo.sang@intel.com>
Date:   Tue Aug 24 14:35:17 2010 +0100

    intel_pmic_battery: Fix battery charging status on mrst
    
    The arguments got swapped on some functions which produces undefined results.
    The main one got fixed before submit but the other two were missed.
    
    Signed-off-by: Shuduo Sang <shuduo.sang@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index c61ffec..2a10cd3 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -185,8 +185,8 @@ static int pmic_scu_ipc_battery_property_get(struct battery_property *prop)
 {
 	u32 data[3];
 	u8 *p = (u8 *)&data[1];
-	int err = intel_scu_ipc_command(IPC_CMD_BATTERY_PROPERTY,
-				IPCMSG_BATTERY, NULL, 0, data, 3);
+	int err = intel_scu_ipc_command(IPCMSG_BATTERY,
+				IPC_CMD_BATTERY_PROPERTY, NULL, 0, data, 3);
 
 	prop->capacity = data[0];
 	prop->crnt = *p++;
@@ -207,7 +207,7 @@ static int pmic_scu_ipc_battery_property_get(struct battery_property *prop)
 
 static int pmic_scu_ipc_set_charger(int charger)
 {
-	return intel_scu_ipc_simple_command(charger, IPCMSG_BATTERY);
+	return intel_scu_ipc_simple_command(IPCMSG_BATTERY, charger);
 }
 
 /**

commit 1d220334d6a8a711149234dc5f98d34ae02226b8
Author: Anton Vorontsov <cbouatmailru@gmail.com>
Date:   Wed Sep 8 00:10:26 2010 +0400

    apm_power: Add missing break statement
    
    The missing break statement causes wrong capacity calculation for
    batteries that report energy.
    
    Reported-by: d binderman <dcb314@hotmail.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 936bae5..dc628cb 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -233,6 +233,7 @@ static int calculate_capacity(enum apm_source source)
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+		break;
 	case SOURCE_VOLTAGE:
 		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
 		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
