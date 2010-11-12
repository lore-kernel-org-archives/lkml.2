Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0KLKpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:45:07 -0500
Received: from mail.bugwerft.de ([212.112.241.193]:52479 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab0KLKpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:45:06 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 05:45:06 EST
From: Sven Neumann <s.neumann@raumfeld.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sven Neumann <s.neumann@raumfeld.com>
Subject: [PATCH] ds2760_battery: fix calculation of time_to_empty_now
Date: Fri, 12 Nov 2010 11:36:22 +0100
Message-Id: <1289558182-28817-1-git-send-email-s.neumann@raumfeld.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check against division by zero was modified in commit b0525b48.
Since this change time_to_empty_now is always reported as zero
while the battery is discharging and as a negative value while
the battery is charging. This is because current is negative while
the battery is discharging.

Fix the check introduced by commit b0525b48 so that time_to_empty_now
is reported correctly during discharge and as zero while charging.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/power/ds2760_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 4d3b272..c8d26df 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -212,7 +212,7 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	if (di->rem_capacity > 100)
 		di->rem_capacity = 100;
 
-	if (di->current_uA >= 100L)
+	if (di->current_uA < -100L)
 		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
 					/ (di->current_uA / 100L);
 	else
-- 
1.7.1

