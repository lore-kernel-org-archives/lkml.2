Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0G0NvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 09:51:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51701 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0G0NvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 09:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=X7KqfEJn8nTCzGbAu4gJJ1UPWh5M/8VAoum9koXeuNJRm4INS3S3P96gxadzPhFWGd
         Yxc04wNgzFddfEwttOiDCSMplYr/pjno4fn6YzD3pPp2mRu95kxPxlF6JF+Q92cq8cBr
         Tf+1AI9lpq53Aa5b6paosaHTYe56G9EX5js6Y=
Date: Tue, 27 Jul 2010 17:51:15 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.35.git
Message-ID: <20100727135115.GA31789@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here is another small fixup for ds2782_battery driver.

At first I thought that this is not 2.6.35 regression, thus
I didn't send it earlier. But, Ben Hutchings convinced me that
this is actually 2.6.35 regression, so now I believe that this
fix should be OK.

It affects only minor platforms though, i.e. sh4, alpha, frv,
microblaze, mn10300. And I doubt that any of those platforms
have DS2782 batteries, so I will understand if you won't pull
it that late.

Thanks,

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
  Linus Torvalds (1):
        Linux 2.6.35-rc3

are available in the git repository at:

  git://git.infradead.org/users/cbou/battery-2.6.35.git master

Peter Huewe (1):
      ds2782_battery: Rename get_current to fix build failure / name conflict

 drivers/power/ds2782_battery.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)


commit eb9650d6d989f24f21232a055d8fd45f1a9dcf99
Author: Peter Huewe <peterhuewe@gmx.de>
Date:   Thu May 13 01:54:57 2010 +0200

    ds2782_battery: Rename get_current to fix build failure / name conflict
    
    This patch changes the name of get_current function pointer to
    get_battery_current to resolve a name conflict with the get_current
    macro defined in current.h.
    
    This conflict resulted in a build-failure[1] for the sh4 arch
    allyesconfig:
    
      drivers/power/ds2782_battery.c:216:48: error: macro "get_current"
      passed 2 arguments, but takes just
    
    This patch fixes the issue. To be consistent the other function pointers
    (_voltage,_capacity) were renamed too.
    
    Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
    Acked-by: Ryan Mallon <ryan@bluewatersys.com>
    Acked-by: Mike Rapoport <mike@compulab.co.il>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index d762a0c..9b3b4b7 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -43,10 +43,9 @@
 struct ds278x_info;
 
 struct ds278x_battery_ops {
-	int	(*get_current)(struct ds278x_info *info, int *current_uA);
-	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
-	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
-
+	int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
+	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
+	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
 };
 
 #define to_ds278x_info(x) container_of(x, struct ds278x_info, battery)
@@ -213,11 +212,11 @@ static int ds278x_get_status(struct ds278x_info *info, int *status)
 	int current_uA;
 	int capacity;
 
-	err = info->ops->get_current(info, &current_uA);
+	err = info->ops->get_battery_current(info, &current_uA);
 	if (err)
 		return err;
 
-	err = info->ops->get_capacity(info, &capacity);
+	err = info->ops->get_battery_capacity(info, &capacity);
 	if (err)
 		return err;
 
@@ -246,15 +245,15 @@ static int ds278x_battery_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = info->ops->get_capacity(info, &val->intval);
+		ret = info->ops->get_battery_capacity(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = info->ops->get_voltage(info, &val->intval);
+		ret = info->ops->get_battery_voltage(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		ret = info->ops->get_current(info, &val->intval);
+		ret = info->ops->get_battery_current(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_TEMP:
@@ -307,14 +306,14 @@ enum ds278x_num_id {
 
 static struct ds278x_battery_ops ds278x_ops[] = {
 	[DS2782] = {
-		.get_current  = ds2782_get_current,
-		.get_voltage  = ds2782_get_voltage,
-		.get_capacity = ds2782_get_capacity,
+		.get_battery_current  = ds2782_get_current,
+		.get_battery_voltage  = ds2782_get_voltage,
+		.get_battery_capacity = ds2782_get_capacity,
 	},
 	[DS2786] = {
-		.get_current  = ds2786_get_current,
-		.get_voltage  = ds2786_get_voltage,
-		.get_capacity = ds2786_get_capacity,
+		.get_battery_current  = ds2786_get_current,
+		.get_battery_voltage  = ds2786_get_voltage,
+		.get_battery_capacity = ds2786_get_capacity,
 	}
 };
 
